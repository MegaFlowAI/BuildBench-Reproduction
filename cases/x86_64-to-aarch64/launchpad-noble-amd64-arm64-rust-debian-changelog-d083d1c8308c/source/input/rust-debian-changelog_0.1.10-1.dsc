-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-debian-changelog
Binary: librust-debian-changelog-dev
Architecture: any
Version: 0.1.10-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Jelmer Vernooĳ <jelmer@debian.org>
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/debian-changelog
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/debian-changelog]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-flate2-1+default-dev, librust-maplit-1+default-dev
Build-Depends: debhelper (>= 12), dh-cargo (>= 25), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-chrono-0.4+default-dev <!nocheck>, librust-debversion-0.2+default-dev (>= 0.2.1-~~) <!nocheck>, librust-lazy-regex-2+default-dev <!nocheck>, librust-log-0.4+default-dev <!nocheck>, librust-rowan-0.15+default-dev (>= 0.15.11-~~) <!nocheck>, librust-textwrap-0.16+default-dev <!nocheck>, librust-whoami-0.8-dev <!nocheck>
Package-List:
 librust-debian-changelog-dev deb rust optional arch=any
Checksums-Sha1:
 b56c1a2ac18615fd73983a093a43a4bcbd7fb032 30118 rust-debian-changelog_0.1.10.orig.tar.gz
 87b4de10522090b7aaf28789ccbf5bd398cbf924 2460 rust-debian-changelog_0.1.10-1.debian.tar.xz
Checksums-Sha256:
 cf0fbdc5e8c585c4c35454d1fad4a1cf1f5cbae4c55071f4ae80fbb65662ac0b 30118 rust-debian-changelog_0.1.10.orig.tar.gz
 7692cf7414f7aaeab404ac779bd08238bd941b3f0a6a6e0d341ffa45082b5966 2460 rust-debian-changelog_0.1.10-1.debian.tar.xz
Files:
 d4254870715d28e800ec6e456e9d9371 30118 rust-debian-changelog_0.1.10.orig.tar.gz
 61ee36a69ecf54ee0dbdaf602c1507f1 2460 rust-debian-changelog_0.1.10-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgIoEfJX3ae+y722SMG8hYYBCUGYFAmVBQ2cACgkQMG8hYYBC
UGbm/Af+Kzz3Y/Np+cCbIMnaHloXjSZWQ/6N2Obs1MH4V5N7N4lEqLN4fkZ62v83
nEIFMar64Wxzkc3MzzVZSTxR3UmVhtAIvrcueYMihuA1zeBLDUHbe6nSqqNcMHQr
n8/gnJzbijTlWP4RCicbVmLD8FW9DXdsmP+zZaBb2U/kDWVsgg85vk0v0h8Ly1ap
BQgcdsUI8vxL44J3BAVKmKqZpcxZJLIqqr6+ms4lXOmq/ZvmbFpwFptseJXRkPSc
sLYVdKwplZE6yqJI227zh5atJDHrwKPm44WPYIwZwkgaTqCOwopxWqhcN7qCOMdk
V/VOMuIcrZEAWU6qSVVoGNM7klXz7A==
=nxId
-----END PGP SIGNATURE-----
