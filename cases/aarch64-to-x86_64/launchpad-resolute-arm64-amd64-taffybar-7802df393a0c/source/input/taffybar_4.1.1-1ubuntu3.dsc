-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: taffybar
Binary: libghc-taffybar-dev, libghc-taffybar-prof, libghc-taffybar-doc, taffybar
Architecture: any all
Version: 4.1.1-1ubuntu3
Maintainer: Debian Haskell Group <pkg-haskell-maintainers@lists.alioth.debian.org>
Uploaders:  Louis Bettens <louis@bettens.info>,
Homepage: https://github.com/taffybar/taffybar
Standards-Version: 4.7.3
Vcs-Browser: https://salsa.debian.org/haskell-team/DHG_packages/tree/master/p/taffybar
Vcs-Git: https://salsa.debian.org/haskell-team/DHG_packages.git [p/taffybar]
Build-Depends: dh-sequence-haskell, debhelper-compat (= 13), clang-21, libclang-21-dev, llvm-21, ghc (>= 9.10), ghc-prof, haskell-devscripts (>= 0.13), libghc-hstringtemplate-dev (>= 0.8), libghc-hstringtemplate-dev (<< 0.9), libghc-hstringtemplate-prof, libghc-x11-dev (>= 1.5.0.1), libghc-x11-prof, libghc-aeson-dev, libghc-aeson-prof, libghc-ansi-terminal-dev, libghc-ansi-terminal-prof, libghc-conduit-dev, libghc-conduit-prof, libghc-data-default-dev, libghc-data-default-prof, libghc-dbus-dev (>= 1.2.11), libghc-dbus-dev (<< 2.0.0), libghc-dbus-prof, libghc-dbus-hslogger-dev (>= 0.1.0.1), libghc-dbus-hslogger-dev (<< 0.2.0.0), libghc-dbus-hslogger-prof, libghc-dyre-dev (>= 0.9.0), libghc-dyre-dev (<< 0.10), libghc-dyre-prof, libghc-either-dev (>= 4.0.0.0), libghc-either-prof, libghc-extra-dev, libghc-extra-prof, libghc-enclosed-exceptions-dev (>= 1.0.0.1), libghc-enclosed-exceptions-prof, libghc-fsnotify-dev (>= 0.4), libghc-fsnotify-dev (<< 0.5), libghc-fsnotify-prof, libghc-gi-cairo-connector-dev, libghc-gi-cairo-connector-prof, libghc-gi-cairo-render-dev, libghc-gi-cairo-render-prof, libghc-gi-gdk3-dev (>= 3.0.30), libghc-gi-gdk3-dev (<< 3.1), libghc-gi-gdk3-prof, libghc-gi-gdkpixbuf-dev (>= 2.0.6), libghc-gi-gdkpixbuf-dev (<< 2.1), libghc-gi-gdkpixbuf-prof, libghc-gi-gdkx113-dev (>= 3.0.17), libghc-gi-gdkx113-dev (<< 4), libghc-gi-gdkx113-prof, libghc-gi-glib-dev, libghc-gi-glib-prof, libghc-gi-gtk-hs-dev (>= 0.3.17), libghc-gi-gtk-hs-dev (<< 0.4), libghc-gi-gtk-hs-prof, libghc-gi-gtk3-dev (>= 3.0.44), libghc-gi-gtk3-dev (<< 4), libghc-gi-gtk3-prof, libghc-gi-pango-dev, libghc-gi-pango-prof, libghc-gtk-sni-tray-dev (>= 0.1.8.0), libghc-gtk-sni-tray-prof, libghc-gtk-strut-dev (>= 0.1.2.1), libghc-gtk-strut-prof, libghc-haskell-gi-base-dev (>= 0.24), libghc-haskell-gi-base-prof, libghc-hslogger-dev, libghc-hslogger-prof, libghc-hspec-dev, libghc-hspec-prof, libghc-http-client-dev (>= 0.5), libghc-http-client-prof, libghc-http-client-tls-dev, libghc-http-client-tls-prof, libghc-http-conduit-dev, libghc-http-conduit-prof, libghc-http-types-dev, libghc-http-types-prof, libghc-multimap-dev (>= 1.2.1), libghc-multimap-prof, libghc-parsec3-dev (>= 3.1), libghc-parsec3-prof, libghc-rate-limit-dev (>= 1.1.1), libghc-rate-limit-prof, libghc-regex-compat-dev, libghc-regex-compat-prof, libghc-safe-dev (>= 0.3), libghc-safe-dev (<< 1), libghc-safe-prof, libghc-scotty-dev (>= 0.20), libghc-scotty-dev (<< 0.23), libghc-scotty-prof, libghc-split-dev (>= 0.1.4.2), libghc-split-prof, libghc-status-notifier-item-dev (>= 0.3.1.0), libghc-status-notifier-item-prof, libghc-time-locale-compat-dev (>= 0.1), libghc-time-locale-compat-dev (<< 0.2), libghc-time-locale-compat-prof, libghc-time-units-dev (>= 1.0.0), libghc-time-units-prof, libghc-tuple-dev (>= 0.3.0.2), libghc-tuple-prof, libghc-utf8-string-dev, libghc-utf8-string-prof, libghc-xdg-basedir-dev (>= 0.2), libghc-xdg-basedir-dev (<< 0.3), libghc-xdg-basedir-prof, libghc-xdg-desktop-entry-dev, libghc-xdg-desktop-entry-prof, libghc-xml-dev, libghc-xml-prof, libghc-xml-helpers-dev, libghc-xml-helpers-prof, libghc-xmonad-dev, libghc-xmonad-prof, libghc-optparse-applicative-dev, libghc-optparse-applicative-prof
Build-Depends-Indep: ghc-doc, libghc-hstringtemplate-doc, libghc-x11-doc, libghc-aeson-doc, libghc-ansi-terminal-doc, libghc-conduit-doc, libghc-data-default-doc, libghc-dbus-doc, libghc-dbus-hslogger-doc, libghc-dyre-doc, libghc-either-doc, libghc-extra-doc, libghc-enclosed-exceptions-doc, libghc-fsnotify-doc, libghc-gi-cairo-connector-doc, libghc-gi-cairo-render-doc, libghc-gi-gdk3-doc, libghc-gi-gdkpixbuf-doc, libghc-gi-gdkx113-doc, libghc-gi-glib-doc, libghc-gi-gtk-hs-doc, libghc-gi-gtk3-doc, libghc-gi-pango-doc, libghc-gtk-sni-tray-doc, libghc-gtk-strut-doc, libghc-haskell-gi-base-doc, libghc-hslogger-doc, libghc-hspec-doc, libghc-http-client-doc, libghc-http-client-tls-doc, libghc-http-conduit-doc, libghc-http-types-doc, libghc-multimap-doc, libghc-parsec3-doc, libghc-rate-limit-doc, libghc-regex-compat-doc, libghc-safe-doc, libghc-scotty-doc, libghc-split-doc, libghc-status-notifier-item-doc, libghc-time-locale-compat-doc, libghc-time-units-doc, libghc-tuple-doc, libghc-utf8-string-doc, libghc-xdg-basedir-doc, libghc-xdg-desktop-entry-doc, libghc-xml-doc, libghc-xml-helpers-doc, libghc-xmonad-doc
Package-List:
 libghc-taffybar-dev deb haskell optional arch=any
 libghc-taffybar-doc deb doc optional arch=all
 libghc-taffybar-prof deb haskell optional arch=any
 taffybar deb haskell optional arch=any
