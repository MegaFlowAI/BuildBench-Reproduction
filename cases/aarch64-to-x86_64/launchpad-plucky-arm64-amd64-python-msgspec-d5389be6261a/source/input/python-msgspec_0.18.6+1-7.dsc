-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: python-msgspec
Binary: python-msgspec-doc, python3-msgspec
Architecture: all amd64 arm64 mips64el ppc64el riscv64 alpha hurd-amd64 loong64
Version: 0.18.6+1-7
Maintainer: Debian Python Team <team+python@tracker.debian.org>
Uploaders:  Stein Magnus Jodal <jodal@debian.org>,
Homepage: https://github.com/jcrist/msgspec
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/python-team/packages/python-msgspec
Vcs-Git: https://salsa.debian.org/python-team/packages/python-msgspec.git
Testsuite: autopkgtest, autopkgtest-pkg-pybuild
Testsuite-Triggers: python3-all, python3-pytest
Build-Depends: debhelper-compat (= 13), dh-sequence-python3, dh-sequence-sphinxdoc, libpython3-all-dev, pybuild-plugin-pyproject, python3-all, python3-pytest <!nocheck>
Build-Depends-Indep: furo <!nodoc>, python3-setuptools, python3-sphinx <!nodoc>, python3-sphinx-copybutton <!nodoc>, python3-sphinx-design <!nodoc>, python3-ipython <!nodoc>, python-attr-doc <!nodoc>, python3-doc <!nodoc>
Package-List:
 python-msgspec-doc deb doc optional arch=all
 python3-msgspec deb python optional arch=amd64,arm64,mips64el,ppc64el,riscv64,alpha,hurd-amd64,loong64
Checksums-Sha1:
 cf2f955f24e896a55aa009edb00b4ff67c72ac56 1311867 python-msgspec_0.18.6+1.orig.tar.gz
 4bc2153c08d3b16f2fb49177ac880a07e7ef7677 251508 python-msgspec_0.18.6+1-7.debian.tar.xz
Checksums-Sha256:
 5bff8c3f9303eb589516e02de4141ce31be09a0fdf4980734b020b64c120295e 1311867 python-msgspec_0.18.6+1.orig.tar.gz
 9ddcd8aeda6a7f2e9ce32230a788b0953cb9d487b3d9625855a51de727850f0f 251508 python-msgspec_0.18.6+1-7.debian.tar.xz
Files:
 a3e4d236f6cc238b2d65f82fd44c3423 1311867 python-msgspec_0.18.6+1.orig.tar.gz
 dc0bd2ff20a94443f2caff3c7bd0a9b4 251508 python-msgspec_0.18.6+1-7.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEtw38bxNP7PwBHmKqgwFgFCUdHbAFAmc3FoMACgkQgwFgFCUd
HbCRTA/+Ms2S0iMx6Po3jQB0nclLX3AdS9lC04G5+UXzactKuuEOwUtksXltgjkj
jSfeFlUKB1e4R5CdQtsnFUtV6wLKkL3b/6bRBEaHHdyq66nTv3RH1YFSk5y2wdD7
i96vbjo8CH3YG/mMIsd7lA7W7WOopFdEmzcA40YUhMNqQOXtIfcdtH6PyCsPlGds
T+KtUHkOvL5HmO63CLcBwtFdIiY6rIAXYTQq1I3itZu+zEzKzaolWtLb2UGq2dSZ
HOkQBq7Zu6wlYUcrI03gVgY/0P1kNtoH0LBYlRewfvzCvhstFyb47WktK2p6mM0m
CK/RF4UckYQ/VratAai3vgb5TZpd0huurJMvNmt/fUjRLlX0ApGZ2IeQYDInlqiq
3B9pqq7IoC6++5cTqrHtjoEb9Rhc+P5yMWJLSYEC7WhJIZ50xkZTx/EYT24zT/Ij
PPk4n3WceDWRs7hwsFVhVW2i//wXBPav8PCyxL2wnLfSlpEtHmXjrGLIVi21vJPt
lFaJ9vulRkrrukgMRDNVmhHmnS/3LfbfA+avAMrmN+H8cFYMVwxJ5jkQy8JXopym
j9rlD6Dkl0Buqq82ZInLo7SfNqZxAwxvByzEPyslI9fS0iXui183LuEEPS9/TK+S
CfloPXHT3Q6J+2BOHTBEG60SsPB/ghZLWEWF/p1pLYBpZKTiaF4=
=DhLR
-----END PGP SIGNATURE-----
