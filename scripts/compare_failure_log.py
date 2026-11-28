#!/usr/bin/env python3
"""比较重新生成的失败日志与官方 target-failure.log。

官方日志包含 Launchpad buildd/sbuild 包装层，重放日志是 obs-build + dpkg-buildpackage，
因此不要求逐字节一致；判定标准：
  - 重新构建必须真的进入包构建并失败（package_build 阶段失败、退出码非 0）；
  - 官方日志里可提取的失败诊断必须全部出现在重放日志中（允许重放多出诊断）；
  - 重放日志必须包含关键构建阶段，且行数达到官方日志的至少 15%（防止只跑了半截）。
"""
import json
import hashlib
import re
import sys
from collections import Counter
from pathlib import Path

from check_baseline import fingerprints
from pilot import pilots, reference_bytes, root_matches

STAGES = {
    "chroot_or_root": re.compile(r"Using BUILD_ROOT|init_buildsystem|creating repository for debootstrap"),
    "dependency_install": re.compile(r"preinstalling |installing |expanding package dependencies"),
    "source_unpack": re.compile(r"dpkg-source: info: (extracting|unpacking)"),
    "build_started": re.compile(r"----- building |dpkg-buildpackage: info: source package"),
    "build_failed": re.compile(r"dpkg-buildpackage: error:|failed \"build "),
}
TIMING = re.compile(r"^\[\s*\d+s\]\s?")
# obs-build 的并行构建会把进度行插到其他行中间；单独成行后再比对。
INTERLEAVED_PROGRESS = re.compile(r"\[\s*\d+%\]")


def clean_lines(path: Path) -> list[str]:
    lines = []
    import gzip
    opener = gzip.open if path.suffix == ".gz" else open
    with opener(path, "rb") as handle:
        for chunk in iter(lambda: handle.readline(262144), b""):
            line = chunk.decode("utf-8", "replace")
            line = TIMING.sub("", line).strip()
            if not line:
                continue
            match = INTERLEAVED_PROGRESS.search(line)
            if match and match.start() > 0:
                prefix = line[: match.start()].strip()
                suffix = line[match.start():].strip()
                if prefix:
                    lines.append(prefix)
                if suffix:
                    lines.append(suffix)
            else:
                lines.append(line)
    repaired = []
    for line in lines:
        if line.startswith(":"):
            for index in range(len(repaired) - 1, max(-1, len(repaired) - 4), -1):
                candidate = repaired[index]
                if "(.text+" in candidate and "undefined reference" not in candidate:
                    repaired[index] = candidate.rstrip() + line
                    break
            else:
                repaired.append(line)
        else:
            repaired.append(line)
    return repaired


