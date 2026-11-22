-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: golang-github-evanw-esbuild
Binary: golang-github-evanw-esbuild-dev, esbuild
Architecture: any all
Version: 0.14.25-1
Maintainer: Debian Go Packaging Team <team+pkg-go@tracker.debian.org>
Uploaders: Anthony Fok <foka@debian.org>
Homepage: https://github.com/evanw/esbuild
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/go-team/packages/golang-github-evanw-esbuild
Vcs-Git: https://salsa.debian.org/go-team/packages/golang-github-evanw-esbuild.git
Testsuite: autopkgtest-pkg-go
Build-Depends: debhelper-compat (= 13), dh-sequence-golang, golang-any (>= 2:1.13~), golang-golang-x-sys-dev (>= 0.0~git20210908.aa78b53), golang-src
Build-Depends-Arch: nodejs [!armel !hurd-i386 !powerpc !riscv64], npm [!armel !hurd-i386 !powerpc !riscv64]
Package-List:
 esbuild deb javascript optional arch=any
 golang-github-evanw-esbuild-dev deb golang optional arch=all
Checksums-Sha1:
 cdcf2497394438197d93249710d2c9ea01a242cf 1574314 golang-github-evanw-esbuild_0.14.25.orig.tar.gz
 832d90659e1355e56310d39bcd080eb1865fe35c 7844 golang-github-evanw-esbuild_0.14.25-1.debian.tar.xz
Checksums-Sha256:
 fca00b5895abd33aca1290cacf7dfafb642fedc1548c82ecec5b638a85419236 1574314 golang-github-evanw-esbuild_0.14.25.orig.tar.gz
 ce95bd86f3381b83ee620e5c4cf48449c324a9bf80917ed98ab8e61b3da42c58 7844 golang-github-evanw-esbuild_0.14.25-1.debian.tar.xz
Files:
 ae8fffe40b0e73a402078b6ec493d626 1574314 golang-github-evanw-esbuild_0.14.25.orig.tar.gz
 c239677ce365d47faa69578e3296baf3 7844 golang-github-evanw-esbuild_0.14.25-1.debian.tar.xz
Go-Import-Path: github.com/evanw/esbuild

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEEFCQhsZrUqVmW+VBy6iUAtBLFms8FAmI3nzAQHGZva2FAZGVi
aWFuLm9yZwAKCRDqJQC0EsWazz/PD/4pD/WzZwYKAK+9snA36SvZwBvW6lmwDA8Z
ig4W+C4RRDBzEvn+J93c2Rkr2165v0eti+g6GSVNOQpm7VeO12Am5A1k5o+a54AT
Llm9eLr4y8z/bf2jQCLRoNUlTg/w8Iv9TEkGpIk9QMTZGAtTsf9Xm28s7rPV4hXd
EiXRsAsSO5nf28Qpxk62WfGBPfr6bfQiq8LSoNpPcTYI4946gN9XB2Q5BAk2jXYq
oIjLdLt0zNeB4C3RjhSUQy68LjgTGZe06sI9My+sEfZv5OS+qNJ9wV4QVeJcWuhj
/OgG5aqwQ2FmGhk+30/d2u97pLh2etM6PB1kF3sBkcM4KEBMiVpNluKVnzogqMRg
06WwUy9tVmaSt/YYFvlGjabWYweUAR2TBGLnSzPfho/kTqlvJJKcRNgj5vxUv9gA
ljoR41sy2d35CGj3WPmrKInOBWo7a3vn5LDqBrCxSIwwRBgoPz0bRFjyfaoc26iW
oPuksOAIy/sbmshDFLrlwyQIcLAz+nwz0FEmI9oFZyjbUQLmNLxHKeKEwi8QzrUo
WWj6grf6Y9JeWcl2zKMx1KSxOxIlTAQGQR/TvyNXWBWHFxiSxoxVZTPh01e4Ossy
KZsRNU9pLaGOJx5DWM6fmmxBaLO9N158gdc1v5Fvgz+2Bsy0kyGdLItPkihxQiDV
J7gxNt71jA==
=aK3e
-----END PGP SIGNATURE-----
