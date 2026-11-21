#!/bin/sh
set -eu
mode=$1
options=$2
export DEB_BUILD_OPTIONS="$options"
export LC_ALL=C.UTF-8 LANG=C.UTF-8
export TERM="${BUILDBENCH_BUILD_TERM:-dumb}" HOME="${BUILDBENCH_BUILD_HOME:-/tmp}"
cd /work
cp /input/* .
dpkg-source --no-check -x ./*.dsc source
cd source
if [ -f /input-patch/change.patch ]; then
    if ! patch --batch --forward --fuzz=0 -p1 --dry-run < /input-patch/change.patch ||
       ! patch --batch --forward --fuzz=0 -p1 < /input-patch/change.patch; then
        echo 'BUILD_BENCH_PATCH_APPLY_FAILED'
        exit 3
    fi
fi
echo 'BUILD_BENCH_BUILD_STARTED'
rc=0
dpkg-buildpackage -us -uc "$mode" -rfakeroot || rc=$?
printf 'BUILD_BENCH_BUILD_EXIT=%s\n' "$rc"
exit "$rc"
