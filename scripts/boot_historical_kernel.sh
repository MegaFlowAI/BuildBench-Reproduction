#!/usr/bin/env bash
set -euo pipefail

arch=$1
case_id=$2
output=$3
expected=$(jq -er --arg case "$case_id" '.[$case].kernel' cases/historical-hosts.json)
read -r system hostname release _ <<<"$expected"
[[ "$system" == Linux && "$hostname" =~ ^[a-z0-9-]+$ && "$release" == 5.4.0-173-generic ]]
version=5.4.0-173.191
package="linux-image-$release"
archive="${package}_${version}_${arch}.deb"

mkdir -p "$output/root"
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
cd "$output"
source_url="https://launchpad.net/ubuntu/+archive/primary/+files/$archive"
curl -fsSL --retry 3 "$source_url" -o "$archive"
[[ "$(dpkg-deb -f "$archive" Package)" == "$package" ]]
[[ "$(dpkg-deb -f "$archive" Version)" == "$version" ]]
[[ "$(dpkg-deb -f "$archive" Architecture)" == "$arch" ]]
dpkg-deb -x "$archive" kernel
image="kernel/boot/vmlinuz-$release"
if [[ $(od -An -tx1 -N2 "$image" | tr -d ' \n') == 1f8b ]]; then
    gzip -dc "$image" >kernel/Image
    image=kernel/Image
fi
mkdir -p root/{bin,dev,proc,sys}
cp "$(command -v busybox)" root/bin/busybox
cat >root/init <<EOF
#!/bin/busybox sh
set -eu
/bin/busybox mount -t devtmpfs devtmpfs /dev
exec >/dev/console 2>&1
/bin/busybox hostname $hostname
printf 'Kernel version: '
/bin/busybox uname -snrvm
/bin/busybox poweroff -f
EOF
chmod 0755 root/init
(cd root && find . -print0 | cpio --null -o -H newc --quiet) | gzip -n >initramfs.gz
timeout 180 "${qemu[@]}" -accel tcg -m 768 -smp 2 -nic none -display none \
    -monitor none -serial stdio -no-reboot -kernel "$image" -initrd initramfs.gz \
    -append "console=$console rdinit=/init quiet panic=-1" >boot.log 2>&1
tr -d '\r' <boot.log | grep -Fx "Kernel version: $expected"
sha=$(sha256sum "$archive" | cut -d ' ' -f 1)
size=$(stat -c %s "$archive")
jq -n --arg file "$archive" --arg origin "$source_url" --arg arch "$arch" \
    --arg sha "$sha" --arg kernel "$expected" --argjson size "$size" \
    '{file:$file,origin:$origin,architecture:$arch,sha256:$sha,bytes:$size,verified_kernel:$kernel}' \
    >kernel-package.json
