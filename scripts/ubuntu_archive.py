#!/usr/bin/env python3
"""Recover Debian dependencies from public Ubuntu archives."""
import gzip
import hashlib
import lzma
import subprocess
import tempfile
from pathlib import Path

SNAPSHOT = "https://snapshot.ubuntu.com/ubuntu"
LAUNCHPAD = "https://launchpad.net/ubuntu/+archive/primary/+files"


def fetch(url, destination, *, max_time=120):
    return subprocess.run(
        ["curl", "--silent", "--fail", "--location", "--retry", "3",
         "--connect-timeout", "15", "--max-time", str(max_time), url, "-o", str(destination)],
        check=False,
    ).returncode == 0


def _parse_index(handle, wanted, matched):
    fields = {}
    for line in handle:
        if line == "\n":
            name, version = fields.get("Package"), fields.get("Version")
            if name in wanted and (wanted[name] is None or wanted[name] == version):
                if {"Filename", "Architecture", "SHA256"} <= fields.keys():
                    matched[name] = dict(fields)
            fields = {}
        elif not line.startswith((" ", "\t")):
            key, sep, value = line.partition(": ")
            if sep and key in {"Package", "Version", "Architecture", "Filename", "SHA256"}:
                fields[key] = value.rstrip("\n")


def snapshot_index(root, suite, component, scratch, wanted, architecture):
    matched = {}
    for suffix, opener in ((".xz", lzma.open), (".gz", gzip.open)):
        path = scratch / f"{suite}-{component}{suffix}"
        url = f"{root}/dists/{suite}/{component}/binary-{architecture}/Packages{suffix}"
        if not fetch(url, path, max_time=240):
            continue
        with opener(path, "rt", encoding="utf-8", errors="replace") as handle:
            _parse_index(handle, wanted, matched)
        if len(matched) >= len(wanted):
            break
    return matched


def acquire(name, version, record, root, destination, architecture):
    from urllib.parse import quote

    basename = f"{name}_{version.split(':')[-1]}"
    if record:
        arch = record["Architecture"]
        candidates = [(f"{root}/{record['Filename']}", arch),
                      (f"{LAUNCHPAD}/{quote(f'{basename}_{arch}.deb')}", arch)]
    else:
        candidates = [(f"{LAUNCHPAD}/{quote(f'{basename}_{arch}.deb')}", arch)
                      for arch in (architecture, "all")]
    with tempfile.TemporaryDirectory(dir=destination) as scratch:
        path = Path(scratch) / "package.deb"
        for url, arch in candidates:
            if not fetch(url, path, max_time=420 if name.startswith("nvidia-cuda-") else 120):
                continue
            with path.open("rb") as handle:
                checksum = hashlib.sha256()
                for block in iter(lambda: handle.read(1048576), b""):
                    checksum.update(block)
            digest = checksum.hexdigest()
            if record and digest != record["SHA256"]:
                continue
            metadata = subprocess.run(
                ["dpkg-deb", "-f", str(path), "Package", "Version", "Architecture"],
                capture_output=True, text=True, check=False,
            )
            if metadata.returncode:
                continue
            fields = dict(line.split(": ", 1) for line in metadata.stdout.splitlines())
            if fields != {"Package": name, "Version": version, "Architecture": arch}:
                continue
            filename = f"{basename}_{arch}.deb"
            path.rename(destination / filename)
            return {"package": name, "version": version, "arch": arch, "filename": filename,
                    "sha256": digest, "url": url, "snapshot_sha256_verified": bool(record)}
    return None
