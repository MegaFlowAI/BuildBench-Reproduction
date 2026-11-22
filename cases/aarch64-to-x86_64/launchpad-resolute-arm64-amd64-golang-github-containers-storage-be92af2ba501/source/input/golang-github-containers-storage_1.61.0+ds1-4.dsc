-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: golang-github-containers-storage
Binary: golang-github-containers-storage-dev, containers-storage
Architecture: any all
Version: 1.61.0+ds1-4
Maintainer: Debian Go Packaging Team <team+pkg-go@tracker.debian.org>
Uploaders: Reinhard Tartler <siretart@tauware.de>, Dmitry Smirnov <onlyjob@debian.org>
Homepage: https://github.com/containers/storage
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/go-team/packages/golang-github-containers-storage
Vcs-Git: https://salsa.debian.org/go-team/packages/golang-github-containers-storage.git
Testsuite: autopkgtest, autopkgtest-pkg-go
Testsuite-Triggers: @recommends@, bats, dh-golang, golang-any
Build-Depends: debhelper-compat (= 11), dh-golang, ffjson, go-md2man, golang-github-burntsushi-toml-dev, golang-github-containerd-btrfs-dev (>= 1.0.0), golang-github-containerd-stargz-snapshotter-dev (>= 0.8.0-3), golang-github-cyphar-filepath-securejoin-dev (>= 0.3.4), golang-github-docker-go-units-dev, golang-github-google-go-intervals-dev, golang-github-gotestyourself-gotest.tools-dev, golang-github-hashicorp-go-multierror-dev, golang-github-json-iterator-go-dev, golang-github-klauspost-compress-dev, golang-github-klauspost-pgzip-dev, golang-github-mattn-go-shellwords-dev, golang-github-moby-sys-dev (>> 0.0~git20241107), golang-github-opencontainers-go-digest-dev, golang-github-opencontainers-runc-dev, golang-github-opencontainers-selinux-dev (>= 1.5.0), golang-github-opencontainers-specs-dev, golang-github-pkg-errors-dev, golang-github-sirupsen-logrus-dev, golang-github-stretchr-testify-dev, golang-github-ulikunitz-xz-dev, golang-github-vbatts-tar-split-dev, golang-go (>> 2:1.14~~), golang-go-patricia-dev, golang-go-zfs-dev, golang-gocapability-dev, golang-golang-x-net-dev, golang-golang-x-sys-dev (>> 0.0~git20201223), libbtrfs-dev, libdevmapper-dev
Package-List:
 containers-storage deb golang optional arch=any
 golang-github-containers-storage-dev deb golang optional arch=all
Checksums-Sha1:
 1e5ff8fad8cb323b8eec60f0282b64ee0f79d932 408440 golang-github-containers-storage_1.61.0+ds1.orig.tar.xz
 be44331aa4b990cc89ae1b73e506d477dfb301fb 18276 golang-github-containers-storage_1.61.0+ds1-4.debian.tar.xz
Checksums-Sha256:
 de29d94a719a077e9937e423a01f1106b0195970f640ada8da94d58597059762 408440 golang-github-containers-storage_1.61.0+ds1.orig.tar.xz
 840e64882ffaa68f5969637e930a85c8d0ce2ecb5bf00db7b229af33d0fe9f48 18276 golang-github-containers-storage_1.61.0+ds1-4.debian.tar.xz
Files:
 9731bdaebb58e583ddc50856b85f7259 408440 golang-github-containers-storage_1.61.0+ds1.orig.tar.xz
 ed3c17b6251f42cc9c65e2de30f9780f 18276 golang-github-containers-storage_1.61.0+ds1-4.debian.tar.xz
Go-Import-Path: go.podman.io/storage
Dgit: 91a4acff1c85db8f8b2bc97ad51f193ffcf896a4 debian archive/debian/1.61.0+ds1-4 https://git.dgit.debian.org/golang-github-containers-storage
Git-Tag-Info: tag=cd3b1e3f44e35e86ad0d9837d533898cc4a0669f fp=30de7d1763ab9452c7e0825049a76977942826cb
Git-Tag-Tagger: Reinhard Tartler <siretart@tauware.de>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEN02M5NuW6cvUwJcqYG0ITkaDwHkFAmkqLE4ACgkQYG0ITkaD
wHlOJw/9ED01NCXaaaGmIb2Poxfe56v+CeASoS0pW3BSbzAVuL4oDAuWTWtPcShi
TYxmU+h8kq8A/OM8NJe4tx22+i3XbYNfIUe16YPe9zD2l2+WaEP3EIxhphT8y2DB
Our5xbfSCzfDV682LzNm0RERohkV4VmOkl14Mkv8x41sQaLdNQQOH64cemLOw1Su
owWWwzOx1url2/zOqX+W4qiNW9+11/xfNAk6D6CKTYXPa4wtRKVzWh9HJykCz1+V
sMVgzWff1JIZ6RSV2B2s4WNFw49KdsGF00h7vhhsxIfJllh6sBBeaf7miIWMmlwy
AETdrOfTOJbqvvsWeaOwOK05mHECPNL7EqNuCuwXs8RyP12N45IdVLiwC70nO0Kh
y9mPz/v9OAvlCG521oBX8Oo0C/PMMYqPcJw4RJ0R/6B8ja4B/c87sOunf6L9ab2E
UPPehfmSqEUfOVCo+SjRes6V8UkobBiNEYG+aSq+kNgJSbeuFTFe5iE+82KgED02
nlYyrMY93Klv3j3y3pjYKdNOH5hVzJ24cuESlDaW/4o0mDmkA4VxQaUKHY7YwmCB
gAA9xQEwtT0Yv8Jvxz+Z32LMfxJ8ulzJ6zpijMQ1eHjy7s8vVTMy68uNo3cV3VS9
5786NWEdXT/fWTsOnOkT9ks2HAg2YpGux3oU5tDzoZ2Ivygo5Qw=
=O1WX
-----END PGP SIGNATURE-----
