-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: rust-generator
Binary: librust-generator-dev
Architecture: any
Version: 0.6.20-3
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Fabian Grünbichler <f.gruenbichler@proxmox.com>
Homepage: https://github.com/Xudong-Huang/generator-rs.git
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/generator
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/generator]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo
Build-Depends: debhelper (>= 12), dh-cargo (>= 24), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-cc-1+default-dev <!nocheck>, librust-libc-0.2+default-dev <!nocheck>, librust-log-0.4+default-dev <!nocheck>, librust-rustc-version-0.4+default-dev <!nocheck>, librust-winapi-0.3+default-dev <!nocheck>, librust-winapi-0.3+memoryapi-dev <!nocheck>, librust-winapi-0.3+sysinfoapi-dev <!nocheck>
Package-List:
 librust-generator-dev deb rust optional arch=any
Checksums-Sha1:
 6435aa5499d390cb79777b9534a785d42d3c0788 26788 rust-generator_0.6.20.orig.tar.gz
 6f482146c7164a6f260240043104dbd69f6a825a 3120 rust-generator_0.6.20-3.debian.tar.xz
Checksums-Sha256:
 caaa160efb38ce00acbe4450d41a103fb3d2acdb17ff09a7cf38f3ac26af0738 26788 rust-generator_0.6.20.orig.tar.gz
 8077181901b93696a26e788cea5def0f719c393aaa3101ebfcbb61d8bbe771d6 3120 rust-generator_0.6.20-3.debian.tar.xz
Files:
 e889b3fd709d603878bc76313b0d399d 26788 rust-generator_0.6.20.orig.tar.gz
 9a3ee0f9af40bb22aa5b4ac860825939 3120 rust-generator_0.6.20-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtg21mU05vsTRqVzPfmUo2nUvG+EFAmGj9JYACgkQfmUo2nUv
G+G47w/9EslpdF0YIsp36RjDzlE+qjnicePGo1Bd/oXB6OJD9YBBQow2RsUTeDip
osD3xgVEUitB1D42G/BKVD2gmAy6QW6bsKLd4kfLtGF3jLNiHiDc2uGXNCfCs4uk
f6sSNHnA74NeqfFJQtetHtbUyIsfa631eYU6ucST0U56kAkoisaAESsgXgEQCeDx
SR1pv9nDBPrQFdSzKuhd0sWR2PdvNY3X3OBfKqk2lVxLyJvt3P4kR+4uZJrPzDOe
rx2gdX+uewa0Bi7X4ETDSkjVtx43Px3No441uje3dcKcUgvRhNMZJNvsPkv/F0IU
p/lk/XgNu3X7gwOaauPGhf0/WDszE1zSfPPK0Pl5Ks4N2tNCe+rOTY2+P/nCu4zt
i9xj/WmGgwp5K3UXMKsRXqOnSnaeQ/18pjYtLczSLb+1ZTceaeO7yCLq25lGtATg
xvKRob56c2CTxjwwLdoLAHfmqdxFJLr+G4jCoFr0Qi4CP1O/fpJzl7GbwfE3/u0b
7s8nIdQuz6esKzA1VGJgmoeMfMKBpjTsv5CEmAbZRRJ6CcYxTc9JyyO95mbtgeo4
osGMbFnFLnB0sImZubq8VJmht7k3q0PIFMYIHSXNRmIo0GBOxfbXh20vP7F++nHA
HVDdKGLzZVbOzk9P8KPPuFoacaiw+NwVtzRr23H/qh5ZSGkKaQM=
=an/Z
-----END PGP SIGNATURE-----
