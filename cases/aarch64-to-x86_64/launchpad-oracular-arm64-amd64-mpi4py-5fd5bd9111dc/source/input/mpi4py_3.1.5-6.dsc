-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: mpi4py
Binary: python3-mpi4py, python-mpi4py-doc
Architecture: any all
Version: 3.1.5-6
Maintainer: Debian Science Maintainers <debian-science-maintainers@lists.alioth.debian.org>
Uploaders: Drew Parsons <dparsons@debian.org>, Yaroslav Halchenko <debian@onerussian.com>, Michael Hanke <michael.hanke@gmail.com>,
Homepage: https://github.com/mpi4py/mpi4py
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/science-team/mpi4py
Vcs-Git: https://salsa.debian.org/science-team/mpi4py.git
Testsuite: autopkgtest
Testsuite-Triggers: libpmix-dev, libucx-dev, python3-cffi, python3-dill, python3-numpy, python3-setuptools, python3-simplejson, python3-yaml
Build-Depends: debhelper-compat (= 13), dh-sequence-python3, mpi-default-dev, mpi-default-bin, openssh-client, cython3-legacy, python3-all-dev, python3-numpy, python3-sphinx, python3-setuptools
Build-Depends-Indep: texinfo, texlive, latexmk, tex-gyre, texlive-latex-extra, python3-doc
Package-List:
 python-mpi4py-doc deb doc optional arch=all
 python3-mpi4py deb python optional arch=any
Checksums-Sha1:
 5a6f213bc2ff06fba6470e7171b0dedb82285056 371181 mpi4py_3.1.5.orig.tar.gz
 a093e9e2342dc0d7a9f968354c6f816324cc34bb 13356 mpi4py_3.1.5-6.debian.tar.xz
Checksums-Sha256:
 29cc7ad701c190ef37622e4a2b2e2dab94fbc7777b1a15fa2029097c41b6edf0 371181 mpi4py_3.1.5.orig.tar.gz
 f95bf7f585c3dad8b3726aebe5a320b3c16d5befa3ec9e539cf1e706952b5ec2 13356 mpi4py_3.1.5-6.debian.tar.xz
Files:
 c3b456711b6e01c081d2745a17d66dfc 371181 mpi4py_3.1.5.orig.tar.gz
 718e80483b840b03c36353e7c7d95a68 13356 mpi4py_3.1.5-6.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEI8mpPlhYGekSbQo2Vz7x5L1aAfoFAmY5TH8ACgkQVz7x5L1a
AfqbhxAAtMDF6bMVFeGl0kduYiBWwnfLZXpXOGc//775Hz7l4e0VTiozUJLCn1wB
aEQqjn9rzU0uNc7AEsM5Z/D5bY405SkT+5yrJ2nMvw8DgGEYcUSxpWpAb/TBm+zz
6jzOM7LJmsRrQRDRPNSFJ7ldcDvR5xCpVC7228BLSRJ77kvY+IuN6toCJy/yGS/R
5dlwZSj5J7850amiQNl2xkGZpFgWstYoaPvKr1sdxiK2AwGpvthq5KT/3BdfyLqQ
qKe6YNYV21oTtQtZ4OZcK5BmgV+mrPE+yQuIuqeBLVxtz3Ep0vM8wD17nv/OTKfI
8kETHqpl/8JXvQ3y+FFBttKzyvyN1cKfOk7BuuPlp7PBwx6bhQR2Et4fjd6vDaHO
irSrTuZ6N21hRV4W+X5TtLIEi3RusGg4ofNEXd798FQJ9+hmwjjp6HVydsJPqKGD
Wrp05aWOiO7h6R01qDAgj2G/f/Mm5etrjRLekxdbX6cKPn08ulfMCgmrnC9MO2ee
KNijaKbVnUUzErbkLToi23g1pErb2gOD/pI82uCNLlcjwiQCwNGtNXDsQ+JPu/rK
soJI4yU/R9Ts0RVqYV+okQqxS130L2LSwCcCPwn/cziZE/CVYYSKWrYcOVVnhmat
JTjG2UNg9HQgLB8AgVMxq3MTE5M5w+94AoMzvUw5jZme0CxLDUE=
=f9Y6
-----END PGP SIGNATURE-----
