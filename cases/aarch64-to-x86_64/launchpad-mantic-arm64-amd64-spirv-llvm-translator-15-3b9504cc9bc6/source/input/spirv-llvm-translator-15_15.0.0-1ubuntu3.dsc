-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: spirv-llvm-translator-15
Binary: libllvmspirvlib15, libllvmspirvlib-15-dev, llvm-spirv-15
Architecture: any
Version: 15.0.0-1ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Timo Aaltonen <tjaalton@debian.org>, Andreas Beckmann <anbe@debian.org>,
Homepage: https://github.com/KhronosGroup/SPIRV-LLVM-Translator
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/opencl-team/spirv-llvm-translator
Vcs-Git: https://salsa.debian.org/opencl-team/spirv-llvm-translator.git -b llvm15/main
Testsuite: autopkgtest
Testsuite-Triggers: clang-15, cmake, g++, llvm-15-dev, pkgconf, spirv-headers, spirv-tools
Build-Depends: debhelper-compat (= 13), cmake, pkgconf, spirv-headers (>= 1.5.5), spirv-tools, libclang-15-dev, llvm-15-dev, clang-15 <!nocheck>
Package-List:
 libllvmspirvlib-15-dev deb libdevel optional arch=any
 libllvmspirvlib15 deb libs optional arch=any
 llvm-spirv-15 deb libdevel optional arch=any
Checksums-Sha1:
 f288e95377bc94e5fdbe5ed4f2dfdd16ef02289a 1515145 spirv-llvm-translator-15_15.0.0.orig.tar.gz
 a923173c9a2b90c12894283c45209b8d2d86b7a1 5196 spirv-llvm-translator-15_15.0.0-1ubuntu3.debian.tar.xz
Checksums-Sha256:
 b1bebd77f72988758c00852e78c2ddc545815a612169a0cb377d021e2f846d88 1515145 spirv-llvm-translator-15_15.0.0.orig.tar.gz
 1cfb135b23bd0421b51db7c98fca9323a050aa21b85963ad812010ecccacfa9a 5196 spirv-llvm-translator-15_15.0.0-1ubuntu3.debian.tar.xz
Files:
 19e3ee2fb84754602ec754c594b20a1d 1515145 spirv-llvm-translator-15_15.0.0.orig.tar.gz
 d0b2771099291256d26762440bff38da 5196 spirv-llvm-translator-15_15.0.0-1ubuntu3.debian.tar.xz
Original-Maintainer: Debian OpenCL team <pkg-opencl-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCZJquKBIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pJaHgCgzxIY8KNvvLqaq5c7FpWte4J8pAoAnAxI
hcFw09F3eLlrueXVRQueuKZl
=hPzC
-----END PGP SIGNATURE-----
