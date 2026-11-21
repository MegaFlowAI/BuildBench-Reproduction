#!/usr/bin/env bash
set -euo pipefail

case_dir=$(realpath "$1")
workspace=$(realpath "$2")
runtime_image=$3
result_root=$(mktemp -d "$workspace/result-XXXXXXXX")
output="$result_root/build-output"

# 保留发布包的 source/input 结构，给旧版 Validator 创建一次性工作目录。
test ! -e "$output"
runtime_case=$(mktemp -d "$workspace/input-XXXXXXXX")
cp -al "$case_dir/source/input" "$runtime_case/input"
cp -a "$case_dir/config" "$runtime_case/config"
mkdir "$runtime_case/dependencies"
for dependency_dir in "$case_dir"/dependencies/ubuntu-*; do
    cp -al "$dependency_dir" "$runtime_case/dependencies/"
done
python3 scripts/prepare_frozen_runtime.py "$case_dir" "$runtime_case" "$workspace/runtime-settings.json"
reference="$case_dir/logs/target-failure.log"

limits=()
cpus=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["reproduction_conditions"].get("cpus", ""))' "$workspace/runtime-settings.json")
if [[ -n "$cpus" ]]; then
    limits=(--cpus "$cpus")
fi
code=0
docker run --rm --network none --privileged "${limits[@]}" \
    -e HOME=/tmp -e TMPDIR=/tmp \
    -e BUILD_CASE_ISOLATED_WORKER=1 -e BUILD_CASE_VM_TYPE=chroot \
    --mount "type=bind,src=$runtime_case,dst=$runtime_case,readonly" \
    --mount "type=bind,src=$result_root,dst=$result_root" \
    "$runtime_image" --input "$runtime_case" --output "$output" \
    > "$workspace/validator-console.log" 2>&1 || code=$?
printf '%s\n' "$code" > "$workspace/validator.exit"
if [[ -d "$output" ]]; then
    # 只恢复当前运行留下的证据目录权限。
    docker run --rm --network none --entrypoint chown \
        --mount "type=bind,src=$output,dst=/output" "$runtime_image" \
        -R "$(id -u):$(id -g)" /output
fi
python3 scripts/check_exact_log.py "$case_dir" "$reference" "$output" "$code" "$workspace/exact-result.json"
