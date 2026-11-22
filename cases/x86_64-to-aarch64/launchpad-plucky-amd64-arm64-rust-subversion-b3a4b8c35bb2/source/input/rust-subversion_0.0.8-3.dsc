-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-subversion
Binary: librust-subversion-dev
Architecture: any
Version: 0.0.8-3
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Jelmer Vernooĳ <jelmer@debian.org>
Homepage: https://github.com/jelmer/subversion-rs
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/subversion
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/subversion]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-tempfile-3+default-dev, rustc
Build-Depends: debhelper-compat (= 13), dh-sequence-cargo, cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-apr+default-dev (>= 0.1.14-~~) <!nocheck>, librust-bindgen-0.71+default-dev <!nocheck>, librust-ctor-0.1+default-dev <!nocheck>, librust-lazy-static-1+default-dev (>= 1.5.0-~~) <!nocheck>, librust-system-deps-7+default-dev <!nocheck>, liblz4-dev <!nocheck>, libsqlite3-dev <!nocheck>, libsvn-dev <!nocheck>, libutf8proc-dev <!nocheck>, pkgconf <!nocheck>
Package-List:
 librust-subversion-dev deb rust optional arch=any
Checksums-Sha1:
 4994796c74493ad61f1029840fe44179ce60a944 47405 rust-subversion_0.0.8.orig.tar.gz
 ccffff52dec20bbdec1d4b9e26cd9e28fa6dd3ac 3696 rust-subversion_0.0.8-3.debian.tar.xz
Checksums-Sha256:
 bcdb4f68599e4d4118f4d8e4defee8078b0942a1c95cc35e2ee0b5f026473964 47405 rust-subversion_0.0.8.orig.tar.gz
 e700d9e782b6695be9feef55de2de365648fe9ddfbd03585abb7d3682b3061cf 3696 rust-subversion_0.0.8-3.debian.tar.xz
Files:
 8015e933ef2d8f170745b98b15a68a2c 47405 rust-subversion_0.0.8.orig.tar.gz
 16cf2a5e7b0201592bfbc4efcd20e685 3696 rust-subversion_0.0.8-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQUWTv/Sl6/b+DpcW7svtu2B7myvgUCZ5uW+AAKCRDsvtu2B7my
vpsZAQCyccra54sKuesGQX9TZIVFqYQkZDNvD3vmRrEKQetI2AEA70wl7VSv9ED/
fXL4uufwMyQ9h6lURG0KVs1tlFZcuAI=
=4mVg
-----END PGP SIGNATURE-----
