-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-trivialdb
Binary: librust-trivialdb-dev
Architecture: any
Version: 0.1.5-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Jelmer Vernooĳ <jelmer@debian.org>
Homepage: https://github.com/jelmer/tdb-rs
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/trivialdb
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/trivialdb]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-tempfile-3+default-dev
Build-Depends: debhelper (>= 12), dh-cargo (>= 25), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-bindgen+default-dev (>= 0.60-~~) <!nocheck>, librust-bitflags-1+default-dev (>= 1.2-~~) <!nocheck>, librust-libc-0.2+default-dev <!nocheck>, librust-pkg-config-0.3+default-dev <!nocheck>, librust-system-deps-6+default-dev (>= 6.1.1-~~) <!nocheck>, libtdb-dev
Package-List:
 librust-trivialdb-dev deb rust optional arch=any
Checksums-Sha1:
 6649223a1a3d26304a2bf9888096a036143a07ba 13743 rust-trivialdb_0.1.5.orig.tar.gz
 0be28047816871131a573c1629b730f6500ed0cb 2284 rust-trivialdb_0.1.5-1.debian.tar.xz
Checksums-Sha256:
 3d642d324c46c601ec93ab43ac2714c960334f27e56809018143a34eb8ed5751 13743 rust-trivialdb_0.1.5.orig.tar.gz
 7fe359d25ef3a5ef0e5fbbe0a822f1f59dbe10cbedde8ec74155936633abda96 2284 rust-trivialdb_0.1.5-1.debian.tar.xz
Files:
 2dc1aad7794ce3236162c9218cd6ef5a 13743 rust-trivialdb_0.1.5.orig.tar.gz
 7391b1b3095e1e687515114999869ddd 2284 rust-trivialdb_0.1.5-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgIoEfJX3ae+y722SMG8hYYBCUGYFAmann8cACgkQMG8hYYBC
UGZ2CQf/QOQiw+zGyqPsoug3qUSAOKXSLrzKhNis1dHlQMurkFv01/MM42pshQPF
pLOBSIzkjSEIyypnVgC4rjNwIlnTmMxHFrtTRF2yVQ9vg8VoYXD+WaT/sbuO3Mby
uWeQeEAH2tT/h4PBp47PqKRv6NfaaYJP5hnDvB/A2r8ipAOmrJ6S2ZY4um3JE3Ds
kmX2PktgggsQGs4SLxS42/WCjvXBVnpvaGrQ2LsSx1GA3gJAyWd76a5nfffPtkOR
xuIL6wlwQYNgu+b7EmOOq5GKNEYi1mHgOujrtUs7FuuEU1gLuPcAtqbBd1FUaLWp
7ocvoe/SOtoIJCDu9DSSa20RMXO3Xg==
=r37N
-----END PGP SIGNATURE-----
