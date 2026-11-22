-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libgpuarray
Binary: libgpuarray3, libgpuarray-dev, libgpuarray-doc, python3-pygpu, python3-pygpu-dbg
Architecture: any all
Version: 0.7.6-6
Maintainer: Debian Science Maintainers <debian-science-maintainers@lists.alioth.debian.org>
Uploaders: Ghislain Antony Vaillant <ghisvail@gmail.com>, Rebecca N. Palmer <rebecca_palmer@zoho.com>
Homepage: https://github.com/Theano/libgpuarray
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/science-team/libgpuarray
Vcs-Git: https://salsa.debian.org/science-team/libgpuarray.git
Testsuite: autopkgtest
Testsuite-Triggers: libclblas-dev, libclblast-dev, mpi-default-bin, ocl-icd-opencl-dev, pocl-opencl-icd, python3-all, python3-all-dbg, python3-mpi4py, python3-nose, python3-scipy
Build-Depends: cmake, cython3 (>= 0.25), cython3-dbg, debhelper-compat (= 13), dpkg-dev (>= 1.17.14), dh-python, python3-all-dbg, python3-all-dev, python3-numpy, python3-numpy-dbg, python3-setuptools, sphinx-common, python3-mako
Build-Depends-Indep: python3-breathe <!nodoc>, python3-sphinx <!nodoc>, python3-sphinx-rtd-theme <!nodoc>
Package-List:
 libgpuarray-dev deb libdevel optional arch=any
 libgpuarray-doc deb doc optional arch=all profile=!nodoc
 libgpuarray3 deb libs optional arch=any
 python3-pygpu deb python optional arch=any
 python3-pygpu-dbg deb debug optional arch=any
Checksums-Sha1:
 c5ccbb29d2edf9770d22e6dc7fd7e8383694b3a8 293770 libgpuarray_0.7.6.orig.tar.gz
 b69b10d334c939193daf555aa026434ff49aad0d 14432 libgpuarray_0.7.6-6.debian.tar.xz
Checksums-Sha256:
 ad1c00dd47c3d36ee1708e5167377edbfcdb7226e837ef9c68b841afbb4a4f6a 293770 libgpuarray_0.7.6.orig.tar.gz
 89e673d4307646c607e116f91a08aed7fc5262e37a55d446868d0cac44ee13fb 14432 libgpuarray_0.7.6-6.debian.tar.xz
Files:
 d8e0ec6a2ad3bf2eba915dc7efff467e 293770 libgpuarray_0.7.6.orig.tar.gz
 8721ffb0711ddb727fd4ad20ed6267cd 14432 libgpuarray_0.7.6-6.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJMBAEBCgA2FiEEZ8sxEAXE7b4yF1MI3uUNDVZ+omYFAmEr/ZAYHHJlYmVjY2Ff
cGFsbWVyQHpvaG8uY29tAAoJEN7lDQ1WfqJmtIkP/2aK16NDzQcsp1GUY4l9Fg6e
3j4CngzLWKxHabre5kI8vpWBUVB2WlMo5+MEudiD0+vD/WZBfAgtwXO7rn/8KMXh
tIdCizR/LcLA+kHB1B7jBdRqI+O44V33xFTs/j+gIY601IIMJwwz6ys7BMK1iUr4
QmskU1t+CECWoVsbwLytXktXTaEMCIZvAH+QdfjDtegAfeRNfjjD9D2VjsQUPu6D
ohQQg5G8x729Xlq7vEDhbhn/n+d7aBY6RYUsHfmB3JKjhzfmN15MpHk60+tgb3Mr
zzbeMkrx7DC0gWo8DYUCWOyjj9VsxA0q1H/Bl85Ik+k1+GvsrueIZey2CDg8u4kc
SvsFuuxMOcPWJbiIMd+OQ0wXgGOSsKTt6lN1kZyM/LGCN7lYdrDIxPZqF4Y/t+q9
VTLQfms/2A7Nv9xaTTDIm/D7WOAIQPOrnZWf0nIJVqj9x7YL6iUasvAQA1Csk8Wj
vzP0sn+jeiSuw4C0OjK48sw8B6moa46JtU8DGZBpGRP6w0Ldy/iXbrC+b9nDrEcW
nW8+UCAVeHbKfxMMh5R7PZpBVJC+304AljdvczfOr6/KDg3oKANq/lLreIIgpidX
cvt+/nzb+Zq0VsT0iB+dUym1Eb7eeCevVg/JVNqRwatKg3c/3oSwal83RcC5PbzS
aJVbijXS+lO7S+BPQ9/R
=vNch
-----END PGP SIGNATURE-----
