-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gloo-cuda
Binary: libgloo-cuda-dev, libgloo-cuda-0
Architecture: any
Version: 0.0~git20230117.1090929-2
Maintainer: Debian Deep Learning Team <debian-ai@lists.debian.org>
Uploaders: Mo Zhou <lumin@debian.org>
Homepage: https://github.com/facebookincubator/gloo
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/deeplearning-team/gloo
Vcs-Git: https://salsa.debian.org/deeplearning-team/gloo.git
Testsuite: autopkgtest
Testsuite-Triggers: g++
Build-Depends: cmake, debhelper-compat (= 13), libgtest-dev, libhiredis-dev, libibverbs-dev, mpi-default-dev, nvidia-cuda-toolkit-gcc, libnccl-dev
Package-List:
 libgloo-cuda-0 deb contrib/libs optional arch=any
 libgloo-cuda-dev deb contrib/libdevel optional arch=any
Checksums-Sha1:
 1646d21c6a7e4cedfde3b3e77d68cfbe57d6a3bb 181624 gloo-cuda_0.0~git20230117.1090929.orig.tar.xz
 5f8e4224268ae38e86eea7ac612b2d6d6115d4ef 5036 gloo-cuda_0.0~git20230117.1090929-2.debian.tar.xz
Checksums-Sha256:
 14a13dceaa15428df98d04294dff8c6b2cce7c02a852962bb2feb3b1f2674b02 181624 gloo-cuda_0.0~git20230117.1090929.orig.tar.xz
 a9d86c563c3a0efe5f567a4c96a7907f9a60ea78474b76a9645c86d0c9af704a 5036 gloo-cuda_0.0~git20230117.1090929-2.debian.tar.xz
Files:
 1e315c15116a751008ddeea97f89fdfb 181624 gloo-cuda_0.0~git20230117.1090929.orig.tar.xz
 9664302bd369e5419e4b533fad0a1694 5036 gloo-cuda_0.0~git20230117.1090929-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCgAvFiEEY4vHXsHlxYkGfjXeYmRes19oaooFAmTuW/4RHGx1bWluQGRl
Ymlhbi5vcmcACgkQYmRes19oaopzIBAAjX3nFmEqCK1Tvi5X/ExFfXDDRqTUfDuA
Gji3og200h6UF2ln+AWuq87hPDuhokM+gsXhMjTfua/hFtbcP7xEjrv2IBTGu6mc
T34UUg6dCgRtPoWWXRFltabK/SCrbLP2+siz5OSw8JTQR7DjSIKZsRARXWH/hfRr
46I2TRJzLvSBez7z3BnBZAgk1pByNgWxKIC6vHIwca+xA4Zm8qFHJC4q/skUvl/f
5PRbddzopenwD9WYVxMDe0Ra6zBzCbmcSS66toWH9ArkbcNMmbGvcEhYf2OdS4pC
vFrLPFRCiZc8dUXRHCjIwmJ9oxRUb+/Sc6YUfGIxcLWve0eFAtxnLzWW54RtmhRI
Uryk4et/fi5QcHPzzDywKQKddWWWRaYpXCXOgDXp7hypFgc+PLkllg360yYVIukH
qtvveYDsTKBztbCN/Yg49LNCHNEm40034w27o7XYoSMKQatlCh3oBX6cM94HXCp6
VX9LTgfc4fmW8GuCIBXjD7uhYbOTKKL6ayy3nxYJytC/eVUSkJ81PQJfc9CxzIqY
2Zn6q4cFDMWLzSY9sHGZdEz4usuyXwA0T+v7p1GpkSEk9XrKHP7b9x7C+XIUxTyO
gcIXswHf2cEDCq1gb0NmfBNl8VPJfviklEbrtoyDegy5+p8VVfkIq67ImUiHT439
NVHPP8LgZiA=
=GMCH
-----END PGP SIGNATURE-----
