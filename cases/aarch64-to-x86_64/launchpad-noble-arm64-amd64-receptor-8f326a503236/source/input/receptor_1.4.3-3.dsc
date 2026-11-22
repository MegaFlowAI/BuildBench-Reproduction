-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: receptor
Binary: golang-github-ansible-receptor-dev, receptor, receptor-doc, python3-receptorctl, python3-receptor-python-worker
Architecture: any all
Version: 1.4.3-3
Maintainer: Debian Go Packaging Team <team+pkg-go@tracker.debian.org>
Uploaders: Jérémy Lal <kapouer@melix.org>
Homepage: https://github.com/ansible/receptor
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/go-team/packages/receptor
Vcs-Git: https://salsa.debian.org/go-team/packages/receptor.git
Testsuite: autopkgtest-pkg-go
Build-Depends: debhelper-compat (= 13), dh-sequence-golang, dh-sequence-python3, dh-sequence-sphinxdoc, sphinx, pybuild-plugin-pyproject, python3-setuptools, python3-all, python3-pytest, python3-urllib3, python3-click, python3-dateutil, python3-yaml, tox, ca-certificates, help2man, lsof, psmisc, openssh-client, golang-any, golang-github-creack-pty-dev, golang-github-fortytw2-leaktest-dev, golang-github-fsnotify-fsnotify-dev, golang-github-ghjm-cmdline-dev, golang-github-golang-jwt-jwt-dev, golang-github-golang-mock-dev, golang-github-google-shlex-dev, golang-github-gorilla-websocket-dev, golang-github-minio-highwayhash-dev, golang-github-pbnjay-memory-dev, golang-github-quic-go-quic-go-dev, golang-github-rogpeppe-go-internal-dev, golang-github-songgao-water-dev, golang-github-vishvananda-netlink-dev, golang-golang-x-net-dev, golang-gopkg-yaml.v2-dev, golang-k8s-api-dev, golang-k8s-apimachinery-dev, golang-k8s-client-go-dev
Package-List:
 golang-github-ansible-receptor-dev deb golang optional arch=all
 python3-receptor-python-worker deb python optional arch=all
 python3-receptorctl deb python optional arch=all
 receptor deb web optional arch=any
 receptor-doc deb doc optional arch=all
Checksums-Sha1:
 54de85fcaf088dff6ea49a839895c7d6efb499a0 3606 receptor_1.4.3.orig-golang-github-jupp0r-go-priority-queue.tar.gz
 27fd2fa1f4ca64370e845e73c9611fc209eb49b5 2661 receptor_1.4.3.orig-golang-github-prep-socketpair.tar.gz
 bf17604ad8b6052c3a141199763a7a9126d51e62 361758 receptor_1.4.3.orig.tar.gz
 e1dbf27e0d01460fc53e81f8e8ab899068ad0f3e 24832 receptor_1.4.3-3.debian.tar.xz
Checksums-Sha256:
 05a7cad9be1f344b7158cd7bdfa73c8c73d3feb8da551b644ff2fc548983d0a4 3606 receptor_1.4.3.orig-golang-github-jupp0r-go-priority-queue.tar.gz
 e1104733a326e1b7a724586342080e238438303d55125be52d4cfb5837bc345e 2661 receptor_1.4.3.orig-golang-github-prep-socketpair.tar.gz
 9886eabf11b822833dc39bb8b61d33e277b446b7ba855db05ae169a6e2f8b3d2 361758 receptor_1.4.3.orig.tar.gz
 3be1ae271b9ded064e4523cbee0f03331e056171acdefc45592fae039779c4f8 24832 receptor_1.4.3-3.debian.tar.xz
Files:
 aecdf7bfa2b9016c67e068435dbba03f 3606 receptor_1.4.3.orig-golang-github-jupp0r-go-priority-queue.tar.gz
 c7319edfd5843f42c9b79d2ea5fd431e 2661 receptor_1.4.3.orig-golang-github-prep-socketpair.tar.gz
 07052fb570eaa54ba93ba2cd4bba37df 361758 receptor_1.4.3.orig.tar.gz
 719f576b2139d02c997760d4b44490c0 24832 receptor_1.4.3-3.debian.tar.xz
Go-Import-Path: github.com/ansible/receptor

-----BEGIN PGP SIGNATURE-----

iQJGBAEBCAAwFiEEA8Tnq7iA9SQwbkgVZhHAXt0583QFAmWaAXwSHGthcG91ZXJA
bWVsaXgub3JnAAoJEGYRwF7dOfN0cUsP/3BE1HACIyUFkN0DJ4CQstiXJtscp8in
pi56gWD8at0RVEw4IYyDNkjXQnLsbAabJCQosNWhtm9xmChnKwq7gUkWIMyzWuOc
D/3E2pqjKgPZnoPGFQUiCoQn4z/b+B+vbP+xR0VN3VXVHNLfpIp9GW0z1oL62nvG
Gy0GWbNx8OKuUh+GKMLKDAh2IflbIZb+zr4bUHX7NufWMaDZ9Tqvx1LekW7ftZGR
KS037YNtqPKd1IK0TkNnM2XrufFUeGlkEapAtxkjn8W/oBiK/Pfw8xp7YS2hUgb1
rIchCL2oKRbJ5nn4PivfIwUUBlliJr3hoXGDiTlRw+4xHSH9mc2FHZJMC6ai9JGP
s3b0dkHtzTsooVsZw8eYaURAvaDxirJxmXpE8sbcQX2nN+EReM+CNUcLm4k7AkLB
9/qu2MBlb+jS/mwzc0cLb2yj5a/WsIM6o2cq8vc+yX2gH8tfXjL+kV2ICju9Y/Ao
C0kiMsjrjjpK9XJjQ9SldoBjjloAIctQqY7HSbXwVDVJbmL2VL2Fwdf2GwQnDJ9/
7ONwyVnfsc9Nj2KlOAh2IJ2++lVPAPnl2GPzeb3R0X98JYCkpYu/27CcGHcD0Jq3
RBLq/soCyu+fMrSMWl+x7fuBOKp3hGiXNAwScHguEaswhoqopBBKxGVqKG7tNT81
lktWb2B4JIzv
=dEJM
-----END PGP SIGNATURE-----
