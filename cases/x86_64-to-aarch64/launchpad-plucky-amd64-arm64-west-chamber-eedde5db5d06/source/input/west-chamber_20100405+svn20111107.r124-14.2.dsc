-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: west-chamber
Binary: west-chamber-common, west-chamber-source, west-chamber-dkms
Architecture: any all
Version: 20100405+svn20111107.r124-14.2
Maintainer: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>
Homepage: http://code.google.com/p/scholarzhang/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/debian/west-chamber
Vcs-Git: https://salsa.debian.org/debian/west-chamber.git
Testsuite: autopkgtest, autopkgtest-pkg-dkms
Testsuite-Triggers: linux-doc, module-assistant-autopkgtest
Build-Depends: debhelper-compat (= 13), bzip2, dh-sequence-dkms, libxtables-dev (>= 1.4.3), pkgconf
Package-List:
 west-chamber-common deb admin optional arch=any
 west-chamber-dkms deb kernel optional arch=all
 west-chamber-source deb kernel optional arch=all
Checksums-Sha1:
 afd56b4cb8a3a2cda25767576b14e3562ee2adb3 42501 west-chamber_20100405+svn20111107.r124.orig.tar.bz2
 f49d8409d424dc0fea5609b83f6702e64be3dd76 8432 west-chamber_20100405+svn20111107.r124-14.2.debian.tar.xz
Checksums-Sha256:
 9f663099b0a3b4552256919855d19eec8fe8373eb8f8b9a4113edcdce5bd44a1 42501 west-chamber_20100405+svn20111107.r124.orig.tar.bz2
 6c475ef04fb00ca1212059b56adfe48e5c5791d389d724bdb82704cf90c72f83 8432 west-chamber_20100405+svn20111107.r124-14.2.debian.tar.xz
Files:
 8c0956ec80b5dc88e6cf23575a9c2c56 42501 west-chamber_20100405+svn20111107.r124.orig.tar.bz2
 571a67e193e266d2bf0e72ada948f396 8432 west-chamber_20100405+svn20111107.r124-14.2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE6/MKMKjZxjvaRMaUX7M/k1np7QgFAme8oRgQHGFuYmVAZGVi
aWFuLm9yZwAKCRBfsz+TWentCO0YD/wPHSAwUp2Ch1K2mO76H9T4R3zLCBn3RHIL
1P72ssAyKMiFxm+QUTbAm/9rGAVkblC31abks76uGXfOGMxhHINSn+hYNFjMUYDF
un5POUJvx2LiooTB5jPI7eZlMm2NWf5l4K/OrxNrD/HoE7qripLyYs3bO8wzT2BE
l18OuaX3v/y2SPbmg/JNQ3qL3s53QkXK2ZYhsr3IhsNncE75MOT/2AneC6VjYSBJ
jhMrF3RCZFJxey6ZmJ1RQGBRg7QuGJ9v/J7pc+l70UrM0oYprvIYz0SysaShI+aW
TwI1ND1LV128symznoOPvpt+YNxDjjbfMoXRP1qwLWbwvAUYWUIaLA94BqqJJgct
MgHJK4d95hCGS+UgzQrJ3YfSgGhWUvsXLHY2zvATYWmkmLy0SwHk8l0ATfiIZ7De
BjNqxLhKrZlcGATkeqkexgnPZWfWq0R1l3j+AfiVSU/xQ5wVAZI3I++yR5JmWBBk
ZbAEAklBRs3hIVIq7qE6gvJxkZYrcaT+AAgmYGsjyY2JrYyzySoOYrFwCRlenaaK
A74jUSGDVweRBzFSC4Y5ZZbNNDofvn5gESYS0RSj2Klnu/dhz9eIPH4PQt5vc3vA
RLOTdLBLng5vZa+WgexjPAaSR1zGhs2GETACEowPrjefLlF+6jsSKzgAatPkc4fb
/fEwyTqEFQ==
=PDRu
-----END PGP SIGNATURE-----
