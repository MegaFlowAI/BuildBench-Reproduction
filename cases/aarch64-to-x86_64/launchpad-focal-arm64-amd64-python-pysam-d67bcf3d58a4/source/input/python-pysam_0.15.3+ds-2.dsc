-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: python-pysam
Binary: python-pysam, python3-pysam, python-pysam-tests
Architecture: any all
Version: 0.15.3+ds-2
Maintainer: Debian Med Packaging Team <debian-med-packaging@lists.alioth.debian.org>
Uploaders: Charles Plessy <plessy@debian.org>, Andreas Tille <tille@debian.org>
Homepage: https://pysam.readthedocs.org/en/latest
Standards-Version: 4.4.0
Vcs-Browser: https://salsa.debian.org/med-team/python-pysam
Vcs-Git: https://salsa.debian.org/med-team/python-pysam.git
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: @builddeps@
Build-Depends: debhelper-compat (= 12), dh-exec, dh-python, libhts-dev (>= 1.9), zlib1g-dev, python-all-dev, python-setuptools, cython (>= 0.23), python3-all-dev, python3-setuptools, cython3 (>= 0.23), tabix <!nocheck>, samtools (>= 1.9) <!nocheck>, bcftools (>= 1.9) <!nocheck>, python-pytest <!nocheck>, python3-pytest <!nocheck>
Package-List:
 python-pysam deb python optional arch=any
 python-pysam-tests deb python optional arch=all
 python3-pysam deb python optional arch=any
Checksums-Sha1:
 f94f259969052b8954c86b0eca709cb5947ca36d 1364456 python-pysam_0.15.3+ds.orig.tar.xz
 5b6f15cd2c2a7afb44308654bff71b76afbfa097 373252 python-pysam_0.15.3+ds-2.debian.tar.xz
Checksums-Sha256:
 0968a90e5b1d5418d21f94cdb6f43cd9f496f04fdfeefc8bf5b50aae8e2b950d 1364456 python-pysam_0.15.3+ds.orig.tar.xz
 893bb5c3f3b10e389e605def891d334bc9f524ac08712336dbad82e593e5b5b0 373252 python-pysam_0.15.3+ds-2.debian.tar.xz
Files:
 7c118934f275b79a61c36a05333cfd08 1364456 python-pysam_0.15.3+ds.orig.tar.xz
 543072417d577a509a51a98dd2c646c3 373252 python-pysam_0.15.3+ds-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEck1gkzcRPHEFUNdHPCZ2P2xn5uIFAl4RD5gACgkQPCZ2P2xn
5uKzEg/7BRa/qptpNcxXGohR9RufoEBJq9PusdHIVSEtkjkhB9yJwZEOomjz4Bny
hmSLvqK0aI65VbC7BYyynr27MrsUs98I51WX3jw8UbcgMMTuBs/CVXFIvncqOkz3
QYskvDIEYI0vrAquRvwkeX901GISJRaGsYHgQOkyxCPmMjDjg7PxlSOWZThTNQZQ
4h+P50FLzdDAiGqd4djR1AlT9LKimWdNOEk/LsC+utMnmPdf9xZOLuD1uYpn8UUO
3kQ2hR5scHNQpz2dSGu0u0XNKfDNf6g4cXTHW9sj5DimMApPcDRPcwcpexsxrNsW
XXq1mfuZBKeYBsgVmf9YsIRZYU4rSczXOLrF3Zqv+YhihdtJ5O0KDb7t7LOlGRaU
GxYPFLrgw57s3oNmCoJz+wNEALlmyuRKS6nbLMMpvQwBRJSHwkDGvX1DT3J8/pwr
YjEgEpCJeXg9ImBzYJ24D6AEw6z0DZHHxzCwUdsYTEqyokfxKj0sj4HExWZ9kja/
UVkLThxOwiundjBS3BWe6X0a/B0K4P+bgirIUP0JL1FtsPyvfjd7vUp+w1sdSkRq
IBmBz0U63XSTIux5+rEwPu/gjxz38dpXfuZ6frLW0XBc0l6cvXSubq60vSplCpKf
M+PwB4vFQkMdY/jpiGODQnsXlAgrDADbdd3EKaTcE3p3p4xP6Fc=
=YMRd
-----END PGP SIGNATURE-----
