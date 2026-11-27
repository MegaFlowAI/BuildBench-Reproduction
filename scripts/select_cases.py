#!/usr/bin/env python3
"""根据逗号分隔的 case ID 列表生成 Actions 矩阵。"""
import json
import sys
from pathlib import Path

CASES = json.loads(Path("cases.json").read_text())
RUNNERS = {"arm64": "ubuntu-24.04-arm", "amd64": "ubuntu-24.04"}

selection = sys.argv[1].strip()
ids = [item.strip() for item in selection.split(",") if item.strip()]
if not ids:
    raise SystemExit("selection 不能为空：请填一个或多个 case ID，用英文逗号分隔")
unknown = [item for item in ids if item not in CASES]
if unknown:
    raise SystemExit(f"未知 case ID: {unknown}")
unique_ids = list(dict.fromkeys(ids))
matrix = [
    {"case": case, "runner": RUNNERS[CASES[case]["architecture"]]}
    for case in unique_ids
]
print(json.dumps({"include": matrix}))
