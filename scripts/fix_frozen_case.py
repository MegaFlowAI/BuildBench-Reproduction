#!/usr/bin/env python3
"""准备冻结用例目录：补齐 usr-is-merged 空 meta 包（debootstrap 引擎需要）。

原因：debootstrap 对 bookworm 之后的 suite 会把 usr-is-merged 加进 required 列表；
Ubuntu 归档用 base-files 的 Provides 满足，但 obs-build 的本地仓库只收录
buildconfig 引用到的包，因此需要显式提供一个同名空包并写进 Preinstall。
"""
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

NEED_SUITES = {"kinetic", "lunar", "mantic", "noble", "oracular", "plucky", "questing", "resolute"}


def make_stub(directory: Path) -> Path:
    build = Path(tempfile.mkdtemp(dir=directory))
    control = build / "DEBIAN" / "control"
    control.parent.mkdir(parents=True)
    control.write_text(
        "Package: usr-is-merged\n"
        "Version: 36ubuntu1\n"
        "Section: oldlibs\n"
        "Priority: optional\n"
        "Architecture: all\n"
        "Depends: base-files (>= 12)\n"
        "Maintainer: BuildBench local metapackage <root@localhost>\n"
        "Description: empty metapackage marking merged-/usr transition (local stub)\n"
    )
    target = directory / "usr-is-merged_36ubuntu1_all.deb"
    subprocess.run(["dpkg-deb", "--build", str(build), str(target)], check=True,
                   capture_output=True)
    shutil.rmtree(build)
    return target


def main() -> int:
    case_dir = Path(sys.argv[1]).resolve()
    case = json.loads((case_dir / "case.json").read_text())
    series = case["platform"]["series"]
    manifest = json.loads((case_dir / "manifest.json").read_text())
    build = manifest["build"]
    buildconfig = case_dir / build["buildconfig"]
    config_text = buildconfig.read_text()
    if series not in NEED_SUITES or "buildengine: debootstrap" not in config_text:
        print(f"no usr-is-merged fix needed: series={series}")
        return 0
    lock_path = case_dir / build["dependency_lock"]
    lock = json.loads(lock_path.read_text())
    if any(entry["package"] == "usr-is-merged" for entry in lock["dependencies"]):
        print("usr-is-merged already present")
    else:
        stub = make_stub(case_dir)
        all_dir = next((case_dir / name for name in build["dependency_dirs"]
                        if name.endswith("-all")), None)
        if all_dir is None:
            raise SystemExit("no *-all dependency directory")
        shutil.copyfile(stub, all_dir / stub.name)
        digest = hashlib.sha256(stub.read_bytes()).hexdigest()
        lock["dependencies"].append({
            "package": "usr-is-merged",
            "version": "36ubuntu1",
            "arch": "all",
            "filename": stub.name,
            "sha256": digest,
        })
        lock["dependency_count"] = len(lock["dependencies"])
        lock_path.write_text(json.dumps(lock, indent=2, sort_keys=True) + "\n")
        print(f"added {stub.name} to {all_dir.name} and dependency lock")
    if "usr-is-merged" not in config_text:
        lines = config_text.splitlines()
        done = False
        for index, line in enumerate(lines):
            if not done and line.startswith("Preinstall:"):
                lines[index] = line.rstrip() + " usr-is-merged"
                done = True
        if not done:
            lines.append("Preinstall: usr-is-merged")
        buildconfig.write_text("\n".join(lines) + "\n")
        print("appended usr-is-merged to buildconfig Preinstall")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
