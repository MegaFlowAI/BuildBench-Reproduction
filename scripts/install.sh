#!/bin/sh
set -eu
export DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8
mkdir -p /var/lib/dpkg/info /var/lib/dpkg/updates /var/lib/dpkg/alternatives /var/log
touch /var/lib/dpkg/status

# 1) unpack packages one by one; if a maintainer preinst cannot run in the bare
#    container root, neutralise that script and retry. Container builds do not
#    need maintainer migrations (usrmerge, pam, ldconfig is run later).
failed_pkgs=""
for deb in $(ls /tmp/pool/*.deb | sort); do
    if dpkg --force-depends --force-confnew --unpack "$deb" >>/tmp/install.log 2>&1; then
        continue
    fi
    pkg=$(dpkg-deb -f "$deb" Package)
    mkdir -p "/var/lib/dpkg/info"
    printf '#!/bin/sh\nexit 0\n' > "/var/lib/dpkg/info/$pkg.preinst"
    chmod 0755 "/var/lib/dpkg/info/$pkg.preinst"
    echo "neutralised $pkg.preinst" >>/tmp/install.log
    dpkg --force-depends --force-confnew --unpack "$deb" >>/tmp/install.log 2>&1 || {
        echo "=== unpack failed for $deb ==="
        grep -i "error\|warning" /tmp/install.log | tail -20
        failed_pkgs="$failed_pkgs $pkg"
    }
done
if [ -n "$failed_pkgs" ]; then
    echo "=== unpack failures:$failed_pkgs ==="
    exit 1
fi

# 2) neutralise postinst scripts that cannot run in a bare container root
for script in usrmerge.postinst usr-is-merged.postinst; do
    path="/var/lib/dpkg/info/$script"
    if [ -e "$path" ]; then
        printf '#!/bin/sh\nexit 0\n' > "$path"
        chmod 0755 "$path"
        echo "neutralised $script"
    fi
done

# 3) configure everything (retry once with neutralised postinst on failure)
if ! dpkg --force-depends --force-confnew --configure -a >/tmp/configure.log 2>&1; then
    echo "=== dpkg --configure -a failed; neutralising failing postinst ==="
    grep -i "error" /tmp/configure.log | tail -10 || true
    awk '/^Setting up /{print $3}' /tmp/configure.log | tail -5 | while read -r pkg; do
        pkg=${pkg%%:*}
        [ -n "$pkg" ] || continue
        printf '#!/bin/sh\nexit 0\n' > "/var/lib/dpkg/info/$pkg.postinst"
        chmod 0755 "/var/lib/dpkg/info/$pkg.postinst"
        echo "neutralised $pkg.postinst" >>/tmp/configure.log
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
