#!/usr/bin/env python3
"""Compare raw validator output with the official failure log."""

import argparse
import json
from pathlib import Path

from export_frozen_case import sha256

BLOCK_SIZE = 1024 * 1024


def first_difference(reference, replay):
    offset = 0
    with reference.open("rb") as expected, replay.open("rb") as actual:
        while True:
            left, right = expected.read(BLOCK_SIZE), actual.read(BLOCK_SIZE)
            if left != right:
                return offset + next(
                    (n for n, (a, b) in enumerate(zip(left, right)) if a != b),
                    min(len(left), len(right)),
                )
            if not left:
                return None
            offset += len(left)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("case_dir", type=Path)
    parser.add_argument("reference", type=Path)
    parser.add_argument("result", type=Path)
    parser.add_argument("validator_exit", type=int)
    parser.add_argument("verdict", type=Path)
    args = parser.parse_args()
    expected = json.loads((args.case_dir / "checksums/frozen-environment.json").read_text())
    reference_hash = sha256(args.reference)
    if reference_hash != expected["reference_sha256"]:
        raise SystemExit("Official log checksum mismatch")

    raw_log = args.result / "build.log"
    events_file = args.result / "build-events.jsonl"
    result_file = args.result / "build-result.json"
    verdict = {
        "case_id": json.loads((args.case_dir / "case.json").read_text())["case_id"],
        "validator_exit": args.validator_exit,
        "reference_sha256": reference_hash,
        "reference_bytes": args.reference.stat().st_size,
        "status": "build_evidence_missing",
    }
    if raw_log.is_file() and events_file.is_file() and result_file.is_file():
        result = json.loads(result_file.read_text())
        events = [json.loads(line) for line in events_file.read_text().splitlines() if line]
        if result["case_id"] != verdict["case_id"]:
            raise SystemExit("Build result case identity mismatch")
        difference = first_difference(args.reference, raw_log)
        package_failed = (
            args.validator_exit != 0 and result["status"] == "failed"
            and result["build_exit_code"] not in (None, 0)
            and any(e.get("stage") == "package_build" and e.get("state") == "failed" for e in events)
        )
        verdict.update(
            status="exact" if package_failed and difference is None else
                   "byte_mismatch" if package_failed else "build_failure_unverified",
            package_failed=package_failed,
            build_exit_code=result["build_exit_code"],
            replay_sha256=sha256(raw_log),
            replay_bytes=raw_log.stat().st_size,
            first_difference_byte=None if difference is None else difference + 1,
        )
    args.verdict.write_text(json.dumps(verdict, indent=2) + "\n")
    print(json.dumps(verdict, indent=2))
    return 0 if verdict["status"] == "exact" else 1


if __name__ == "__main__":
    raise SystemExit(main())
