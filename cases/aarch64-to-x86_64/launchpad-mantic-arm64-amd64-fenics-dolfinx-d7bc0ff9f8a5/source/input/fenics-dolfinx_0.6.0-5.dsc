-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: fenics-dolfinx
Binary: libdolfinx-dev, libdolfinx-real-dev, libdolfinx-complex-dev, libdolfinx-real0.6, libdolfinx-complex0.6, python3-dolfinx, python3-dolfinx-real, python3-dolfinx-complex, dolfinx-doc
Architecture: any all
Version: 1:0.6.0-5
Maintainer: Debian Science Team <debian-science-maintainers@lists.alioth.debian.org>
Uploaders:  Drew Parsons <dparsons@debian.org>
Homepage: http://fenicsproject.org
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/science-team/fenics/fenics-dolfinx
Vcs-Git: https://salsa.debian.org/science-team/fenics/fenics-dolfinx.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, python3-cppimport, python3-decorator, python3-gmsh, python3-matplotlib, python3-pytest, python3-scipy
Build-Depends: cmake (>= 3.12), debhelper-compat (= 13), dh-python, gfortran, catch2, chrpath, libbasix-dev (>= 0.6.0~), python3-basix, libboost-chrono-dev, libboost-dev (>= 1.70), libboost-filesystem-dev, libboost-iostreams-dev, libboost-math-dev, libboost-mpi-dev, libboost-program-options-dev, libboost-serialization-dev, libboost-thread-dev, libboost-timer-dev, libeigen3-dev (>= 3.2.90), libhdf5-mpi-dev, libpugixml-dev, libsuitesparse-dev, libscotch-dev, libxml2-dev, mpi-default-dev, libpetsc-real-dev (>= 3.10), libpetsc-complex-dev (>= 3.10), libslepc-real-dev (>= 3.10), libslepc-complex-dev (>= 3.10), python3-setuptools, python3-petsc4py, python3-petsc4py-real, python3-petsc4py-complex, python3-slepc4py, python3-slepc4py-real, python3-slepc4py-complex, pkg-config, python3-all-dev:any (>= 3.7~), python3-cffi, python3-pkg-resources, python3-ffcx (>= 1:0.6.0~), python3-ffcx (<< 1:0.7.0), python3-ufl (>= 2022.2.0~), python3-mpi4py, python3-numpy (>= 1:1.21~), python3-pip, python3-ply, python3-pybind11 (>= 2.7.0~), python3-sphinx
Build-Depends-Indep: doxygen, graphviz, libjs-mathjax, libjs-modernizr, python3-myst-parser, python3-sphinx-rtd-theme
Package-List:
 dolfinx-doc deb doc optional arch=all
 libdolfinx-complex-dev deb libdevel optional arch=any
 libdolfinx-complex0.6 deb libs optional arch=any
 libdolfinx-dev deb libdevel optional arch=any
 libdolfinx-real-dev deb libdevel optional arch=any
 libdolfinx-real0.6 deb libs optional arch=any
 python3-dolfinx deb python optional arch=any
 python3-dolfinx-complex deb python optional arch=any
 python3-dolfinx-real deb python optional arch=any
Checksums-Sha1:
 77c9d48d927460f33db62e6377d90d0beabf6a6e 684211 fenics-dolfinx_0.6.0.orig.tar.gz
 0c8ee6efd20dcead0ca4297f6eadf95f4a8bebe8 45280 fenics-dolfinx_0.6.0-5.debian.tar.xz
Checksums-Sha256:
 eb8ac2bb2f032b0d393977993e1ab6b4101a84d54023a67206e3eac1a8d79b80 684211 fenics-dolfinx_0.6.0.orig.tar.gz
 f6f5f196fc8657c5ea1054dac3c2a85e69b3fbcfc3d4d20c6e0e127641fe31a6 45280 fenics-dolfinx_0.6.0-5.debian.tar.xz
Files:
 05b8d2dff390eeb220ad3b03b4bf0f82 684211 fenics-dolfinx_0.6.0.orig.tar.gz
 61cb66073ea19dd72f56683a5d35f211 45280 fenics-dolfinx_0.6.0-5.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEI8mpPlhYGekSbQo2Vz7x5L1aAfoFAmS6kiwACgkQVz7x5L1a
Afo28hAAlqPvIRj2JGSIp2IBLm4/E02RqDoDx4h1bVxsxb7tYM9GDCRlyX66EFsM
JJ6zvaBoXLIGJO4cbI43aq94nFlHWNvg/+5gVmYJcvBza9ArHN9YKkSzwd0r8nnL
NQXftHbtss0vkG/YFj/lLsFFEi6BsCh5MVomyaG42OMNgn1d3tl/XTybloSqCyp6
+3sZ9eN4laEZnmGp1yYwTEVsAReTAF1nR36TkGhRNoBCizi+LHYiUkLKDLmurd4m
dmCow0yVm5hD+RFQm+y+s9kKHl7wpx0532TxZyM1PvMcMBV4ofjWm89vqRV0DX/w
WRR/600QoXSLCEvhQ3LCy4hkIH5VHv+4uFWeap6DNcijQjyNo/Q8fSTjsNOlnzdW
gbO+TtSsP19HAYXPAzbtKZ33xg0QOIfThzTzy4Zq5zP6o+cobAl/+BgsQHtr7P0e
26FNmGqQXTJkmZ2xSVd54CM3l6txOeBPxADIT5Mi0B/nXgW9pTlcZKrhGHR1O3BZ
LYPujLfT0t/pZsei5zpYLgi5jWMkDcLCLR4Am77FUiktvXr5gOm14jxPa5rwifsb
+entLxvHj0AQ6wpWSzhjweAEQpGhTWSJy5x7ZQ5iG3epLokwj8limsUwyGzCZD94
ybpKuxQiBOnSdIkLtYqEewGwYSdac1OKvyE1XxKpyQtqCnOcaO4=
=z7xt
-----END PGP SIGNATURE-----
