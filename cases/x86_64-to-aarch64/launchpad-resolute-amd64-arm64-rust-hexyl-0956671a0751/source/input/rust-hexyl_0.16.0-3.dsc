-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-hexyl
Binary: librust-hexyl-dev, hexyl
Architecture: any
Version: 0.16.0-3
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Wolfgang Silbermayr <wolfgang@silbermayr.at>
Homepage: https://github.com/sharkdp/hexyl
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/hexyl
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/hexyl]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo, librust-assert-cmd-2+default-dev, librust-predicates-3+default-dev, librust-pretty-assertions-1+default-dev, rustc
Build-Depends: debhelper-compat (= 13), dh-sequence-cargo, help2man
Build-Depends-Arch: cargo:native, rustc:native (>= 1.74), libstd-rust-dev, librust-anyhow-1+default-dev, librust-clap-4+default-dev, librust-clap-4+derive-dev, librust-clap-4+wrap-help-dev, librust-const-format-0.2+default-dev, librust-libc-0.2+default-dev, librust-owo-colors-4+default-dev, librust-supports-color-3+default-dev, librust-terminal-size-0.4+default-dev, librust-thiserror-1+default-dev
Package-List:
 hexyl deb utils optional arch=any
 librust-hexyl-dev deb utils optional arch=any
Checksums-Sha1:
 6a88371620dd0c712f81059146c8d3386d94bfaa 42892 rust-hexyl_0.16.0.orig.tar.gz
 77bedc73192afeaef56f3dffa1f8edf714606ef6 3592 rust-hexyl_0.16.0-3.debian.tar.xz
Checksums-Sha256:
 43d56dd04872b6c6d429f18d2e03df95f853feb618c7cd8bf22d0e6851ce5ef8 42892 rust-hexyl_0.16.0.orig.tar.gz
 f0d637ccf861b83b65e3dcfc9b295fe7321fe19854dc5f2d3234a2e5491771f5 3592 rust-hexyl_0.16.0-3.debian.tar.xz
Files:
 227042f187f0bb7c73878f97776f5ab9 42892 rust-hexyl_0.16.0.orig.tar.gz
 b74fb5026347cf9a754c7ed24d19fd53 3592 rust-hexyl_0.16.0-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQUWTv/Sl6/b+DpcW7svtu2B7myvgUCaWqYswAKCRDsvtu2B7my
vnlQAQD45D/l7yo9WSw3/jqxgOOoz38TbOiZZzvycGcaRC0b4AD+MXJL/WXUB6/k
v+QO2I99UIk0CscryVWoQWWFqO9tdwo=
=rIVS
-----END PGP SIGNATURE-----
