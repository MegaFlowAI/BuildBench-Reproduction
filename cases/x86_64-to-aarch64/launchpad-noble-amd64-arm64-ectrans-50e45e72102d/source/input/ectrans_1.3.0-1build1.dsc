-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: ectrans
Binary: libectrans-0, ectrans-utils, libectrans-dev
Architecture: any
Version: 1.3.0-1build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://github.com/ecmwf-ifs/trans
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org:/science-team/ectrans.git
Vcs-Git: https://salsa.debian.org:/science-team/ectrans.git -b debian/latest
Build-Depends: debhelper-compat (= 13), architecture-is-64-bit, dh-buildinfo, dh-fortran-mod (>= 0.34), ecbuild (>= 3.3.2), chrpath, libopenblas-dev [!ia64 !alpha !hurd-amd64], libblas-dev [!amd64 !arm64 !mips64el !ppc64el !s390x !ppc64], liblapack-dev [!amd64 !arm64 !mips64el !ppc64el !s390x !ppc64], mpi-default-dev, libfftw3-dev, libopenmpi-dev, libfiat-dev, fiat-utils
Package-List:
 ectrans-utils deb science optional arch=any
 libectrans-0 deb libs optional arch=any
 libectrans-dev deb libdevel optional arch=any
Checksums-Sha1:
 1d202aea67f77693d7912669d0f7827155eaf18f 229700 ectrans_1.3.0.orig.tar.xz
 6b53664deaa39051a9cbca0d19cf5272ed00f6bd 4520 ectrans_1.3.0-1build1.debian.tar.xz
Checksums-Sha256:
 fc80eb5f4dadfb3f40cd37a90a8856e956e06f3bf5681867f153e8512ca22d95 229700 ectrans_1.3.0.orig.tar.xz
 4e08c7915e966d7a56933139e48872a71c2790fb957a121cff65289dbc0e258c 4520 ectrans_1.3.0-1build1.debian.tar.xz
Files:
 653038fdab8216a0cf0a7c3d0099588a 229700 ectrans_1.3.0.orig.tar.xz
 1a0b042fc4be21e09020f1fa22c48aee 4520 ectrans_1.3.0-1build1.debian.tar.xz
Original-Maintainer: Alastair McKinstry <mckinstry@debian.org>

-----BEGIN PGP SIGNATURE-----

iQJOBAEBCgA4FiEErEg/aN5yj0PyIC/KVo0w8yGyEz0FAmYJpyQaHHN0ZXZlLmxh
bmdhc2VrQHVidW50dS5jb20ACgkQVo0w8yGyEz3c/g/+OBcyZYno/BgKP7JO9KH4
rt25hitVWtJVaM19Mc9wonchqja/NmK9I92cL4S0HzC1ZNDQHo94AST6w2lo489e
dkkIoz8KdBS4RqEx18bJlGa6PkfQU+p4uR5e5UnUrEd7N8HgQjQPeRX/4Si1m1AD
siZUnT4lBR2z42CZm3uaWe5/RnjF/vslRXJza0vIrfIUMQpLIrA/gU+jTTCb13y0
j3zAeUrXcLLobTvYH/2KWM4XuaReOzLcI9l13qRRlpBAThksLwub9tOh9KF4hApD
DVZASDe3wU9JgBfJDXj6dVyF4XFefZr3H5iH1/mSsXb0mGPobgiFEfEc6srPie1f
/ogW4caWiWDzk0UM9naijnz8eSUF49KItM4cb7jlPKDnAQwIUT3Rr/pUBNCP4jXX
ajtC5aPx2kNaQZROl2iMCKiSFjn4U1IwHx2EscwdB/GyO6IERC91B0PxzxR8eMzp
kQjL+3BGHLBY8EGSjss507PAkQgBMEWyPK387z3L7dvAw2tvGNQOYggmaot+xkmr
/hajl9RmvTFUDjFb5OVxan5zBFhQAiQWdqYbZP3xa3RTjQvag4xar1zGefTNyWrG
60RfXRQ8144m5BDsEblkFc0RJd0SoR5Pd7lEFfj9pdGBRbZQhDKOvxXhpbh7KI+W
kbK7HuYRNw2Pe42bkIWgcY8=
=4GNx
-----END PGP SIGNATURE-----
