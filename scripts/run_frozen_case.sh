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
cp -al "$case_dir/config" "$runtime_case/config"
mkdir "$runtime_case/dependencies"
for dependency_dir in "$case_dir"/dependencies/ubuntu-*; do
    cp -al "$dependency_dir" "$runtime_case/dependencies/"
done
python3 - "$case_dir/manifest.json" "$runtime_case/manifest.json" "$workspace/runtime-settings.json" <<'PY'
import json
import sys
from pathlib import Path

source, target, settings = map(Path, sys.argv[1:])
data = json.loads(source.read_text(encoding="utf-8"))
historical = json.loads(Path("cases.json").read_text(encoding="utf-8"))[data["case_id"]]
jobs = historical["jobs"]
if type(jobs) is not int or jobs < 1:
    raise ValueError("Invalid historical build parallelism")
settings.write_text(json.dumps({
    "frozen_jobs": data["build"]["jobs"],
    "historical_jobs": jobs,
}, indent=2) + "\n", encoding="utf-8")
data["build"]["jobs"] = jobs
data["build"]["recipe"] = "input/" + Path(data["build"]["recipe"]).name
data["patch_policy"]["allowed_paths"] = ["input/**"]
target.write_text(json.dumps(data), encoding="utf-8")
PY
reference="$case_dir/logs/target-failure.log"

code=0
docker run --rm --network none --privileged \
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
