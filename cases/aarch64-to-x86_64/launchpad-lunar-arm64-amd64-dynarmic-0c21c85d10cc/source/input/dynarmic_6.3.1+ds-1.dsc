-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: dynarmic
Binary: libdynarmic6, libdynarmic-dev
Architecture: any-amd64 any-arm64
Version: 6.3.1+ds-1
Maintainer: Andrea Pappacoda <andrea@pappacoda.it>
Homepage: https://github.com/merryhime/dynarmic
Description: ARM dynamic recompiler
 Dynarmic is a dynamic recompiler for the ARMv6K, ARMv7A architecture, with
 partial ARMv8 support.
 .
 In the pursuit of speed, some behavior not commonly depended upon is elided.
 Therefore this emulator does not match spec.
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/debian/dynarmic
Vcs-Git: https://salsa.debian.org/debian/dynarmic.git
Testsuite: autopkgtest
Testsuite-Triggers: c++-compiler, cmake, g++
Build-Depends: debhelper-compat (= 13), cmake (>= 3.12), catch2, libboost-dev, libfmt-dev, libxbyak-dev [any-amd64], libzydis-dev, pkg-config, robin-map-dev
Package-List:
 libdynarmic-dev deb libdevel optional arch=any-amd64,any-arm64
 libdynarmic6 deb libs optional arch=any-amd64,any-arm64
Checksums-Sha1:
 80eb08b3ff26d6d228f59bae981e3d98a4fc8951 418588 dynarmic_6.3.1+ds.orig.tar.xz
 a35992139d44ee695fb29e0a991bb386e26da09f 5176 dynarmic_6.3.1+ds-1.debian.tar.xz
Checksums-Sha256:
 5a5aea5fddd91fbc4f56744e93045609d00ccfd98030d5dc8f75ecf73755352f 418588 dynarmic_6.3.1+ds.orig.tar.xz
 712ac1bbdc066d35d597661720686f26823a10b5d13317fbece08dfd435cfc8c 5176 dynarmic_6.3.1+ds-1.debian.tar.xz
Files:
 5f36eca662541b939797fb0376306aaf 418588 dynarmic_6.3.1+ds.orig.tar.xz
 7ae74936a9d5520b721d2e772d2236b9 5176 dynarmic_6.3.1+ds-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQS6VuNIvZRFHt7JcAdKkgiiRVB3pwUCY36MIgAKCRBKkgiiRVB3
pxcjAQDgrH2LzShHek/TiSnuKjDrSvrY9Momj9a6VMQkz1Ky+QD/YZb7zKOD7NKz
WuH66nfn0JFRLJmIm/myArB57SjPHgw=
=wGXN
-----END PGP SIGNATURE-----
