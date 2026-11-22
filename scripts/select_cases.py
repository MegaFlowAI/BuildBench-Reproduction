#!/usr/bin/env python3
"""根据用例目录为原生 runner 生成 Actions 矩阵。"""
import csv
import json
import sys
from pathlib import Path

CASES = json.loads(Path("cases.json").read_text())
CONTROLS = {
    "launchpad-questing-amd64-arm64-golf-baef926efdc3",
    "launchpad-noble-arm64-amd64-globalplatform-df0b1ad38fd5",
}
selection = sys.argv[1]
ALIASES = {
    "全量": "all", "全部": "all", "所有": "all",
    "待复现": "pending", "未验证": "unverified", "试点": "pilot",
    "ARM64": "arm64", "arm": "arm64", "aarch64": "arm64",
    "X86": "amd64", "x86_64": "amd64", "x64": "amd64", "amd": "amd64",
}
selection = ALIASES.get(selection.strip(), selection)
variants = len(sys.argv) > 2 and sys.argv[2] == "true"
if selection == "pending":
    selected = [case for case, data in CASES.items() if data["handover_status"] == "pending"]
elif selection == "unverified":
    with Path("docs/public-baselines.csv").open(newline="", encoding="utf-8") as ledger:
        selected = [row["case"] for row in csv.DictReader(ledger) if row["tier"] == "pending"]
elif selection == "pilot":
    selected = [case for case, data in CASES.items() if case in CONTROLS or data["handover_status"] == "pending"]
elif selection in ("all", "arm64", "amd64"):
    selected = [case for case, data in CASES.items() if selection in ("all", data["architecture"])]
elif selection in CASES:
    selected = [selection]
else:
    requested = [item.strip() for item in selection.replace("\n", ",").split(",") if item.strip()]
    unknown = [item for item in requested if item not in CASES]
    if unknown:
        raise SystemExit(f"Unknown case ids: {unknown}")
    selected = requested
runners = {"arm64": "ubuntu-24.04-arm", "amd64": "ubuntu-24.04"}
matrix = []
for case in dict.fromkeys(selected):
    data = CASES[case]
    profiles = data.get("variants", {}) if variants else ("",)
    for profile in profiles:
        matrix.append({"case": case, "runner": runners[data["architecture"]], "variant": profile})
if not matrix:
    raise SystemExit("No configured case variants for this selection" if variants else "No cases selected")
if len(matrix) > 256:
    raise SystemExit("Matrix exceeds the GitHub Actions limit of 256 jobs")
print(json.dumps({"include": matrix}))
