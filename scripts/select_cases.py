#!/usr/bin/env python3
"""根据逗号分隔的 case ID 列表生成 Actions 矩阵。"""
import json
import sys
from pathlib import Path

from pilot import ROOT, pilots

CASES = json.loads((ROOT / "cases.json").read_text(encoding="utf-8"))
RUNNERS = {"arm64": "ubuntu-24.04-arm", "amd64": "ubuntu-24.04"}

selection = sys.argv[1].strip() if len(sys.argv) > 1 else ""
if selection in {"pilot", "isa-10"}:
    ids = list(pilots())
elif selection in {"arm64", "x86_64-to-aarch64"}:
    ids = [case for case, details in CASES.items() if details["architecture"] == "arm64"]
elif selection == "repair-1":
    ids = [case for case in CASES if case in {
        "launchpad-jammy-amd64-arm64-python-hug-c0ae7695bec4",
        "launchpad-jammy-amd64-arm64-libqalculate-150db9c6c990",
        "launchpad-noble-amd64-arm64-ectrans-50e45e72102d",
        "launchpad-noble-amd64-arm64-ecmwflibs-d611bdd10253",
    }]
elif selection == "repair-2":
    ids = ["launchpad-jammy-amd64-arm64-python-hug-c0ae7695bec4"]
elif selection == "repair-3":
    ids = ["launchpad-jammy-amd64-arm64-python-hug-c0ae7695bec4"]
elif selection == "repair-4":
    ids = [case for case in CASES if case in {
        "launchpad-mantic-amd64-arm64-haskell-tldr-e08dd2db85e1",
        "launchpad-noble-amd64-arm64-haskell-copilot-c99-1fb879daa3b8",
        "launchpad-oracular-amd64-arm64-python-msgspec-6f918d331f35",
        "launchpad-questing-amd64-arm64-kdsoap-95149c86d1d7",
    }]
elif selection == "repair-5":
    ids = [case for case in CASES if case in {
        "launchpad-oracular-amd64-arm64-lxqt-qtplugin-de887d7c53b9",
        "launchpad-plucky-amd64-arm64-tinycbor-835bc0b749b6",
        "launchpad-plucky-amd64-arm64-gcc-15-cross-26cf66d777b8",
        "launchpad-questing-amd64-arm64-ktorrent-ee287a61e3d5",
        "launchpad-resolute-amd64-arm64-libelas-8f3152c7b0d2",
        "launchpad-resolute-amd64-arm64-gcc-mingw-w64-b0ed8efd1dee",
    }]
elif selection == "repair-6":
    ids = [case for case in CASES if case in {
        "launchpad-questing-amd64-arm64-rocm-llvm-8e2801d0c140",
        "launchpad-questing-amd64-arm64-xmbmon-ad2ecb4e1183",
    }]
else:
    ids = [item.strip() for item in selection.split(",") if item.strip()]
if not ids:
    raise SystemExit("selection 不能为空：请填一个或多个 case ID，用英文逗号分隔")
unknown = [item for item in ids if item not in CASES]
if unknown:
    raise SystemExit(f"未知 case ID: {unknown}")
matrix = [
    {"case": case, "runner": RUNNERS[CASES[case]["architecture"]]}
    for case in dict.fromkeys(ids)
]
if len(matrix) > 256:
    raise SystemExit("矩阵超过 GitHub Actions 256 个 job 的上限")
print(json.dumps({"include": matrix}))
