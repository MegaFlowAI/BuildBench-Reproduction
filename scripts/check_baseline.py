#!/usr/bin/env python3
"""对比原始构建的失败诊断，缺少明确证据时拒绝进入补丁阶段。"""
import collections
import hashlib
import json
import re
import sys
from pathlib import Path

from run_baseline import TIMEOUT, historical_limit

FAILURE = re.compile(
    r"\berror(?:\[[A-Z0-9]+\])?: |\bFatal: |undefined reference to |"
    r"assertion failed|^FAIL[!: ]|^--- FAIL: |^\[  FAILED  \]|^QFATAL |"
    r"^panic: |Segmentation fault| ->  (?:failed|broken):|"
    r"^help2man: can['’]t get |^dh_installdocs: Cannot find \(any matches for\)|"
    r"^[\w.]*(?:Error|Exception):\s+|\(NoMethodError\)$|: cxref: syntax error$|"
    r"^(?:mv: cannot stat|rmdir: failed to remove|chmod: cannot access) .*: No such file or directory$|"
    r"^/usr/share/cargo/bin/dh-cargo-built-using: abort: |"
    r"^E: pybuild .*: configure: plugin pyproject failed with: |"
    r"^objcopy: .*: file format not recognized$|^Compiled library .* makes inconsistent assumptions over library |"
    r"^/bin/sh: \d+: (?:cannot create .*: Directory nonexistent|cd: can.t cd to \S+)$|"
    r"^tar: .*: Cannot open: No such file or directory$|"
    r"^not ok \d+ - (?!.*#\s*TODO\b).+|^#\s+(?:got|expected):",
    re.I,
)
WRAPPER = re.compile(r"^(?:dpkg-buildpackage:|dh_.*returned exit code|make(?:\[\d+\])?:)")
CMAKE_ERROR = re.compile(r"^CMake Error(?: (?:at|in) |:)")
MAKE_FAILURE = re.compile(r"^make(?:\[\d+\])?: .*?(?:Illegal instruction \(core dumped\)|: No such file or directory)$")
CONTROL = {
    "launchpad-questing-amd64-arm64-golf-baef926efdc3": (
        "-fcf-protection=full", "not supported for this target",
    ),
    "launchpad-noble-arm64-amd64-globalplatform-df0b1ad38fd5": (
        "undefined reference", "__wrap_RAND_bytes",
    ),
}
AVO = "launchpad-groovy-arm64-amd64-golang-github-mmcloughlin-avo-472bebf32a26"
AVO_STACK = re.compile(r"(?P<site>(?:dot|geohash)\.s:\d+) (?P<offset>\+0x[0-9a-f]+) fp=")
NGINX = "launchpad-oracular-arm64-amd64-nginx-6e36942eabb2"
NGINX_CONTROL = re.compile(r"^(dpkg-deb: error: parsing file 'debian/nginx-core/DEBIAN/control') near line \d+( package 'nginx-core':)$")
CASE_DIAGNOSTICS = {
    "launchpad-groovy-arm64-amd64-alertmanager-irc-relay-6dae554a134b": re.compile(
        r"^github\.com/google/alertmanager-irc-relay\.TestSendAlertDisconnected\("
    ),
    "launchpad-noble-arm64-amd64-lua-luv-e9dbd90452a8": re.compile(
        r"^ok 98 thread - getaffinity, setaffinity$|"
        r"^make\[\d+\]: \*\*\* \[/usr/share/dh-lua/make/dh-lua.Makefile.single:\d+: "
        r"test-app-dynamic-real\] Error 139$"
    ),
    "launchpad-oracular-arm64-amd64-qtorganizer-eds-3a12a7097a09": re.compile(
        r"^(?:\d+: )?recurrence-test\s*:\s*(?:FAIL!\s*:|Actual\s+\(|Expected\s+\(|Loc: \[)"
    ),
    "launchpad-resolute-arm64-amd64-python-pyinstrument-b6735db865a5": re.compile(
        r"^FAILED test/test_stack_sampler\.py::\S+ - .+$"
    ),
    "launchpad-jammy-arm64-amd64-tmpreaper-8c42ffb8e477": re.compile(
        r"^You forgot to fix the VERSION in configure\.ac!$|"
        r"^make: \*\*\* \[debian/rules:\d+: build-stamp\] Error 1$|"
        r"^dpkg-buildpackage: error: debian/rules build subprocess returned exit status 2$"
    ),
    "launchpad-kinetic-arm64-amd64-golang-mvdan-sh-8cac33b424a0": re.compile(
        r"^src/github\.com/rogpeppe/go-internal/testscript/exe\.go:\d+:\d+:"
        r" not enough arguments in call to testing\.MainStart$|"
        r"^(?:have|want) \((?:nopTestDeps|testing\.testDeps),.*\)$|"
        r"^FAIL\s+mvdan\.cc/sh/v3/cmd/shfmt \[build failed\]$"
    ),
    "launchpad-kinetic-arm64-amd64-libengine-gost-openssl-e12421181e3b": re.compile(
        r"^\d+% tests passed, \d+ tests failed out of \d+$|"
        r"^\d+ - \S+ \((?:SEGFAULT|Failed|Timeout|Subprocess aborted)\)$|"
        r"^make\[\d+\]: \*\*\* \[Makefile:\d+: test\] Error 8$"
    ),
    "launchpad-plucky-arm64-amd64-libotr-7f09e7c32c80": re.compile(
        r"^\S+\s+\(Wstat: \d+ .*Tests: \d+ Failed: \d+\)$|"
        r"^Non-zero wait status: \d+$|^Parse errors: Bad plan\..+$|"
        r"^Result: FAIL$|^make\[\d+\]: \*\*\* \[Makefile:\d+: check-am\] Error 1$"
    ),
    "launchpad-plucky-amd64-arm64-libgovirt-627f7c04c776": re.compile(
        r"^not ok /govirt/[^ ]+ - libgovirt-FATAL-WARNING: .+"
    ),
    "launchpad-resolute-amd64-arm64-libsieve-3aad69166304": re.compile(
        r"^make\[\d+\]: \*\*\* \[Makefile:\d+: header-lex.lo\] Error 1$"
    ),
    NGINX: re.compile(r"^'Depends' field, reference to 'libnginx-mod-http-geoip2':"),
    AVO: re.compile(r"^SIGILL: illegal instruction$|^FAIL\s+github.com/mmcloughlin/avo/examples/(?:dot|geohash)\s+"),
    "launchpad-plucky-amd64-arm64-efitools-faf68620bf82": re.compile(
        r"^Invalid DOS header magic$|^make\[1\]: \*\*\* \[Make.rules:\d+: HelloWorld-signed.efi\] Error 1$"
    ),
    "launchpad-jammy-arm64-amd64-pyml-d615cc69fb95": re.compile(
        r"^Test '.*' \.\.\.(?: passed)?$|^make\[1\]: \*\*\* \[debian/rules:\d+: override_dh_auto_test\] Error 1$"
    ),
    "launchpad-resolute-arm64-amd64-dnscap-1198fcbd04b6": re.compile(
        r"^See plugins/[^/ ]+/test-suite.log for debugging\.$|^ln: .+|"
        r"^dh_auto_test: error: .+ returned exit code \d+$"
    ),
}
BLIS = "launchpad-resolute-arm64-amd64-python-cython-blis-fedd35dc0412"
TINYCBOR = "launchpad-plucky-amd64-arm64-tinycbor-835bc0b749b6"
QT_TEST_RESULT = re.compile(
    r"^\*+ (?:Start|Finished) testing of |^(?:PASS|FAIL!|SKIP|XFAIL|XPASS|QFATAL)\s*:|"
    r"^(?:Actual|Expected)\s+\(|^Loc: \[|^Totals: "
)
QT_TEST_EXIT = re.compile(
    r"^make\[\d+\]: \*\*\* \[[^\]]+: (?:check|sub-tojson-check|override_dh_auto_test)\] Error \d+$"
    r"|^dpkg-buildpackage: error: debian/rules binary-arch subprocess returned exit status 2$"
)
TERMINAL_DIAGNOSTICS = {
    "launchpad-focal-arm64-amd64-libgnomecanvasmm2-6-4f638ef38203": (4, re.compile(
        r"^find docs/reference/html -name '\*\.md5' -print0 \| xargs -0 rm -v$|"
        r"^rm: missing operand$|"
        r"^make: \*\*\* \[debian/rules:24: build/libgnomecanvasmm-2.6-doc\] Error 123$|"
        r"^dpkg-buildpackage: error: debian/rules build subprocess returned exit status 2$"
    )),
    "launchpad-plucky-amd64-arm64-gcc-15-cross-26cf66d777b8": (9, re.compile(
        r"^/usr/bin/ld: \S+\(hash-table\.o\).*: unresolvable R_AARCH64_ADR_PREL_PG_HI21 "
        r"relocation against symbol .stderr@@GLIBC_2\.17.$|"
        r"^/usr/bin/ld: final link failed: bad value$|"
        r"^gnatlink: error when calling /usr/bin/aarch64-linux-gnu-g\+\+-15$|"
        r"make(?:\[\d+\])?: \*\*\* \[[^\]]+: (?:gnatmake-re|gnattools-cross|all-gnattools|"
        r"stamp-dir/build-gcc.amd64)\] Error \d+$|"
        r"^dpkg-buildpackage: error: debian/rules build-arch subprocess returned exit status 2$"
    )),
}
LIBYUV = "launchpad-oracular-amd64-arm64-libyuv-91738d032815"
LIBMAUS2 = "launchpad-oracular-amd64-arm64-libmaus2-12ed4994dfc2"
AUTOMAKE_SUMMARY = re.compile(r"^# (?:TOTAL|PASS|SKIP|XFAIL|FAIL|XPASS|ERROR):\s+[0-9]+$")
TEST_STAGE = re.compile(r"^dpkg-buildpackage: error: debian/rules binary-arch subprocess returned exit status 2$")
GTEST_FINISH = re.compile(r"^\[==========\] (\d+) tests from (\d+) test suites ran\.")
ANSI_COLOR = re.compile(r"\x1b\[[0-9;]*m")
STARTED = b"BUILD_BENCH_BUILD_STARTED"
EXIT = b"BUILD_BENCH_BUILD_EXIT="


