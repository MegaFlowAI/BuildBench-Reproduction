-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: cysignals
Binary: python3-cysignals-pari, python3-cysignals-bare, cysignals-tools, python-cysignals-doc
Architecture: any all
Version: 1.10.2+ds-3build1
Maintainer: Jerome Benoit <calculus@rezozer.net>
Uploaders: Debian Python Modules Team <python-modules-team@lists.alioth.debian.org>
Homepage: https://github.com/sagemath/cysignals
Standards-Version: 4.4.1
Vcs-Browser: https://salsa.debian.org/python-team/modules/cysignals
Vcs-Git: https://salsa.debian.org/python-team/modules/cysignals.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, cython3, libpari-dev, libpython3-dev, python3-setuptools
Build-Depends: debhelper-compat (= 12), help2man, dh-python, python3-setuptools, python3-all, python3-distutils, python3-sphinx, libpython3-all-dev, cython3 (>= 0.28), libpari-dev (>= 2.9), gdb
Build-Depends-Indep: python3-docutils, latexmk, texlive-latex-base, texlive-latex-recommended, texlive-fonts-recommended, texlive-plain-generic, texlive-latex-extra
Package-List:
 cysignals-tools deb devel optional arch=all
 python-cysignals-doc deb doc optional arch=all
 python3-cysignals-bare deb python optional arch=any
 python3-cysignals-pari deb python optional arch=any
Checksums-Sha1:
 6389a21ae306cc4c153918cd3569272723b184f9 49384 cysignals_1.10.2+ds.orig.tar.xz
 59d4f1b2560a5296d53a13e15b390a3c7f7ad197 12744 cysignals_1.10.2+ds-3build1.debian.tar.xz
Checksums-Sha256:
 03229e96a7fe4631ca730be6421fd0b1ca148c135d222ef800ad8cdce0a631e8 49384 cysignals_1.10.2+ds.orig.tar.xz
 c9ed92058ef02e18d30f23a14d878280aeed1e77b83e2e1732bde90c178a40f0 12744 cysignals_1.10.2+ds-3build1.debian.tar.xz
Files:
 54749c1dd4337b994444db024da2fd02 49384 cysignals_1.10.2+ds.orig.tar.xz
 30347c10cf4c0dfe80627cdf0e123c32 12744 cysignals_1.10.2+ds-3build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAl5LrxcQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9TEZEACkOHfULJKjZtI5TFpkiPNn7ju0BMeIcXx8
nwIkqyCQMFCVc23WN+77r7mU/K6giQ/O4i/bAU/3EEyconRBZWebvAH7xAQnKvDL
SQcjaNoVPPP03JCMuOYpjdLfAATu5tQ43JeZ+s9x+t/ZC0yhgrDtTivU1pNjooS0
IBTNJ2t4fTPMvWHrh3Kd5V3N1o12zMZ+QBAAg1ONspBwZFNOMg+dwt+9AZRnGydg
d0TZ6nYErFx6j7hkfUDV3d29WGfbzbbefT1hEFNombiFmENSz1Q9476gBe871NMK
Jz7cL+sIvhn8oxpd5wjsjXeqNMqlJmyprl+4iJbT5Sa1erK1J+e1OHW0NIRuwqjq
HasDrhTOJ2+91GIxdCfkrz94J3pRGFaWhVQ2Wd1qukzpyjv5tv9uWQXgab7B2N0o
fR3/Q/Hn2Oj+PWhFa33UQ6+2Bd/1e2QP0UkETdQq1Q8nUQYlG1cKs23sYlnKz4ss
f79Y0Y6J8bIKJ/JA5u2tRT3ztIq1mERuAKaPvPaJsD/R5esKyISJFw4lh2wqQWtZ
DUMs0V4vpKHaZqfoT+4t1Svc6h0EEmIlNq+rtm88ewSxYP/ITwpozhHeHs3Jfagu
kVXC3t4g1bYxIp9PFZGIWNbdYOEsrGe+LA/0oN4rsuBIUCFQxH1/doJ0evrIJ2R5
R/xrMoKQ+Q==
=dZkY
-----END PGP SIGNATURE-----
