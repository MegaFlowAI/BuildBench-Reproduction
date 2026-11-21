#!/usr/bin/env python3
"""下载并校验单个官方用例。"""
import hashlib
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

RELEASE = "https://matrix.cstcloud.cn/build-bench/releases/training-set/v0.1"
ARCHIVE = "buildbench-development-cases-v0.1.zip"
SHA256 = "94372a28dbd81ece8f5007b83ec4b4ff1b0590de43a528be4461ae7f2bbd675d"

case_id, arch, target = sys.argv[1:]
target = Path(target)
target.mkdir(parents=True, exist_ok=True)
archive = target / ARCHIVE
subprocess.run(["curl", "-fSL", "--retry", "3", "--max-time", "600",
                f"{RELEASE}/{ARCHIVE}", "-o", archive], check=True)
with archive.open("rb") as handle:
    if hashlib.file_digest(handle, "sha256").hexdigest() != SHA256:
        raise SystemExit("Official archive checksum mismatch")
direction = {"arm64": "x86_64-to-aarch64", "amd64": "aarch64-to-x86_64"}[arch]
marker = f"/cases/{direction}/{case_id}/"
with zipfile.ZipFile(archive) as source:
    for member in source.infolist():
        if marker not in f"/{member.filename}" or member.is_dir():
            continue
        relative = f"/{member.filename}".split(marker, 1)[1]
        if relative != "logs/target-failure.log" and not relative.startswith("source/input/"):
            continue
        parts = Path(relative).parts
        if ".." in parts or Path(relative).is_absolute():
            raise SystemExit(f"Unexpected archive path {relative}")
        output = target / relative
        output.parent.mkdir(parents=True, exist_ok=True)
        with source.open(member) as incoming, output.open("wb") as outgoing:
            shutil.copyfileobj(incoming, outgoing)
archive.unlink()
assert list((target / "source/input").glob("*.dsc"))
assert (target / "logs/target-failure.log").is_file()
