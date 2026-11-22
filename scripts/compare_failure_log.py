#!/usr/bin/env python3
"""比较重新生成的失败日志与官方 target-failure.log。

官方日志包含 Launchpad buildd/sbuild 包装层，重放日志是 obs-build + dpkg-buildpackage，
因此不要求逐字节一致；判定标准：
  - 重新构建必须真的进入包构建并失败（package_build 阶段失败、退出码非 0）；
  - 官方日志里可提取的失败诊断必须全部出现在重放日志中（允许重放多出诊断）；
  - 重放日志必须包含关键构建阶段，且行数达到官方日志的至少 15%（防止只跑了半截）。
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

from check_baseline import FAILURE, fingerprints

STAGES = {
    "chroot_or_root": re.compile(r"Using BUILD_ROOT|init_buildsystem|creating repository for debootstrap"),
    "dependency_install": re.compile(r"preinstalling |installing |expanding package dependencies"),
    "source_unpack": re.compile(r"dpkg-source: info: (extracting|unpacking)"),
    "build_started": re.compile(r"----- building |dpkg-buildpackage: info: source package"),
    "build_failed": re.compile(r"dpkg-buildpackage: error:|failed \"build "),
}
TIMING = re.compile(r"^\[\s*\d+s\]\s?")


def clean_lines(path: Path) -> list[str]:
    lines = []
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.readline(262144), b""):
            line = chunk.decode("utf-8", "replace")
            line = TIMING.sub("", line).strip()
            if line:
                lines.append(line)
    return lines


def main() -> int:
    case_dir, reference, output, validator_exit, verdict_path = sys.argv[1:6]
    case_dir = Path(case_dir)
    reference = Path(reference)
    output = Path(output)
    verdict_path = Path(verdict_path)
    result_file = output / "build-result.json"
    replay_log = output / "build.log"
    verdict = {
        "case_id": json.loads((case_dir / "case.json").read_text())["case_id"],
        "validator_exit": int(validator_exit),
        "status": "build_evidence_missing",
    }
    reasons = []
    if not (result_file.is_file() and replay_log.is_file()):
        verdict["reasons"] = ["build-result.json or build.log missing"]
        verdict_path.write_text(json.dumps(verdict, indent=2) + "\n")
        print(json.dumps(verdict, indent=2, ensure_ascii=False))
        return 1

    result = json.loads(result_file.read_text())
    case_id = json.loads((case_dir / "case.json").read_text())["case_id"]
    ref_lines = clean_lines(reference)
    replay_lines = clean_lines(replay_log)
    ref_diag = fingerprints(reference, None, case_id=case_id)
    # obs-build 会给每行加 [ 123s] 前缀；先剥掉再提取诊断，避免同一行被判成不同指纹。
    replay_cleaned = output / "build.log.normalized"
    replay_cleaned.write_text("\n".join(replay_lines) + "\n", encoding="utf-8")
    replay_diag = fingerprints(replay_cleaned, None, case_id=case_id)
    missing = ref_diag - replay_diag
    extra = replay_diag - ref_diag
    stages = {name: bool(pattern.search("\n".join(replay_lines))) for name, pattern in STAGES.items()}
    ratio = (len(replay_lines) / len(ref_lines)) if ref_lines else 0
    failed_stages = result.get("failed_stages") or []
    package_failed = (
        result.get("status") == "failed"
        and result.get("build_exit_code") not in (None, 0)
    )
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
        "failed_stages": failed_stages,
        "replay_sha256": None,
    })

    if not package_failed:
        reasons.append("重放没有在包构建阶段失败（基线不会失败）")
    if missing:
        reasons.append(f"官方日志里有 {sum(missing.values())} 条失败诊断在重放中缺失")
    if not all(stages.values()):
        missing_stages = [name for name, present in stages.items() if not present]
        reasons.append("重放日志缺少阶段: " + ", ".join(missing_stages))
    if ratio < 0.15:
        reasons.append(f"重放日志只有官方日志的 {ratio:.0%} 行，疑似未完整执行")
    verdict["status"] = "matched" if not reasons else "mismatch"
    verdict["reasons"] = reasons
    verdict_path.write_text(json.dumps(verdict, indent=2, ensure_ascii=False) + "\n")
    print(json.dumps(verdict, indent=2, ensure_ascii=False))
    return 0 if not reasons else 1


if __name__ == "__main__":
    raise SystemExit(main())
