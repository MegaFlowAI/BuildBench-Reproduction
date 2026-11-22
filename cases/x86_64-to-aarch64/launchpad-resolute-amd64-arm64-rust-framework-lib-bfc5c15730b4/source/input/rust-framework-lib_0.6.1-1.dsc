-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-framework-lib
Binary: librust-framework-lib-dev
Architecture: any
Version: 0.6.1-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders: Nadzeya Hutsko <nadzya.info@gmail.com>
Homepage: https://github.com/FrameworkComputer/framework-system
Standards-Version: 4.7.3
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/framework-lib
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/framework-lib]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, rustc
Build-Depends: debhelper-compat (= 13), dh-sequence-cargo
Build-Depends-Arch: cargo:native <!nocheck>, rustc:native (>= 1.81) <!nocheck>, libstd-rust-dev <!nocheck>, librust-built-0.8+chrono-dev <!nocheck>, librust-built-0.8+default-dev <!nocheck>, librust-built-0.8+git2-dev <!nocheck>, librust-clap-4+cargo-dev (>= 4.5) <!nocheck>, librust-clap-4+default-dev (>= 4.5) <!nocheck>, librust-clap-4+derive-dev (>= 4.5) <!nocheck>, librust-clap-complete-4+default-dev (>= 4.5) <!nocheck>, librust-clap-num-1+default-dev (>= 1.2.0) <!nocheck>, librust-clap-verbosity-flag-2+default-dev <!nocheck>, librust-dmidecode-1-dev <!nocheck>, librust-env-logger-0.11+default-dev <!nocheck>, librust-guid-create-0.5-dev <!nocheck>, librust-hidapi-2+default-dev (>= 2.6.3) <!nocheck>, librust-lazy-static-1+default-dev (>= 1.4.0) <!nocheck>, librust-libc-0.2+default-dev (>= 0.2.155) <!nocheck>, librust-log-0.4+default-dev <!nocheck>, librust-nix-0.30+default-dev <!nocheck>, librust-nix-0.30+ioctl-dev <!nocheck>, librust-nix-0.30+user-dev <!nocheck>, librust-no-std-compat-0.4+alloc-dev (>= 0.4.1) <!nocheck>, librust-no-std-compat-0.4+default-dev (>= 0.4.1) <!nocheck>, librust-num-0.4-dev <!nocheck>, librust-num-derive-0.4-dev <!nocheck>, librust-num-traits-0.2-dev <!nocheck>, librust-regex-1-dev (>= 1.11.1) <!nocheck>, librust-rusb-0.9+default-dev (>= 0.9.4) <!nocheck>, librust-sha2-0.10+force-soft-dev (>= 0.10.8) <!nocheck>, librust-spin-0.9+default-dev <!nocheck>
Package-List:
 librust-framework-lib-dev deb rust optional arch=any
Checksums-Sha1:
 aa53bc51aa47bde92cbae53fea412a03803a3d3a 1549141 rust-framework-lib_0.6.1.orig.tar.gz
 5ab98ad7d3f74bf777639f5f39c2e406e9b344de 4620 rust-framework-lib_0.6.1-1.debian.tar.xz
Checksums-Sha256:
 8d382ea6cc34f9edb02c6b27e8e3d04aa367f804b6943d5c7c0104059c5ecfa8 1549141 rust-framework-lib_0.6.1.orig.tar.gz
 eb475dad938bc710fb0cd4d519d5b212a81eafb6e30f9ed069ae5fdf08bcb18e 4620 rust-framework-lib_0.6.1-1.debian.tar.xz
Files:
 be1fa50235c31b0d4b5896edec78d606 1549141 rust-framework-lib_0.6.1.orig.tar.gz
 0c5d09a1c606b318a406f65690542946 4620 rust-framework-lib_0.6.1-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJVBAEBCgA/FiEEbdkGe7ToK0Amc9ppdh5TKjcTRTAFAmm+8FghHGRlYmlhbkBm
YWJpYW4uZ3J1ZW5iaWNobGVyLmVtYWlsAAoJEHYeUyo3E0UwdhYP/3Cild8ZM8/D
pC9VjVObSixmT6YlQKXMGFfD+zCnOZsLjR5KkPXR+L/ncemIo++ejPWFkHgg766v
aLNEwYErmTxCXjw8xJRV2FfWoibhcY4VlTXatSt5bau7DYcZEK5wRc9IuMN2u18f
NFzdUBj/tBH1O771GkukwEoj2i3FiOROqFc0opFaX9zYziu3jyXP/OmwaxJQYoWj
TUIiLO+q9amyVxfStFSEqokH0S3NU1moUkL84jutUD+zjnzz1+xZcZ0HLRfJ5VSs
0QUlZvj05HGd1lJdx1fLiuhMGxMLDBAFnUEeuKZBpoI7A6vJm850T90W9eFqwlSy
JgnmOnULQAMOmsZV8nCd2I4mpA84eLmMzZenUCKM7Mtoact2My9CQG5Zk0AaNzDf
G0ovpeh3RflTaW6VN6RVhDxlF/rv/3iOr8oZr52uqfaoRCUbDQ20P4ciYv3mnh0h
shGJBQfxFfP9JcGkRormIpycG7a2RLe+PyUl32k7HKR+yYSwAqSQi8Dd96Herjlm
BeQPmzg3Phr4+VSTFBAp7dovG5qmR7qF1uHIUmFSYfjfclSQSlAMKRpWme0xndC3
GK6VLbhUFDDXizWM5YQqioNVadniA7OKaGnSvYVUkPlkFTtOT9Joh2fNYBBPcutM
ILQmhrpnMl61KkR/7q0BTod78/RDIZm0
=hNgz
-----END PGP SIGNATURE-----
