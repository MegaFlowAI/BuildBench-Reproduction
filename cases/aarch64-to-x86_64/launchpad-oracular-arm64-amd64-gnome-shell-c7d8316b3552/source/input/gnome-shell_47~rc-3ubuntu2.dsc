-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gnome-shell
Binary: gnome-shell, gnome-shell-common, gnome-shell-extension-prefs
Architecture: linux-any all
Version: 47~rc-3ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Jeremy Bícha <jbicha@ubuntu.com>, Marco Trevisan (Treviño) <marco@ubuntu.com>
Homepage: https://wiki.gnome.org/Projects/GnomeShell
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gnome-shell/tree/ubuntu/latest
Vcs-Git: https://salsa.debian.org/gnome-team/gnome-shell.git -b ubuntu/latest
Build-Depends: appstream, bash-completion, dbus-daemon <!nocheck>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, gjs (>= 1.73.1), gir1.2-accountsservice-1.0 <!nocheck>, gir1.2-gcr-4-dev, gir1.2-gdkpixbuf-2.0-dev, gir1.2-gdm-1.0 <!nocheck>, gir1.2-geoclue-2.0 <!nocheck>, gir1.2-gnomebg-4.0 <!nocheck>, gir1.2-gnomedesktop-4.0 <!nocheck>, gir1.2-gweather-4.0 (>= 4.1) <!nocheck>, gir1.2-nma4-1.0 (>= 1.10.4) [linux-any] <!nocheck>, gir1.2-polkitagent-1.0-dev, gir1.2-rsvg-2.0 <!nocheck>, gir1.2-upowerglib-1.0 <!nocheck>, gnome-control-center-dev, gnome-pkg-tools, gnome-settings-daemon-common (>= 40~) <!nocheck>, gobject-introspection (>= 1.80), gsettings-desktop-schemas-dev (>= 47~rc), gtk-doc-tools, libasound2-dev, libatk-bridge2.0-dev, libecal2.0-dev (>= 3.45), libedataserver1.2-dev (>= 3.45), libgcr-4-dev (>= 3.90.0), libgjs-dev (>= 1.73.1), libgl1-mesa-dri <!nocheck>, libglib2.0-dev (>= 2.80), libgnome-autoar-0-dev, libgnome-bluetooth-3.0-dev (>= 3.9.0) [linux-any], libgnome-desktop-4-dev (>= 40), libgnome-menu-3-dev, libgstreamer1.0-dev, libgstreamer-plugins-base1.0-dev, libgtk-4-dev, libibus-1.0-dev, libjson-glib-dev, libmutter-15-dev (>= 47~rc), mutter-15-tests (>= 47~rc) <!nocheck>, libnm-dev [linux-any], libpipewire-0.3-dev (>= 0.3.49) [linux-any], libpolkit-agent-1-dev, libpulse-dev, libsecret-1-dev, libsystemd-dev [linux-any], libx11-dev, libxfixes-dev, libxml2-dev, mesa-common-dev, meson (>= 0.58.0), mutter (>= 47~rc) <!nocheck>, pipewire <!nocheck>, pkgconf, python3-docutils, sassc, systemd-dev [linux-any], terser, xauth <!nocheck>, xvfb <!nocheck>, xwayland <!nocheck>
Package-List:
 gnome-shell deb gnome optional arch=linux-any
 gnome-shell-common deb gnome optional arch=all
 gnome-shell-extension-prefs deb gnome optional arch=linux-any
Checksums-Sha1:
 d9714b63a3228e0ffdab856c516d8409d7f77bd5 2137468 gnome-shell_47~rc.orig.tar.xz
 5f7341964cae2da4493ac6bd3ea1ee069ce04aee 156212 gnome-shell_47~rc-3ubuntu2.debian.tar.xz
Checksums-Sha256:
 bfeff82dcf208c021ba02387c3e0a69bfe47ae80083b8ae23aa01cd415e99004 2137468 gnome-shell_47~rc.orig.tar.xz
 e80acd7ab8d8a7bd6730b440d17de36f38454feb6e2b36516af3e0fe5d171cb9 156212 gnome-shell_47~rc-3ubuntu2.debian.tar.xz
Files:
 559f495f5c7a9f80090ace79235fd9a6 2137468 gnome-shell_47~rc.orig.tar.xz
 5c3bee256a996e96d882d704b14b6740 156212 gnome-shell_47~rc-3ubuntu2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gnome-shell
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gnome-shell.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE1MUB2kjreXoIF1CTlEnC9QmWY18FAmbn/gsACgkQlEnC9QmW
Y1+1MRAAid60XTRB230fS77UzDvQxEkO0wbmhPIkFtXPVNOm5fRjACq6e19J5EGy
fRlpKpxhDSUsyce61vswTrxkC5U/AG31sVFWqLeu39UZav+EAbDCCRISszsIWQXr
A0WhipP1njyBEK1A3q33XQlDywuc23WnKEXDilguCfwCsLfoFk+0lzlT+QQVh6jE
Lj7+DTcPRlrO0CRuGfkahqzQrTx2zFIGTE7nRxWZttOQUpDlEl1559Hf9epRcsN+
nzevkNST2UoWvarARzzSeEjl8WSyq3i9P7I3E/SvQNYEltDd0LL8/ekntOwVRXI3
P7uMHoq3djn06kkcM3ClnwPAsNIOfnmx3plq1R7A4avg45/fA27aYuF54VZg74vM
D5fw2aY0r5rxq85ZlAYxdkp5OGV9tuzmRglrWNH5uzDoQuzwI0qR7XdNq9MFNM0e
kRdH5Tp5rkXhYozBJ0dhduCvpJdbparDTD4lV5jUR8eaGEIV+lDXWvykR7IU3Y7M
LFCjrZVRtdraakHQHbumMFVPjPAMEEg8YQ+ewPzjvLXvpm/Yup/ne8kXJIVvKoe6
0jr882X+5w5YD/9X+ylo8kI8gIQsTTLq+4Aji9Em/1Fj/aQw1ItPcrpO6cCg+aqg
swm0avzAP/6AkBDRcQSpMOO1sWh2Scvv2cJ5/kY+p6rMUS1SeTI=
=hQoU
-----END PGP SIGNATURE-----
