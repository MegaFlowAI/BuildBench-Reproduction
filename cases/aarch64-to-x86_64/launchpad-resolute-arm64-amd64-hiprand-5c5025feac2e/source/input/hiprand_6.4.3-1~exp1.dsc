-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: hiprand
Binary: libhiprand1, libhiprand-dev, libhiprand1-tests, libhiprand-doc
Architecture: amd64 arm64 ppc64el all
Version: 6.4.3-1~exp1
Maintainer: Debian ROCm Team <debian-ai@lists.debian.org>
Uploaders: Christian Kastner <ckk@debian.org>,
Homepage: https://github.com/ROCm/hipRAND
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/rocm-team/hiprand
Vcs-Git: https://salsa.debian.org/rocm-team/hiprand.git
Testsuite: autopkgtest
Testsuite-Triggers: pkg-rocm-tools
Build-Depends: debhelper-compat (= 13), cmake, hipcc (>= 5.6.1~), libamd-comgr-dev (>= 6.0~), libamdhip64-dev (>= 5.6.1~), libhsa-runtime-dev (>= 5.7.1~), librocrand-dev (>= 6.4.1~), rocm-cmake, libgtest-dev <!nocheck>, pkg-rocm-tools (>= 0.9.0~exp3)
Build-Depends-Indep: dh-sequence-sphinxdoc <!nodoc>, python3-doxysphinx <!nodoc>, python3-rocm-docs (>= 1.20.0-1~) <!nodoc>, python3-sphinx-external-toc <!nodoc>, libjs-jquery <!nodoc>, libjs-mathjax <!nodoc>, libjs-sphinxdoc <!nodoc>, libjs-underscore <!nodoc>
Package-List:
 libhiprand-dev deb libdevel optional arch=amd64,arm64,ppc64el
 libhiprand-doc deb doc optional arch=all profile=!nodoc
 libhiprand1 deb libs optional arch=amd64,arm64,ppc64el
 libhiprand1-tests deb libdevel optional arch=amd64,arm64,ppc64el profile=!nocheck
Checksums-Sha1:
 10edee2df4090e8e0da08e8a489d8a85f5bd1543 127204 hiprand_6.4.3.orig.tar.gz
 5601314dcf0e8eed633087f6efe4985d47d807c8 6104 hiprand_6.4.3-1~exp1.debian.tar.xz
Checksums-Sha256:
 15b67f1b0dcad6319d2fa54d3330a075e74d52a650b682f44afa086cb0f526f0 127204 hiprand_6.4.3.orig.tar.gz
 821ac6d2baf1aca5b46c5a1b0f97fc1e115f4c3e13a18ecca85c2ffd88dbf734 6104 hiprand_6.4.3-1~exp1.debian.tar.xz
Files:
 7deba0fb809fb5acfdbc79cc9073b9e3 127204 hiprand_6.4.3.orig.tar.gz
 4e1e77a30011032b1b828aee21905556 6104 hiprand_6.4.3-1~exp1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEQZ9+mkfDq5UZ8bCjOZU6N95Os2sFAmiXBcgACgkQOZU6N95O
s2trRw//cmCzmG/rnSQp3hjTtSLkdJu+ohGmlC/IdzU5a++TbU5w1/VPdaVTPXmX
aBNefDy4s5x6BPvCncVsPUqt8cX4ELGYkgQKpfYqDSJOLL4orFQg51wW3kB48Eo3
SVO/QKnf4cofGb0gyXzKfo8vvKlOvD2gKABMu5IG+QeUaQRusj8TcN+4bOMrwNF1
wjThrOAatX+EAXjTBP0f5mMzh+mCWTvpWjoKenjIWUwhWQacRhEE4jRHOTrPEZen
EhceLjddMM5091TH8My9jv5ODj0SdAU/6mw+73D+DhQdBy4uGHWtJ+Yh8Kg0pPLn
JPZGJ9K5ECcnVBm0LGAtsn9mODrZD6GaBlWRwLakZ6aciKzddA38agMe4/ZktYY7
tLTrrDgVoX0RBBBdtS+aPJzc3N3S5n53nRCrcmFAV2P0vF7OovKvzzM68Maszqp5
zZelYtc4TuOqllj0RyyiJZSNcU/hTCSw/y1uLfIcYbz/wvotglKo0Dp2tRIADV+A
9TDCoAacXnSRuTCMhcQCizrEi4I5c2LFcUlXwgLZLQNy2rlwaqyp4JliShv/93kN
px9t58cdLF54uXPinRp7nMi2KBvTxwtDQhRjVgYGE3J3/mX+PnGpzc1cHA23AcMP
2w6DIZb2avTybkuSL7u+7aQ9Rmf1ygjaA+WR63hXk8POMouULZE=
=X/iv
-----END PGP SIGNATURE-----
