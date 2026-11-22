-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-lcms2
Binary: librust-lcms2-dev
Architecture: any
Version: 5.6.0-1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Matthias Geiger <matthias.geiger1024@tutanota.de>
Homepage: https://lib.rs/crates/lcms2
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/lcms2
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/lcms2]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo
Build-Depends: debhelper (>= 12), dh-cargo (>= 25), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>, librust-foreign-types-0.5+default-dev <!nocheck>, librust-lcms2-sys-4+default-dev <!nocheck>
Package-List:
 librust-lcms2-dev deb rust optional arch=any
Checksums-Sha1:
 88533686665665f2a0dc50956c08b82f419e2373 27991 rust-lcms2_5.6.0.orig.tar.gz
 fcee5a80d2b80540705686ac56bcff90cd4fe2cf 2668 rust-lcms2_5.6.0-1.debian.tar.xz
Checksums-Sha256:
 b9d50a4d00d909da0ec023ab34ea09bf3b3b79b5a36b3e0da3a305112edaf150 27991 rust-lcms2_5.6.0.orig.tar.gz
 e1296ac00e00fa8cdbd4afb2b838fb9df1e18eef8432357bd976f881e740e734 2668 rust-lcms2_5.6.0-1.debian.tar.xz
Files:
 992bcc3f686e7ca3fda7184bf3eea70c 27991 rust-lcms2_5.6.0.orig.tar.gz
 cbbcea890b27579916c989ba6a5a1157 2668 rust-lcms2_5.6.0-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmTxDG0ACgkQ5mx3Wuv+
bH0n3Q//QusgDvNJJfUiASM0P6j83wb0LtF/QYoK5ZOZWM292Ls5VAMrgiblh8Rq
1YXS6LgnwM7QrmrkuaPo05g6iH0xaG+/exX3RqGSsx+uEcfcdCBRbZ89LUs0vCUH
TMfNeraI9iAp4D4yiRcWWXC5s+xsOlpr3FNRzZe5QAzSQk9tzqtjt+w4k4UbVwlq
bwFLRTJDL12hNZOoYsskej4Wwig4UFK4kSQx0kua+T834fpkBntufpELFV4fQfPv
z/q6InJIrdzBXty87fh68K7yRhE/UHZd6U/dn36ZshtuHJeeOoEfi0+eczYHjb64
SNe5KlJReQ4K5XqrjYn6LF3olpuYiwppbw29c+OoGBQ3vKeU1cHqelu1VX01jeHv
dtjDD9Jw8qB6IU64PnX0W5XrMsBHkh9K0OOJIlshhAu3LjWtr+vuKnjnOfeOIO9B
6ogiqTSnjKB5+cf+hj1h9nT59/uMD7nvk4mNdsPJZnzUSRs3MIyGG5b3JJgfSHTT
a538415FPws8+J985bclpq+3avkpf45UwND6gJQ07XDfWW0gR5LHlfwGQiQcqi9U
pwNtWXieTkIo4WRZOgLTZrrDcO1ryZXg2nrJWTFfHmilCB+m0H0LKOfNwdoih+7j
oeHDW1ha73KU0Is9xsAihJRYWzfvYBhhzbPDVljosnNX/2VuOJw=
=8r1c
-----END PGP SIGNATURE-----
