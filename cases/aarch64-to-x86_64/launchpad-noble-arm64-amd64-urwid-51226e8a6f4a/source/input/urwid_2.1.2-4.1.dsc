-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: urwid
Binary: python3-urwid, python-urwid-doc
Architecture: any all
Version: 2.1.2-4.1
Maintainer: Debian Python Team <team+python@tracker.debian.org>
Uploaders: Ian Ward <ian@excess.org>
Homepage: https://urwid.org/
Description: curses-based UI/widget library
 Urwid is a console user interface library that includes many features
 useful for text console application developers including:
 .
  * Fluid interface resizing (xterm window resizing/fbset on Linux console)
  * Web application display mode using Apache and CGI
  * Support for UTF-8, simple 8-bit and CJK encodings
  * Multiple text alignment and wrapping modes built-in
  * Ability to create user-defined text layout classes
  * Simple markup for setting text attributes
  * Powerful list box that handles scrolling between different widget types
  * List box contents may be managed with a user-defined class
  * Flexible edit box for editing many different types of text
  * Buttons, check boxes and radio boxes
  * Customizable layout for all widgets
  * Easy interface for creating HTML screen shots
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/python-team/packages/urwid
Vcs-Git: https://salsa.debian.org/python-team/packages/urwid.git
Testsuite: autopkgtest-pkg-python
Build-Depends: debhelper-compat (= 13), dh-sequence-python3, dh-sequence-sphinxdoc, locales-all, python3-twisted, python3-all-dev, python3-setuptools, python3-sphinx
Package-List:
 python-urwid-doc deb doc optional arch=all
 python3-urwid deb python optional arch=any
Checksums-Sha1:
 4ad6eb1cfc8d2c1a53aeab7f47091d6381b6061e 634621 urwid_2.1.2.orig.tar.gz
 90f26507c72d0fac49c1d683ab7f00367ab388f5 6576 urwid_2.1.2-4.1.debian.tar.xz
Checksums-Sha256:
 588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae 634621 urwid_2.1.2.orig.tar.gz
 c9dedd303170733083d51bcb0c09ef2ded4bc5c0025bd1c2fe56a8d2a27b5f29 6576 urwid_2.1.2-4.1.debian.tar.xz
Files:
 f7f4e6bed9ba38965dbd619520f39287 634621 urwid_2.1.2.orig.tar.gz
 f51880afcddf0dcb44af789ee0422349 6576 urwid_2.1.2-4.1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEVovyKmYzfL/Jprm3LIPbyOm9DjcFAmWSxnkACgkQLIPbyOm9
DjdFGw//btF7gI9wNjpM0MVSnig8JJhg6EhoHOJnZSvPFV6SrZRTi6mP6Iw0WKfe
tZYqiYErXjtGcq1o9r23xbxTYD3mh7pIikJAByOwbwTzYWj83WdcMXejLMqWmPqX
iHiOg6jG6hzKgFIUj32iGVfTpcgI6rWGWywfgdOwOIKzCasHpsTfRKS6uKEhsJn2
yGoZ+nYnA4+uiIPgkV/cnEOR43xeUfjoYrgN+Q9WzfEv2FIJ6vHgJwnLsQOgBx9S
XYn16Ge0j3PZRYFW9IMpu/rTnpswD/Y0ps+W99hdEKRychKYeKiAdVp7uoQfwvqn
YskH2HpMMPcCLcMgKUz7KBdwV5SuuxgCCH3TzSKZWbteo85f0qfGVBsYVKFSGjmK
bGUniyxCJJGOVxcwwbrNVnWsQTbDghyKXdXlynQFDSfWKWbynKMu421H6wtffl5X
o9HseXMShanP7wbixr5QNjQ+PQiHN7IykUS5ZrseUnooZn4F5Iq5IYpZfzaAQEYE
53wd11xS5q3yxL9P3qY+qJZcDXggV5bxM8Jpi/57/S4upiw/rDfvUijGVX35oRuN
DbC+ishVVn6IzLdzY7z0EBY6YEI2JaY4168UPA+BFV6odKDN5ETAqZPZhuq8xLCy
STWzlYmsYYeswrriwwE0VAnNVMioeLP6cOII+Jt0uZDz3/cd5XM=
=IxEh
-----END PGP SIGNATURE-----
