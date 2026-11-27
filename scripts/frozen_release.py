#!/usr/bin/env python3
"""Select published case bundles and verify Release downloads before loading them."""

import argparse
import json
import re
import shutil
import subprocess
import time
from pathlib import Path

from export_frozen_case import ARCHITECTURES, sha256


ROOT = Path(__file__).resolve().parents[1]
RELEASE = "https://github.com/MegaFlowAI/BuildBench-Reproduction/releases/download/frozen-cases-v1"
RUNNERS = {"amd64": "ubuntu-24.04", "arm64": "ubuntu-24.04-arm"}


def frozen_cases():
    cases = {}
    for arch, (_, direction, _) in ARCHITECTURES.items():
        for path in sorted((ROOT / "cases" / direction).glob("*/asset.json")):
            case = path.parent.name
            if case in cases or not re.fullmatch(r"launchpad-[a-z0-9-]+", case):
                raise ValueError(f"Invalid or duplicate published case: {case}")
            cases[case] = (arch, path)
    return cases


def available_cases(cases, assets, repairs):
    runtimes = json.loads((ROOT / "cases/runtimes.json").read_text())
    uploaded = {asset["name"]: (asset["size"], asset["digest"])
                for asset in assets if asset["state"] == "uploaded"}

    def is_published(record):
        return uploaded.get(record["file"]) == (record["bytes"], "sha256:" + record["sha256"])

    blocked = {
        case for repair in repairs
        if "asset" not in repair or not is_published(repair["asset"])
        for case in repair["cases"]
    }
    return {
        case: (arch, path) for case, (arch, path) in cases.items()
        if case not in blocked and is_published(runtimes[arch])
        and is_published(json.loads(path.read_text()))
    }


def select(selection, release_assets):
    cases = frozen_cases()
    if release_assets:
        pages = json.loads(release_assets.read_text())
        repairs = json.loads((ROOT / "cases/integrity-repairs.json").read_text())
        cases = available_cases(cases, (asset for page in pages for asset in page), repairs)
    if selection == "all" or selection in RUNNERS:
        selected = [case for case, (arch, _) in cases.items()
                    if selection in {"all", arch}]
    else:
        selected = list(dict.fromkeys(case.strip() for case in selection.split(",")))
    if not selected or not all(case in cases for case in selected):
        raise SystemExit("Selection must identify published case bundles")
    print(json.dumps({"include": [
        {"case": case, "runner": RUNNERS[cases[case][0]]} for case in selected
    ]}, separators=(",", ":")))


def download(record, work, file_name):
    if record["file"] != file_name or not re.fullmatch(r"[a-z0-9][a-z0-9._+-]+", file_name):
        raise ValueError("Invalid asset name")
    destination = work / file_name
    url = record.get("origin", f"{RELEASE}/{file_name}")
    temporary = work / (file_name + ".partial")
    for attempt in range(5):
        temporary.unlink(missing_ok=True)
        subprocess.run([
            "curl", "--fail", "--location", "--silent", "--show-error",
            "--retry", "4", "--retry-all-errors", "--connect-timeout", "30",
            "--max-time", "1800", "--output", temporary, url,
        ], check=True)
        if temporary.stat().st_size == record["bytes"] and sha256(temporary) == record["sha256"]:
            temporary.replace(destination)
            print(f"Verified {file_name}", flush=True)
            return destination
        print(
            f"Checksum retry for {file_name}: got {temporary.stat().st_size} bytes "
            f"{sha256(temporary)} expected {record['bytes']} bytes {record['sha256']}",
            flush=True,
        )
        if attempt < 4:
            time.sleep(2 * (attempt + 1))
    raise ValueError(f"Asset checksum mismatch after retries: {file_name}")


