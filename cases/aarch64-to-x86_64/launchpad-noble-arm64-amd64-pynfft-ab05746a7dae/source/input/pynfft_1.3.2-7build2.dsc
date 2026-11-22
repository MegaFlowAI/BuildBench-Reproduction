-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: pynfft
Binary: python3-pynfft, python-pynfft-doc
Architecture: any all
Version: 1.3.2-7build2
Maintainer: Debian Science Maintainers <debian-science-maintainers@lists.alioth.debian.org>
Uploaders: Ghislain Antony Vaillant <ghisvail@gmail.com>
Homepage: https://github.com/ghisvail/pyNFFT.git
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/science-team/pynfft
Vcs-Git: https://salsa.debian.org/science-team/pynfft.git
Testsuite: autopkgtest
Testsuite-Triggers: python3-all, python3-nose
Build-Depends: cython3, debhelper-compat (= 13), dh-python, libnfft3-dev, python3-all-dev, python3-nose, python3-numpy, python3-setuptools
Build-Depends-Indep: python3-sphinx
Package-List:
 python-pynfft-doc deb doc optional arch=all
 python3-pynfft deb python optional arch=any
Checksums-Sha1:
 fced9c0924568a7fde46bb7c02edaa6ba0c09fc1 180500 pynfft_1.3.2.orig.tar.gz
 803700a47a654cb5d81336a368fdfced72f596e4 5628 pynfft_1.3.2-7build2.debian.tar.xz
Checksums-Sha256:
 ae41e720e569d0d99e3a44c82c36b35a49cfc9ecc23a1cd039fe9e2895aada2c 180500 pynfft_1.3.2.orig.tar.gz
 65a1766aecd24113ce874005de40acd770559e83fe99d7266d33e1702ee60220 5628 pynfft_1.3.2-7build2.debian.tar.xz
Files:
 d2457a3f43839a8acce3295c60d5e692 180500 pynfft_1.3.2.orig.tar.gz
 dc4954b5010c27f29d615a46784a3ba1 5628 pynfft_1.3.2-7build2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmVDYxgQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9QYOD/9QkPgzeZ2EmV5IzvNCgFZih6jpNFDzwC06
0ZrvSp4yfimImSg8zMwmfmu1wN0DTZ0h4HrBZw77ebqYNIjuMd+6DzJT/uZqL35J
xmiqaEJz4vauKiAs4fb8XvYDzalHOMK+a+EoboE0smJXZXv7ko1I5pUu98eNKi31
QcMhMmiH/+T4jui8PH81ibkJXrWpCIpxq4hFiBERCF4kbxJtBmKFIcEaTln0AZiO
Esoc+S3nFAUeD10rmjSsXCMu3csUQQmZRcgf3j3ywbnDlMQ7DkJbxHjX9WA9ZmKN
TNObHrrSr6nAYxtrKXkvxHMotO+i4vkPjefUQ6v4ZubEE7q0HerBuiYhl18EwcdQ
VcHDxZbSWMEAt/R/JI4IpTiKixtoEaQl33feV2irfsVMz4/iUKSqkA/SNpMQkAmt
N7H/ORAkwtDVE2g8W0yUVnANKMsQYV3OGRjH5aozWNCOPEgyR7rvGXrRx5cGRDNM
LXuac95+077pqtWFK1IJqVju280/OJWkPn6GJvmspa+5kZ2rCOjjjnIGMeOk+SgF
cHD8N7YXAZK5PYHykGv1/z1g2eXDlP8snqBOwHJKM8cCoYHC4ecW81R5enWvQApd
JTjMT+Hj1I9Uw/cEwSPd2uoZWGu8xJ+EzZrKG8qHnR1c5YQL9KJ3dZV2muqZDaPG
2rIrcgElgw==
=epyK
-----END PGP SIGNATURE-----
