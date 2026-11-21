#!/usr/bin/env python3
"""Upload verified server-side case archives to the public frozen-cases Release."""

import argparse
import csv
import json
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from export_frozen_case import sha256


REPO = "MegaFlowAI/BuildBench-Reproduction"
API = f"https://api.github.com/repos/{REPO}"
UPLOADS = f"https://uploads.github.com/repos/{REPO}"


def request(url, token, method="GET", stream=None, size=None):
    headers = {
        "Authorization": "Bearer " + token,
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    if stream:
        headers.update({"Content-Length": str(size), "Content-Type": "application/zstd"})
    with urlopen(Request(url, stream, headers, method=method), timeout=120) as response:
        return None if response.status == 204 else json.load(response)


def listed_assets(release_id, token):
    assets = {}
    page = 1
    while True:
        entries = request(f"{API}/releases/{release_id}/assets?per_page=100&page={page}", token)
        assets.update((entry["name"], entry) for entry in entries)
        if len(entries) < 100:
            return assets
        page += 1


def check_uploaded(entry, record):
    return (entry["state"] == "uploaded" and entry["size"] == record["bytes"]
            and entry["digest"] == "sha256:" + record["sha256"])


def publish(path, record, existing, release_id, token):
    if existing and check_uploaded(existing, record):
        return {"file": path.name, "status": "already_uploaded", "id": existing["id"]}
    if existing:
        # Delete only incomplete uploads of this exact archive. Preserve completed assets.
        if existing["state"] != "starter" or existing["size"] != record["bytes"]:
            raise ValueError("Release already contains a conflicting asset")
        request(f"{API}/releases/assets/{existing['id']}", token, method="DELETE")
    if path.stat().st_size != record["bytes"] or sha256(path) != record["sha256"]:
        raise ValueError("Server archive differs from the committed description")
    with path.open("rb") as stream:
        uploaded = request(
            f"{UPLOADS}/releases/{release_id}/assets?name={path.name}",
            token, method="POST", stream=stream, size=record["bytes"],
        )
    if not check_uploaded(uploaded, record):
        raise ValueError("GitHub returned a different asset digest or size")
    return {"file": path.name, "status": "uploaded", "id": uploaded["id"],
            "sha256": record["sha256"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive_dir", type=Path)
    parser.add_argument("--workers", default=4, type=int, choices=range(1, 9))
    parser.add_argument("--exclude", action="append", default=[])
    args = parser.parse_args()
    token = sys.stdin.readline().strip()
    if not token:
        parser.error("Read the GitHub token from standard input")
    release_id = request(f"{API}/releases/tags/frozen-cases-v1", token)["id"]
    existing = listed_assets(release_id, token)
    with Path("docs/public-baselines.csv").open(encoding="utf-8", newline="") as data:
        pending = {row["case"] for row in csv.DictReader(data) if row["tier"] == "pending"}
    records = []
    for asset in sorted(Path("cases").glob("*/*/asset.json")):
        case = asset.parent.name
        if case in args.exclude:
            continue
        record = json.loads(asset.read_text())
        if not re.fullmatch(r"launchpad-[a-z0-9-]+", case) or record["file"] != case + ".tar.zst":
            raise ValueError(f"Bad case archive name: {case}")
        records.append((case, record))
    records.sort(key=lambda item: (item[0] not in pending, item[1]["bytes"]))

    def upload(item):
        _, record = item
        name = record["file"]
        path = args.archive_dir / name
        current = existing.get(name)
        for attempt in range(3):
            try:
                result = publish(path, record, current, release_id, token)
                break
            except (HTTPError, URLError, TimeoutError) as error:
                if attempt == 2:
                    result = {"file": name, "status": "upload_failed", "reason": str(error)}
                    break
                time.sleep(3 * (attempt + 1))
                try:
                    current = listed_assets(release_id, token).get(name)
                except (URLError, TimeoutError):
                    current = None
            except (ValueError, OSError) as error:
                result = {"file": name, "status": "upload_failed", "reason": str(error)}
                break
        print(json.dumps(result), flush=True)
        return result["status"] == "upload_failed"

    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        failed = sum(pool.map(upload, records))
    print(json.dumps({"files": len(records), "failed": failed}), flush=True)
    return min(failed, 1)


if __name__ == "__main__":
    raise SystemExit(main())