def apply_repairs(case, case_root, work):
    repairs = json.loads((ROOT / "cases/integrity-repairs.json").read_text())
    applied = {repair["file"]: repair for repair in repairs if case in repair["cases"]}
    if not applied:
        return
    manifest = json.loads((case_root / "manifest.json").read_text())
    build = manifest["build"]
    lock_path = case_root / build["dependency_lock"]
    lock = json.loads(lock_path.read_text())
    entries = {entry["filename"]: entry for entry in lock["dependencies"]}
    directories = {name.rsplit("-", 1)[1]: case_root / name for name in build["dependency_dirs"]}
    for name, repair in applied.items():
        entry = entries[name]
        target = directories[entry["arch"]] / name
        if sha256(target) != repair["archived_sha256"] or entry["sha256"] != repair["archived_sha256"]:
            raise ValueError(f"Unexpected original dependency bytes: {name}")
        asset = repair["asset"]
        downloaded = download(asset, work, "recovered-" + asset["sha256"] + ".deb")
        actual = subprocess.check_output([
            "dpkg-deb", "-f", downloaded, "Package", "Version", "Architecture",
        ], text=True)
        replacement = repair.get("replacement")
        expected = dict(zip(("Package", "Version", "Architecture"),
                            (entry["package"], entry["version"], entry["arch"])))
        if replacement:
            expected = dict(zip(("Package", "Version", "Architecture"),
                                (replacement["package"], replacement["version"],
                                 replacement["arch"])))
        if dict(line.split(": ", 1) for line in actual.splitlines()) != expected:
            raise ValueError(f"Recovered package identity changed: {name}")
        if replacement:
            replacement_path = directories[replacement["arch"]] / replacement["filename"]
            target.unlink()
            shutil.copyfile(downloaded, replacement_path)
            entry["filename"] = replacement["filename"]
            entry["version"] = replacement["version"]
            entry["arch"] = replacement["arch"]
        else:
            shutil.copyfile(downloaded, target)
        entry["sha256"] = asset["sha256"]
    lock_path.write_text(json.dumps(lock, indent=2, sort_keys=True) + "\n")
    (work / "dependency-repairs.json").write_text(json.dumps(list(applied.values()), indent=2) + "\n")


def fetch_bundle(case, work):
    arch, metadata = frozen_cases()[case]
    work = work.resolve()
    work.mkdir(parents=True, exist_ok=False)
    archive = download(json.loads(metadata.read_text()), work, case + ".tar.zst")
    subprocess.run(["tar", "--zstd", "-xf", archive, "-C", work], check=True)
    case_root = work / case
    for path in metadata.parent.rglob("*"):
        if path.is_file() and path != metadata:
            packaged = case_root / path.relative_to(metadata.parent)
            if sha256(path) != sha256(packaged):
                raise ValueError(f"Release metadata differs from Git: {path.name}")
    apply_repairs(case, case_root, work)
    return arch, case_root


def fetch_bundle_only(case, work):
    return fetch_bundle(case, work)


def fetch(case, work):
    arch, _ = fetch_bundle(case, work)
    runtime = json.loads((ROOT / "cases/runtimes.json").read_text())[arch]
    image_archive = download(runtime, work, runtime["file"])
    subprocess.run(["docker", "load", "--input", image_archive], check=True)
    actual = subprocess.check_output([
        "docker", "image", "inspect", "--format", "{{.Architecture}}", runtime["image"],
    ], text=True).strip()
    if actual != arch:
        raise ValueError(f"Runtime architecture mismatch: expected {arch}, got {actual}")
    (work / "runtime-image.txt").write_text(runtime["image"] + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    matrix = commands.add_parser("matrix")
    matrix.add_argument("selection")
    matrix.add_argument("--release-assets", type=Path)
    fetch_bundle = commands.add_parser("fetch-bundle")
    fetch_bundle.add_argument("case")
    fetch_bundle.add_argument("work", type=Path)
    fetch_case = commands.add_parser("fetch")
    fetch_case.add_argument("case")
    fetch_case.add_argument("work", type=Path)
    args = parser.parse_args()
    if args.command == "matrix":
        select(args.selection, args.release_assets)
    elif args.command == "fetch-bundle":
        fetch_bundle_only(args.case, args.work)
    else:
        fetch(args.case, args.work)


if __name__ == "__main__":
    main()
