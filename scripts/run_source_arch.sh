#!/usr/bin/env bash
set -euo pipefail

case_id=$1
case_root=$(realpath "$2")
patch_file=${3:-}
work=${RUNNER_TEMP:-/tmp}/buildbench-source-${case_id}
rm -rf "$work"
mkdir -p "$work"
log="$work/source-arch-build.log"
source_dir="$work/source"
input="$case_root/source/input"
dsc=$(find "$input" -maxdepth 1 -name '*.dsc' -print -quit)
test -n "$dsc"

python3 - "$case_root/case.json" <<'PY'
import json
import platform
import sys
case = json.load(open(sys.argv[1]))
expected = {"aarch64": "aarch64", "x86_64": "x86_64"}[case["platform"]["source_arch"]]
actual = platform.machine()
if actual != expected:
    raise SystemExit(f"source runner architecture mismatch: expected {expected}, got {actual}")
print(f"source architecture check: {actual}")
PY

dpkg-source -x "$dsc" "$source_dir"
if [[ -n "$patch_file" ]]; then
    git -C "$source_dir" apply --whitespace=nowarn "$patch_file"
fi

{
    echo "case: $case_id"
    echo "source architecture: $(uname -m)"
    echo "build mode: current runner packages, patch applied before build"
    sudo env DEBIAN_FRONTEND=noninteractive apt-get update
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential dpkg-dev devscripts equivs fakeroot
    # mk-build-deps resolves the package's declared names against the runner's
    # native repository. Version pins that only exist in the historical target
    # image are reported in the log instead of being silently ignored.
    sudo mk-build-deps --install --tool='apt-get -y --no-install-recommends' \
        --remove "$source_dir/debian/control"
    cd "$source_dir"
    DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -us -uc -b -j"$(nproc)"
} 2>&1 | tee "$log"
rc=${PIPESTATUS[0]}
printf '%s\n' "$rc" > "$work/source-arch-build.exit"
find "$work" -maxdepth 2 -type f -name '*.deb' -printf '%f\n' | sort > "$work/source-arch-binary-packages.txt"
if [[ "$rc" -ne 0 ]]; then
    exit "$rc"
fi
test -s "$work/source-arch-binary-packages.txt"
echo "source architecture build succeeded"
