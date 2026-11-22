-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libinsane
Binary: libinsane-dev, libinsane1, gir1.2-libinsane-1.0, libinsane-doc
Architecture: any all
Version: 1.0.1-1
Maintainer: Thomas Perret <thomas.perret@phyx.fr>
Homepage: https://gitlab.gnome.org/World/OpenPaperwork/libinsane
Standards-Version: 4.4.0
Vcs-Browser: https://salsa.debian.org/openpaperwork-team/libinsane
Vcs-Git: https://salsa.debian.org/openpaperwork-team/libinsane.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, libcunit1-dev, python3, python3-gi, valgrind
Build-Depends: debhelper-compat (= 12), meson, libsane-dev, libgirepository1.0-dev, gobject-introspection, python3-gi, valac, gtk-doc-tools
Package-List:
 gir1.2-libinsane-1.0 deb introspection optional arch=any
 libinsane-dev deb libdevel optional arch=any
 libinsane-doc deb doc optional arch=all
 libinsane1 deb libs optional arch=any
Checksums-Sha1:
 20049aa56fa4ef9f968d9c0a395297ea324f137a 706575 libinsane_1.0.1.orig.tar.gz
 235ffdf6c29af58496d235d3074ce231c1142baa 4628 libinsane_1.0.1-1.debian.tar.xz
Checksums-Sha256:
 2e067661594a175a385f2b11b4230b8833d5ad376c50cb32a7b60243b585ca69 706575 libinsane_1.0.1.orig.tar.gz
 5e955948cd4bc9f5e171cf5d36769d1a9b3772cbe4b410053a891f5d1bbd853f 4628 libinsane_1.0.1-1.debian.tar.xz
Files:
 1747bf44f3b3c4b35562aa649e4a471d 706575 libinsane_1.0.1.orig.tar.gz
 910804eb853f63acf1996eabb76c9fc4 4628 libinsane_1.0.1-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkjZVexcMh/iCHArDweDZLphvfH4FAl2REyUACgkQweDZLphv
fH5UghAApEXM3VzG7Ir6c8Oqk7HEscZnEcHL5VMpt/Kh1lNgywpuGUPu61AtYt4U
5EwBx1eDnPSg4CvynUxihDgAF0FStaMaQN/BpDPDbfTNY/YgkUXWa32o0Vuk/SOc
4RPxdd7ck7V+kMthWeNA1cPQdOnXTmWKN2he5VSeq1d0F8j48vfWt7RlNOFpl7AE
F4XBL3BwWWsWCGDX+7rh+I8bLTyxTpNn37hXgfsciKunfeC7dv5r5hzyydes1sUA
xjkXWLwnqD7VTSZjq971GxnDXQ6CbE5zEIQZPtz2v2U9MO/0nk7T4YBTjgBMKXF7
22WWCK6jJXT4+ro2QR1YPilKpfIssWCOTWx4cIpBSO3pinvNwVOPrfWcTmvjgNCe
ceW/EL9eDgClQLUqN+/HmT82DPfEXFGdheu2daTTnKcTTNsqg0jVQELUFMPhGT+z
8NEaG8ZeeypV4t/zECU4i4kjKM2Inao3Ydcxh7XePujMri6QZ34FidbB2NwJlizn
IMopNbDA7JDcuG0WXg9eHdrE771TqMIAHDocIa6dMBm6gkwq0BX4Sw+JClYgR+7t
qwVPnsvcXeFVawxJqFOKWFpC0/4yrJR6Dkr2H/ZNWOVHCEAR1f+sUtEvaifk2fiW
vmnfmO1qEbWmnOuWd75MX2tX+Lsf0qw2onFijncY7f55n+eZol8=
=agyS
-----END PGP SIGNATURE-----
