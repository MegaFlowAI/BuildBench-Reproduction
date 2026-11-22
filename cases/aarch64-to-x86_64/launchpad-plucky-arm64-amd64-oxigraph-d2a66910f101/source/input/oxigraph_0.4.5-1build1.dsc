-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: oxigraph
Binary: oxigraph, librust-oxrdf-dev, librust-oxsdatatypes-dev, librust-sparesults-dev, librust-spargebra-dev, librust-oxigraph-dev, librust-oxrocksdb-sys-dev
Architecture: any all
Version: 0.4.5-1build1
Maintainer: Jonas Smedegaard <dr@jones.dk>
Homepage: https://github.com/oxigraph/oxigraph
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/debian/oxigraph
Vcs-Git: https://salsa.debian.org/debian/oxigraph.git
Testsuite: autopkgtest
Testsuite-Triggers: dh-rust, librust-bindgen-dev, librust-cc-1+default-dev, librust-cc-1+parallel-dev, librust-is-terminal-0.4+default-dev, librust-oxigraph-0.4+default-dev, librust-oxigraph-0.4+http-client-dev, librust-oxigraph-0.4+rocksdb-debug-dev, librust-oxigraph-0.4-dev, librust-oxrdf-0.2+default-dev, librust-oxrdf-0.2+oxsdatatypes-dev, librust-oxrdf-0.2+rdf-star-dev, librust-oxrdf-0.2-dev, librust-oxrdfio-0.1+async-tokio-dev, librust-oxrdfio-0.1+default-dev, librust-oxrdfio-0.1-dev, librust-oxrdfxml-0.1+async-tokio-dev, librust-oxrdfxml-0.1+default-dev, librust-oxrdfxml-0.1-dev, librust-oxrocksdb-sys-0.4+default-dev, librust-oxrocksdb-sys-0.4+pkg-config-dev, librust-oxrocksdb-sys-0.4-dev, librust-oxsdatatypes-0.2+custom-now-dev, librust-oxsdatatypes-0.2+default-dev, librust-oxsdatatypes-0.2-dev, librust-oxttl-0.1+async-tokio-dev, librust-oxttl-0.1+default-dev, librust-oxttl-0.1+rdf-star-dev, librust-oxttl-0.1-dev, librust-sparesults-0.2+default-dev, librust-sparesults-0.2+rdf-star-dev, librust-sparesults-0.2-dev, librust-spargebra-0.3+default-dev, librust-spargebra-0.3+rdf-star-dev, librust-spargebra-0.3+sep-0002-dev, librust-spargebra-0.3+sep-0006-dev, librust-spargebra-0.3-dev, librust-sparopt-0.1+default-dev, librust-sparopt-0.1+rdf-star-dev, librust-sparopt-0.1+sep-0002-dev, librust-sparopt-0.1+sep-0006-dev, librust-sparopt-0.1-dev, librust-tokio-1+macros-dev, librust-tokio-1+rt-dev
Build-Depends: debhelper-compat (= 13), dh-sequence-bash-completion, dh-sequence-rust, librocksdb-dev, librust-anyhow-1+default-dev, librust-assert-cmd-2+default-dev, librust-assert-fs-1+default-dev, librust-bindgen-dev (<< 0.71), librust-cc-1+default-dev, librust-cc-1+parallel-dev, librust-clap-4+default-dev, librust-clap-4+derive-dev, librust-clap-complete-4+default-dev, librust-clap-mangen-0.2+default-dev, librust-console-error-panic-hook-0.1+default-dev, librust-dashmap-5+default-dev, librust-digest-0.10+default-dev, librust-flate2-1+default-dev, librust-getrandom-0.2+default-dev, librust-hex-0.4+default-dev, librust-is-terminal-0.4+default-dev, librust-js-sys-0.3+default-dev, librust-json-event-parser-0.2+default-dev, librust-libc-0.2+default-dev, librust-md-5-0.10+default-dev, librust-memchr-2+default-dev, librust-nom-7+default-dev, librust-oxhttp-0.2+default-dev, librust-oxhttp-0.2+flate2-dev, librust-oxhttp-0.2+native-tls-dev, librust-oxilangtag-0.1+default-dev, librust-oxiri-0.2+default-dev (>= 0.2.3), librust-peg-0.8+default-dev, librust-pkg-config-0.3+default-dev, librust-portable-atomic-1+default-dev, librust-quick-xml-0.36+async-tokio-dev, librust-quick-xml-0.36+default-dev, librust-rand-0.8+default-dev, librust-rayon-1+default-dev, librust-rayon-core-1+default-dev, librust-regex-1+default-dev, librust-rustc-hash-2+default-dev, librust-sha1-0.10+default-dev, librust-sha2-0.10+default-dev, librust-siphasher-dev (<< 2), librust-thiserror-1+default-dev, librust-tokio-1+default-dev, librust-tokio-1+io-util-dev, librust-tokio-1+macros-dev, librust-tokio-1+rt-dev, librust-url-2+default-dev, python3-dev
Package-List:
 librust-oxigraph-dev deb rust optional arch=all
 librust-oxrdf-dev deb rust optional arch=all
 librust-oxrocksdb-sys-dev deb rust optional arch=all
 librust-oxsdatatypes-dev deb rust optional arch=all
 librust-sparesults-dev deb rust optional arch=all
 librust-spargebra-dev deb rust optional arch=all
 oxigraph deb web optional arch=any