Checksums-Sha1:
 d8dbabfe2e21181359b4887510e523d5785c231d 130627 taffybar_4.1.1.orig.tar.gz
 546cb68fc3859d31aa41fda4888b6d14dcb5e1a1 4852 taffybar_4.1.1-1ubuntu3.debian.tar.xz
Checksums-Sha256:
 b582f3c409914d538a4cbd62d089545e7adacfd2f91980b8005447b09f1470b9 130627 taffybar_4.1.1.orig.tar.gz
 7873ccb60a533148415d17c2a28eddd1b2bdc8477b02eac6099e3719e7b65353 4852 taffybar_4.1.1-1ubuntu3.debian.tar.xz
Files:
 27e5ea7b5da79ca63235ca890a9683a1 130627 taffybar_4.1.1.orig.tar.gz
 155db86d270a83b2b9618c743e8eee31 4852 taffybar_4.1.1-1ubuntu3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkpeKbhleSSGCX3/w808JdE6fXdkFAmm4+3IACgkQ808JdE6f
XdmS5xAAkSh4y8ZF72cIF0ouKH7NgBvh3H5dUDk38lVi3WFAtX/eRqPUWsIoDPVB
XjKhTLGOFdTITzPnGozcDVodlPLQ95D4l5kTwsMpxVW8bLRAX6T18iMrP+gTHzlm
Rhk/Z+ci1tnLIZC2lf7S3A3B6Dgypw6owwNf2Sz9qpk0QZBpW4pi+xARUceleyIa
2eRR0xcOsY5eutquEBvOE4s4LMqiv0a/S/embAYAJ39PHgQYI28UUaqHMa8e8jwp
PZcc8cA7hxqfi161P/r1sVi4X6e62bs/PWIzNJAWQFgZkGU2jz9KqJs6Ri/B2eLm
+e0NERZas7ae5FvO8mHUufvRjFks0Qq4rjQxUjJdadSq9ZVYbgyLoM+ws4DLY3au
/malz3tpbzIUAxIVG1LV8o8o0JNo/pjYDAILp5SD6a6qVm91R6wNe+8dXhBgyVdp
HJL5t9lWTR8nsgIfb1X6gwkTrfF0PDLdnRCqG9eMVqDDpmqT7S0M/1g9ocb2BdbO
qveBIPKd1cPHV9x7tCjo/46G0MFyxpn7PEBD26vu2QcZWeFIToH4QDJYlE1L9vDk
gDFrE7Cpn/dWDvyyNtJKVIUz/ScgY4AcAdMk21BXeT+/JQP8OZax2vHUnG0zxmHZ
xcYkWm9VoO0nfSJSzk0jsEFq40sf/U+D/2NWtQK5d0NxR5MkeAM=
=9qC7
-----END PGP SIGNATURE-----
