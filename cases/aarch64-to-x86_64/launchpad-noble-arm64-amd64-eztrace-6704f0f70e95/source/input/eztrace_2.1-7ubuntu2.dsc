-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: eztrace
Binary: eztrace, libeztrace-dev, libeztrace0
Architecture: any
Version: 2.1-7ubuntu2
Maintainer: Samuel Thibault <sthibault@debian.org>
Homepage: https://eztrace.gitlab.io/eztrace/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/eztrace
Vcs-Git: https://salsa.debian.org/debian/eztrace.git
Testsuite: autopkgtest
Testsuite-Triggers: bc, build-essential, clang, gawk, libmpich-dev, libomp-dev, libopenmpi-dev, libpomp2-dev, libstarpu-dev, mpich, openmpi-bin, otf2-tools, pkg-config
Build-Depends: debhelper-compat (= 12), pkg-config, cmake, bc, gawk, gfortran, libiberty-dev, binutils-dev (>= 2.29~), zlib1g-dev, libotf2-trace-dev, otf2-tools, opari2, libpomp2-dev, clang [amd64 arm64 i386 ppc64el riscv64], libomp-dev [amd64 arm64 i386 ppc64el riscv64], libstarpu-dev (>= 1.3~), libstarpu-dev (>= 1.4.1+dfsg-7) | libstarpu-dev (<< 1.4~), libnetcdf-dev, libpnetcdf-dev [amd64 arm64 mips64el ppc64el s390x alpha ia64 sparc64 kfreebsd-amd64 ppc64 riscv64], libpapi-dev [amd64 arm64 armel armhf i386 powerpc ppc64el mips64el ppc64 x32], libmpich-dev, mpi-default-dev, mpi-default-bin
Build-Conflicts: libeztrace0
Package-List:
 eztrace deb devel optional arch=any
 libeztrace-dev deb libdevel optional arch=any
 libeztrace0 deb libs optional arch=any
Checksums-Sha1:
 4ef5bdd6db07d9c7506e22f0c98ebf8305159779 512944 eztrace_2.1.orig.tar.gz
 69dc5547c7bc025850455b8bdf00e4ce5c8fc6f6 14416 eztrace_2.1-7ubuntu2.debian.tar.xz
Checksums-Sha256:
 b5a2966b4ec739ec17ce8f45d880974f87ae04f15fde1f16bde2762aef0b680b 512944 eztrace_2.1.orig.tar.gz
 e54769ca59e8d6b97c52fb462ad7deade43b118ffae29384982829f87c3db5ff 14416 eztrace_2.1-7ubuntu2.debian.tar.xz
Files:
 77514273f4b0e3e66e050ebe2a304865 512944 eztrace_2.1.orig.tar.gz
 b7fb7ca06e1fe8819417aad403f61c6f 14416 eztrace_2.1-7ubuntu2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEVovyKmYzfL/Jprm3LIPbyOm9DjcFAmX8vn0ACgkQLIPbyOm9
DjeM5A/6A+31P3+0Y87b/adSvaOBMSaKwthEyrWFhf5X64iY4qFrBCRLf1imapHS
d06sygaUIG47XXd2A8BqSNsM9o/Jlh7p1r5B3/kdT68p3kU279tO/FJpD1o7yonk
RWGNzBpatsJMTmTPes03VInNXOkivvZVwsH8FVDyGoqagv9z+S8hZ51dmgxkAVP1
LVtMm6WU1Vv+0aj9Z46Vp7aBsSiIpvHq1J8gJiJhYMOO4qkmkjXrEit8G+eD6om5
gcizcjjgiu7PTIFv8FtA2Jd443evmEde9/WMOiiFLJ1TzjHpU/0z+nzPpdyJyVDX
2Ff4SGSZ8GbqM949tLy1LoI9K6ySIQg2y1OhcOPcweJbEguRafbLfLczsoEKMvFo
I7Gljgv1UnvSP12vUPCPdX2U6f3EAFYMi54R768bh+ybs0nCmB213e+jX6zyUZSp
TBqbTtecQKUmWsbwwxLinDH5EHMcNC5XP290ylJsH6yw/s7kKz7NUrRwsh9ZSiQK
9SqY/rj4mQHlY6UpOArFGCTenM+G+ZwsbMbTQ/nmPmvI1IyOaUwsThGNU6IbH2sx
4h49IPpdaHi26dTVGooKv9+6i7s2ysKyuNzxJeXiKRM3AI/0EdmJGuf23xPNlOkA
ua25FKdJ4uXKiu0oqWAWonjexdXrEagyM33b871AZzTWNV5PzIU=
=e/J9
-----END PGP SIGNATURE-----
