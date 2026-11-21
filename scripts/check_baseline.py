#!/usr/bin/env python3
"""对比原始构建的失败诊断，缺少明确证据时拒绝进入补丁阶段。"""
import collections
import json
import re
import sys
from pathlib import Path

from run_baseline import TIMEOUT, historical_limit

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
STARTED = b"BUILD_BENCH_BUILD_STARTED"
EXIT = b"BUILD_BENCH_BUILD_EXIT="


def normalize(line):
    line = line.translate(str.maketrans({chr(8216): chr(39), chr(8217): chr(39), chr(96): chr(39)}))
    line = line.replace("/work/source", "<source>").replace("/<<PKGBUILDDIR>>", "<source>")
    line = re.sub(r"/tmp/[^ /'\x22]+", "/tmp/<temp>", line)
    line = re.sub(r"\b0x[0-9a-f]+\b", "<address>", line)
    line = re.sub(r"\b\d{2,}\b(?= Segmentation fault| Terminated| Killed| Aborted)", "<pid>", line)
    line = re.sub(r"(line \d+: )\d{2,}(?= Segmentation)", r"\1<pid>", line)
    line = re.sub(r"/tmp/<temp>/\d+", "/tmp/<temp>/<pid>", line)
    line = re.sub(r"\s+\[\d+\.\d+s\]$|\s+\(\d+(?:\.\d+)?(?:s| ms)\)$", "", line)
    return " ".join(line.split())


def fingerprints(path, start):
    found = collections.Counter()
    active = False
    with Path(path).open("rb") as handle:
        for chunk in iter(lambda: handle.readline(262144), b""):
            line = chunk.decode("utf-8", "replace").strip()
            if start is not None and line.startswith(start):
                active = True
            if start is not None and not active:
                continue
            if len(line) > 2500 or not FAILURE.search(line) or WRAPPER.search(line):
                continue
            found[normalize(line)] += 1
    return found


def build_events(log):
    started = 0
    exits = []
    with Path(log).open("rb") as handle:
        for chunk in iter(lambda: handle.readline(262144), b""):
            line = chunk.rstrip(b"\r\n")
            if line == STARTED:
                started += 1
            elif line.startswith(EXIT):
                exits.append(line[len(EXIT):])
    return started, exits


def compare(case_id, reference, replay, status, idle):
    try:
        code = int(status)
    except ValueError:
        return "invalid_status", {"exit": status}
    started, exits = build_events(replay)
    if started != 1:
        return "build_start_unconfirmed", {"exit": code, "start_markers": started}

    limit = historical_limit(reference)
    if idle.is_file():
        evidence = json.loads(idle.read_text())
        if (limit is None or limit != evidence["historical_limit_seconds"] or
                evidence["seconds_without_output"] < limit or evidence["container_exit"] != code or
                code != 143 or exits):
            return "idle_termination_unconfirmed", {"exit": code, "idle": evidence}

        def last_lines(path):
            tail = collections.deque(maxlen=3)
            with Path(path).open("rb") as handle:
                for chunk in iter(lambda: handle.readline(262144), b""):
                    line = chunk.decode("utf-8", "replace").strip()
                    if TIMEOUT.match(line):
                        break
                    if line:
                        tail.append(normalize(line))
            return tail

        historical_tail = list(last_lines(reference))
        actual_tail = list(last_lines(replay))
        if len(historical_tail) != 3 or historical_tail != actual_tail:
            return "idle_tail_mismatch", {"historical_tail": historical_tail, "actual_tail": actual_tail}
        return "matched", {"kind": "idle_timeout", "exit": code, "idle": evidence, "tail": actual_tail}

    if exits != [str(code).encode()] or not 0 <= code <= 255:
        return "package_exit_unconfirmed", {"exit": code}
    if code == 0:
        return "baseline_success", {"exit": code}
    if limit is not None:
        return "expected_idle_timeout", {"exit": code, "historical_limit_seconds": limit}
    historical = fingerprints(reference, "dpkg-buildpackage:")
    if not historical:
        historical = fingerprints(reference, None)
        mode = "whole-log"
    else:
        mode = "section"
    actual = fingerprints(replay, "BUILD_BENCH_BUILD_STARTED")
    if case_id in CONTROL:
        mode = "control"
        required = CONTROL[case_id]
        historical = collections.Counter({k: v for k, v in historical.items() if all(s in k for s in required)})
        actual = collections.Counter({k: v for k, v in actual.items() if all(s in k for s in required)})
    result = {"exit": code, "kind": mode, "diagnostic_count": sum(historical.values())}
    if not historical:
        result["actual_count"] = sum(actual.values())
        return "historical_diagnostics_missing", result
    if historical == actual:
        return "matched", result
    result["missing"] = dict(historical - actual)
    result["additional"] = dict(actual - historical)
    return "diagnostic_mismatch", result


def main():
    case_id, reference, replay, code, idle, verdict_file = sys.argv[1:]
    status, details = compare(case_id, reference, replay, code, Path(idle))
    verdict = {"case": case_id, "status": status, **details}
    Path(verdict_file).write_text(json.dumps(verdict, indent=2) + "\n", encoding="utf-8")
    print(f"Baseline verdict: {status} ({details.get('kind', 'build')})")
    for key in ("missing", "additional"):
        if details.get(key):
            lines = list(details[key].items())
            print(f"{key} diagnostics ({len(lines)} unique): {lines[:12]}")
    return 0 if status == "matched" else 1


if __name__ == "__main__":
    sys.exit(main())
