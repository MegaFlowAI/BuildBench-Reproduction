-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libayatana-appindicator
Binary: libayatana-appindicator1, gir1.2-ayatanaappindicator-0.1, libayatana-appindicator-dev, libayatana-appindicator-doc, libayatana-appindicator3-1, libayatana-appindicator3-dev, gir1.2-ayatanaappindicator3-0.1, libayatana-appindicator0.1-cil, libayatana-appindicator0.1-cil-dev, libayatana-appindicator3-0.1-cil, libayatana-appindicator3-0.1-cil-dev
Architecture: any all
Version: 0.5.90-1
Maintainer: Ayatana Packagers <pkg-ayatana-devel@lists.alioth.debian.org>
Uploaders:  Mike Gabriel <sunweaver@debian.org>,
Homepage: https://github.com/AyatanaIndicators/libayatana-appindicator
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian-edu-ayatana-team/libayatana-appindicator
Vcs-Git: https://salsa.debian.org/debian-ayatana-team/libayatana-appindicator.git
Build-Depends: cmake (>= 3.13), cmake-extras (>= 1.5-8~), debhelper-compat (= 13), dpkg-dev (>= 1.16.1.1), at-spi2-core, cli-common-dev (>= 0.8~) [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], gobject-introspection, intltool, gtk-doc-tools, libxml2-utils, libnunit-cil-dev [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], dbus-test-runner, xvfb, valac, mono-devel (>= 2.4.3) [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], libglib2.0-dev (>= 2.35.4), libgtk-3-dev (>= 2.91.3), libgtk2.0-dev (>= 2.12.0), procps, gtk-sharp3-gapi [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], libgtk3.0-cil-dev [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], gtk-sharp2-gapi [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], libgtk2.0-cil-dev [amd64 arm64 armel armhf i386 mipsel ppc64el s390x kfreebsd-amd64 kfreebsd-i386 powerpc ppc64], libdbus-glib-1-dev (>= 0.82), libayatana-indicator-dev (>= 0.6.0-0~), libayatana-indicator3-dev (>= 0.6.0-0~), libdbusmenu-glib-dev (>= 0.5.90), libdbusmenu-gtk-dev (>= 0.5.90), libdbusmenu-gtk3-dev (>= 0.5.90), libgirepository1.0-dev
Package-List:
 gir1.2-ayatanaappindicator-0.1 deb introspection optional arch=any
 gir1.2-ayatanaappindicator3-0.1 deb introspection optional arch=any
 libayatana-appindicator-dev deb libdevel optional arch=any
 libayatana-appindicator-doc deb doc optional arch=all
 libayatana-appindicator0.1-cil deb cli-mono optional arch=amd64,arm64,armel,armhf,i386,mipsel,ppc64el,s390x,kfreebsd-amd64,kfreebsd-i386,powerpc,ppc64
 libayatana-appindicator0.1-cil-dev deb cli-mono optional arch=amd64,arm64,armel,armhf,i386,mipsel,ppc64el,s390x,kfreebsd-amd64,kfreebsd-i386,powerpc,ppc64
 libayatana-appindicator1 deb libs optional arch=any
 libayatana-appindicator3-0.1-cil deb cli-mono optional arch=amd64,arm64,armel,armhf,i386,mipsel,ppc64el,s390x,kfreebsd-amd64,kfreebsd-i386,powerpc,ppc64
 libayatana-appindicator3-0.1-cil-dev deb cli-mono optional arch=amd64,arm64,armel,armhf,i386,mipsel,ppc64el,s390x,kfreebsd-amd64,kfreebsd-i386,powerpc,ppc64
 libayatana-appindicator3-1 deb libs optional arch=any
 libayatana-appindicator3-dev deb libdevel optional arch=any
Checksums-Sha1:
 0cca281d20885193f0c028aaf049610c7ac94194 123642 libayatana-appindicator_0.5.90.orig.tar.gz
 d951357c6f9abadacd17f5789f0abcda46a9daba 833 libayatana-appindicator_0.5.90.orig.tar.gz.asc
 3f438590b6bb5a766559d88a8c8be961e7b06e70 17368 libayatana-appindicator_0.5.90-1.debian.tar.xz
Checksums-Sha256:
 9a89fd20639814cddda937a299cc885907dd21cec9b73632d9324214c33e1d81 123642 libayatana-appindicator_0.5.90.orig.tar.gz
 8ed497c087cb464098aed010694030ab73f63c53c1d72600875daa5c7fc2f0c2 833 libayatana-appindicator_0.5.90.orig.tar.gz.asc
 7eac56fd5dfda0b4897f25b3c9703885d45deb2f94344078fdf928f967bf51b1 17368 libayatana-appindicator_0.5.90-1.debian.tar.xz
Files:
 9d3c8d396e90b5b302068cdae14a9980 123642 libayatana-appindicator_0.5.90.orig.tar.gz
 68998d1b5bf93d8f2d2e6a77733dc59e 833 libayatana-appindicator_0.5.90.orig.tar.gz.asc
 a2fe0cd4949251b392c3dd4b5bfc738e 17368 libayatana-appindicator_0.5.90-1.debian.tar.xz
Python-Version: all

-----BEGIN PGP SIGNATURE-----

iQJJBAEBCAAzFiEEm/uu6GwKpf+/IgeCmvRrMCV3GzEFAmG4/gIVHHN1bndlYXZl
ckBkZWJpYW4ub3JnAAoJEJr0azAldxsxe3IP/2u4h+58beKkrJGoqxmUwJln8d+b
zqhRjCTTOH/iMgoB8dICp+DejoSaxVmaWXsYmSmoRBBakPXYOhVj19VmmukNjsts
8XGW/YR14JN82G2DX6fJ4VWeyyGvv75DLc2YrdoHI4F+y187iCAEhLsj0ql30Onh
j8aa9yZTf58DXpwpJTe4YDcyNDneXkh+B2N6xiG8gMtFZDeEgh/sR4Xh4VL8z8xU
PWwufD8N4ujE8hiFjhuoHzOdBlSpnNtMNSYYopLjnesmVqpjAE/Oqztfgh5J1LRN
73oB9wA0KC2DERP83aQXlh9kKnu0X6/Wnxm+NU0YEsAe8mhDy0nfl3jXAC5pwliD
uBOoxolOLg66LGF7QK9rvtB8wTT6hxcJkMW4nOCuLSddT5DKYX2NvdrRy2U0PMuA
BETnhXLPCFDIFI5gOOr5CtlCmIkbKr13ZSaUvwbvyOGFufa4OwqWYj1fs0VeoxHb
dWU4z/K3/hogogyNWi77AeHdDcPexNmKbNwQEH9gmDSeEeL6fIRkZrtECh0ZAtff
nxAVLbtTkNt4FyqOLsV+YgaoCOowxtC0W6R7D9kHh2gmI/La9A+8Jmo1fSVUUN9O
ND6Yu4tugKqSYezaIfpAeywAXPXwz72V9j4rzbktYsZV+WAD/V9fLq+r9iagM2re
4DhtAEDABROOAjjm
=lH6l
-----END PGP SIGNATURE-----
