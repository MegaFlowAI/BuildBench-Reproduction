#!/usr/bin/env python3
"""按官方日志记录的静默时限监控原始构建。"""
import json
import re
import subprocess
import sys
import time
from pathlib import Path

TIMEOUT = re.compile(r"^E: Build killed with signal TERM after (\d+) minutes of inactivity")


def historical_limit(reference):
    with Path(reference).open("rb") as handle:
        for data in iter(lambda: handle.readline(262144), b""):
            if match := TIMEOUT.match(data.decode("utf-8", "replace")):
                return int(match[1]) * 60
    return None


def main():
    reference, logfile, evidence, container, *command = sys.argv[1:]
    limit = historical_limit(reference)
    with Path(logfile).open("wb") as destination:
        process = subprocess.Popen(command, stdout=destination, stderr=subprocess.STDOUT)
        if limit is None:
            return process.wait()
        last_write = time.monotonic()
        previous = 0
        while process.poll() is None:
            time.sleep(2)
            size = Path(logfile).stat().st_size
            now = time.monotonic()
            if size != previous:
                previous, last_write = size, now
            elif now - last_write >= limit:
                with Path(logfile).open("rb") as log:
                    if not any(line.startswith(b"BUILD_BENCH_BUILD_STARTED") for line in log):
                        continue
                subprocess.run(["docker", "stop", "--time", "10", container], check=True)
                code = process.wait()
                Path(evidence).write_text(json.dumps({
                    "seconds_without_output": round(now - last_write, 3),
                    "historical_limit_seconds": limit,
                    "container_exit": code,
                }))
                return code
    return process.returncode


if __name__ == "__main__":
    sys.exit(main())
