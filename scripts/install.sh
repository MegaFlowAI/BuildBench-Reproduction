#!/bin/sh
set -eu
export DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8
mkdir -p /var/lib/dpkg/info /var/lib/dpkg/updates /var/lib/dpkg/alternatives /var/log
touch /var/lib/dpkg/status
if ! dpkg --force-depends --force-confnew --install /tmp/pool/*.deb >/tmp/install.log 2>&1; then
    dpkg --configure -a >>/tmp/install.log 2>&1 || true
    if ! dpkg --force-depends --force-confnew --install /tmp/pool/*.deb >>/tmp/install.log 2>&1; then
        tail -100 /tmp/install.log
        exit 1
    fi
fi
dpkg --configure -a
dpkg --audit >/tmp/audit
test ! -s /tmp/audit || { cat /tmp/audit; exit 1; }
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
