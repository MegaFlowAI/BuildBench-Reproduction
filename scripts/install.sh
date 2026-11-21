#!/bin/sh
set -eu
export DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8
mkdir -p /var/lib/dpkg/info /var/lib/dpkg/updates /var/lib/dpkg/alternatives /var/log
touch /var/lib/dpkg/status

# 1) unpack everything first (no maintainer scripts run)
if ! dpkg --force-depends --force-confnew --unpack /tmp/pool/*.deb >/tmp/install.log 2>&1; then
    echo "=== dpkg --unpack tail ==="
    tail -60 /tmp/install.log
    exit 1
fi

# 2) neutralise maintainer scripts that cannot run in a bare container root.
#    usrmerge's postinst tries to migrate /bin -> /usr/bin; our bootstrap root is
#    already merged-usr, so mark it done instead of letting the migration fail.
for script in usrmerge.postinst usr-is-merged.postinst; do
    path="/var/lib/dpkg/info/$script"
    if [ -e "$path" ]; then
        printf '#!/bin/sh\nexit 0\n' > "$path"
        chmod 0755 "$path"
        echo "neutralised $script"
    fi
done

# 3) configure everything
if ! dpkg --force-depends --force-confnew --configure -a >/tmp/configure.log 2>&1; then
    echo "=== dpkg --configure -a failed (tail) ==="
    tail -80 /tmp/configure.log
    exit 1
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
