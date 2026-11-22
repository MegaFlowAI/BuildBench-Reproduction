-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: rocm-llvm
Binary: hipcc, rocm-device-libs-20, libamd-comgr3, libamd-comgr-dev
Architecture: any
Version: 6.4.3+dfsg-1~exp3
Maintainer: Debian ROCm Team <debian-ai@lists.debian.org>
Uploaders: Xuanteng Huang <xuanteng.huang@outlook.com>, Christian Kastner <ckk@debian.org>, Cordell Bloor <cgmb@debian.org>
Homepage: https://github.com/ROCm/llvm-project
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/rocm-team/rocm-llvm
Vcs-Git: https://salsa.debian.org/rocm-team/rocm-llvm.git
Testsuite: autopkgtest
Testsuite-Triggers: cmake, g++, gcc, libamdhip64-dev, make, rocminfo
Build-Depends: debhelper-compat (= 13), cmake, clang-20, clang-tools-20, dh-exec, libclang-20-dev, libclang-rt-20-dev, libhsa-runtime-dev (>= 6.1.2~), libnuma-dev, lld-20, liblld-20-dev, llvm-20-dev, libzstd-dev, zlib1g-dev, libxml2-dev, libfile-basedir-perl, chrpath
Package-List:
 hipcc deb libdevel optional arch=amd64,arm64,ppc64el
 libamd-comgr-dev deb libdevel optional arch=any
 libamd-comgr3 deb libs optional arch=any
 rocm-device-libs-20 deb libs optional arch=any
Checksums-Sha1:
 0ec9355b1533cb5f11f38dd1ba9203f27b3775ef 326616 rocm-llvm_6.4.3+dfsg.orig.tar.xz
 72343cc5bbfbf326a76b7f67780162a02324af39 13068 rocm-llvm_6.4.3+dfsg-1~exp3.debian.tar.xz
Checksums-Sha256:
 3660d6c0be0d1513376c067177c603425edfe899ae243f82022cd4a2b36065db 326616 rocm-llvm_6.4.3+dfsg.orig.tar.xz
 1eeb76f62972fcbb90895a62df57a014c9e40f43a67f2c9af2202f46ed1fb5f7 13068 rocm-llvm_6.4.3+dfsg-1~exp3.debian.tar.xz
Files:
 0c365d11d8eca3c7035f0bad5518f121 326616 rocm-llvm_6.4.3+dfsg.orig.tar.xz
 7a88594e2a12950f7bc54c7044a5046d 13068 rocm-llvm_6.4.3+dfsg-1~exp3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

wsG7BAEBCgBvBYJonwikCRD5747gwCFjD0cUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmejbZPzplA7ut+5TuULdUXqwQlgtPLC0wHxmX2lRhJ4
xhYhBAzgb+OSqkj40i5EcfnvjuDAIWMPAADrYhAAw0CixztyEwf4iojtEWZJlcD5
irtvz/ukaD3yrgVpJgCPYaYRQwsrekVy1wY9t/EjKfkCsQWNvgHfobMlLrb7wBU2
3+Yi6sHr8zt2XaAemjf0FGUpGWxnmVFXDH0h9HDKhKj7J6HM7MOVkNw4V9PUjOaF
/OCp8Rm4MOlNFXyRYh18IGN1Tg1vxJv3a/Ao7r/JhoWv1GUhAc1j960tWat2MYBi
el9csm3AELW//2QrXiCUFOuC+uOD/mT93yNfnJRjFHE7O0aYSpV6WrytsXXmmIOC
ZPzACXOh+LsRSX/4mOvwICeD1MD6YDgBSJOA6kRENlQLvrfbXmI9ddV124IgM6OM
6hkb5z8aG7QT6X7gdnsPJq4BDx3C8N9GRgU/wNMxg8kY1IDmFByXPMY+gUFXrS7j
MkTWKRS0nyg8/YlN+VawFw+8C8jovRKm2XOjogD8jc/8jGuDRGg5n1Kr5Qm6+2fg
Wq0MRPuigtN+hmwO1zsC4qXG2CfJcc4Ray2Nic2smcuHRWT1w95Tq0NFSRaj0JtR
HmLuBhUZgXhjKO/YW8hIqevJzqpPpUcyx6xNJTm0aH/pM3GfArVkwIvwiEko95k8
Hs2ByQtBdja1gGg052M6HdFLnjvUajrYAOCt0iHVaNNTKNvi1lq43JjYKEVQKRAL
4wTv8BCEKDxJ69pvMpE=
=IZmV
-----END PGP SIGNATURE-----
