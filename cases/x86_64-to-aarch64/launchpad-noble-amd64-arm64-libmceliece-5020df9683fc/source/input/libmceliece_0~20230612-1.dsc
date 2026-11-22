-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libmceliece
Binary: libmceliece-dev, libmceliece1, mceliece
Architecture: any
Version: 0~20230612-1
Maintainer: Jan Mojžíš <jan.mojzis@gmail.com>
Uploaders:  Simon Josefsson <simon@josefsson.org>,
Homepage: https://lib.mceliece.org
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/debian/libmceliece
Vcs-Git: https://salsa.debian.org/debian/libmceliece.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dpkg-dev, librandombytes-dev
Build-Depends: debhelper-compat (= 13), libcpucycles-dev, librandombytes-dev, python3
Package-List:
 libmceliece-dev deb libdevel optional arch=any
 libmceliece1 deb libs optional arch=any
 mceliece deb devel optional arch=any
Checksums-Sha1:
 f73d40279711b07983f29eb63443e21508ac1e87 560158 libmceliece_0~20230612.orig.tar.gz
 92dae6c88ea852aee92eea12d0d0121094e182ce 5356 libmceliece_0~20230612-1.debian.tar.xz
Checksums-Sha256:
 6603d08888b39b5abbe96d75ee9393920acc4e077461d4f6c6910b7df0574ff7 560158 libmceliece_0~20230612.orig.tar.gz
 6b8b950b883777daf9b90cc8bc87238b698c38630806f4263d6259f14ddc3866 5356 libmceliece_0~20230612-1.debian.tar.xz
Files:
 b64bda05dfa776b201484ee6f953b6ff 560158 libmceliece_0~20230612.orig.tar.gz
 f80332ce5d0b13951acb405c2ff2f8ef 5356 libmceliece_0~20230612-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQSjzJyHC50xCrrUzy9RcisI/kdFogUCZSmqTQAKCRBRcisI/kdF
ouYWAP9GRi2nycimFOdglORXNbc8tlEMbA4Svz1P3gSDEEmTSgD/X/FEjbP4SEJa
9EBlfhSekhbnL+LQa1y8s5PzsdcMwwA=
=zUr+
-----END PGP SIGNATURE-----
