-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-hamming-rs
Binary: librust-hamming-rs-dev
Architecture: any
Version: 0.2.23-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Fab Stz <fabstz-it@yahoo.fr>
Homepage: https://github.com/JeWaVe/hamming_rs
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/hamming-rs
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/hamming-rs]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-criterion-0.5+default-dev, librust-hamming-0.1+default-dev, librust-rand-0.8+default-dev, librust-strsim-0.11+default-dev, rustc
Build-Depends: debhelper-compat (= 13), dh-sequence-cargo
Build-Depends-Arch: cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>
Package-List:
 librust-hamming-rs-dev deb rust optional arch=any
Checksums-Sha1:
 35c40b118c160848c713aa6ab31f7c60e4b7b558 55923 rust-hamming-rs_0.2.23.orig.tar.gz
 e55d2c9da143bcba60409836bae7e851b8d98b7a 2744 rust-hamming-rs_0.2.23-1.debian.tar.xz
Checksums-Sha256:
 b6c2ed44810941ff19d199c516eb866ef3740fadabac26224c8d7e60ecfd3eeb 55923 rust-hamming-rs_0.2.23.orig.tar.gz
 89e2d1acef2ec1ee4ffd7e9a1b2d5168d616455480bb78f37fcb242e1b92d1e1 2744 rust-hamming-rs_0.2.23-1.debian.tar.xz
Files:
 c9889d89f89dda09e8f7b74e3dc71ad9 55923 rust-hamming-rs_0.2.23.orig.tar.gz
 4af345f6b24296b0737958b4283db6a4 2744 rust-hamming-rs_0.2.23-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQTjXSWUWAMcT4Fcz+oDR6wEe1CAhQUCaLiFQQAKCRADR6wEe1CA
hQQNAQD/vktu9l1S22nkahlLmW8W4aFRCnuva9Q2ffhFTPgQfgD8D+Fme096R0ik
HGlmJLTrXYTNRKS9tcO7rDJ+uVNQvg8=
=7iia
-----END PGP SIGNATURE-----
