#!/usr/bin/env bash
set -euo pipefail

case_id=$1
work=$2
patch_file=${3:-}
mkdir -p "$work/evidence"

python3 - "$case_id" "$work/config.json" <<'PY'
import json
import sys
from pathlib import Path
case = json.loads(Path("cases.json").read_text())[sys.argv[1]]
Path(sys.argv[2]).write_text(json.dumps(case))
actual = {"aarch64": "arm64", "x86_64": "amd64"}[__import__("platform").machine()]
if actual != case["architecture"]:
    raise SystemExit("Unexpected runner architecture")
PY
arch=$(jq -r .architecture "$work/config.json")
mode=$(jq -r .mode "$work/config.json")
options=$(jq -r '"parallel=" + (.jobs|tostring) + " " + (.options|join(" "))' "$work/config.json")

python3 scripts/fetch_case.py "$case_id" "$arch" "$work/official"
python3 scripts/prepare_environment.py "$work/config.json" "$work/environment" "$work/evidence/dependencies.json"
docker build --network none -f "$work/environment/environment.Dockerfile" \
    --tag "buildbench-case:$case_id" "$work/environment" > "$work/evidence/environment.log" 2>&1 || {
    tail -35 "$work/evidence/environment.log"
    exit 1
}

run_build() {
    local label=$1
    local patch=${2:-}
    local code=0
    local -a mounts=()
    mkdir -p "$work/$label"
    chmod 0777 "$work/$label"
    if [[ -n "$patch" ]]; then
        mounts+=(--mount "type=bind,src=$patch,dst=/input-patch/change.patch,readonly")
    fi
    docker run --rm --network none --cap-drop ALL --security-opt no-new-privileges \
        --user buildd --mount "type=bind,src=$work/official/source/input,dst=/input,readonly" \
        --mount "type=bind,src=$work/$label,dst=/work" "${mounts[@]}" \
        "buildbench-case:$case_id" /bin/sh /usr/local/bin/build-case "$mode" "$options" \
        > "$work/evidence/$label.log" 2>&1 || code=$?
    printf '%s\n' "$code" > "$work/evidence/$label.exit"
    printf '%s exit code: %s\n' "$label" "$code"
}

run_build baseline
python3 scripts/check_baseline.py "$case_id" "$work/official/logs/target-failure.log" \
    "$work/evidence/baseline.log" "$(cat "$work/evidence/baseline.exit")"
if [[ -n "$patch_file" ]]; then
    run_build patched "$patch_file"
    grep -qx 'BUILD_BENCH_BUILD_EXIT=0' "$work/evidence/patched.log"
    find "$work/patched" -maxdepth 1 -type f -name '*.deb' -printf '%f\n' > "$work/evidence/binary-packages.txt"
    test -s "$work/evidence/binary-packages.txt"
fi
