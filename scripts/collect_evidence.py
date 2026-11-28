#!/usr/bin/env python3
"""Record host, input provenance, every attempt and a compact reproducibility report."""
import argparse
import json
import os
import platform
import shutil
import subprocess
import time
from pathlib import Path

from pilot import ROOT, audit, case_path, digest, pilots, read_json


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def collect(case_id, work, bundle):
    dest = work / "evidence"
    dest.mkdir(exist_ok=True)
    for pattern in ("*.json", "*.exit", "validator-*.log", "effective-buildconfig-*.txt", "effective-recipe-*.dsc"):
        for path in work.glob(pattern):
            shutil.copyfile(path, dest / path.name)
    for path in bundle.glob("dependency-*.json"):
        shutil.copyfile(path, dest / path.name)
    for directory in work.glob("result-*/build-output"):
        target = dest / directory.parent.name
        target.mkdir(exist_ok=True)
        for name in ("build.log", "build-result.json", "build-diagnostics.json", "build-events.jsonl"):
            path = directory / name
            if path.is_file():
                shutil.copyfile(path, target / name)
    root = case_path(case_id)
    for name in ("case.json", "asset.json"):
        shutil.copyfile(root / name, dest / name)
    shutil.copyfile(root / "logs/target-failure.log.gz", dest / "target-failure.log.gz")
    verdict_path = work / "baseline-verdict.json"
    verdict = read_json(verdict_path) if verdict_path.exists() else {}
    host = read_json(work / "host.json") if (work / "host.json").exists() else {}
    timings = {p.stem: read_json(p) for p in work.glob("timing-*.json")}
    report = {"case_id": case_id, "category": verdict.get("category", "infrastructure"),
              "status": verdict.get("status", "build_evidence_missing"),
              "reasons": verdict.get("reasons", ["No baseline verdict; inspect preparation/validator logs"]),
              "wall_seconds": round(time.time() - host["started_unix"], 2) if host else None,
              "timings": timings, "run_url": host.get("run_url"), "commit": host.get("commit"),
              "build_exit_code": verdict.get("build_exit_code"),
              "reference_sha256": verdict.get("reference_sha256"),
              "replay_sha256": verdict.get("replay_sha256")}
    write(dest / "report.json", report)
    hashes = {str(p.relative_to(dest)).replace("\\", "/"): digest(p)
              for p in dest.rglob("*") if p.is_file() and p.name != "evidence-sha256.json"}
    write(dest / "evidence-sha256.json", hashes)
    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as handle:
            handle.write(f"### {case_id}\n\n复现判定：**{report['category']}**；总耗时 {report['wall_seconds']} 秒。\n\n")
            for reason in report["reasons"]:
                handle.write(f"- {reason}\n")
    print(json.dumps(report, ensure_ascii=False))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["start", "collect"])
    parser.add_argument("case_id")
    parser.add_argument("work", type=Path)
    parser.add_argument("bundle", type=Path)
    args = parser.parse_args()
    args.work.mkdir(parents=True, exist_ok=True)
    if args.mode == "collect":
        collect(args.case_id, args.work, args.bundle)
        return
    env = os.environ
    host = {"started_unix": time.time(), "case_id": args.case_id, "machine": platform.machine(),
            "kernel": platform.release(), "cpu_count": os.cpu_count(),
            "runner_arch": env.get("RUNNER_ARCH"), "runner_image": env.get("ImageOS"),
            "runner_image_version": env.get("ImageVersion"), "commit": env.get("GITHUB_SHA"),
            "run_attempt": env.get("GITHUB_RUN_ATTEMPT"),
            "run_url": f"{env.get('GITHUB_SERVER_URL', '')}/{env.get('GITHUB_REPOSITORY', '')}/actions/runs/{env.get('GITHUB_RUN_ID', '')}"}
    write(args.work / "host.json", host)
    write(args.work / "input-audit.json", audit(args.case_id))
    if shutil.which("lscpu"):
        (args.work / "host-lscpu.json").write_text(subprocess.check_output(["lscpu", "-J"], text=True), encoding="utf-8")


if __name__ == "__main__":
    main()

