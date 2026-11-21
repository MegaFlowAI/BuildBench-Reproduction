#!/usr/bin/env bash
set -euo pipefail

build_id=$1
arch=$2
suite=$3
jobs=$4
mode=$5
recipe=$6
maintainer=$7

[[ "$build_id" =~ ^PACKAGEBUILD-[0-9]+$ && "$arch" =~ ^(amd64|arm64)$ && "$suite" =~ ^[a-z]+-proposed$ ]]
[[ "$jobs" =~ ^[1-9][0-9]*$ && "$mode" =~ ^-[Bb]$ && "$recipe" != */* && "$recipe" == *.dsc ]]
useradd --create-home --shell /bin/bash --groups sbuild buildd
printf 'buildd ALL=(root) NOPASSWD: ALL\n' >/etc/sudoers.d/buildbench
chmod 0440 /etc/sudoers.d/buildbench
install -o buildd -g sbuild /etc/buildbench/sbuildrc /home/buildd/.sbuildrc

work="/home/buildd/build-$build_id"
mkdir "$work"
tar -xf /input/chroot -C "$work"
guest="$work/chroot-autobuild"
test -x "$guest/usr/bin/dpkg"
install -d -m 2775 "$guest/build"
install -d "$guest/var/local/buildbench-packages"
find /input/dependencies -type f -name '*.deb' -exec cp -t "$guest/var/local/buildbench-packages" -- {} +
(
    cd "$guest/var/local/buildbench-packages"
    dpkg-scanpackages --multiversion . /dev/null >Packages
)
if [[ -d "$guest/etc/apt/sources.list.d" ]]; then
    mv "$guest/etc/apt/sources.list.d" "$guest/etc/apt/sources.list.d.archived"
fi
mkdir "$guest/etc/apt/sources.list.d"
printf 'deb [trusted=yes] file:/var/local/buildbench-packages ./\n' >"$guest/etc/apt/sources.list"
cat >"/etc/schroot/chroot.d/$build_id" <<EOF
[build-$build_id]
description=Historical Launchpad chroot for $build_id
type=directory
directory=$guest
users=buildd
root-users=buildd
groups=sbuild
profile=sbuild
EOF
cp /input/source/* "$work/"
chown buildd:sbuild "$work" "$work/"*.dsc
runuser -u buildd -- /usr/share/launchpad-buildd/bin/builder-prep
chroot "$guest" apt-get update

args=(-c "chroot:build-$build_id" "--arch=$arch" "--dist=$suite" --nolog "--jobs=$jobs")
if [[ "$mode" == -b ]]; then
    args+=(-A)
fi
if [[ -n "$maintainer" ]]; then
    args+=(--maintainer "$maintainer")
fi
exec runuser -u buildd -- /usr/share/launchpad-buildd/bin/sbuild-package \
    "$build_id" "$arch" "$suite" "${args[@]}" "$recipe"
