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

    local -a limits=()
    local cpus
    cpus=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["reproduction_conditions"].get("cpus", ""))' "$workspace/runtime-settings.json")
    if [[ -n "$cpus" ]]; then
        limits=(--cpus "$cpus")
    fi
    local code=0
    docker run --rm --network none --privileged "${limits[@]}" \
        -e HOME=/tmp -e TMPDIR=/tmp \
        -e BUILD_CASE_ISOLATED_WORKER=1 -e BUILD_CASE_VM_TYPE=chroot \
        --mount "type=bind,src=$runtime_case,dst=$runtime_case,readonly" \
        --mount "type=bind,src=$result_root,dst=$result_root" \
        "$runtime_image" --input "$runtime_case" --output "$output" \
        > "$workspace/validator-$label.log" 2>&1 || code=$?
    printf '%s\n' "$code" > "$workspace/validator-$label.exit"
    printf '%s\n' "$result_root" > "$workspace/result-root-$label.txt"
    if [[ -d "$output" ]]; then
        docker run --rm --network none --entrypoint chown \
            --mount "type=bind,src=$output,dst=/output" "$runtime_image" \
            -R "$(id -u):$(id -g)" /output
    fi
    printf '%s\n' "$output"
}

baseline_output=$(run_validator "$case_dir" baseline)
python3 scripts/compare_failure_log.py "$case_dir" "$reference" "$baseline_output" \
    "$(cat "$workspace/validator-baseline.exit")" "$workspace/baseline-verdict.json"

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
