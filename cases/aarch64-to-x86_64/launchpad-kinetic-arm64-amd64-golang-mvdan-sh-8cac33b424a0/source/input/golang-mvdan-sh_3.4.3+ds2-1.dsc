-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: golang-mvdan-sh
Binary: golang-mvdan-sh-dev, shfmt
Architecture: any all
Version: 3.4.3+ds2-1
Maintainer: Debian Go Packaging Team <team+pkg-go@tracker.debian.org>
Uploaders: Andreas Tille <tille@debian.org>, Nilesh Patra <nilesh@debian.org>,
Homepage: https://github.com/mvdan/sh
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/go-team/packages/golang-mvdan-sh
Vcs-Git: https://salsa.debian.org/go-team/packages/golang-mvdan-sh.git
Testsuite: autopkgtest-pkg-go
Build-Depends: debhelper-compat (= 13), dh-golang, golang-any, golang-github-creack-pty-dev, golang-github-frankban-quicktest-dev, golang-github-google-go-cmp-dev, golang-github-google-renameio-dev, golang-github-pkg-diff-dev, golang-github-rogpeppe-go-internal-dev, golang-golang-x-sync-dev, golang-golang-x-sys-dev, golang-golang-x-term-dev, golang-mvdan-editorconfig-dev, scdoc
Package-List:
 golang-mvdan-sh-dev deb golang optional arch=all
 shfmt deb golang optional arch=any
Checksums-Sha1:
 72b68ad2241434cda7fb3d7d7abe2a2e5ac33f40 157372 golang-mvdan-sh_3.4.3+ds2.orig.tar.xz
 c49a50a3347bd09d124015bc35f7368d082d54d6 3268 golang-mvdan-sh_3.4.3+ds2-1.debian.tar.xz
Checksums-Sha256:
 a3cfefb460493e7ee960e5e17fa918d856756844fd5da9beda5a89959a015877 157372 golang-mvdan-sh_3.4.3+ds2.orig.tar.xz
 457beef6bb2834811f17567ed532a34763fb876bc60bbbb86124e0e236a3702f 3268 golang-mvdan-sh_3.4.3+ds2-1.debian.tar.xz
Files:
 5e015da917e7e40e5b1447d658a545a5 157372 golang-mvdan-sh_3.4.3+ds2.orig.tar.xz
 cd2197cbe744fc5fcf42bde9e9a08fb2 3268 golang-mvdan-sh_3.4.3+ds2-1.debian.tar.xz
Go-Import-Path: mvdan.cc/sh/v3

-----BEGIN PGP SIGNATURE-----

iIYEARYIAC4WIQSRhdT1d2eu7mxV1B5/RPol6lUUywUCYmwEYRAcemhzakBkZWJp
YW4ub3JnAAoJEH9E+iXqVRTL+t8BAOZ/UfEusDwnSo9ANUya37BUvh1YAq3cXfko
D/V0R3vzAQD05zTGChcvGq0YwuVvTPdegojX5m8Sl6Z2OKtYHLe+DQ==
=pRNy
-----END PGP SIGNATURE-----
