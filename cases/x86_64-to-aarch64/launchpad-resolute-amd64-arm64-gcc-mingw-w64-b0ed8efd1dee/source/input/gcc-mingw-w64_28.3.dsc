-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (native)
Source: gcc-mingw-w64
Binary: gcc-mingw-w64-bootstrap, gcc-mingw-w64, gcc-mingw-w64-i686, gcc-mingw-w64-i686-posix, gcc-mingw-w64-i686-win32, gcc-mingw-w64-x86-64, gcc-mingw-w64-x86-64-posix, gcc-mingw-w64-x86-64-win32, gcc-mingw-w64-ucrt64, g++-mingw-w64, g++-mingw-w64-i686, g++-mingw-w64-i686-posix, g++-mingw-w64-i686-win32, g++-mingw-w64-x86-64, g++-mingw-w64-x86-64-posix, g++-mingw-w64-x86-64-win32, g++-mingw-w64-ucrt64, gfortran-mingw-w64, gfortran-mingw-w64-i686, gfortran-mingw-w64-i686-posix, gfortran-mingw-w64-i686-win32, gfortran-mingw-w64-x86-64, gfortran-mingw-w64-x86-64-posix, gfortran-mingw-w64-x86-64-win32, gfortran-mingw-w64-ucrt64, gobjc-mingw-w64, gobjc-mingw-w64-i686, gobjc-mingw-w64-i686-posix, gobjc-mingw-w64-i686-win32, gobjc-mingw-w64-x86-64, gobjc-mingw-w64-x86-64-posix, gobjc-mingw-w64-x86-64-win32, gobjc-mingw-w64-ucrt64, gobjc++-mingw-w64, gobjc++-mingw-w64-i686, gobjc++-mingw-w64-i686-posix, gobjc++-mingw-w64-i686-win32, gobjc++-mingw-w64-x86-64,
 gobjc++-mingw-w64-x86-64-posix, gobjc++-mingw-w64-x86-64-win32, gobjc++-mingw-w64-ucrt64, gnat-mingw-w64, gnat-mingw-w64-i686, gnat-mingw-w64-i686-posix, gnat-mingw-w64-i686-win32, gnat-mingw-w64-x86-64, gnat-mingw-w64-x86-64-posix, gnat-mingw-w64-x86-64-win32, gnat-mingw-w64-ucrt64, gcc-mingw-w64-i686-posix-runtime, gcc-mingw-w64-i686-win32-runtime, gcc-mingw-w64-x86-64-posix-runtime, gcc-mingw-w64-x86-64-win32-runtime, gcc-mingw-w64-ucrt64-runtime,
 gcc-mingw-w64-base
Architecture: any all
Version: 28.3
Maintainer: Stephen Kitt <skitt@debian.org>
Homepage: https://www.gnu.org/software/gcc/
Standards-Version: 4.7.3
Vcs-Browser: https://salsa.debian.org/mingw-w64-team/gcc-mingw-w64
Vcs-Git: https://salsa.debian.org/mingw-w64-team/gcc-mingw-w64.git
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 13), binutils-mingw-w64-i686, binutils-mingw-w64-ucrt64, binutils-mingw-w64-x86-64, bison, flex, g++-15 <!stage1>, gcc-15-source (>= 15.2.0-11), gnat-15 [alpha amd64 arm64 armel armhf hppa i386 mips64el mipsel ppc64 ppc64el riscv64 s390x sh4 sparc64 x32] <!stage1>, libelf-dev, libgmp-dev, libisl-dev, libmpc-dev, libmpfr-dev, mingw-w64-i686-dev <!stage1>, mingw-w64-ucrt64-dev <!stage1>, mingw-w64-x86-64-dev <!stage1>, xz-utils, zlib1g-dev
Package-List:
 g++-mingw-w64 deb devel optional arch=all profile=!stage1
 g++-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 g++-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 g++-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 g++-mingw-w64-ucrt64 deb devel optional arch=any profile=!stage1
 g++-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 g++-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 g++-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64 deb devel optional arch=all profile=!stage1
 gcc-mingw-w64-base deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-bootstrap deb devel optional arch=any
 gcc-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gcc-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-i686-posix-runtime deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-i686-win32-runtime deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-ucrt64 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-ucrt64-runtime deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gcc-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-x86-64-posix-runtime deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-x86-64-win32-runtime deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64 deb devel optional arch=all profile=!stage1
 gfortran-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gfortran-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-ucrt64 deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gfortran-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gnat-mingw-w64 deb devel optional arch=all profile=!stage1
 gnat-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gnat-mingw-w64-i686-posix deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-i686-win32 deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-ucrt64 deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gnat-mingw-w64-x86-64-posix deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-x86-64-win32 deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gobjc++-mingw-w64 deb devel optional arch=all profile=!stage1
 gobjc++-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gobjc++-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-ucrt64 deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gobjc++-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64 deb devel optional arch=all profile=!stage1
 gobjc-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gobjc-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-ucrt64 deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gobjc-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
Checksums-Sha1:
 e02da4dfc4b48224af3d660a41712aa14a232bc7 36796 gcc-mingw-w64_28.3.tar.xz
Checksums-Sha256:
 5bdababdc114eed1c7362003877e4652a23be1dcc946da06cf893d005f01bc86 36796 gcc-mingw-w64_28.3.tar.xz
Files:
 4213d929f662d88eecfd1cf5f36594b3 36796 gcc-mingw-w64_28.3.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAml6AAgACgkQgNMC9Yht
g5xnaBAAnWSCZbgstlPrgPsuEwqb85mDaDiSc3P7taxWH9FuU1XonRtOL3sDPfNc
TrMPBh/S/AFqL6USonFY53qNNo8MxYi2M2gW6N+5Cf+UTB+eJGJzEliz9+fHyPfN
VPjxzOfawYvBACkzoYqJEPQG4lat4bfM4rkGNqgi9PVLsx6ACSMxATwCitZnd6sv
lFh15olN4WhboZlLOivyzJvD+Y6ueDaxpR0MgIL9GP7T4MJ1rE9pSRnMcxZbfKrV
5jYTb9yv80wI80C9NyCwlyT8pRwkfRIvFRdZQFvcCQdAZnrxWGlCmP6oGghi9Cxp
fxknXBgXvvaAte8ocM8MMvq8ExC+Wwa+Wx/66w54Ow+3dhVGe43htDnKxGb46pNq
2O4XyQ+Q0F8WX6I4/wgnvHhh/3Y012kcQvtYBCcjtVuK7wIXTIsPRglgAKSdjDfw
c7/hpx9BPz4huLyclz/BxXeaqPiGTgZ5agaQ08MUdme5T0fqBXraC6NI67MEbJVK
wNtPoF7yW2aLTpjY/ubkeXpbdv7H7rDnFltpz6AkBKZpOcDRzSgvRoCsH+3tJ5b4
oyKS93h3RZUcGtniEshVgoSEc6Uf0WV8AkdPIyUR6UFSBgyYhvXp9G0SkfsEhFfe
U3tvkaUJXmT08BrAx1e/mVo/VRuUexv8mv2egtNhzLSFPq59yx4=
=DpS/
-----END PGP SIGNATURE-----
