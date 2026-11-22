-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: nginx
Binary: nginx, nginx-doc, nginx-common, nginx-dev, nginx-core, nginx-full, nginx-light, nginx-extras, libnginx-mod-http-geoip, libnginx-mod-http-image-filter, libnginx-mod-http-xslt-filter, libnginx-mod-mail, libnginx-mod-stream, libnginx-mod-stream-geoip, libnginx-mod-http-perl
Architecture: any all
Version: 1.26.0-1ubuntu1
Maintainer: Debian Nginx Maintainers <pkg-nginx-maintainers@alioth-lists.debian.net>
Uploaders: Jan Mojžíš <jan.mojzis@gmail.com>
Homepage: https://nginx.org
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/nginx-team/nginx
Vcs-Git: https://salsa.debian.org/nginx-team/nginx.git
Testsuite: autopkgtest
Testsuite-Triggers: curl, libnginx-mod-http-auth-pam, libnginx-mod-http-brotli-filter, libnginx-mod-http-brotli-static, libnginx-mod-http-cache-purge, libnginx-mod-http-dav-ext, libnginx-mod-http-echo, libnginx-mod-http-fancyindex, libnginx-mod-http-geoip2, libnginx-mod-http-headers-more-filter, libnginx-mod-http-memc, libnginx-mod-http-set-misc, libnginx-mod-http-srcache-filter, libnginx-mod-http-subs-filter, libnginx-mod-http-uploadprogress, libnginx-mod-http-upstream-fair, libnginx-mod-nchan, libnginx-mod-rtmp, libnginx-mod-stream-geoip2, ssl-cert
Build-Depends: debhelper-compat (= 13), libexpat-dev, libgd-dev, libgeoip-dev, libpcre2-dev, libperl-dev, libssl-dev, libxslt1-dev, po-debconf, zlib1g-dev
Package-List:
 libnginx-mod-http-geoip deb httpd optional arch=any
 libnginx-mod-http-image-filter deb httpd optional arch=any
 libnginx-mod-http-perl deb httpd optional arch=any
 libnginx-mod-http-xslt-filter deb httpd optional arch=any
 libnginx-mod-mail deb httpd optional arch=any
 libnginx-mod-stream deb httpd optional arch=any
 libnginx-mod-stream-geoip deb httpd optional arch=any
 nginx deb httpd optional arch=any
 nginx-common deb httpd optional arch=all
 nginx-core deb httpd optional arch=all
 nginx-dev deb httpd optional arch=all
 nginx-doc deb doc optional arch=all
 nginx-extras deb httpd optional arch=any
 nginx-full deb httpd optional arch=all
 nginx-light deb httpd optional arch=all
Checksums-Sha1:
 798390eae26a25e91d158891b341596eaddd0dea 1244118 nginx_1.26.0.orig.tar.gz
 61daca79ef7cc3364632b70ba0a3a706dfb6e019 83484 nginx_1.26.0-1ubuntu1.debian.tar.xz
Checksums-Sha256:
 d2e6c8439d6c6db5015d8eaab2470ab52aef85a7bf363182879977e084370497 1244118 nginx_1.26.0.orig.tar.gz
 f4ec05ab07c939923d9a1fb7d408cbd08b3e9e769ca55007b48049f9e086d4e8 83484 nginx_1.26.0-1ubuntu1.debian.tar.xz
Files:
 bb1b92cf7d72efcc0da343b057f23516 1244118 nginx_1.26.0.orig.tar.gz
 1a4351caaa0543885ab5129cb2a6e95a 83484 nginx_1.26.0-1ubuntu1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkpeKbhleSSGCX3/w808JdE6fXdkFAmZblpEACgkQ808JdE6f
XdnM0Q/+MHddFPIXwbgEgIkpu/4ZTX4K1pAii42jykOXBsr9unkdictOGDdcajet
32izmisNp6HbXUSs7Gza8Ntvwm1MjwK0GCCcn3dRH5Ot7PoWnH4emJn2asIbnDZc
/hr+1SbNQcM6XWtpDKeGh6suKD7dnj1Q7LE7K0FnUk8mAM6gjpk3eZDrxvE6FUQy
s9IQ1HqV/VFqgmJweJ2V043KKqJO1FHNXpLjRM1wtxq3kU8oauSFRNawzyoSYCmj
UBPcxkkN+s8ZqFoOns3IXTWul2VBoxf2h3uJBPseBtNQu9e1ErTFGqSVKQCFQ7Fj
QCbVI/OD2RLOMIonU1me/cfY3lvFlVucJ5x3MpN1VMVo/iC1Xgefa0rZWZoBnv0J
9w5Wlid9CEUqEfqXXr/LMl/+uwYUmkF+rJuYOl9UiSwUPg4dyBSIn/OvmJY5GRdM
/SkjRzKy8d5wtuUBnvAEYNsXE+Q7l4JqLRKwVZXZ2zAXbEKkB2eGSavHgzEHFsJf
Pi76IiZzwjV0gEzEzOkjGxug4aeo/v7TeDznFFG90GumJT3LZT4TrmPf9ZP3xoW5
+YAQZfDgX4NGZ393LdtXyt02VCGhzvq2emLP7qQ/CK4bW9FBjvWRh4mGrb9ZkWKp
Dt0qbbtg/vc4IdCpa6EiPQAHDsH4Axx8CdhpAkUlM96xYZIhSfY=
=ENni
-----END PGP SIGNATURE-----
