#!/usr/bin/env python3
"""Summarize expected cases, including missing/cancelled jobs; never infer a match."""
import argparse
import json
from pathlib import Path

from pilot import read_json


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("evidence", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("matrix", help="JSON selection matrix, including every expected case")
    args = parser.parse_args()
    reports = {r["case_id"]: r for p in args.evidence.rglob("report.json") for r in [read_json(p)]}
    rows = [reports.get(item["case"], {"case_id": item["case"], "category": "evidence_missing", "wall_seconds": None})
            for item in json.loads(args.matrix)["include"]]
    matched = sum(r["category"] in {"isa_failure_reproduced", "historical_failure_reproduced"} for r in rows)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / "results.json").write_text(json.dumps({"matched": matched, "total": len(rows), "cases": rows}, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    lines = [f"复现匹配 {matched}/{len(rows)}。构建失败是预期，是否复现以此表和逐例证据为准。", "",
             "| Case | 判定 | 全流程秒数 |", "| --- | --- | --- |"]
    lines += [f"| {r['case_id']} | {r['category']} | {r.get('wall_seconds')} |" for r in rows]
    (args.output / "results.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("\n".join(lines))
    return 0 if matched == len(rows) else 1


if __name__ == "__main__":
    raise SystemExit(main())