def normalize(line):
    line = line.translate(str.maketrans({chr(8216): chr(39), chr(8217): chr(39), chr(96): chr(39)}))
    line = line.replace("/work/source", "<source>").replace("/<<PKGBUILDDIR>>", "<source>")
    line = re.sub(r"/<<BUILDDIR>>/[^/\s]+(?=/)", "<source>", line)
    line = re.sub(r"/tmp/[^ /'\x22]+", "/tmp/<temp>", line)
    line = re.sub(r"\b0x[0-9a-f]+\b", "<address>", line)
    line = re.sub(r"\b\d{2,}\b(?= Segmentation fault| Terminated| Killed| Aborted)", "<pid>", line)
    line = re.sub(r"(line \d+: )\d{2,}(?= Segmentation)", r"\1<pid>", line)
    line = re.sub(r"/tmp/<temp>/\d+", "/tmp/<temp>/<pid>", line)
    line = re.sub(r"\s+\[\d+\.\d+s\]$|\s+\(\d+(?:\.\d+)?(?:s| ms)\)$", "", line)
    return " ".join(line.split())


def fingerprints(path, start, *, case_id=None):
    found = collections.Counter()
    case_diagnostics = CASE_DIAGNOSTICS.get(case_id)
    active = start is None
    cmake = []
    cmake_size = 0
    with Path(path).open("rb") as handle:
        for chunk in iter(lambda: handle.readline(262144), b""):
            raw = chunk.decode("utf-8", "replace")
            line = raw.strip()
            if not active and line.startswith(start):
                active = True
            if not active:
                continue
            if cmake:
                if not line or raw.startswith("  "):
                    if line and cmake_size + len(line) <= 8192:
                        cmake.append(line)
                        cmake_size += len(line)
                    continue
                if len(cmake) > 1:
                    found[normalize(" ".join(cmake))] += 1
                cmake = []
            if CMAKE_ERROR.match(line):
                if line.startswith("CMake Error:") and line != "CMake Error:":
                    found[normalize(line)] += 1
                else:
                    cmake = [line]
                    cmake_size = len(line)
                continue
            if case_id == BLIS and line.startswith("[COMMAND] gcc ") and "gcc: error:" in line:
                # 并行输出中，另一条命令的 stdout 可能与实际失败的 stderr 拼接。
                line = line[line.rindex("gcc: error:"):]
            if len(line) > 2500:
                continue
            if case_id == NGINX and (control := NGINX_CONTROL.fullmatch(line)):
                found[f"{control[1]}{control[2]}"] += 1
            elif case_id == AVO and (stack := AVO_STACK.search(line)):
                found[f"{stack['site']} {stack['offset']}"] += 1
            elif case_id == AVO and line.startswith("FAIL\tgithub.com/mmcloughlin/avo/examples/"):
                found[" ".join(line.split()[:2])] += 1
            elif case_diagnostics and case_diagnostics.search(line):
                found[normalize(line)] += 1
            elif case_id == "launchpad-resolute-arm64-amd64-dnscap-1198fcbd04b6" and AUTOMAKE_SUMMARY.fullmatch(line):
                continue
            elif MAKE_FAILURE.fullmatch(line) or (FAILURE.search(line) and not WRAPPER.search(line)):
                found[normalize(line)] += 1
    if len(cmake) > 1:
        found[normalize(" ".join(cmake))] += 1
    return found


