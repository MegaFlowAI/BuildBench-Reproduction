#!/usr/bin/env bash
set -euo pipefail

case_dir=$(realpath "$1")
workspace=$(realpath "$2")
runtime_image=$3
patch_file=${4:-}

mkdir -p "$workspace"
python3 scripts/fix_frozen_case.py "$case_dir"
reference="$case_dir/logs/target-failure.log"

run_validator() {
    local root=$1
    local label=$2
    local result_root
    result_root=$(mktemp -d "$workspace/result-${label}-XXXXXXXX")
    local output="$result_root/build-output"
    local runtime_case
    runtime_case=$(mktemp -d "$workspace/input-${label}-XXXXXXXX")
    cp -al "$root/source/input" "$runtime_case/input"
    cp -a "$root/config" "$runtime_case/config"
    mkdir "$runtime_case/dependencies"
    for dependency_dir in "$root"/dependencies/ubuntu-*; do
        cp -al "$dependency_dir" "$runtime_case/dependencies/"
    done
    python3 scripts/prepare_frozen_runtime.py "$root" "$runtime_case" "$workspace/runtime-settings.json"

    local -a docker_args=()
    local -a timeout_args=()
    local cpus cpuset nofile memory timeout_seconds
    cpus=$(jq -r '.reproduction_conditions.cpus // empty' "$workspace/runtime-settings.json")
    cpuset=$(jq -r '.reproduction_conditions.cpuset // .reproduction_conditions.cpuset_cpus // empty' "$workspace/runtime-settings.json")
    nofile=$(jq -r '.reproduction_conditions.nofile // empty' "$workspace/runtime-settings.json")
    memory=$(jq -r '.reproduction_conditions.memory // empty' "$workspace/runtime-settings.json")
    timeout_seconds=$(jq -r '.reproduction_conditions.timeout // empty' "$workspace/runtime-settings.json")
    if [[ -n "$cpus" ]]; then
        docker_args+=(--cpus "$cpus")
    fi
    if [[ -n "$cpuset" ]]; then
        docker_args+=(--cpuset-cpus "$cpuset")
    fi
    if [[ -n "$nofile" ]]; then
        docker_args+=(--ulimit "nofile=${nofile}:${nofile}")
    fi
    if [[ -n "$memory" ]]; then
        docker_args+=(--memory "$memory")
    fi
    mapfile -t vars < <(jq -r '.reproduction_conditions.vars // {} | to_entries[] | ["-e", (.key + "=" + (.value | tostring))] | .[]' "$workspace/runtime-settings.json")
    if (( ${#vars[@]} )); then
        docker_args+=("${vars[@]}")
    fi
    if [[ -n "$timeout_seconds" ]]; then
        timeout_args=(timeout --signal=TERM --kill-after=30 "${timeout_seconds}s")
    fi
    local code=0
    set +e
    "${timeout_args[@]}" docker run --rm --network none --privileged "${docker_args[@]}" \
        -e HOME=/tmp -e TMPDIR=/tmp \
        -e BUILD_CASE_ISOLATED_WORKER=1 -e BUILD_CASE_VM_TYPE=chroot \
        --mount "type=bind,src=$runtime_case,dst=$runtime_case,readonly" \
        --mount "type=bind,src=$result_root,dst=$result_root" \
        "$runtime_image" --input "$runtime_case" --output "$output" \
        2>&1 | tee "$workspace/validator-$label.log" >&2
    code=${PIPESTATUS[0]}
    set -e
    printf '%s\n' "$code" > "$workspace/validator-$label.exit"
    printf '%s\n' "$result_root" > "$workspace/result-root-$label.txt"
    if [[ -d "$output" ]]; then
        docker run --rm --network none --entrypoint chown \
            --mount "type=bind,src=$output,dst=/output" "$runtime_image" \
            -R "$(id -u):$(id -g)" /output
    fi
    printf '%s\n' "$output"
}

attempts=1
baseline_output=$(run_validator "$case_dir" baseline-1)
attempts=$(jq -r '.reproduction_conditions.attempts // 1' "$workspace/runtime-settings.json")
[[ "$attempts" =~ ^[1-9][0-9]*$ ]]
matched=false
last_verdict="$workspace/baseline-verdict-1.json"
if python3 scripts/compare_failure_log.py "$case_dir" "$reference" "$baseline_output" \
    "$(cat "$workspace/validator-baseline-1.exit")" "$last_verdict"; then
    matched=true
    cp "$last_verdict" "$workspace/baseline-verdict.json"
fi
if [[ "$matched" != true && "$attempts" -gt 1 ]]; then
    for attempt in $(seq 2 "$attempts"); do
        baseline_output=$(run_validator "$case_dir" "baseline-$attempt")
        last_verdict="$workspace/baseline-verdict-$attempt.json"
        if python3 scripts/compare_failure_log.py "$case_dir" "$reference" "$baseline_output" \
            "$(cat "$workspace/validator-baseline-$attempt.exit")" "$last_verdict"; then
            matched=true
            cp "$last_verdict" "$workspace/baseline-verdict.json"
            break
        fi
    done
fi
if [[ "$matched" != true ]]; then
    cp "$last_verdict" "$workspace/baseline-verdict.json"
    exit 1
fi

if [[ -n "$patch_file" ]]; then
    patched_case="$workspace/patched-case"
    python3 scripts/apply_submission_patch.py "$case_dir" "$patch_file" "$patched_case"
    patched_output=$(run_validator "$patched_case" patched)
    test "$(cat "$workspace/validator-patched.exit")" -eq 0
    python3 - "$patched_output" "$workspace/patched-result.json" "$patched_case/case.json" <<'PY'
import json
import sys
from pathlib import Path

output = Path(sys.argv[1])
target = Path(sys.argv[2])
case = json.loads(Path(sys.argv[3]).read_text())
result_file = output / "build-result.json"
if not result_file.is_file():
    raise SystemExit("patched build produced no build-result.json")
result = json.loads(result_file.read_text())
if result.get("status") not in ("succeeded", "completed") or result.get("build_exit_code") != 0:
    raise SystemExit(f"patched build did not succeed: {result.get('status')} exit={result.get('build_exit_code')}")
artifacts = result.get("artifacts") or []
binary = [item for item in artifacts if item.get("kind") == "binary"]
arch = {"x86_64": "amd64", "aarch64": "arm64"}[case["platform"]["target_arch"]]
valid = [item for item in binary if f"_{arch}." in item["path"] or "_all." in item["path"]]
if not valid:
    raise SystemExit(f"patched build produced no {arch} binary packages: {binary}")
target.write_text(json.dumps({"status": "success", "artifacts": artifacts,
                              "binary_packages": [item["path"] for item in valid]}, indent=2) + "\n")
print("patched build succeeded with", len(valid), "binary packages")
PY
fi

# job 状态与软件构建结果保持一致：
# - 有补丁：基线匹配后，补丁构建成功才退出 0；
# - 无补丁（复现）：基线匹配只说明复现成功，job 状态按原始构建的退出码返回（历史失败 => 红）。
if [[ -z "$patch_file" ]]; then
    baseline_build_exit=$(jq -r '.build_exit_code // empty' "$baseline_output/build-result.json" 2>/dev/null || true)
    if [[ -z "$baseline_build_exit" || "$baseline_build_exit" == "null" ]]; then
        echo "baseline matched but build exit code is unavailable; treating as failure"
        exit 1
    fi
    echo "baseline matched (historical failure reproduced); job status follows build result: exit ${baseline_build_exit}"
    exit "$baseline_build_exit"
fi
