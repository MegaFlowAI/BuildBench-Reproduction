#!/usr/bin/env bash
set -euo pipefail

input=$1
case_root=$2
evidence=$3
settings="$input/launchpad-settings.json"
arch=$(jq -er .architecture "$settings")
expected=$(jq -er .historical_kernel "$settings")
hostname=$(jq -er .hostname "$settings")
jobs=$(jq -er .jobs "$settings")
build_id=$(jq -er .build_id "$settings")
[[ "$hostname" =~ ^[a-z0-9-]+$ && "$jobs" =~ ^[1-9][0-9]*$ && "$build_id" =~ ^PACKAGEBUILD-[0-9]+$ ]]

if [[ "$arch" == amd64 ]]; then
    qemu=(qemu-system-x86_64 -machine q35 -cpu max)
    qemu_package=qemu-system-x86
    console=ttyS0
else
    [[ "$arch" == arm64 ]]
    qemu=(qemu-system-aarch64 -machine virt -cpu cortex-a57)
    qemu_package=qemu-system-arm
    console=ttyAMA0
fi
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends "$qemu_package" busybox-static cpio

work=$(mktemp -d "$RUNNER_TEMP/launchpad-vm-XXXXXXXX")
root="$work/root"
mkdir -p "$root"
container=$(docker create buildbench-launchpad-host)
trap 'docker rm "$container" >/dev/null' EXIT
docker export "$container" | sudo tar -C "$root" -xf -
sudo mkdir -p "$root"/{input,dev,proc,sys,run}
sudo cp -a "$case_root/source/input" "$root/input/source"
sudo cp -a "$case_root/dependencies" "$root/input/dependencies"
sudo cp "$input/$(jq -er .chroot.file "$settings")" "$root/input/chroot"
sudo cp "$input/launchpad-pins" "$root/input/apt-pins"
sudo cp "$(command -v busybox)" "$root/bin/busybox"

mapfile -t args < <(jq -r '.build_id,.architecture,.distribution,.jobs,.mode,.recipe,.maintainer' "$settings")
{
    cat <<'EOF'
#!/bin/bash
set -euo pipefail
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
mount -t devtmpfs devtmpfs /dev
exec </dev/null >/dev/console 2>&1
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mkdir -p /dev/pts /dev/shm /run/lock
mount -t devpts -o gid=5,mode=620 devpts /dev/pts
mount -t tmpfs tmpfs /dev/shm
EOF
    printf 'hostname %q\n' "$hostname"
    printf 'printf "127.0.0.1 localhost %s.buildd %s\\n" >/etc/hosts\n' "$hostname" "$hostname"
    cat <<'EOF'
printf 'BUILDBENCH_KERNEL='
uname -snrvm
status=0
EOF
    printf '/usr/local/bin/run-launchpad-host'
    printf ' %q' "${args[@]}"
    cat <<'EOF'
 >/run/build.log 2>&1 || status=$?
printf 'BUILDBENCH_EXIT=%s\n' "$status"
echo 'BUILDBENCH_RAW_SHA256='$(sha256sum /run/build.log | cut -d ' ' -f 1)
echo BUILDBENCH_RAW_LOG_BEGIN
gzip -nc /run/build.log | base64
echo BUILDBENCH_RAW_LOG_END
sync
/bin/busybox poweroff -f
EOF
} | sudo tee "$root/init" >/dev/null
sudo chmod 0755 "$root/init"
sudo bash -c 'cd "$1" && find . -print0 | cpio --null --quiet -o -H newc' _ "$root" | gzip -1n >"$work/initramfs.gz"

dpkg-deb -x "$input/$(jq -er .kernel_package.file "$settings")" "$work/kernel"
image="$work/kernel/boot/vmlinuz-$(cut -d ' ' -f 3 <<<"$expected")"
if [[ $(od -An -tx1 -N2 "$image" | tr -d ' \n') == 1f8b ]]; then
    gzip -dc "$image" >"$work/Image"
    image="$work/Image"
fi
# The unpacked builder image, historical chroot, dependency pool, and apt's
# temporary unpack area coexist in the initramfs-backed guest.  Four GiB is
# insufficient for the larger frozen cases even though the host has space.
"${qemu[@]}" -accel tcg -m 8192 -smp "$jobs" -nic none -display none -monitor none \
    -serial stdio -no-reboot -kernel "$image" -initrd "$work/initramfs.gz" \
    -append "console=$console rdinit=/init quiet loglevel=2 panic=-1" 2>&1 | tee "$evidence/vm-console.log"

tr -d '\r' <"$evidence/vm-console.log" >"$work/console.txt"
grep -Fx "BUILDBENCH_KERNEL=$expected" "$work/console.txt"
grep -Fx BUILDBENCH_RAW_LOG_END "$work/console.txt"
sed -n '/^BUILDBENCH_RAW_LOG_BEGIN$/,/^BUILDBENCH_RAW_LOG_END$/p' "$work/console.txt" |
    sed '1d;$d' | base64 --decode | gzip -d >"$evidence/build.log"
actual=$(sha256sum "$evidence/build.log" | cut -d ' ' -f 1)
grep -Fx "BUILDBENCH_RAW_SHA256=$actual" "$work/console.txt"
code=$(sed -n 's/^BUILDBENCH_EXIT=\([0-9][0-9]*\)$/\1/p' "$work/console.txt")
[[ "$code" =~ ^[0-9]+$ ]]
printf '%s\n' "$code" >"$evidence/sbuild.exit"
