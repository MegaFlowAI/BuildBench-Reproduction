-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: tasmanian
Binary: tasgrid, libtasmaniansparsegrid8, libtasmaniandream8, libtasmanianfortran8, libtasmaniancaddons8, libtasmanian-dev, octave-tasmanian, python3-tasmanian
Architecture: any all
Version: 8.2-2
Maintainer: Debian Science Maintainers <debian-science-maintainers@lists.alioth.debian.org>
Uploaders: Sébastien Villemot <sebastien@debian.org>
Homepage: https://github.com/ORNL/TASMANIAN
Standards-Version: 4.7.3
Vcs-Browser: https://salsa.debian.org/science-team/tasmanian
Vcs-Git: https://salsa.debian.org/science-team/tasmanian.git
Testsuite: autopkgtest
Testsuite-Triggers: g++, gfortran, octave
Build-Depends: debhelper-compat (= 13), dh-sequence-fortran, dh-sequence-python3, cmake, libblas-dev, liblapack-dev, python3-numpy
Package-List:
 libtasmanian-dev deb libdevel optional arch=any
 libtasmaniancaddons8 deb libs optional arch=any
 libtasmaniandream8 deb libs optional arch=any
 libtasmanianfortran8 deb libs optional arch=any
 libtasmaniansparsegrid8 deb libs optional arch=any
 octave-tasmanian deb math optional arch=all
 python3-tasmanian deb python optional arch=any
 tasgrid deb math optional arch=any
Checksums-Sha1:
 f8ec80d09d6daee2a99132c74f4dca64a1ec5ca8 680212 tasmanian_8.2.orig.tar.gz
 2e506004c046c0bc410ddb8a15622a919aa04371 6152 tasmanian_8.2-2.debian.tar.xz
Checksums-Sha256:
 ae2a3ad91c9e7aab1672ab98871fb7fb1600170ddbc09ad69d479755369fb7fc 680212 tasmanian_8.2.orig.tar.gz
 7bbe1af9db410e2410f2680a1fcd59fa0ade9296a5bd7c67027420579158d1d4 6152 tasmanian_8.2-2.debian.tar.xz
Files:
 59c87d6625bc0bc36214dab4364a68a9 680212 tasmanian_8.2.orig.tar.gz
 712ed70b9af8f9e48772a478a8af490a 6152 tasmanian_8.2-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCgAdFiEEU5UdlScuDFuCvoxKLOzpNQ7OvkoFAmln8G8ACgkQLOzpNQ7O
vkpPNw/2OyXWYonT15UHAHBzhvOYBXjDM9WiHXb+eV4t2CrEaiQ/JfwrqWqyhS+9
Nvf9hgZCAwaaYIjilM8t+wJKIEOsKhN21ek9KhnPMy579YpP/Kee1LCZChtEP1xe
zLQe5WwcWS102IuT3T0VURZBaH9EsNXqFSOLZThFPXed3f/krkxl+UFZhEyuroBF
TGhCDLY49+Ldsh3Ujx1D/EJb0Kb7ifisVWpr0e1UuBKslsykaSMUpEMX+TfBTCZ5
u4WTHaeq72IFjnwVDLPWuQxec0J38LOT1kfCyOJEKofTeQyn/IdUAHMVREo9yjZD
vTlma0aELSyfBbpHN6de5s2D2VrtQFulKVs0EOISOM5eDWC6Ps/ktV1QXPZXEm5o
GxrDw6dylyAnQiVKZIbHEO5abnzsyur7QOfXRo9xoFly/AzFYPWLb6nLraXgT92P
xkMqB4irxPRwDql/nmpoXjgPHyh84ZRaBOnxhp/cSHRg7h5j17Lqgcc/trGhOpVr
PIQc1vHVw0kbMAy33Tw/uiWxRntXhfWrlbOfa/L0fsh4pXdBwSBYA2rfg/qL/NgA
vbIpzJZX253S8xY65Sj1KA7WP8Amj3NhoDmZEoyyyTRS95b5HQj3LAaj4A5AJ6mB
aepGyAwtpP41rkIJlS3WKH/8cJFjmod3Fpxn2jIQZIBgsA0Egg==
=Mc6y
-----END PGP SIGNATURE-----
