-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-landlock
Binary: librust-landlock-dev
Architecture: any
Version: 0.4.3-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Eddie Billoir <lechatp@outlook.fr>
Homepage: https://landlock.io
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/landlock
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/landlock]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-anyhow-1+default-dev, librust-lazy-static-1+default-dev, librust-strum-0.26+default-dev, librust-strum-macros-0.26+default-dev, rustc
Build-Depends: debhelper-compat (= 13), dh-sequence-cargo
Build-Depends-Arch: cargo:native <!nocheck>, rustc:native (>= 1.63) <!nocheck>, libstd-rust-dev <!nocheck>, librust-enumflags2-0.7+default-dev <!nocheck>, librust-libc-0.2+default-dev (>= 0.2.175-~~) <!nocheck>, librust-thiserror-2+default-dev <!nocheck>
Package-List:
 librust-landlock-dev deb rust optional arch=any
Checksums-Sha1:
 ace331f67cf278974ec2b54cd3bc84a0adb42ccd 45960 rust-landlock_0.4.3.orig.tar.gz
 780a602b809ee6508fc78e457a1c1cdcb6bae416 5348 rust-landlock_0.4.3-1.debian.tar.xz
Checksums-Sha256:
 affe8b77dce5b172f8e290bd801b12832a77cd1942d1ea98259916e89d5829d6 45960 rust-landlock_0.4.3.orig.tar.gz
 92e1e09e9cd580f38732ee76db7e72862decd9913eedba4a4b8f8ebd1a652723 5348 rust-landlock_0.4.3-1.debian.tar.xz
Files:
 2615fc92078e5483abb876b97c95dbe0 45960 rust-landlock_0.4.3.orig.tar.gz
 23c3ff091ccfc7b2fdb0504713493aa7 5348 rust-landlock_0.4.3-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQTjXSWUWAMcT4Fcz+oDR6wEe1CAhQUCaN/0oAAKCRADR6wEe1CA
hbuaAP0Yw5BXZzTKURazo+VzhnuN3t63DNHwFHecfxXKbG6JJgD7BzTl9OXfbCCo
uBg7EgPdQF3w8TYtD8rywFA3Dm00JQA=
=P3XY
-----END PGP SIGNATURE-----
