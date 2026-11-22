-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: jellyfish
Binary: jellyfish, libjellyfish-2.0-2, libjellyfish-2.0-dev, python3-dna-jellyfish, libjellyfish-perl, jellyfish-examples
Architecture: amd64 arm64 armel armhf i386 mips64el ppc64el hppa hurd-i386 ia64 kfreebsd-amd64 kfreebsd-i386 riscv64 loong64 all
Version: 2.3.1-2
Maintainer: Debian Med Packaging Team <debian-med-packaging@lists.alioth.debian.org>
Uploaders: Shaun Jackman <sjackman@debian.org>, Andreas Tille <tille@debian.org>, Michael R. Crusoe <crusoe@debian.org>, Étienne Mollier <emollier@debian.org>
Homepage: https://github.com/gmarcais/Jellyfish
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/med-team/jellyfish
Vcs-Git: https://salsa.debian.org/med-team/jellyfish.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@
Build-Depends: debhelper-compat (= 13), d-shlibs, autoconf-archive, yaggo, pkg-config, bc, time, procps, swig, python3-all-dev, dh-sequence-python3, perl, chrpath, libhts-dev, dos2unix, samtools
Package-List:
 jellyfish deb science optional arch=amd64,arm64,armel,armhf,i386,mips64el,ppc64el,hppa,hurd-i386,ia64,kfreebsd-amd64,kfreebsd-i386,riscv64,loong64
 jellyfish-examples deb science optional arch=all
 libjellyfish-2.0-2 deb libs optional arch=amd64,arm64,armel,armhf,i386,mips64el,ppc64el,hppa,hurd-i386,ia64,kfreebsd-amd64,kfreebsd-i386,riscv64,loong64
 libjellyfish-2.0-dev deb libdevel optional arch=amd64,arm64,armel,armhf,i386,mips64el,ppc64el,hppa,hurd-i386,ia64,kfreebsd-amd64,kfreebsd-i386,riscv64,loong64
 libjellyfish-perl deb perl optional arch=amd64,arm64,armel,armhf,i386,mips64el,ppc64el,hppa,hurd-i386,ia64,kfreebsd-amd64,kfreebsd-i386,riscv64,loong64
 python3-dna-jellyfish deb python optional arch=amd64,arm64,armel,armhf,i386,mips64el,ppc64el,hppa,hurd-i386,ia64,kfreebsd-amd64,kfreebsd-i386,riscv64,loong64
Checksums-Sha1:
 9aaf5f07cecf638544d27ca3de7cb7057184c92c 681990 jellyfish_2.3.1.orig.tar.gz
 3e2e3cd80e7dbf493cd330a52f0f4220e8d17c72 13924 jellyfish_2.3.1-2.debian.tar.xz
Checksums-Sha256:
 540d09457fb4e14b98c7f1428cf885c333e2d6ef4f6a3735aa06be13eb523d69 681990 jellyfish_2.3.1.orig.tar.gz
 1b431f9062e9379aa0fac783c008ae5328ba499b0fe82573f59082a023c7d144 13924 jellyfish_2.3.1-2.debian.tar.xz
Files:
 27fb29ad3edfe25d776cfbf98dcc8c0e 681990 jellyfish_2.3.1.orig.tar.gz
 026bc276a5b6db11f005a2d3a5aa7ea4 13924 jellyfish_2.3.1-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAyFiEEj5GyJ8fW8rGUjII2eTz2fo8NEdoFAmWSpe4UHGVtb2xsaWVy
QGRlYmlhbi5vcmcACgkQeTz2fo8NEdrspg/4hNJYLRRsXCV/BWup/FD36eNWSebG
Ku6azC8syCcd6lxPXkkCH9UTWraJRLKN9WgCtTjAt+E/6miacd7FUtCy/q+pZsSS
kpvnU8XaGqFLtRt4Q1qiSe7uAa8jpP5QkHipkW4l7X8eT0TqNHbXuqcmfSM2Qve+
RC4XNuwyox1So/h+rp82RrexYkaLTUQnTXi/fPDMgIw3dEN6Kg6pgoi44wp9+y3J
Z+8p/uD93cr7O571CEzlavoFJMqZSF0rGKZn11V3wCCk/quDPhvj0xswAyf7WRA1
1MCbHOGFSADKai5S3fsZ6VRnem7SKxCP9JReIZPOnuV5mcshe1EGsHxKOjlB9DiE
Jt73+BZ5fHrimx84slWn/Xy025PIKpWgNpuB08denAsQ4pD9vOxm15uFxfgI6qPL
tRswTrYxNsT0dtlh9YUTs+xrVKJurkF2/EM5fO/PcSnvj2W6D2mFUNPNnhzsKmn3
MXnBjXhzkY+vpzB4o8AtpE5BwAN+S412BMiRpwBA6uIvnvHqW/l+l/YrjF37awJR
21mcukmuZB76hMt8rFluEN/eB2S7yQB5F3Cv+hAqMVn0o+7EEn3xl0JwBl6tFxel
dsM1P2RUIT9RwGKcge1fcTT+yDastQQArKMK+pHZabmjK/uBpRLV5WwgG5QHuSHd
micFw3z0+SMVcA==
=e7Xg
-----END PGP SIGNATURE-----
