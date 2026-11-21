#!/usr/bin/env python3
"""恢复指定构建环境并输出依赖来源和校验记录。"""
import collections
import concurrent.futures
import json
import shutil
import subprocess
import sys
import tarfile
import tempfile
from pathlib import Path

from ubuntu_archive import SNAPSHOT, acquire, snapshot_index

SEEDS = {
    "base-files", "base-passwd", "bash", "coreutils", "coreutils-from-uutils",
    "coreutils-from-gnu", "gnu-coreutils", "rust-coreutils", "dash", "diffutils",
    "dpkg", "findutils", "grep", "gzip", "libc-bin", "sed", "tar", "xz-utils",
}
SERIES = ["focal", "groovy", "hirsute", "impish", "jammy", "kinetic", "lunar",
          "mantic", "noble", "oracular", "plucky", "questing", "resolute"]


def read_control(path):
    control = subprocess.check_output(["dpkg-deb", "-f", path], text=True)
    result = {}
    key = None
    for line in control.splitlines():
        if line.startswith((" ", "\t")) and key:
            result[key] += " " + line.strip()
        elif ": " in line:
            key, result_value = line.split(": ", 1)
            result[key] = result_value
    return result


def dependency_name(term):
    return term.strip().split(" ", 1)[0].split(":", 1)[0]


def bootstrap(pool, archive, architecture):
    packages = {}
    providers = collections.defaultdict(list)
    for package in sorted(pool.glob("*.deb")):
        control = read_control(package)
        name = control["Package"]
        packages[name] = (package, control)
        for term in control.get("Provides", "").split(","):
            if virtual := dependency_name(term):
                providers[virtual].append(name)
    selected = SEEDS & packages.keys()
    queue = list(selected)
    while queue:
        _, control = packages[queue.pop()]
        dependencies = ",".join(control.get(key, "") for key in ("Depends", "Pre-Depends"))
        for group in dependencies.split(","):
            for term in group.split("|"):
                alternative = dependency_name(term)
                candidates = [alternative] if alternative in packages else providers.get(alternative, [])
                if candidates:
                    selected_provider = next((name for name in candidates if name in selected), candidates[0])
                    break
            else:
                continue
            chosen = selected_provider
            if chosen not in selected:
                selected.add(chosen)
                queue.append(chosen)
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        for relative in ("usr/bin", "usr/sbin", "usr/lib", "usr/lib64", "etc", "tmp", "dev", "proc", "sys", "run"):
            (root / relative).mkdir(parents=True, exist_ok=True)
        merged = ("usr-is-merged" in packages or architecture == "arm64" or
                  int(packages["libc6"][1]["Version"].split(".")[1].split("-")[0]) >= 39)
        for name in ("bin", "sbin", "lib", "lib64"):
            if merged:
                (root / name).symlink_to("usr/" + name)
            else:
                (root / name).mkdir()
        for name in sorted(selected):
            subprocess.run(["dpkg-deb", "-x", packages[name][0], root], check=True)
        for name in ("passwd", "group"):
            master = root / "usr/share/base-passwd" / f"{name}.master"
            shutil.copyfile(master, root / "etc" / name)
        policy = root / "usr/sbin/policy-rc.d"
        policy.write_text("#!/bin/sh\nexit 101\n")
        policy.chmod(0o755)
        (root / "tmp").chmod(0o1777)

        def root_owner(member):
            member.uid = member.gid = 0
            member.uname = member.gname = "root"
            return member

        with tarfile.open(archive, "w:xz", preset=1) as output:
            for path in sorted(root.iterdir()):
                output.add(path, arcname=path.name, filter=root_owner)


def candidate_suites(case):
    names = []

    def add(name):
        if name and name not in names:
            names.append(name)

    base = (case.get("suite") or "").split("-")[0]
    add(case.get("distribution"))
    add(base + "-proposed")
    add(base)
    add(base + "-updates")
    add(base + "-security")
    if base in SERIES:
        index = SERIES.index(base)
        for offset in (1, 2):
            if index - offset >= 0:
                add(SERIES[index - offset])
    return names


def main():
    case_path, output, evidence = map(Path, sys.argv[1:])
    case = json.loads(case_path.read_text())
    wanted = case["packages"]
    architecture = case["architecture"]
    if not wanted:
        raise SystemExit("No historical package versions recorded")
    root = f"{SNAPSHOT}/{case['snapshot']}" if case["snapshot"] else None
    output.mkdir(parents=True)
    pool = output / "pool"
    pool.mkdir()
    suites = candidate_suites(case)
    print("Snapshot suite candidates:", ", ".join(suites), flush=True)
    indexed = {}
    chosen = None
    best_hits = 0
    source_suites = {}
    with tempfile.TemporaryDirectory() as scratch, concurrent.futures.ThreadPoolExecutor(12) as workers:
        if root:
            for suite in suites:
                trial = {}
                futures = [workers.submit(snapshot_index, root, suite, component,
                                          Path(scratch), wanted, architecture)
                           for component in ("main", "universe")]
                for future in futures:
                    try:
                        trial.update(future.result())
                    except Exception as exc:  # noqa: BLE001
                        print("snapshot index error:", suite, exc, flush=True)
                ratio = len(trial) / len(wanted)
                print(f"suite {suite}: indexed {len(trial)}/{len(wanted)} ({ratio:.0%})", flush=True)
                if len(trial) > best_hits:
                    chosen, best_hits = suite, len(trial)
                for name, record in trial.items():
                    if name not in indexed:
                        indexed[name] = record
                        source_suites[name] = suite
                if len(indexed) == len(wanted):
                    break
            if chosen and len(indexed) != len(wanted):
                remaining = wanted.keys() - indexed.keys()
                needed = {name: wanted[name] for name in remaining}
                futures = [workers.submit(snapshot_index, root, chosen, component,
                                          Path(scratch), needed, architecture)
                           for component in ("restricted", "multiverse")]
                for future in futures:
                    try:
                        for name, record in future.result().items():
                            indexed[name] = record
                            source_suites[name] = chosen
                    except Exception as exc:  # noqa: BLE001
                        print("snapshot index error:", chosen, exc, flush=True)
            print(f"Ubuntu Snapshot suite={chosen} indexed {len(indexed)}/{len(wanted)} versions", flush=True)
            jobs = {
                name: workers.submit(acquire, name, version, indexed.get(name), root, pool, architecture)
                for name, version in wanted.items()
            }
            records = {name: job.result() for name, job in jobs.items()}
        else:
            records = {name: None for name in wanted}
    for name, record in records.items():
        if record is not None:
            record["snapshot_suite"] = source_suites.get(name)
    missing = {name: wanted[name] for name, record in records.items() if record is None}
    evidence.write_text(json.dumps({"missing": missing, "packages": records, "suite": chosen}, indent=2))
    if missing:
        raise SystemExit(f"Historical dependencies unavailable: {missing}")
    (output / "expected.tsv").write_text("".join(f"{name}\t{version}\n" for name, version in wanted.items()))
    bootstrap(pool, output / "bootstrap.tar.xz", architecture)
    for filename in ("install.sh", "build-in-container.sh", "environment.Dockerfile"):
        shutil.copyfile(Path(__file__).with_name(filename), output / filename)


if __name__ == "__main__":
    main()
