#!/usr/bin/env python3
"""Assemble one release asset from the official source and a frozen package pool."""

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


ARCHITECTURES = {
    "arm64": ("arm", "x86_64-to-aarch64", "aarch64"),
    "amd64": ("x86", "aarch64-to-x86_64", "x86_64"),
}


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def write_json(path, data):
    path.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def assemble(official, frozen, case_id, platform, destination):
    side, direction, target = ARCHITECTURES[platform]
    original = official / "cases" / direction / case_id
    previous = frozen / "cases" / side / case_id
    manifest = json.loads((previous / "manifest.json").read_text(encoding="utf-8"))
    metadata = json.loads((original / "case.json").read_text(encoding="utf-8"))
    if manifest["case_id"] != case_id or metadata["case_id"] != case_id:
        raise ValueError("Case identity mismatch")
    build = manifest["build"]
    if build["architecture"] != target or metadata["platform"]["target_arch"] != target:
        raise ValueError("Case architecture mismatch")

    source_files = original / "checksums/source-input.sha256.json"
    inputs = json.loads(source_files.read_text(encoding="utf-8"))["files"]
    actual_names = {p.name for p in (original / "source/input").iterdir()}
    if {record["path"] for record in inputs} != actual_names:
        raise ValueError("Official source checksum inventory is incomplete")
    for record in inputs:
        source = original / "source/input" / record["path"]
        if source.stat().st_size != record["bytes"] or sha256(source) != record["sha256"]:
            raise ValueError(f"Official source checksum mismatch: {source.name}")

    shutil.copytree(original / "source", destination / "source", copy_function=link_file)
    shutil.copytree(original / "logs", destination / "logs", copy_function=link_file)
    shutil.copytree(original / "checksums", destination / "checksums")
    shutil.copyfile(original / "case.json", destination / "case.json")
    shutil.copyfile(original / "README.md", destination / "README.md")
    shutil.copytree(previous / "config", destination / "config")

    recipe = Path(build["recipe"])
    if recipe.parent != Path("input") or recipe.name not in actual_names:
        raise ValueError("Frozen manifest recipe missing from official sources")
    build["recipe"] = str(Path("source/input") / recipe.name)
    lock_path = destination / build["dependency_lock"]
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    if lock["case_id"] != case_id or len(lock["dependencies"]) != lock["dependency_count"]:
        raise ValueError("Dependency lock does not identify the full case")
    with (original / "logs/target-failure.log").open("rb") as log:
        historical_line = next((line for line in log if line.startswith(b"Package versions: ")), b"")
    versions = {}
    for raw in historical_line.decode().split()[2:]:
        package, version = raw.split("_", 1)
        if not (version == "0.invalid.0" and package.startswith("sbuild-build-depends-")):
            versions[package] = version
    dirs = {}
    for dirname in build["dependency_dirs"]:
        arch = dirname.rsplit("-", 1)[-1]
        dirs[arch] = destination / dirname
        dirs[arch].mkdir(parents=True)
    pool = frozen / ("pool_" + side)
    locked_files = {record["filename"] for record in lock["dependencies"]}
    recovered = []
    for package, version in sorted(versions.items()):
        for arch in (platform, "all"):
            name = f"{package}_{version.rsplit(':', 1)[-1]}_{arch}.deb"
            if name in locked_files:
                break
            if (pool / name).is_file():
                recovered.append({
                    "package": package, "version": version, "arch": arch, "filename": name,
                })
                break
    for record, is_alternative in [(r, False) for r in lock["dependencies"]] + [(r, True) for r in recovered]:
        name = record["filename"]
        if name != Path(name).name or not name.endswith(".deb"):
            raise ValueError(f"Invalid dependency filename: {name}")
        deb = pool / name
        fields = subprocess.check_output(
            ["dpkg-deb", "-f", deb, "Package", "Version", "Architecture"], text=True,
        )
        actual = dict(line.split(": ", 1) for line in fields.splitlines())
        # 旧锁文件以 fallback 标记引导包，实际版本以包的控制字段为准。
        record.pop("src", None)
        if record["version"] in {"fallback", "dsc", "pool"}:
            record["role"] = {"fallback": "bootstrap_fallback", "dsc": "source_control", "pool": "pool_fallback"}[record["version"]]
            record["version"] = actual["Version"]
        expected = dict(zip(("Package", "Version", "Architecture"),
                            (record["package"], record["version"], record["arch"])))
        if actual != expected:
            raise ValueError(f"Frozen dependency metadata mismatch: {name}")
        digest = sha256(deb)
        if record.get("sha256", digest) != digest:
            raise ValueError(f"Frozen dependency checksum mismatch: {name}")
        record["sha256"] = digest
        if is_alternative:
            # OBS must resolve only against the package pool from the frozen manifest.
            target_file = destination / "dependencies/historical-alternatives" / record["arch"] / name
            target_file.parent.mkdir(parents=True, exist_ok=True)
            record["path"] = target_file.relative_to(destination).as_posix()
        else:
            target_file = dirs[record["arch"]] / name
        if not target_file.exists():
            link_file(deb, target_file)
    lock["dependency_count"] = len(lock["dependencies"])
    write_json(lock_path, lock)
    # Validator 的补丁路径规则只适用于 source/input 中的源码。
    manifest["patch_policy"]["allowed_paths"] = ["source/input/**"]
    write_json(destination / "manifest.json", manifest)
    locked_versions = {record["package"]: record["version"] for record in lock["dependencies"]}
    write_json(destination / "checksums/frozen-environment.json", {
        "provenance": "buildbench-200-exact-v1",
        "reference_sha256": sha256(destination / "logs/target-failure.log"),
        "historical_versions_recorded": len(versions),
        "historical_alternatives": recovered,
        "historical_version_differences": {
            name: {"historical": version, "locked": locked_versions.get(name)}
            for name, version in sorted(versions.items()) if locked_versions.get(name) != version
        },
        "additional_bootstrap_packages": {
            name: locked_versions[name] for name in sorted(locked_versions.keys() - versions.keys())
        },
    })


