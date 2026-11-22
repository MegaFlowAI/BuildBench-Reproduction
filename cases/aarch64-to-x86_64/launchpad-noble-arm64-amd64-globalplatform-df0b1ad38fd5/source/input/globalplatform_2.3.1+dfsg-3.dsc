-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: globalplatform
Binary: gpshell, libglobalplatform-dev, libglobalplatform7, libgppcscconnectionplugin1
Architecture: any
Version: 2.3.1+dfsg-3
Maintainer: Debian Authentication Maintainers <pkg-auth-maintainers@lists.alioth.debian.org>
Uploaders:  Simon Josefsson <simon@josefsson.org>,
Homepage: https://kaoh.github.io/globalplatform/
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/auth-team/globalplatform
Vcs-Git: https://salsa.debian.org/auth-team/globalplatform.git
Testsuite: autopkgtest
Testsuite-Triggers: gcc, libc-dev, libssl-dev, pcscd, pkgconf
Build-Depends: cmake, debhelper-compat (= 13), doxygen, libcmocka-dev, libminizip-dev, libpcsclite-dev, libssl-dev, pandoc, pkg-config, zlib1g-dev
Package-List:
 gpshell deb devel optional arch=any
 libglobalplatform-dev deb libdevel optional arch=any
 libglobalplatform7 deb libs optional arch=any
 libgppcscconnectionplugin1 deb libs optional arch=any
Checksums-Sha1:
 5d30827e1d17d1908dc66347a047a93d03bc2e98 315024 globalplatform_2.3.1+dfsg.orig.tar.xz
 67295bde5d28a84677abe79bcd80fe2ffdf63275 7568 globalplatform_2.3.1+dfsg-3.debian.tar.xz
Checksums-Sha256:
 9f67a7f5d1d0c9e2c80a024c71e301d8ba4ad2e6110ec492305f87acada066ef 315024 globalplatform_2.3.1+dfsg.orig.tar.xz
 0579dd2a3281b2cc2e2ee2a4cf035f6ebbfd2c4c796a6ced61d81180b0b78218 7568 globalplatform_2.3.1+dfsg-3.debian.tar.xz
Files:
 ad4f9e184f6e706fee0fab99ad5399ce 315024 globalplatform_2.3.1+dfsg.orig.tar.xz
 415445d363e752dd38d9b89fb2e12f2f 7568 globalplatform_2.3.1+dfsg-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iIoEARYIADIWIQSjzJyHC50xCrrUzy9RcisI/kdFogUCZVXXXBQcc2ltb25Aam9z
ZWZzc29uLm9yZwAKCRBRcisI/kdFoiAxAQCsX69iOsXZo6/H5lrYQFmx6MWBxmj+
yZOQGpGRqNes/gD/XGM4Aejyk82Mvod306z485H/yiAoKisLl2OHsQtM/wU=
=ik+3
-----END PGP SIGNATURE-----
