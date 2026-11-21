#!/usr/bin/env python3
"""Prepare and verify an sbuild replay with the original Launchpad chroot."""

import argparse
import hashlib
import json
import re
from pathlib import Path

from check_exact_log import first_difference
from export_frozen_case import sha256
from frozen_release import ROOT, RUNNERS, download, fetch_bundle
from prepare_frozen_runtime import build_flags


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8"))


def settings(case):
    catalog = read_json(ROOT / "cases.json")[case]
    host = read_json(ROOT / "cases/historical-hosts.json")[case]
    versions = host["toolchain"]
    if versions["sbuild"] != "0.79.0-1ubuntu1" or not versions["launchpad-buildd"].startswith("236~"):
        raise ValueError("This replay host supports the Launchpad 236 toolchain")
    chroot = read_json(ROOT / "cases/launchpad-chroots.json")[host["chroot_sha1"]]
    return {
        "architecture": catalog["architecture"],
        "distribution": catalog["distribution"],
        "jobs": catalog["jobs"],
        "mode": catalog["mode"],
        "runner": RUNNERS[catalog["architecture"]],
        "build_id": "PACKAGEBUILD-" + host["build_url"].rsplit("/", 1)[-1],
        "hostname": host["kernel"].split()[1],
        "chroot_sha1": host["chroot_sha1"],
        "chroot": chroot,
    }


def prepare(case, work):
    data = settings(case)
    architecture, case_root = fetch_bundle(case, work)
    if architecture != data["architecture"]:
        raise ValueError("Case architecture changed")
    record = data["chroot"]
    chroot = download(record, work, "launchpad-chroot-" + data["chroot_sha1"] + ".tar")
    digest = hashlib.sha1()
    with chroot.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    if digest.hexdigest() != data["chroot_sha1"]:
        raise ValueError("Chroot differs from the raw historical SHA-1")
    manifest = read_json(case_root / "manifest.json")
    data["recipe"] = Path(manifest["build"]["recipe"]).name
    reference = case_root / "logs/target-failure.log"
    flags, _ = build_flags(reference, data["mode"])
    data["maintainer"] = next((arg[2:] for arg in flags if arg.startswith("-m")), "")
    (work / "launchpad-settings.json").write_text(json.dumps(data, indent=2) + "\n")
    packages = read_json(ROOT / "cases.json")[case]["packages"]
    with (work / "launchpad-pins").open("w", encoding="utf-8") as pins:
        for package, version in sorted(packages.items()):
            pins.write(f"Package: {package}\nPin: version {version}\nPin-Priority: 1001\n\n")


def compare(case_root, log, exit_code, output):
    reference = case_root / "logs/target-failure.log"
    historical = read_json(case_root / "checksums/frozen-environment.json")
    reference_hash = sha256(reference)
    if reference_hash != historical["reference_sha256"]:
        raise ValueError("Reference log checksum mismatch")
    failures = []
    installed = None
    with log.open("rb") as raw:
        for line in raw:
            if line.startswith(b"Package versions: "):
                installed = dict(word.split("_", 1) for word in line.decode().split()[2:]
                                 if not word.startswith("sbuild-build-depends-"))
            if match := re.fullmatch(rb"Fail-Stage:[ \t]+([a-zA-Z0-9_-]+)[ \t]*\r?\n", line):
                failures.append(match[1].decode("ascii"))
    difference = first_difference(reference, log)
    package_failed = exit_code != 0 and "build" in failures
    case_id = read_json(case_root / "case.json")["case_id"]
    verdict = {
        "case_id": case_id,
        "status": ("exact" if difference is None else "byte_mismatch") if package_failed
                  else ("build_succeeded" if exit_code == 0 else "build_infrastructure_failed"),
        "sbuild_exit": exit_code,
        "failed_stages": failures,
        "first_difference_byte": None if difference is None else difference + 1,
        "reference_bytes": reference.stat().st_size,
        "replay_bytes": log.stat().st_size,
        "reference_sha256": reference_hash,
        "replay_sha256": sha256(log),
    }
    if installed is not None:
        expected = read_json(ROOT / "cases.json")[case_id]["packages"]
        version_differences = {
            name: {"historical": expected.get(name), "installed": installed.get(name)}
            for name in sorted(expected.keys() | installed.keys())
            if expected.get(name) != installed.get(name)
        }
        verdict["historical_package_count"] = len(expected)
        verdict["installed_package_count"] = len(installed)
        verdict["versions_matched"] = sum(installed.get(name) == version for name, version in expected.items())
        verdict["version_differences"] = version_differences
    output.write_text(json.dumps(verdict, indent=2) + "\n")
    print(json.dumps({key: value for key, value in verdict.items() if key != "version_differences"}))
    return 0 if verdict["status"] == "exact" else 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    subs = parser.add_subparsers(dest="command", required=True)
    for command in ("runner", "prepare"):
        action = subs.add_parser(command)
        action.add_argument("case")
        if command == "prepare":
            action.add_argument("work", type=Path)
    verdict = subs.add_parser("compare")
    verdict.add_argument("case_root", type=Path)
    verdict.add_argument("log", type=Path)
    verdict.add_argument("exit_code", type=int)
    verdict.add_argument("output", type=Path)
    args = parser.parse_args()
    if args.command == "runner":
        print(settings(args.case)["runner"])
    elif args.command == "prepare":
        prepare(args.case, args.work)
    else:
        return compare(args.case_root, args.log, args.exit_code, args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
