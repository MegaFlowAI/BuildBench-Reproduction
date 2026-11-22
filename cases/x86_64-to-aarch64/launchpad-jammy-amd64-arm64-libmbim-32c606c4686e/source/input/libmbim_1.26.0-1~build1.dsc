-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: libmbim
Binary: libmbim-glib4, libmbim-glib-dev, libmbim-glib-doc, libmbim-utils, libmbim-proxy, gir1.2-mbim-1.0
Architecture: any all
Version: 1.26.0-1~build1
Maintainer: DebianOnMobile Maintainers <debian-on-mobile-maintainers@alioth-lists.debian.net>
Uploaders: Arnaud Ferraris <arnaud.ferraris@gmail.com>, Guido Günther <agx@sigxcpu.org>, Henry-Nicolas Tourneur <debian@nilux.be>, Martin <debacle@debian.org>
Homepage: https://www.freedesktop.org/wiki/Software/libmbim/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/DebianOnMobile-team/libmbim
Vcs-Git: https://salsa.debian.org/DebianOnMobile-team/libmbim.git
Build-Depends: debhelper-compat (= 13), pkg-config, autoconf-archive, gobject-introspection, help2man, libgirepository1.0-dev, libglib2.0-dev (>= 2.56)
Build-Depends-Indep: gtk-doc-tools <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-mbim-1.0 deb introspection optional arch=linux-any
 libmbim-glib-dev deb libdevel optional arch=any
 libmbim-glib-doc deb doc optional arch=all profile=!nodoc
 libmbim-glib4 deb libs optional arch=any
 libmbim-proxy deb net optional arch=any
 libmbim-utils deb net optional arch=any
Checksums-Sha1:
 bd963a9e82da47d993272640ecf1ea8d3301d4e0 554672 libmbim_1.26.0.orig.tar.xz
 907d72f73abb295f10106d26e6c93bfaed60cd35 195 libmbim_1.26.0.orig.tar.xz.asc
 c6efe842947f85cb1fdbc18dc3c776da05e2f37b 10320 libmbim_1.26.0-1~build1.debian.tar.xz
Checksums-Sha256:
 1e1f0926b22c77210442129eca689722ecf324ab9c9abf421a5c989f46e813cf 554672 libmbim_1.26.0.orig.tar.xz
 a8fdfb24e402ff0ee18639f6aad4feebf608c48e61f67906d94701e9d4a77761 195 libmbim_1.26.0.orig.tar.xz.asc
 027cea5c36a95c4da82c1985d81244f4d3b2de0adf9186ad648d659712fb7857 10320 libmbim_1.26.0-1~build1.debian.tar.xz
Files:
 552d498d891c93ee9ed2684a8a6a723e 554672 libmbim_1.26.0.orig.tar.xz
 fed06fbad95cf5098662fd9a2f176bbd 195 libmbim_1.26.0.orig.tar.xz.asc
 6cfb236149b61dad25c530caa8cf2189 10320 libmbim_1.26.0-1~build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCYZyjUBIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pLRPwCbB5FoIvqX/OqwR7+mhOw4n8fZIu0An0wL
yC6omMbnWUxFCu8qUfzeIYqR
=t1On
-----END PGP SIGNATURE-----
