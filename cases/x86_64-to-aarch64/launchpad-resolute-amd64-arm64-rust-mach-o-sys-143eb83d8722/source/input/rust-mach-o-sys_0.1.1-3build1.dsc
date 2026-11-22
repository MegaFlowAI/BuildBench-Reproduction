-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rust-mach-o-sys
Binary: librust-mach-o-sys-dev
Architecture: any
Version: 0.1.1-3build1
Maintainer: Debian Rust Maintainers <pkg-rust-maintainers@alioth-lists.debian.net>
Uploaders:  Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Standards-Version: 4.4.1
Vcs-Browser: https://salsa.debian.org/rust-team/debcargo-conf/tree/master/src/mach-o-sys
Vcs-Git: https://salsa.debian.org/rust-team/debcargo-conf.git [src/mach-o-sys]
Testsuite: autopkgtest
Testsuite-Triggers: dh-cargo
Build-Depends: debhelper (>= 11), dh-cargo (>= 18), cargo:native <!nocheck>, rustc:native <!nocheck>, libstd-rust-dev <!nocheck>
Package-List:
 librust-mach-o-sys-dev deb rust optional arch=any
Checksums-Sha1:
 4b327903f1e05c0281881b8435e021997a7892a5 80515 rust-mach-o-sys_0.1.1.orig.tar.gz
 e555fcee13de9bb30d0245e7403192c92943f35b 2756 rust-mach-o-sys_0.1.1-3build1.debian.tar.xz
Checksums-Sha256:
 baf2802b2135f15ce13e15acec285a42c6da57ece0367490ede90de4c1a5cc92 80515 rust-mach-o-sys_0.1.1.orig.tar.gz
 17f5b3a1911ba9257ceb52aa79aa654dfeba1a525a5e42fa3298ff4bf73611f3 2756 rust-mach-o-sys_0.1.1-3build1.debian.tar.xz
Files:
 cb8687b8f8cede5387ac5af7d043baba 80515 rust-mach-o-sys_0.1.1.orig.tar.gz
 218cc9143c289e8c2d4d84681f3fad70 2756 rust-mach-o-sys_0.1.1-3build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkv5Pi0DK3E7M1gwfWWH9vpxhmAkFAmkt83QACgkQWWH9vpxh
mAkmGA//Yabu0tBVz3jUARxYRn88kpNeHSDHfHhohXy/pEYv8nah4ob0oA775FJ5
yANIIte3Sj4QZOSazgaZ+3vM/QjEbFR5h5cL3Le92jLgs4trsVcKQ1zwGMUgr1gG
GCBAoLVff2EmeSPtlzRSg2G4TYpK4GYeiAnsgbOH2xwxfXPJSkuYVzWZoa/gRX8T
4Cack/2afR0J93NTdz6uA68ug8zPJreTQlXT7UYQ5MynDgAtkEYDv/IEyWlsQmpv
jVfkY+EYyv6fwf6PRLyk/c8bTqnTbfSosMNdn2ichYBiRIV0DinXIyrT8IFryCLB
lpYHLCdfUVJEklP3xqhpsd87IoAFt7fVp9JEZf27hBSHoQOHGhtaLWCAKrDRHT9x
lbwql9R2ePFHzqr7hMs3xryOdznxLRuM1CIIzxrQNNG/frxK8EFlGikOnsCFgaN2
v53zr/x2ZZQaeG/P8V8LydNPMlQzGm1Nc07rpLJ5eiBBdbfHN5qHCMPvcrwwV2ps
9jzJeaa/yDJ9c9Kv8jvahjif32nyrr/nMN/P1aRNOQciEwky6b+0/uV3d0voBNaM
N/BE9jR/me+JDSvvnbeQtGzlU2YZXx+bOE/28jFWsvKdkm4A6j1fU6Biijs8myAS
lufqp9ZAqicx7g+hHz5Pbj/0IpWA2ZEJ7ZtzERbMELSD5nwsZTI=
=rvVF
-----END PGP SIGNATURE-----
