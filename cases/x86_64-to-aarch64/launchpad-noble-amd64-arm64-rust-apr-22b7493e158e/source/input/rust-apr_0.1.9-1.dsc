-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-apr
Binary: librust-apr-dev
Architecture: any
Version: 0.1.9-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Jelmer Vernooĳ <jelmer@debian.org>
Homepage: https://github.com/jelmer/apr-rs
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/apr
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/apr]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo
Build-Depends: debhelper (>= 12), dh-cargo (>= 25), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-bindgen+default-dev (>= 0.60-~~) <!nocheck>, librust-ctor-0.1+default-dev <!nocheck>, librust-pkg-config-0.3+default-dev <!nocheck>, librust-system-deps-6+default-dev <!nocheck>, libapr1-dev <!nocheck>, libaprutil1-dev <!nocheck>, pkg-config <!nocheck>
Package-List:
 librust-apr-dev deb rust optional arch=any
Checksums-Sha1:
 ee21ab7092b151082a1ce5207e88d8dd06088a0e 12098 rust-apr_0.1.9.orig.tar.gz
 f5ad17b9e6ab9add891a7fff25c170400bb98b5d 2220 rust-apr_0.1.9-1.debian.tar.xz
Checksums-Sha256:
 8dc6d7c0cd828ef52a25eae13854be602013896e42475d07d0c96644288210ea 12098 rust-apr_0.1.9.orig.tar.gz
 08af951bfb3fb1c1cdf174c086fc6fccbb0feaa1d0a461713cbba7abf5a7e4e3 2220 rust-apr_0.1.9-1.debian.tar.xz
Files:
 03ac23176a19ed7ee432355a1218f0b8 12098 rust-apr_0.1.9.orig.tar.gz
 65b671df3d836e1b69835e19b0d08807 2220 rust-apr_0.1.9-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCgAdFiEEgIoEfJX3ae+y722SMG8hYYBCUGYFAmVK0mgACgkQMG8hYYBC
UGYinAf4pPqlcLUo4nS+jzjAzEYIVflowlCNKjJqPiJ4gfnnlxMJ7ZarL8wNwOHF
21Kb61AVoXidtBNjbpGelq3n7eVfUNtzC2SJP5ou4AriZWitOUyhK/kaDVL2lGhp
q/YtuafggOPY1IRW0JcxzgsAMbipVJ0dgI2VHvIWlygOTbo6xz1KGz+aX85XhiHg
+PHd5s/ze3/LsJk+NuNz01eUp7ahX5h9nEip64gmPR2pbHJbaqwGABk/OFU69HFd
UyDAI0vrpCD2ABhw/LVswlrwmeISSb+VVgL/ycBOqPuLm40X991IxFGHk4Ra49JE
sg0nIN4d0cemNNkAY80194zL3A4D
=bWlZ
-----END PGP SIGNATURE-----
