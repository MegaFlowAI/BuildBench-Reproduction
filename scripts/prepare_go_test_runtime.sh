#!/usr/bin/env bash
# 只通过 Go 的 -exec 包装测试进程，保持宿主 binfmt 不变。
set -euo pipefail

runtime_dir=$1
evidence=$2
mkdir -p "$runtime_dir"
archive="$runtime_dir/qemu-user.deb"
url='https://deb.debian.org/debian/pool/main/q/qemu/qemu-user_10.0.13+ds-0+deb13u1_amd64.deb'
digest='ca6ede739327a20ae5a3498230c8a3a9a072c586e131bc6bcc1201eb1725e336'
curl -fLsS --retry 3 --max-time 600 "$url" -o "$archive"
printf '%s  %s\n' "$digest" "$archive" | sha256sum -c -
dpkg-deb --fsys-tarfile "$archive" | tar -xOf - ./usr/bin/qemu-x86_64 > "$runtime_dir/qemu-x86_64"
rm "$archive"
cat > "$runtime_dir/go-test" <<'SH'
#!/bin/sh
exec /buildbench-runtime/qemu-x86_64 -cpu max,-fma,-bmi2 "$@"
SH
chmod 0755 "$runtime_dir/qemu-x86_64" "$runtime_dir/go-test"
{
    printf '%s\nSHA256 %s\n' "$url" "$digest"
    "$runtime_dir/qemu-x86_64" --version
    printf '%s\n' 'CPU max,-fma,-bmi2'
} > "$evidence"
