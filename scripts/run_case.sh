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
env_nofile=$(jq -r '.env.nofile // empty' "$work/config.json")
env_cpus=$(jq -r '.env.cpus // empty' "$work/config.json")
env_cpuset=$(jq -r '.env.cpuset // empty' "$work/config.json")
env_user=$(jq -r '.env.user // empty' "$work/config.json")
env_attempts=$(jq -r '.env.attempts // 1' "$work/config.json")
mapfile -t env_vars < <(jq -r '(.env.vars // {}) | to_entries[] | "\(.key)=\(.value)"' "$work/config.json")
echo "case env: nofile=${env_nofile:-default} cpus=${env_cpus:-default} cpuset=${env_cpuset:-default} user=${env_user:-buildd} attempts=$env_attempts vars=${env_vars[*]:-none}"

python3 scripts/fetch_case.py "$case_id" "$arch" "$work/official"
python3 scripts/prepare_environment.py "$work/config.json" "$work/environment" "$work/evidence/dependencies.json"
docker build --network none -f "$work/environment/environment.Dockerfile" \
    --tag "buildbench-case:$case_id" "$work/environment" > "$work/evidence/environment.log" 2>&1 || {
    tail -200 "$work/evidence/environment.log"
    exit 1
}

run_build() {
    local label=$1
    local patch=${2:-}
    local code=0
    local -a mounts=()
    local -a extra_env=()
    mkdir -p "$work/$label"
    chmod 0777 "$work/$label"
    if [[ -n "$patch" ]]; then
        mounts+=(--mount "type=bind,src=$patch,dst=/input-patch/change.patch,readonly")
    fi
    if [[ "${#env_vars[@]}" -gt 0 ]]; then
        for assignment in "${env_vars[@]}"; do
            extra_env+=(--env "$assignment")
        done
    fi
    local container="buildbench-$label-$case_id"
    local -a limits=()
    [[ -n "$env_nofile" ]] && limits+=(--ulimit "nofile=$env_nofile:$env_nofile")
    [[ -n "$env_cpus" ]] && limits+=(--cpus "$env_cpus")
    [[ -n "$env_cpuset" ]] && limits+=(--cpuset-cpus "$env_cpuset")
    local userns=buildd
    [[ -n "$env_user" ]] && userns="$env_user"
    local -a command=(
        docker run --rm --name "$container" --network none --cap-drop ALL --security-opt no-new-privileges
        --user "$userns" "${limits[@]}" "${extra_env[@]}"
        --mount "type=bind,src=$work/official/source/input,dst=/input,readonly"
        --mount "type=bind,src=$work/$label,dst=/work" "${mounts[@]}"
        "buildbench-case:$case_id" /bin/sh /usr/local/bin/build-case "$mode" "$options"
    )
    if [[ "$label" == baseline* ]]; then
        python3 scripts/run_baseline.py "$work/official/logs/target-failure.log" \
            "$work/evidence/$label.log" "$work/evidence/$label-idle-timeout.json" "$container" "${command[@]}" || code=$?
    else
        "${command[@]}" > "$work/evidence/$label.log" 2>&1 || code=$?
    fi
    printf '%s\n' "$code" > "$work/evidence/$label.exit"
    printf '%s exit code: %s\n' "$label" "$code"
    return "$code"
}

attempt=1
while :; do
    label="baseline"
    [[ "$attempt" -gt 1 ]] && label="baseline-attempt-$attempt"
    set +e
    run_build "$label"
    rc=$?
    set -e
    idle="$work/evidence/$label-idle-timeout.json"
    if [[ -s "$idle" ]]; then
        cp "$idle" "$work/evidence/idle-timeout.json"
    fi
    if python3 scripts/check_baseline.py "$case_id" "$work/official/logs/target-failure.log" \
        "$work/evidence/$label.log" "$rc" >&2; then
        echo "Baseline matched on attempt $attempt"
        if [[ "$label" != "baseline" ]]; then
            cp "$work/evidence/$label.log" "$work/evidence/baseline.log"
            printf '%s\n' "$rc" > "$work/evidence/baseline.exit"
        fi
        break
    fi
    attempt=$((attempt + 1))
    if [[ "$attempt" -gt "$env_attempts" ]]; then
        echo "Baseline did not match after $env_attempts attempts"
        exit 1
    fi
    echo "Retrying baseline (attempt $attempt of $env_attempts)"
done

if [[ -n "$patch_file" ]]; then
    run_build patched "$patch_file"
    test "$(cat "$work/evidence/patched.exit")" -eq 0
    grep -qx 'BUILD_BENCH_BUILD_EXIT=0' "$work/evidence/patched.log"
    find "$work/patched" -maxdepth 1 -type f -name '*.deb' -print0 |
        while IFS= read -r -d '' binary; do
            package_arch=$(dpkg-deb -f "$binary" Architecture)
            if [[ "$package_arch" != "$arch" && "$package_arch" != all ]]; then
                exit 1
            fi
            basename "$binary"
        done > "$work/evidence/binary-packages.txt"
    test -s "$work/evidence/binary-packages.txt"
fi
