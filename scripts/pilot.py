#!/usr/bin/env python3
"""Shared pilot selection and offline verification of official inputs."""
import argparse
import gzip
import hashlib
import json
import re
import tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / "pilots/isa-10.json"


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def pilots():
    return {item["case_id"]: item for item in read_json(CONFIG)["cases"]}


def case_path(case_id):
    paths = list((ROOT / "cases").glob("*/" + case_id))
    if len(paths) != 1:
        raise ValueError(f"Expected one case directory: {case_id}")
    return paths[0]


def digest(path):
    with Path(path).open("rb") as handle:
        return hashlib.file_digest(handle, "sha256").hexdigest()


def reference_bytes(path):
    path = Path(path)
    return gzip.decompress(path.read_bytes()) if path.suffix == ".gz" else path.read_bytes()


def root_matches(lines, patterns):
    return [any(re.search(pattern, line) for line in lines) for pattern in patterns]


def audit(case_id):
    spec = pilots()[case_id]
    root = case_path(case_id)
    case = read_json(root / "case.json")
    source_lock = read_json(root / "checksums/source-input.sha256.json")
    for item in source_lock["files"]:
        path = root / "source/input" / item["path"]
        if not path.is_file() or path.stat().st_size != item["bytes"] or digest(path) != item["sha256"]:
            raise ValueError(f"Source integrity mismatch: {path}")
    ref = reference_bytes(root / "logs/target-failure.log.gz")
    ref_sha = hashlib.sha256(ref).hexdigest()
    if ref_sha != read_json(root / "checksums/frozen-environment.json")["reference_sha256"]:
        raise ValueError(f"Official reference integrity mismatch: {case_id}")
    text = ref.decode("utf-8", "replace")
    if not all(root_matches(text.splitlines(), spec["root_patterns"])):
        raise ValueError(f"Root-cause signature absent from official log: {case_id}")
    evidence = []
    for item in spec["source_checks"]:
        with tarfile.open(root / "source/input" / item["archive"]) as archive:
            member = archive.getmember(item["member"])
            if not member.isfile() or member.size > 2_000_000:
                raise ValueError("Unexpected source evidence member")
            source = archive.extractfile(member).read().decode("utf-8", "replace")
        hits = [{"line": n, "text": line.strip()} for n, line in enumerate(source.splitlines(), 1)
                if re.search(item["pattern"], line)]
        if not hits:
            raise ValueError(f"Architecture-specific source evidence absent: {item}")
        evidence.append({**item, "matches": hits})
    def seconds(field):
        match = re.search(r"^" + field + r": (\d+)$", text, re.M)
        return int(match[1]) if match else None
    return {"case_id": case_id, "package": case["package"], "platform": case["platform"],
            "status": "inputs_verified_build_not_run", "reference_sha256": ref_sha,
            "source_files_verified": len(source_lock["files"]), "source_evidence": evidence,
            "official_build_seconds": seconds("Build-Time"),
            "official_install_seconds": seconds("Install-Time"),
            "asset_bytes": read_json(root / "asset.json")["bytes"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["audit", "selection"])
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.command == "selection":
        print(",".join(pilots()))
        return
    report = {"status": "inputs_verified_build_not_run", "cases": [audit(cid) for cid in pilots()]}
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Verified official sources, reference logs and root-cause evidence: {len(report['cases'])} cases; no builds executed")


if __name__ == "__main__":
    main()
