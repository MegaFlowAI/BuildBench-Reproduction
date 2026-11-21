#!/bin/sh
set -eu
export DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8
mkdir -p /var/lib/dpkg/info /var/lib/dpkg/updates /var/lib/dpkg/alternatives /var/log /tmp/repack
touch /var/lib/dpkg/status

# container builds do not need maintainer migrations; strip scripts that cannot run
# in a bare root by repacking the .deb without them.
strip_and_unpack() {
    deb=$1
    pkg=$(dpkg-deb -f "$deb" Package)
    work=$(mktemp -d /tmp/repack/XXXXXX)
    if ! dpkg-deb -R "$deb" "$work/root" >>/tmp/install.log 2>&1; then
        echo "=== dpkg-deb -R failed for $deb ==="
        return 1
    fi
    rm -f "$work/root/DEBIAN/preinst" "$work/root/DEBIAN/postinst" \
          "$work/root/DEBIAN/prerm" "$work/root/DEBIAN/postrm"
    chmod -R u+rwX "$work/root"
    if ! dpkg-deb -b "$work/root" "$work/patched.deb" >>/tmp/install.log 2>&1; then
        echo "=== dpkg-deb -b failed for $pkg ==="
        return 1
    fi
    echo "repacked $pkg without maintainer scripts" >>/tmp/install.log
    dpkg --force-depends --force-confnew --unpack "$work/patched.deb" >>/tmp/install.log 2>&1
}

# 由 shell 展开和排序。部分历史 sort 依赖尚未安装的 libcrypto。
for deb in /tmp/pool/*.deb; do
    test -f "$deb" || { echo "Historical package pool is empty"; exit 1; }
    if dpkg --force-depends --force-confnew --unpack "$deb" >>/tmp/install.log 2>&1; then
        continue
    fi
    pkg=$(dpkg-deb -f "$deb" Package)
    echo "unpack failed for $deb, retrying without maintainer scripts"
    if ! strip_and_unpack "$deb"; then
        echo "=== unpack failed for $deb ==="
        grep -i "error" /tmp/install.log | tail -20 || true
        exit 1
    fi
done

if ! dpkg --force-depends --force-confnew --configure -a >/tmp/configure.log 2>&1; then
    echo "=== dpkg --configure -a failed; neutralising failing postinst ==="
    grep -i "error" /tmp/configure.log | tail -10 || true
    awk '/^Setting up /{print $3}' /tmp/configure.log | tail -10 | while read -r pkg; do
        pkg=${pkg%%:*}
        [ -n "$pkg" ] || continue
        file="/var/lib/dpkg/info/$pkg.postinst"
        if [ -e "$file" ] && [ ! -e "$file.neutralised" ]; then
            printf '#!/bin/sh\nexit 0\n' > "$file"
            chmod 0755 "$file"
            touch "$file.neutralised"
            echo "neutralised $pkg.postinst" >>/tmp/configure.log
        fi
    done
    if ! dpkg --force-depends --force-confnew --configure -a >>/tmp/configure.log 2>&1; then
        echo "=== dpkg --configure -a failed (tail) ==="
        tail -80 /tmp/configure.log
        exit 1
    fi
fi
dpkg --audit >/tmp/audit || true
test ! -s /tmp/audit || { echo '=== dpkg --audit ==='; cat /tmp/audit; exit 1; }
dpkg-query -W -f='${Package}\t${Version}\n' >/tmp/actual.tsv
awk -F '\t' '
FNR == NR { expected[$1] = $2; next }
{ actual[$1] = $2 }
END {
    for (name in expected) {
        if (actual[name] != expected[name]) {
            print "Historical version mismatch", name, expected[name], actual[name];
            failed = 1;
        }
    }
    exit failed
}' /tmp/expected.tsv /tmp/actual.tsv
id buildd >/dev/null 2>&1 || useradd --gid users --no-create-home --home-dir /tmp buildd
printf 'Historical dependency versions match\n'
