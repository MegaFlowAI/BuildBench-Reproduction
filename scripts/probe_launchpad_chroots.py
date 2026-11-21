#!/usr/bin/env python3
"""Find current public Launchpad chroots that match recorded historical SHA-1s."""

import argparse
import hashlib
import json
from pathlib import Path
from urllib.parse import urlencode, urlparse
from urllib.request import urlopen
from urllib.error import HTTPError


LAUNCHPAD = "https://api.launchpad.net/devel/ubuntu"


def known_chroots():
    cases = json.loads(Path("cases.json").read_text())
    hosts = json.loads(Path("cases/historical-hosts.json").read_text())
    result = {}
    for case, metadata in cases.items():
        target = metadata["suite"], metadata["architecture"]
        result.setdefault(target, {}).setdefault(hosts[case]["chroot_sha1"], []).append(case)
    return result


def api(series, arch, pocket, operation):
    params = urlencode({"ws.op": operation, "pocket": pocket, "image_type": "Chroot tarball"})
    try:
        with urlopen(f"{LAUNCHPAD}/{series}/{arch}?{params}", timeout=30) as response:
            return json.load(response)
    except HTTPError as error:
        if error.code not in {403, 404, 410}:
            raise
        return None


def inspect(series, arch, work):
    expected = known_chroots()[series, arch]
    work.mkdir(parents=True, exist_ok=True)
    result = {"series": series, "arch": arch, "expected": expected, "candidates": []}
    seen = set()
    for pocket in ("Proposed", "Release"):
        url = api(series, arch, pocket, "getChrootURL")
        if url in seen or not url:
            continue
        seen.add(url)
        if urlparse(url).hostname != "launchpadlibrarian.net":
            raise ValueError(f"Unexpected Launchpad chroot origin: {url}")
        registered = api(series, arch, pocket, "getChrootHash") or {}
        sha1 = hashlib.sha1()
        sha256 = hashlib.sha256()
        temporary = work / "download.tar"
        with urlopen(url, timeout=120) as response, temporary.open("wb") as file:
            for block in iter(lambda: response.read(1024 * 1024), b""):
                file.write(block)
                sha1.update(block)
                sha256.update(block)
        actual = {"sha1": sha1.hexdigest(), "sha256": sha256.hexdigest()}
        if any(actual[k] != registered[k] for k in actual.keys() & registered.keys()):
            raise ValueError("Canonical chroot digest mismatch")
        asset = None
        if actual["sha1"] in expected:
            asset = "launchpad-chroot-" + actual["sha1"] + ".tar"
            temporary.rename(work / asset)
        else:
            temporary.unlink()
        result["candidates"].append({"pocket": pocket, "url": url, "asset": asset, **actual})
    (work / "chroot-evidence.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    subs = parser.add_subparsers(dest="command", required=True)
    subs.add_parser("matrix")
    target = subs.add_parser("inspect")
    target.add_argument("series")
    target.add_argument("arch")
    target.add_argument("work", type=Path)
    args = parser.parse_args()
    if args.command == "matrix":
        print(json.dumps({"include": [
            {"series": suite, "arch": arch} for suite, arch in sorted(known_chroots())
        ]}, separators=(",", ":")))
    else:
        inspect(args.series, args.arch, args.work)


if __name__ == "__main__":
    main()
