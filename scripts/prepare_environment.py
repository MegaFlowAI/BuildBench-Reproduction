#!/usr/bin/env python3
"""恢复指定构建环境并输出依赖来源和校验记录。"""
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


def bootstrap(pool, archive, architecture):
    packages = {}
    for package in pool.glob("*.deb"):
        control = read_control(package)
        packages[control["Package"]] = (package, control)
    selected = SEEDS & packages.keys()
    queue = list(selected)
    while queue:
        _, control = packages[queue.pop()]
        dependencies = ",".join(control.get(key, "") for key in ("Depends", "Pre-Depends"))
        for group in dependencies.split(","):
            alternatives = [term.strip().split(" ", 1)[0].split(":", 1)[0] for term in group.split("|")]
            chosen = next((name for name in alternatives if name in packages), None)
            if chosen and chosen not in selected:
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


def suites_for(case):
    suites = []
    for name in (case.get("distribution"), case.get("suite")):
        if name and name not in suites:
            suites.append(name)
    expanded = []
    for suite in suites:
        if suite not in expanded:
            expanded.append(suite)
        for pocket in ("-proposed", "-updates", "-security"):
            candidate = suite if suite.endswith(pocket) else suite + pocket
            if candidate not in expanded:
                expanded.append(candidate)
    return expanded


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
    suites = suites_for(case)
    print("Snapshot suites:", ", ".join(suites), flush=True)
    with tempfile.TemporaryDirectory() as scratch, concurrent.futures.ThreadPoolExecutor(12) as workers:
        indexed = {}
        if root:
            indices = [
                workers.submit(snapshot_index, root, suite, component,
                               Path(scratch), wanted, architecture)
                for suite in suites
                for component in ("main", "universe", "restricted", "multiverse")
            ]
            for index in indices:
                try:
                    indexed.update(index.result())
                except Exception as exc:  # noqa: BLE001
                    print("snapshot index error:", exc, flush=True)
        print(f"Ubuntu Snapshot indexed {len(indexed)}/{len(wanted)} versions", flush=True)
        jobs = {
            name: workers.submit(acquire, name, version, indexed.get(name), root, pool, architecture)
            for name, version in wanted.items()
        }
        records = {name: job.result() for name, job in jobs.items()}
    missing = {name: wanted[name] for name, record in records.items() if record is None}
    evidence.write_text(json.dumps({"missing": missing, "packages": records}, indent=2))
    if missing:
        raise SystemExit(f"Historical dependencies unavailable: {missing}")
    (output / "expected.tsv").write_text("".join(f"{name}\t{version}\n" for name, version in wanted.items()))
    bootstrap(pool, output / "bootstrap.tar.xz", architecture)
    for filename in ("install.sh", "build-in-container.sh", "environment.Dockerfile"):
        shutil.copyfile(Path(__file__).with_name(filename), output / filename)


if __name__ == "__main__":
    main()
