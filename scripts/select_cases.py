#!/usr/bin/env python3
"""根据用例目录为原生 runner 生成 Actions 矩阵。"""
import json
import sys
from pathlib import Path

CASES = json.loads(Path("cases.json").read_text())
CONTROLS = {
    "launchpad-questing-amd64-arm64-golf-baef926efdc3",
    "launchpad-noble-arm64-amd64-globalplatform-df0b1ad38fd5",
}
selection = sys.argv[1]
if selection == "pending":
    selected = [case for case, data in CASES.items() if data["handover_status"] == "pending"]
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
print(json.dumps({"include": [{"case": case, "runner": runners[CASES[case]["architecture"]]} for case in selected]}))