def terminal_signature(path, pattern):
    with Path(path).open("rb") as log:
        return [
            normalize(match.group())
            for data in iter(lambda: log.readline(262144), b"")
            if (match := pattern.search(data.decode("utf-8", "replace").strip()))
        ]


def qt_test_result(path):
    digest = hashlib.sha256()
    failures = []
    totals = []
    terminal = terminal_signature(path, QT_TEST_EXIT)
    with Path(path).open("rb") as log:
        for data in iter(lambda: log.readline(262144), b""):
            line = data.decode("utf-8", "replace").strip()
            if not QT_TEST_RESULT.search(line):
                continue
            line = re.sub(r", \d+ms$", "", line) if line.startswith("Totals: ") else line
            if line.startswith("FAIL!"):
                failures.append(line)
            if line.startswith("Totals:"):
                totals.append(line)
            digest.update((line + "\n").encode("utf-8"))
    if failures and totals and any("sub-tojson-check" in line for line in terminal):
        return {"ordered_qt_sha256": digest.hexdigest(), "failures": failures,
                "totals": totals, "terminal": terminal}
    return None


def projected_test_result(path, case_id):
    if case_id == LIBMAUS2:
        summary = collections.Counter()
        with Path(path).open("rb") as handle:
            for data in iter(lambda: handle.readline(262144), b""):
                line = data.decode("utf-8", "replace").strip()
                if (AUTOMAKE_SUMMARY.fullmatch(line) or TEST_STAGE.fullmatch(line) or
                        (line.startswith("FAIL ") and " (exit status: " in line)):
                    summary[normalize(line)] += 1
                if "AutoArray<" in line and " failed to allocate " in line:
                    summary[normalize(line[line.index("AutoArray<"):])] += 1
        return dict(summary) if len(summary) >= 12 else None

    result = {}
    with Path(path).open("rb") as handle:
        # GoogleTest 的最终摘要紧邻构建退出。只读取末尾，避免扫描数 GB 的逐像素输出。
        end = handle.seek(0, 2)
        start = max(0, end - 4 * 1024 * 1024)
        handle.seek(start)
        if start:
            handle.readline()
        for data in iter(lambda: handle.readline(262144), b""):
            if len(data) > 1024:
                continue
            line = ANSI_COLOR.sub("", data.decode("utf-8", "replace")).strip()
            if match := GTEST_FINISH.match(line):
                result = {"total": int(match[1]), "suites": int(match[2]), "failed_tests": []}
            elif not result:
                continue
            elif match := re.fullmatch(r"\[  PASSED  \] (\d+) tests?\.", line):
                result["passed"] = int(match[1])
            elif match := re.fullmatch(r"\[  FAILED  \] (\d+) tests?, listed below:", line):
                result["failed"] = int(match[1])
            elif match := re.fullmatch(r"\[  FAILED  \] (\S+)", line):
                result["failed_tests"].append(match[1])
            elif match := re.fullmatch(r"YOU HAVE (\d+) DISABLED TESTS", line):
                result["disabled"] = int(match[1])
            elif re.fullmatch(r"make\[1\]: \*\*\* \[debian/rules:\d+: execute_after_dh_auto_test\] Error 1", line):
                result["test_target"] = True
            elif TEST_STAGE.fullmatch(line):
                result["build_failed"] = True
    required = {"total", "passed", "failed", "disabled", "test_target", "build_failed"}
    if required <= result.keys() and result["passed"] + result["failed"] == result["total"]:
        if len(result["failed_tests"]) == result["failed"]:
            return result
    return None


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
    if case_id in TERMINAL_DIAGNOSTICS:
        minimum, pattern = TERMINAL_DIAGNOSTICS[case_id]
        historical_result = terminal_signature(reference, pattern)
        actual_result = terminal_signature(replay, pattern)
        result = {"exit": code, "kind": "terminal_failure", "historical": historical_result, "actual": actual_result}
        if len(historical_result) >= minimum and historical_result == actual_result and code == 2:
            return "matched", result
        return "terminal_diagnostic_mismatch", result

    if case_id in (LIBYUV, LIBMAUS2, TINYCBOR):
        if case_id == TINYCBOR:
            historical_result = qt_test_result(reference)
            actual_result = qt_test_result(replay)
        else:
            historical_result = projected_test_result(reference, case_id)
            actual_result = projected_test_result(replay, case_id)
        result = {"exit": code, "kind": "test_summary", "historical": historical_result, "actual": actual_result}
        if code == 2 and historical_result and historical_result == actual_result:
            return "matched", result
        return "test_summary_mismatch", result

    historical = fingerprints(reference, "dpkg-buildpackage:", case_id=case_id)
    if not historical:
        historical = fingerprints(reference, None, case_id=case_id)
        mode = "whole-log"
    else:
        mode = "section"
    actual = fingerprints(replay, "BUILD_BENCH_BUILD_STARTED", case_id=case_id)
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
