-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: lib1305
Binary: lib1305-1, lib1305-dev, poly1305
Architecture: any
Version: 0~20250415-3ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Simon Josefsson <simon@josefsson.org>, Jan Mojžíš <janmojzis@debian.org>,
Homepage: https://lib1305.cr.yp.to/
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/debian/lib1305
Vcs-Git: https://salsa.debian.org/debian/lib1305.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dpkg-dev, libcpucycles-dev, librandombytes-dev, python3, rsync, valgrind-if-available
Build-Depends: debhelper-compat (= 13), dh-python, libcpucycles-dev, librandombytes-dev, pandoc [!m68k !sh4 !x32] <!nodoc>, python3, python3-capstone, valgrind-if-available
Package-List:
 lib1305-1 deb libs optional arch=any
 lib1305-dev deb libdevel optional arch=any
 poly1305 deb devel optional arch=any
Checksums-Sha1:
 81394c755135e4205960ea43def925ba1fa26533 864878 lib1305_0~20250415.orig.tar.gz
 373ddeca1bc8bac4d638acd7e256787eb6acb174 5764 lib1305_0~20250415-3ubuntu1.debian.tar.xz
Checksums-Sha256:
 ac20c0a49898db23e237ac208f876cab83dcfc952d690ec96d8038bb22204c5e 864878 lib1305_0~20250415.orig.tar.gz
 b0ce47cd9f9b95c920b12fe0ae5883f450d7db74110939ba5686bea41268a155 5764 lib1305_0~20250415-3ubuntu1.debian.tar.xz
Files:
 b6f701328d5bc4d4fd89ffb4676af4b6 864878 lib1305_0~20250415.orig.tar.gz
 a85ac9316ccb3e91523be5cd7afd9580 5764 lib1305_0~20250415-3ubuntu1.debian.tar.xz
Original-Maintainer: Debian Security Tools <team+pkg-security@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEpi0s+9ULm1vzYNVLFZ61xO/Id0wFAmk/9kAACgkQFZ61xO/I
d0w++g//dGWh/Q3YzQuG46wKdnA6xX37VmhV/uTz4jvQT77cr0ajm1KuZl7Rm5Rf
MvE7k+doBw8hWMiR+wyNdBR+Dhgdq2HwU4FWNWC9/hKmsTQDpxTwa1YDjSVb52Ru
MOawlqPzTY1U6+YdqQNynrbtqePFny0MZfJsfL4Q3VH70OK/xWBhJ92O32D0jUcd
rH1wJu3tNrx8MD6c8IykHZ97L6wKbXBG2xl27NE96FRYB1rsohBps+Qw8DwfLb8S
n9P1skQoD0AXI03LRUyxZBtXl7QOtyXC2g/T1iDAKNjD1MViSQkC3vhbiV03iIRz
psW7mAQYL+2lBHCpi5qsDZ0UxxUcURFIFWF+wspubxqaQR+I6J1WPkT3Hw8lY2lh
3lZ39SxLGSKAXzZkQrhhRlKJ8t7kak2Zzgkj6Z41ynA7u8CMeVCH5m0h4JnSNM7B
XkFNfxploebZBQk5mr7F8EUJWIf3rpKEhxYlYIqjFtCxj1TZVMVlrGwyI6/OMpsp
S0wpWLNCb0EN06y/jtpGHuALMWylPX7iNRkKLu5jWtzdbo7L4Df2oszv6nRBjs0x
AZ5fZWrh/xlDq0xnmYWynAFwxZmyBhnM1LmNLdTdrfNIoAPS/i35WVeQB3yRnSev
q3X0gfQSdWa5BTFQZODCt9jp3bwdjO05xG1RIJZUxxDfVJWCjko=
=KtFI
-----END PGP SIGNATURE-----
