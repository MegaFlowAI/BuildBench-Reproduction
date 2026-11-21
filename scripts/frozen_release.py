#!/usr/bin/env python3
"""Select published case bundles and verify Release downloads before loading them."""

import argparse
import json
import re
import subprocess
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


def available_cases(cases, assets):
    runtimes = json.loads((ROOT / "cases/runtimes.json").read_text())
    uploaded = {asset["name"]: (asset["size"], asset["digest"])
                for asset in assets if asset["state"] == "uploaded"}

    def is_published(record):
        return uploaded.get(record["file"]) == (record["bytes"], "sha256:" + record["sha256"])

    return {
        case: (arch, path) for case, (arch, path) in cases.items()
        if is_published(runtimes[arch]) and is_published(json.loads(path.read_text()))
    }


def select(selection, release_assets):
    cases = frozen_cases()
    if release_assets:
        pages = json.loads(release_assets.read_text())
        cases = available_cases(cases, (asset for page in pages for asset in page))
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
    if record["file"] != file_name or not re.fullmatch(r"[a-z0-9][a-z0-9.-]+", file_name):
        raise ValueError("Invalid asset name")
    destination = work / file_name
    subprocess.run([
        "curl", "--fail", "--location", "--silent", "--show-error",
        "--retry", "4", "--retry-all-errors", "--output", destination,
        f"{RELEASE}/{file_name}",
    ], check=True)
    if destination.stat().st_size != record["bytes"] or sha256(destination) != record["sha256"]:
        raise ValueError(f"Release asset checksum mismatch: {file_name}")
    print(f"Verified {file_name}", flush=True)
    return destination


def fetch(case, work):
    arch, metadata = frozen_cases()[case]
    work = work.resolve()
    work.mkdir(parents=True, exist_ok=False)
    archive = download(json.loads(metadata.read_text()), work, case + ".tar.zst")
    runtime = json.loads((ROOT / "cases/runtimes.json").read_text())[arch]
    image_archive = download(runtime, work, runtime["file"])
    subprocess.run(["tar", "--zstd", "-xf", archive, "-C", work], check=True)
    case_root = work / case
    for path in metadata.parent.rglob("*"):
        if path.is_file() and path != metadata:
            packaged = case_root / path.relative_to(metadata.parent)
            if sha256(path) != sha256(packaged):
                raise ValueError(f"Release metadata differs from Git: {path.name}")
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
    fetch_case = commands.add_parser("fetch")
    fetch_case.add_argument("case")
    fetch_case.add_argument("work", type=Path)
    args = parser.parse_args()
    if args.command == "matrix":
        select(args.selection, args.release_assets)
    else:
        fetch(args.case, args.work)


if __name__ == "__main__":
    main()