def link_file(source, destination):
    try:
        Path(destination).hardlink_to(source)
    except OSError:
        shutil.copyfile(source, destination)
    return destination


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("official", type=Path)
    parser.add_argument("frozen", type=Path)
    parser.add_argument("case_id")
    parser.add_argument("arch", choices=ARCHITECTURES)
    parser.add_argument("output", type=Path)
    parser.add_argument("--metadata-dir", type=Path)
    args = parser.parse_args()
    if not re.fullmatch(r"launchpad-[a-z0-9-]+", args.case_id):
        parser.error("invalid case ID")
    args.output.mkdir(parents=True, exist_ok=True)
    asset_name = args.case_id + ".tar.zst"
    asset = args.output / asset_name
    if asset.exists():
        raise FileExistsError(asset)
    with tempfile.TemporaryDirectory(dir=args.output) as directory:
        temp = Path(directory)
        case = temp / args.case_id
        case.mkdir()
        assemble(args.official, args.frozen, args.case_id, args.arch, case)
        archive = temp / asset_name
        subprocess.run(
            ["tar", "--zstd", "-cf", archive, "-C", temp, args.case_id],
            check=True, env={**os.environ, "ZSTD_CLEVEL": "3"},
        )
        archive.rename(asset)
        record = {"file": asset.name, "bytes": asset.stat().st_size, "sha256": sha256(asset)}
        if args.metadata_dir:
            direction = ARCHITECTURES[args.arch][1]
            metadata = args.metadata_dir / direction / args.case_id
            metadata.mkdir(parents=True, exist_ok=False)
            for name in ("case.json", "README.md", "manifest.json"):
                shutil.copyfile(case / name, metadata / name)
            for name in ("checksums", "config"):
                shutil.copytree(case / name, metadata / name)
            write_json(metadata / "asset.json", record)
    print(json.dumps(record))


if __name__ == "__main__":
    main()
