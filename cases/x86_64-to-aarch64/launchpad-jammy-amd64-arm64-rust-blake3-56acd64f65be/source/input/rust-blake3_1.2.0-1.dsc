-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: rust-blake3
Binary: librust-blake3-dev
Architecture: any
Version: 1.2.0-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  karthek <mail@karthek.com>
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/blake3
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/blake3]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-hex-0.4+default-dev, librust-rand-0.7+default-dev, librust-rand-chacha-0.2+default-dev
Build-Depends: debhelper (>= 12), dh-cargo (>= 25), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-arrayref-0.3+default-dev (>= 0.3.5-~~) <!nocheck>, librust-arrayvec-0.7-dev <!nocheck>, librust-cc-1+default-dev (>= 1.0.4-~~) <!nocheck>, librust-cfg-if-1+default-dev <!nocheck>, librust-constant-time-eq-0.1+default-dev (>= 0.1.5-~~) <!nocheck>, librust-digest-0.9+std-dev <!nocheck>
Package-List:
 librust-blake3-dev deb rust optional arch=any
Checksums-Sha1:
 9fe39d1e3656c465d26bbc73ecf4edee74014450 156645 rust-blake3_1.2.0.orig.tar.gz
 f5ace26395370f87f359195c0de32d3af8ca205d 7828 rust-blake3_1.2.0-1.debian.tar.xz
Checksums-Sha256:
 526c210b4520e416420759af363083471656e819a75e831b8d2c9d5a584f2413 156645 rust-blake3_1.2.0.orig.tar.gz
 372971d34a245ca4536759b58e9d32ef0cbcf76462f80e50524cdba3ebc27257 7828 rust-blake3_1.2.0-1.debian.tar.xz
Files:
 46dc44751b52cd0fbfed5c0f6ea2cf07 156645 rust-blake3_1.2.0.orig.tar.gz
 969875407797f063eb823d17a28ffd5b 7828 rust-blake3_1.2.0-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJIBAEBCAAyFiEEU0DQATYMplbjSX63DEjqKnqP/XsFAmG+i+oUHHBsdWd3YXNo
QGRlYmlhbi5vcmcACgkQDEjqKnqP/Xsdig/8DzZxucLzfWjw7qecSJ36s28KJl0O
LEDlB4f5cWQoGG7szgSZAA6h+OaNuqtKVNoQYN1Qde34eCalcpjoS4nIFMjqrDgK
rF1OYnWnZWmcCc4y0v9aU3CbhNybMpreLQD/7IyiruP3KzIMRCPrEH5D8kwaAjUx
td/9w2mg+TPr4p5v9LTY0qoPs2vXl/faB/OSrgFTEemdJ7aBnhYLp08LJW6qThAo
BOegKshuicaFBiUuUR28bC7jy1dZkcY0oisORnDqfoEwcyM1NlQbz4XhKRkcEkFF
vWy4PXvtT9ajLqZe52WUXEWeN6Z5zdtE8ikVu/ibrJ4QtNDrXhGSe5t7TmNXnbbe
4i+RONpQry7KXI4OVcrna0S4VgYXWsSJxHWfxCwCVIQS8oHz7JliAvLGSKn7uUX4
ebsbK62u2wwO5rlAQ7MwDg6reFZByenZMZE4pPE72RBiGe/ZI89FcjwRU+KFmZxi
FNqsfYJOyPYK8OJBbtxVvh4QunM4aZmK76r7w6zaLz3FVpbbU99Z7AuwkpCbG83n
DZMKzD0uYTPW8xH4PF3FaFJNjAiQt5xtmmxeUAG5XkVJjdzuxBiOhapszgo+u8YS
yPpxKbBPu4KMy3+Lb/L6G7rl9iHSZMfd9+3W9FYAoMIIgdVLZSkROMBvV8JDGd+A
A5hEuTRIsuYXBrI=
=ajXi
-----END PGP SIGNATURE-----
