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
source_matrix = []
for case in unique_ids:
    for direction in ("aarch64-to-x86_64", "x86_64-to-aarch64"):
        metadata = Path("cases") / direction / case / "case.json"
        if metadata.is_file():
            record = json.loads(metadata.read_text())
            source_arch = {"aarch64": "arm64", "x86_64": "amd64"}[record["platform"]["source_arch"]]
            target_arch = {"aarch64": "arm64", "x86_64": "amd64"}[record["platform"]["target_arch"]]
            if source_arch != target_arch:
                source_matrix.append({"case": case, "runner": RUNNERS[source_arch]})
            break
if len(matrix) + len(source_matrix) > 256:
    raise SystemExit("矩阵超过 GitHub Actions 256 个 job 的上限")
print(json.dumps({"include": matrix, "source_include": source_matrix,
                  "has_source": bool(source_matrix)}))
