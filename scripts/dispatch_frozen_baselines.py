#!/usr/bin/env python3
"""Schedule each uploaded frozen baseline, with a bound on active matrix jobs."""

import argparse
import base64
import json
import re
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from frozen_release import available_cases, frozen_cases
from publish_frozen_assets import API, listed_assets, request


WORKFLOW = API + "/actions/workflows/frozen-baseline.yml"
CASE_ID = re.compile(r"launchpad-[a-z0-9-]+")


def runs(token):
    page = 1
    while True:
        entries = request(
            f"{WORKFLOW}/runs?event=workflow_dispatch&per_page=100&page={page}", token,
        )["workflow_runs"]
        yield from entries
        if len(entries) < 100:
            return
        page += 1


def observed_cases(run, token):
    cases = set(CASE_ID.findall(run["display_title"]))
    if cases and run["conclusion"] not in {"cancelled", "startup_failure", "skipped"}:
        return cases
    jobs = request(f"{run['jobs_url']}?per_page=100", token)["jobs"]
    return {
        match[0] for job in jobs
        if (match := CASE_ID.search(job["name"]))
        and any(step["name"] == "Run frozen original build and compare the raw log"
                and step["conclusion"] in {"success", "failure"} for step in job["steps"])
    }


def dispatch(cases, token):
    payload = {"ref": "main", "inputs": {"selection": ",".join(cases)}}
    headers = {"Authorization": "Bearer " + token, "Content-Type": "application/json",
               "Accept": "application/vnd.github+json"}
    call = Request(WORKFLOW + "/dispatches", json.dumps(payload).encode(), headers, method="POST")
    with urlopen(call, timeout=30) as response:
        body = response.read()
    result = {"cases": cases, "status": "dispatched"}
    if body:
        result["run"] = json.loads(body)
    print(json.dumps(result), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-active", type=int, default=12, choices=range(1, 13))
    parser.add_argument("--batch-size", type=int, default=6, choices=range(1, 13))
    parser.add_argument("--once", action="store_true")
    args = parser.parse_args()
    token = sys.stdin.readline().strip()
    if not token:
        parser.error("Read the GitHub token from standard input")
    release_id = request(f"{API}/releases/tags/frozen-cases-v1", token)["id"]
    inventory = frozen_cases()
    dispatched = set()
    while True:
        try:
            attempted = set(dispatched)
            active = set()
            for run in runs(token):
                seen = observed_cases(run, token)
                attempted.update(seen)
                if run["status"] != "completed":
                    active.update(seen)
            assets = listed_assets(release_id, token)
            source = request(f"{API}/contents/cases/integrity-repairs.json?ref=main", token)
            repairs = json.loads(base64.b64decode(source["content"]))
            available = available_cases(inventory, assets.values(), repairs)
            limit = max(0, min(args.batch_size, args.max_active - len(active)))
            ready = sorted(available.keys() - attempted)[:limit]
            if ready:
                dispatch(ready, token)
                dispatched.update(ready)
            if inventory.keys() <= attempted or args.once:
                return 0
        except (HTTPError, URLError, TimeoutError) as error:
            print(json.dumps({"status": "dispatch_retry", "reason": str(error)}), flush=True)
            if args.once:
                return 1
        time.sleep(60)


if __name__ == "__main__":
    raise SystemExit(main())
