-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: inetutils
Binary: inetutils-syslogd, inetutils-inetd, inetutils-ping, inetutils-traceroute, inetutils-tools, inetutils-ftp, inetutils-ftpd, inetutils-telnet, telnet, inetutils-telnetd, telnetd, inetutils-talk, inetutils-talkd
Architecture: any all
Version: 2:2.6-1ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://www.gnu.org/software/inetutils/
Standards-Version: 4.7.1
Vcs-Browser: https://git.hadrons.org/cgit/debian/pkgs/inetutils.git
Vcs-Git: https://git.hadrons.org/git/debian/pkgs/inetutils.git
Testsuite: autopkgtest
Testsuite-Triggers: autoconf, automake, build-essential, file, gettext, net-tools, netbase
Build-Depends: debhelper-compat (= 13), debhelper (>= 13.10), netbase <!nocheck>, net-tools <!nocheck>, autoconf, automake, bison, gnulib, libreadline-dev, libncurses-dev, libpam0g-dev, libwrap0-dev, libkrb5-dev
Package-List:
 inetutils-ftp deb net optional arch=any
 inetutils-ftpd deb net optional arch=any
 inetutils-inetd deb net optional arch=any
 inetutils-ping deb net optional arch=any
 inetutils-syslogd deb net optional arch=any
 inetutils-talk deb net optional arch=any
 inetutils-talkd deb net optional arch=any
 inetutils-telnet deb net standard arch=any
 inetutils-telnetd deb net optional arch=any
 inetutils-tools deb net optional arch=any
 inetutils-traceroute deb net optional arch=any
 telnet deb oldlibs optional arch=all
 telnetd deb oldlibs optional arch=all
Checksums-Sha1:
 af51b509faa1fe386e98c0e12371d7021885e798 1764528 inetutils_2.6.orig.tar.xz
 93710d3c3117078de4496a16f2131c3f5ff61d4d 1223 inetutils_2.6.orig.tar.xz.asc
 024703f2c1efbd86c19437deb37143299d8ce11e 78528 inetutils_2.6-1ubuntu2.debian.tar.xz
Checksums-Sha256:
 68bedbfeaf73f7d86be2a7d99bcfbd4093d829f52770893919ae174c0b2357ca 1764528 inetutils_2.6.orig.tar.xz
 2438861e2eccf5faf5dba7b83b6b9f6bc7ee83a812315edaa1479342a90adaa7 1223 inetutils_2.6.orig.tar.xz.asc
 bad506ba07269816cdfb5842ab498db1303d93b7351090bb4424367dfccfda86 78528 inetutils_2.6-1ubuntu2.debian.tar.xz
Files:
 401d7d07682a193960bcdecafd03de94 1764528 inetutils_2.6.orig.tar.xz
 48fbf0784119520fd03ff3b6a6f23d83 1223 inetutils_2.6.orig.tar.xz.asc
 1bff958140c0348ae1c28b5b39aeb51f 78528 inetutils_2.6-1ubuntu2.debian.tar.xz
Original-Maintainer: Guillem Jover <guillem@debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEJeP/LX9Gnb59DU5Qr8/sjmac4cIFAmi6/d4ACgkQr8/sjmac
4cKnRA//TyOmzMHVoxNN0jtya1ndz3jemDbzHqDRolSm+UgBjWigzm+bZVD8lj8t
TvWGGjJYmEuqWVCCFDiRHE5J9iYXe+jykocpLnupnaFiUmc1v2gRtp0cjMJr5gzm
krLCWULykNXz4CceIf3+gHA+JUKeE6aKgtQA8VJ8zfxMqafA8M0pGg9xbPj1GUkp
vdbmbEoFL/gZUIbQ/HTYMVFQhtq3W0TAXt27YXioQVred/UaAvqQhwf1beE4Aw3h
czI4wutLl6rQxm42yOKSySe0mpCrWyrwOl02YemxwRmoHiCpP2byONRly6JzejcN
xd+uG8HFR1FOWJdyz9DrXS7HY0lSPEdVdLFG64THADCkhLz41vTzR0hNhtXjvyFm
lz0S9hzmvadu40HtlkU/BDo0979Eydth7EAzRbo4Z/hrSB0ihbBWBwGeV9ztQdmv
EQ0R9OutTJDNnJc1ghhLK67K22POLrL8pqFm2qOe0plOpx81zNaEAnhUEdIAqxGm
Fr0nyCWhZHYoi6AK0PlRTu/v1nDlEvSeohQRkDuTG8La3iwsWZ4i/EUWAWcTUQd+
vNoS5S9P0CP6ws0ordPE4jFc/kh4j5WMd+xhE3dxThC/qN7xj+dWUnwV5DuiGm/i
38u3vL7Q5exfxmvudV44bcQpzJY2o1NZqDzMx+7ZnzIzbUHy8gM=
=VdGg
-----END PGP SIGNATURE-----
