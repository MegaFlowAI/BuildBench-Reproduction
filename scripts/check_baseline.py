#!/usr/bin/env python3
"""对比原始构建的失败诊断，缺少明确证据时拒绝进入补丁阶段。"""
import collections
import json
import re
import sys
from pathlib import Path

from run_baseline import TIMEOUT, historical_limit

# 匹配失败阶段和明确诊断。编译命令、时间和最终 make 包装层单独保留在完整日志中。
FAILURE = re.compile(
    r"\berror(?:\[[A-Z0-9]+\])?: |\bFatal: |undefined reference to |"
    r"assertion failed|^FAIL[!: ]|^--- FAIL: |^\[  FAILED  \]|^QFATAL |"
    r"^panic: |Segmentation fault| ->  (?:failed|broken):",
    re.I,
)
WRAPPER = re.compile(r"^(?:dpkg-buildpackage:|dh_.*returned exit code|make(?:\[\d+\])?:)")
CONTROL = {
    "launchpad-questing-amd64-arm64-golf-baef926efdc3": (
        "-fcf-protection=full", "not supported for this target",
    ),
    "launchpad-noble-arm64-amd64-globalplatform-df0b1ad38fd5": (
        "undefined reference", "__wrap_RAND_bytes",
    ),
}


def fingerprints(path, start):
    found = collections.Counter()
    active = False
    with Path(path).open("rb") as handle:
        for chunk in iter(lambda: handle.readline(262144), b""):
            line = chunk.decode("utf-8", "replace").strip()
            if line.startswith(start):
                active = True
            if not active or len(line) > 2500 or not FAILURE.search(line) or WRAPPER.search(line):
                continue
            line = line.translate(str.maketrans({chr(8216): chr(39), chr(8217): chr(39), chr(96): chr(39)}))
            line = line.replace("/work/source", "<source>").replace("/<<PKGBUILDDIR>>", "<source>")
            line = re.sub(r"/tmp/[^ /'\x22]+", "/tmp/<temp>", line)
            line = re.sub(r"\b0x[0-9a-f]+\b", "<address>", line)
            line = re.sub(r"\s+\[\d+\.\d+s\]$|\s+\(\d+(?:\.\d+)?(?:s| ms)\)$", "", line)
            found[" ".join(line.split())] += 1
    return found


def main():
    case_id, reference, replay, status = sys.argv[1:]
    if status == "0":
        raise SystemExit("Baseline built successfully. Patch validation is gated.")
    idle = Path(replay).with_name("idle-timeout.json")
    if idle.is_file():
        evidence = json.loads(idle.read_text())
        limit = historical_limit(reference)
        if limit != evidence["historical_limit_seconds"] or evidence["seconds_without_output"] < limit:
            raise SystemExit("Historical idle threshold did not match")
        def last_lines(path):
            tail = collections.deque(maxlen=3)
            with Path(path).open("rb") as handle:
                for chunk in iter(lambda: handle.readline(262144), b""):
                    line = chunk.decode("utf-8", "replace").strip()
                    if TIMEOUT.match(line):
                        break
                    if line:
                        tail.append(" ".join(line.split()))
            return tail

        if last_lines(reference) != last_lines(replay):
            raise SystemExit("Last three lines before silence did not match")
        print(f"Baseline matched historical failure after {limit} seconds of inactivity")
        return
    with Path(replay).open("rb") as handle:
        marker = f"BUILD_BENCH_BUILD_EXIT={status}".encode()
        if not any(line.strip() == marker for line in iter(lambda: handle.readline(262144), b"")):
            raise SystemExit("No original package exit evidence. Patch validation is gated.")
    historical = fingerprints(reference, "dpkg-buildpackage:")
    actual = fingerprints(replay, "BUILD_BENCH_BUILD_STARTED")
    if case_id in CONTROL:
        required = CONTROL[case_id]
        historical = collections.Counter({k: v for k, v in historical.items() if all(s in k for s in required)})
        actual = collections.Counter({k: v for k, v in actual.items() if all(s in k for s in required)})
    if historical and historical == actual:
        print(f"Baseline diagnostic match: {sum(historical.values())} lines")
        return
    print("Missing diagnostics:", historical - actual)
    print("Additional diagnostics:", actual - historical)
    raise SystemExit("Baseline failure did not match the reference. Patch validation is gated.")


if __name__ == "__main__":
    main()
