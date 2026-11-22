-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: xsimd
Binary: libxsimd-dev, libxsimd-doc
Architecture: any all
Version: 14.0.0-2ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Julien Lamy <lamy@unistra.fr>
Homepage: https://github.com/xtensor-stack/xsimd
Standards-Version: 4.7.3
Vcs-Browser: https://salsa.debian.org/science-team/xsimd
Vcs-Git: https://salsa.debian.org/science-team/xsimd.git
Testsuite: autopkgtest
Testsuite-Triggers: clang, cmake, doctest-dev, g++, xtl-dev
Build-Depends: debhelper-compat (= 13), cmake, xtl-dev (>= 0.8.0~), python3-breathe <!nodoc>, python3-sphinx <!nodoc>, python3-sphinx-rtd-theme <!nodoc>, doctest-dev <!nocheck>
Package-List:
 libxsimd-dev deb libdevel optional arch=any
 libxsimd-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 5a228b4542afbfd9e3eedfcf93fcb3b086e9291a 306182 xsimd_14.0.0.orig.tar.gz
 210938f107b2d2d959cf5b8de89dffe99de59292 7528 xsimd_14.0.0-2ubuntu1.debian.tar.xz
Checksums-Sha256:
 17de0236954955c10c09d6938d4c5f3a3b92d31be5dadd1d5d09fc1b15490dce 306182 xsimd_14.0.0.orig.tar.gz
 60f766ff22790c399741247c61503e8bfb5520fdf75bd1ce25717ce5b41aa057 7528 xsimd_14.0.0-2ubuntu1.debian.tar.xz
Files:
 75c0d34cf7011924ba19978076c76dc1 306182 xsimd_14.0.0.orig.tar.gz
 4374bb740cda55f8745e1d90b27b01f8 7528 xsimd_14.0.0-2ubuntu1.debian.tar.xz
Original-Maintainer: Debian Science Maintainers <debian-science-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkpeKbhleSSGCX3/w808JdE6fXdkFAmmOP/cACgkQ808JdE6f
Xdn6aA/+I7rKu/vgNj5A+0EHXW7r+y1orWxGt8mvmgr2hE34Ei53Bt75lmEmYjQC
Hlxq9SaB/7r3qUWCo1eFgqrqQSNZOFVwKh5g386TJKYNdTwjNNYdNe4Nmcywt0/n
+zsLEk4rn5G7xjZInZBLyLWEAFqC/9YdukLU5+ZBb+ZRi6Fwk/qpGpGHcLn2m3gt
ggseHMq2LxKMKJcXpb4b+urLfG66CHU354Yo9/9ZD8aFhHJFJAkKnI3VdiAg0a9o
rnv1eEXMQo6dYgTXioom8UvL0+KJgSHBdNK9yf8tVFYrDCtFatZccS4dpfbAITpW
9tgCaKU8Gp66VpqAX8OCHqO+pYuobBgwEohP9rLIXeKbDXxeB2Iu6UoKqhXKbIJz
PnlfTk6wjdPL7sw6aUB+16RGSvLNeO2G2AXa1ahsXqXvLQrsHl36aGB8n+/lxpaf
WuV8egpPN5lsKaCB76Y01psVjEh0J0YKvo3lCLeP5VvPweH6UiNHQCmfEqUMolqt
OZvqLfHj2rebfsDzHc/sDKnozafZqplTDy8I4iE4GPpKAHcA00raxZnXAb2GNfDN
EEM6BlmA77E/81etXhuOYiORU2U7KeXvCLC4WC+hs6qqvIPhF6jBr3YKsWVUwBwP
Tk2oX11iqOASIyBXS7QqjMqnVkJ+BS9om0rA672VWHVLkkuZKSk=
=+CdJ
-----END PGP SIGNATURE-----