Checksums-Sha1:
 d9ed41099682993c4ff5ad6e79754fd325a49081 755618 oxigraph_0.4.5.orig.tar.gz
 57ead5c5b643a5e0fe453de9d6f4d549cff98404 18368 oxigraph_0.4.5-1build1.debian.tar.xz
Checksums-Sha256:
 77fb71c0f0b20e0f24d6447a0f8b09fe990f4ca5e535feccb7eef064c2c5241c 755618 oxigraph_0.4.5.orig.tar.gz
 398028d20c04f780d6335fa7f0f1589a3779713d2a6b51781f4bb1fa349a9a88 18368 oxigraph_0.4.5-1build1.debian.tar.xz
Files:
 2df5218e8b71e9d27277acbe6e1b4ff9 755618 oxigraph_0.4.5.orig.tar.gz
 a815e61d9a8d5d1f4718786ae9fef711 18368 oxigraph_0.4.5-1build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEuDQJkCg9jZvBlJrHR5mjUUbRKzUFAmd4Bu0ACgkQR5mjUUbR
KzXeFhAAgnP74Zy54T8dg7bq9/S5Xzneo0HdvQqQwbKgDyY9gZ4+5e25D1Tenu8o
pzL3h8r20BNKY4oYy9Z8NCPzQUSUa/xe+7+sWLOPH5jY8m57TyRITvdP2OBQ/Dg5
m1Aj9M4HimugF4kWV7SwV+WGjsafvazzDTde0Jy3MLrzzk8AAecGjmhAJzos87n7
ubR5qVlWfWqT7/idPu8t/atxxSQI4ctiMUsnpPIkozMAhZTUfU0j12u/9OjbLG8c
PrEoxw0E7+Dzpus6nEHBXZoZkUotFTs+ol2gDspvsfQuufpzAm4PFhbmamKi7o6C
0i1qPiSiBlzbToqwi9bAOICWXAJK/R3KxER9fTmh+KJTfPKr4ZEOETBOXaJK/UXd
KyC+b0+Qmu0Zwb9EwvspkYjW/Vl/uPL3VSSVwMLtUUzyTPA40t4fNIEDEfDBjm+u
hmYIZGWvhd2HTpmfBy55KSq3UoUv0BTnOBJcRe+z0mP7XZ1kk5077TGXbvFmqOEe
ijcLU2hpHd+iyTOC27cWbVHo9zBctWWX01DRrdSXnsx4OBEqBGD+Z4bN1bJT5dPw
9XdWgqg/5y8zG1mge7pbvimKHoEMGYBrU2AGoUgvZv9lTSMLvhsK2zcS6yQH92TT
g6dbyVXK3I6vNvAaH4HYzDugxyzGm3ynefq0x2H+Uhkvw7IMLlM=
=Fn/x
-----END PGP SIGNATURE-----
