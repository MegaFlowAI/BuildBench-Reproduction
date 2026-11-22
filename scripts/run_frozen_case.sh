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
    local label=$1
    local patch=${2:-}
    local result_root
    result_root=$(mktemp -d "$workspace/result-${label}-XXXXXXXX")
    local output="$result_root/build-output"
    local runtime_case
    runtime_case=$(mktemp -d "$workspace/input-${label}-XXXXXXXX")
    cp -al "$case_dir/source/input" "$runtime_case/input"
    cp -a "$case_dir/config" "$runtime_case/config"
    mkdir "$runtime_case/dependencies"
    for dependency_dir in "$case_dir"/dependencies/ubuntu-*; do
        cp -al "$dependency_dir" "$runtime_case/dependencies/"
    done
    python3 scripts/prepare_frozen_runtime.py "$case_dir" "$runtime_case" "$workspace/runtime-settings.json"

    local -a limits=()
    local cpus
    cpus=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["reproduction_conditions"].get("cpus", ""))' "$workspace/runtime-settings.json")
    if [[ -n "$cpus" ]]; then
        limits=(--cpus "$cpus")
    fi
    local -a patch_mount=()
    if [[ -n "$patch" ]]; then
        patch_mount=(--mount "type=bind,src=$patch,dst=/input-patch/change.patch,readonly")
    fi
    local code=0
    if [[ -n "$patch" ]]; then
        docker run --rm --network none --privileged "${limits[@]}" \
            -e HOME=/tmp -e TMPDIR=/tmp \
            -e BUILD_CASE_ISOLATED_WORKER=1 -e BUILD_CASE_VM_TYPE=chroot \
            --mount "type=bind,src=$runtime_case,dst=$runtime_case,readonly" \
            --mount "type=bind,src=$result_root,dst=$result_root" \
            "${patch_mount[@]}" \
            "$runtime_image" --input "$runtime_case" --output "$output" \
            --patch /input-patch/change.patch \
            > "$workspace/validator-$label.log" 2>&1 || code=$?
    else
        docker run --rm --network none --privileged "${limits[@]}" \
            -e HOME=/tmp -e TMPDIR=/tmp \
            -e BUILD_CASE_ISOLATED_WORKER=1 -e BUILD_CASE_VM_TYPE=chroot \
            --mount "type=bind,src=$runtime_case,dst=$runtime_case,readonly" \
            --mount "type=bind,src=$result_root,dst=$result_root" \
            "$runtime_image" --input "$runtime_case" --output "$output" \
            > "$workspace/validator-$label.log" 2>&1 || code=$?
    fi
    printf '%s\n' "$code" > "$workspace/validator-$label.exit"
    printf '%s\n' "$result_root" > "$workspace/result-root-$label.txt"
    if [[ -d "$output" ]]; then
        docker run --rm --network none --entrypoint chown \
            --mount "type=bind,src=$output,dst=/output" "$runtime_image" \
            -R "$(id -u):$(id -g)" /output
    fi
    printf '%s\n' "$output"
    return 0
}

baseline_output=$(run_validator baseline)
python3 scripts/compare_failure_log.py "$case_dir" "$reference" "$baseline_output" \
    "$(cat "$workspace/validator-baseline.exit")" "$workspace/baseline-verdict.json"

if [[ -n "$patch_file" ]]; then
    patched_output=$(run_validator patched "$patch_file")
    test "$(cat "$workspace/validator-patched.exit")" -eq 0
    python3 - "$patched_output" "$workspace/patched-result.json" <<'PY'
import json
import sys
from pathlib import Path

output = Path(sys.argv[1])
target = Path(sys.argv[2])
result_file = output / "build-result.json"
if not result_file.is_file():
    raise SystemExit("patched build produced no build-result.json")
result = json.loads(result_file.read_text())
if result.get("status") != "completed" or result.get("build_exit_code") != 0:
    raise SystemExit(f"patched build did not succeed: {result.get('status')} exit={result.get('build_exit_code')}")
artifacts = result.get("artifacts") or []
if not artifacts:
    raise SystemExit("patched build produced no artifacts")
target.write_text(json.dumps({"status": "success", "artifacts": artifacts}, indent=2) + "\n")
print("patched build succeeded with", len(artifacts), "artifacts")
PY
fi
