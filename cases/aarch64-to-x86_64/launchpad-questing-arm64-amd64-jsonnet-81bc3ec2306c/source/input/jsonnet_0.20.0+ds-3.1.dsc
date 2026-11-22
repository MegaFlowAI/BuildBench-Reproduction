-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: jsonnet
Binary: jsonnet, libjsonnet0, libjsonnet-dev, python3-jsonnet
Architecture: amd64 arm64 armhf i386 armel loong64 ppc64el riscv64
Version: 0.20.0+ds-3.1
Maintainer: Fukui Daichi <a.dog.will.talk@akane.waseda.jp>
Homepage: https://github.com/google/jsonnet
Standards-Version: 4.7.2
Vcs-Browser: https://salsa.debian.org/debian/jsonnet
Vcs-Git: https://salsa.debian.org/debian/jsonnet.git
Testsuite: autopkgtest
Testsuite-Triggers: python3
Build-Depends: debhelper-compat (= 13), python3-all, python3-all-dev, cmake, dh-python, googletest, libgtest-dev, python3-setuptools, help2man
Package-List:
 jsonnet deb devel optional arch=amd64,arm64,armhf,i386,armel,loong64,ppc64el,riscv64
 libjsonnet-dev deb libdevel optional arch=amd64,arm64,armhf,i386,armel,loong64,ppc64el,riscv64
 libjsonnet0 deb libs optional arch=amd64,arm64,armhf,i386,armel,loong64,ppc64el,riscv64
 python3-jsonnet deb python optional arch=amd64,arm64,armhf,i386,armel,loong64,ppc64el,riscv64
Checksums-Sha1:
 5ddf8b4e19b011b9f0d1daa957096bf6217e89d4 1169196 jsonnet_0.20.0+ds.orig.tar.xz
 52cb4ff1bbdd103525790e49d953d4726ce1bacc 519792 jsonnet_0.20.0+ds-3.1.debian.tar.xz
Checksums-Sha256:
 6b9880ca75cb74d2d209bb33e6b1b49aa8a89f926e28d26324ef6bccfebf2556 1169196 jsonnet_0.20.0+ds.orig.tar.xz
 66adcf6ddde9a3015d9b8568485437f1071b44b8eaab0a564c1ef041e8073f38 519792 jsonnet_0.20.0+ds-3.1.debian.tar.xz
Files:
 b37e3b7d2752f036d5ef244d23587bf4 1169196 jsonnet_0.20.0+ds.orig.tar.xz
 c89763796d696e89e0e9a5646261256e 519792 jsonnet_0.20.0+ds-3.1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEOvp1f6xuoR0v9F3wiNJCh6LYmLEFAmhiln8ACgkQiNJCh6LY
mLG6NxAAqdzga7Hg2dbrrBbrCdxxAIcfl/0GMZNSEsgaJKcwy+XglmNKLU6RwkCt
4D9RfRVGNv/jTnF6PqPET0eDePDF9346EQpcsc6Yu8bNJXHeElZfXwcukfMeCLrD
MCns5h2J4Mjj5Luj/gGEQK8E6onVHR8nmqNpvapG8XEcnU7+XRlrDuQGTIGDXoqg
GK+yzrgYpJWsu5lpPQ+oVGJobG7M2m1od3s1mhAWaCSwa3Nk4bSmQGYkiBvPzgFw
pcCPIug/UP5kFJhGTlHYUY5H3JmBp+Kir7vTI/93+T/425G1kmWBPpA83qYMqhKz
xXL82cv/CPu/oqYFzuGiuIXAklxDU8ihV8vyyIu59z2BqW6X5P0vZb1lK4wjXzXd
4muzth9vu8aZMYg/cwiQu7/43p5odOALUaWpubq5Wec3+RvQ2UJvEXEdyE50/xlc
Q09RtwcQH0p2n9A3bEBZu8N8hLowXZ0Nozcl51QVHdNdz8n/eGq+3Rqf1AvFP57U
PYgslhoGNwQmxvX6aCUDWAWXHg10i7QFX+GldtVqkPvbUx6C+Q9TXRH6OtOqFi5H
+8LY+wQnU/AQS5XzZpswj6TxUeQNePbmNLyK3gtyMA4Vyf5yiSLF78lVeGxgVAyq
iiDPXSELgAR1fTNeb1qmmFwUTVBaqxF20K/YvMXTkPYHwp8ABTI=
=/uN9
-----END PGP SIGNATURE-----
