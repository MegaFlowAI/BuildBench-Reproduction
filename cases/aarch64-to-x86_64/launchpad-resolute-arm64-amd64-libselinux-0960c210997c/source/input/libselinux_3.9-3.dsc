-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libselinux
Binary: selinux-utils, libselinux1, libselinux-dev, libselinux1-udeb, ruby-selinux, python3-selinux
Architecture: linux-any
Version: 3.9-3
Maintainer: Debian SELinux maintainers <selinux-devel@lists.alioth.debian.org>
Uploaders: Laurent Bigonville <bigon@debian.org>, Russell Coker <russell@coker.com.au>, Christian Göttsche <cgzones@googlemail.com>
Homepage: https://github.com/SELinuxProject
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/selinux-team/libselinux
Vcs-Git: https://salsa.debian.org/selinux-team/libselinux.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config, python3-all
Build-Depends: debhelper-compat (= 13), dh-sequence-builtusing, dh-sequence-python3 <!nopython>, dh-sequence-ruby <!noruby>, file, libsepol-dev (>= 3.9), libpcre2-dev, libpython3-all-dev <!nopython>, pkgconf, python3-all-dev:any <!nopython>, python3-pip <!nopython>, python3-setuptools <!nopython>, swig <!nopython> <!noruby>
Package-List:
 libselinux-dev deb libdevel optional arch=linux-any
 libselinux1 deb libs optional arch=linux-any
 libselinux1-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 python3-selinux deb python optional arch=linux-any profile=!nopython
 ruby-selinux deb ruby optional arch=linux-any profile=!noruby
 selinux-utils deb admin optional arch=linux-any
Checksums-Sha1:
 7dc10c4b3f2d83a15d0da3ba5955a80c8f9875ff 205334 libselinux_3.9.orig.tar.gz
 c6efed2b8879139ce2951484bc0e42a11523c897 37792 libselinux_3.9-3.debian.tar.xz
Checksums-Sha256:
 e7ee2c01dba64a0c35c9d7c9c0e06209d8186b325b0638a0d83f915cc3c101e8 205334 libselinux_3.9.orig.tar.gz
 9a9f12e171cdc34a7e92302933b01a7d1faf7e5d16d6634b5490e2d2bae254e1 37792 libselinux_3.9-3.debian.tar.xz
Files:
 4838497a9334a8c2b12714dd63db650b 205334 libselinux_3.9.orig.tar.gz
 f33aaa986053439e76c7786f2cb51939 37792 libselinux_3.9-3.debian.tar.xz
Ruby-Versions: all

-----BEGIN PGP SIGNATURE-----

iQHEBAEBCgAuFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmkhsREQHGJhZ2VAZGVi
aWFuLm9yZwAKCRAfXHqLRVZDFJ8qC/0fQwoOvFKTl0WtBJHRpRVNTFGqREGwMom5
+tlgIpE3JkRMLuEqfd1jz5B8HLwvkHIwu6U5RBFGFtaeknV5aa2fWwdo1bg8A2st
LIm3xWV/+ygPrWly6+kt4WMKxy+a1BBpc9HY4GJ2J0VAM0ZZWl5TloNa0KmS7ELY
Z2FVkijCAXu3/OyiID5g4cJMldTLwRMo3RU6enwVtht9BRz6v18qsA63TgtUv79z
RT5g+4CctTLkTUqmWufQPUBqJZVR01rQ9+8+1ZEypnb/vwU/m3yUqwY8gjmvY9gB
cg6ysXi+eP6szSmxMe0fY19yZ+tGxqNnsNHUq80Xg2G+wYdsQP11kSSUjhB7HjlN
FSJ7RV905hLpSyrI+uQENQYSyCKSIm6ke/Aaq215TBwW+TP1evzg/8vEUOE8K23t
ZCyezVkmwDmz/X5pXWuO8dvFlzBtH1EtTBFYTj+47yu2CGbTlQ/a+RU/lrBMmzeH
PYIAF0EGSiKdHDvcEcuGMMHADHDPm68=
=jHiU
-----END PGP SIGNATURE-----