def main() -> int:
    case_dir, reference, output, validator_exit, verdict_path = sys.argv[1:6]
    case_dir = Path(case_dir)
    reference = Path(reference)
    output = Path(output)
    verdict_path = Path(verdict_path)
    result_file = output / "build-result.json"
    replay_log = output / "build.log"
    verdict = {
        "case_id": json.loads((case_dir / "case.json").read_text(encoding="utf-8"))["case_id"],
        "validator_exit": int(validator_exit),
        "status": "build_evidence_missing",
    }
    reasons = []
    if not (result_file.is_file() and replay_log.is_file()):
        verdict["reasons"] = ["build-result.json or build.log missing"]
        verdict["category"] = "infrastructure"
        verdict_path.write_text(json.dumps(verdict, indent=2) + "\n", encoding="utf-8")
        print(json.dumps(verdict, indent=2, ensure_ascii=False))
        return 1

    result = json.loads(result_file.read_text(encoding="utf-8"))
    case = json.loads((case_dir / "case.json").read_text(encoding="utf-8"))
    case_id = case["case_id"]
    ref_lines = clean_lines(reference)
    replay_lines = clean_lines(replay_log)
    # Both inputs use identical normalization, including compressed Git references.
    reference_cleaned = output / "reference.log.normalized"
    reference_cleaned.write_text("\n".join(ref_lines) + "\n", encoding="utf-8")
    ref_diag = fingerprints(reference_cleaned, None, case_id=case_id)
    # obs-build 会给每行加 [ 123s] 前缀；先剥掉再提取诊断，避免同一行被判成不同指纹。
    replay_cleaned = output / "build.log.normalized"
    replay_cleaned.write_text("\n".join(replay_lines) + "\n", encoding="utf-8")
    replay_diag = fingerprints(replay_cleaned, None, case_id=case_id)
    missing = ref_diag - replay_diag
    extra = replay_diag - ref_diag
    replay_text = "\n".join(replay_lines)
    stages = {name: bool(pattern.search(replay_text)) for name, pattern in STAGES.items()}
    # OBS also prints '----- building' before chroot setup; that is not package execution.
    stages["build_started"] = "dpkg-buildpackage: info: source package " in replay_text
    ratio = (len(replay_lines) / len(ref_lines)) if ref_lines else 0
    failed_stages = result.get("failed_stages") or []
    package_failed = (
        result.get("status") == "failed"
        and type(result.get("build_exit_code")) is int and result["build_exit_code"] != 0
        and stages["build_started"] and stages["build_failed"]
        and not result.get("timed_out", False)
    )
    stage_events = []
    for line in replay_lines:
        if '[build-case] [event] ' in line:
            try:
                event = json.loads(line.split('[build-case] [event] ', 1)[1])
                if event.get("event") == "stage" and event.get("state") == "failed":
                    stage_events.append(event["stage"])
            except (ValueError, KeyError):
                pass
    if stage_events and stage_events[-1] != "package_build":
        package_failed = False
    verdict.update({
        "reference_lines": len(ref_lines),
        "replay_lines": len(replay_lines),
        "line_ratio": round(ratio, 3),
        "reference_diagnostics": sum(ref_diag.values()),
        "replay_diagnostics": sum(replay_diag.values()),
        "missing_diagnostics": {key: value for key, value in (missing or Counter()).items()},
        "extra_diagnostics": sum((extra or Counter()).values()),
        "stages": stages,
        "package_failed": package_failed,
        "build_exit_code": result.get("build_exit_code"),
        "failed_stages": stage_events or failed_stages,
        "replay_sha256": hashlib.sha256(replay_log.read_bytes()).hexdigest(),
        "reference_sha256": hashlib.sha256(reference_bytes(reference)).hexdigest(),
    })

    if not package_failed:
        reasons.append("重放没有在包构建阶段失败（基线不会失败）")
    if not ref_diag:
        reasons.append("官方诊断为空，不能以空集合匹配判定复现成功")
    if int(validator_exit) in (0, 124, 137, 143) or result.get("timed_out"):
        reasons.append("validator 成功或被超时/信号终止，不是完整的预期失败")
    if missing:
        reasons.append(f"官方日志里有 {sum(missing.values())} 条失败诊断在重放中缺失")
    if not all(stages.values()):
        missing_stages = [name for name, present in stages.items() if not present]
        reasons.append("重放日志缺少阶段: " + ", ".join(missing_stages))
    if ratio < 0.15:
        reasons.append(f"重放日志只有官方日志的 {ratio:.0%} 行，疑似未完整执行")
    # A historical match is not valid when replay added failures absent from the
    # official log, even for cases without a hand-audited ISA root signature.
    unexpected = {key: value for key, value in replay_diag.items() if key not in ref_diag}
    verdict["unexpected_diagnostics"] = unexpected
    if unexpected:
        reasons.append("出现官方日志以外的失败诊断，需要排查环境干扰")
    expected = case["platform"]["target_arch"]
    deb_arch = {"aarch64": "arm64", "x86_64": "amd64"}[expected]
    if result.get("target_arch") != expected or f"dpkg-buildpackage: info: host architecture {deb_arch}" not in replay_text:
        reasons.append("构建结果或实际包构建架构与目标不符")
    spec = pilots().get(case_id)
    if spec:
        matches = root_matches(replay_lines, spec["root_patterns"])
        verdict["root_cause"] = spec["root_cause"]
        verdict["root_signature_matches"] = matches
        if not all(matches):
            reasons.append("缺少试点的架构根因诊断")
    verdict["status"] = "matched" if not reasons else "mismatch"
    verdict["category"] = ("isa_failure_reproduced" if spec else "historical_failure_reproduced") if not reasons else (
        "infrastructure" if not stages["build_started"] or result.get("status") in {"unresolvable", "infrastructure_error"}
        else "timeout" if result.get("timed_out") or int(validator_exit) in (124, 137, 143)
        else "unexpected_success" if result.get("build_exit_code") == 0
        else "diagnostic_mismatch")
    verdict["reasons"] = reasons
    verdict_path.write_text(json.dumps(verdict, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(verdict, indent=2, ensure_ascii=False))
    return 0 if not reasons else 1


if __name__ == "__main__":
    raise SystemExit(main())

