-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: python-igraph
Binary: python3-igraph, python-igraph-doc
Architecture: any all
Version: 0.11.2+ds-4
Maintainer: Debian Python Team <team+python@tracker.debian.org>
Uploaders:  Jerome Benoit <calculus@rezozer.net>, TANIGUCHI Takaki <takaki@debian.org>
Homepage: https://igraph.org/python/
Standards-Version: 4.6.2
Vcs-Browser: https://salsa.debian.org/python-team/packages/python-igraph
Vcs-Git: https://salsa.debian.org/python-team/packages/python-igraph.git
Testsuite: autopkgtest
Testsuite-Triggers: python3-graph-tool, python3-networkx, python3-numpy, python3-pandas, python3-scipy
Build-Depends: debhelper-compat (= 13), pkg-config, dh-python, python3-sphinx, libigraph-dev, python3-all-dev, python3-setuptools, python3-numpy, python3-texttable, python3-scipy, python3-pandas, python3-networkx, python3-graph-tool [amd64 arm64 ppc64el s390x ia64 ppc64]
Build-Depends-Indep: pydoctor, python3-sphinx-gallery, python3-sphinx-rtd-theme, python3-doc, python-scipy-doc, python-pandas-doc, tex-gyre, texlive-latex-base, texlive-latex-recommended, texlive-fonts-recommended, texlive-latex-extra, cm-super-minimal, latexmk
Package-List:
 python-igraph-doc deb doc optional arch=all
 python3-igraph deb python optional arch=any
Checksums-Sha1:
 cb0befab4030a97db843a762e090920c777a541b 536688 python-igraph_0.11.2+ds.orig.tar.xz
 26a715af122dbaa440210dce3c0e458417d0db37 6980 python-igraph_0.11.2+ds-4.debian.tar.xz
Checksums-Sha256:
 62d90a1dcf5765403aeff5666ef7ade596ceb77e9f298914fcdaee9b759a8c54 536688 python-igraph_0.11.2+ds.orig.tar.xz
 fddf874bf28293c52b965a7ca7dd40edd2e9acfa16a6f22803fa2bceba0f2302 6980 python-igraph_0.11.2+ds-4.debian.tar.xz
Files:
 da9a9eb228d3cf23aff1cfa9ded0328b 536688 python-igraph_0.11.2+ds.orig.tar.xz
 4146da20ab67a454448e9fa9a23081c4 6980 python-igraph_0.11.2+ds-4.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQRJBAEBCgAzFiEEriiuFXEN/x2H5adiP5IZpn82xosFAmU0C1MVHGNhbGN1bHVz
QHJlem96ZXIubmV0AAoJED+SGaZ/NsaL8H0gANMcThWhAvqN/8x6e+VNerd01QCm
pC6UBw229oCfzglj8VlWrq1ABPAVeClrdhfkuT1ZU0aqstRlw++zbn65VAmh7K8r
3RuybsUUl6hhd8HV9lsdIp/yyeh4uub23felDpD1HFkEaSm6gvEnuaHLGXz/evbi
mdRs3PKTrh45ndAPd5N1eih4FuTt66xojQv8U1hpCbgJMz+yWQt+zAXGtFA64BeE
HTrw7Z/Io0sxZhHZROqjZi1xbJkMrwnth9SLqwLlnhc74OTewoHcr0Ad+72jB432
JxSb5V+/2kCfgiVdc/h3bqx6d5vNbVyOpqyIu4Br3oT5jgwNhafmF1D7eoOrHPhk
dnRE0KqVI9RNrLLO8DCzhkU8V6NcTQ9yjxQ/k/4QYGtDCd3yiJnoEMATx3VWVXFc
+571LD2r7OmN+f+XIW7BnyK1Qgm4arANN7ajmYv8o2gkK49a4iRE2vbCxLgGondL
1kDIPpbI/0i6HIqpWEd0cwQL43bZH5SVmiQ+GHQtOfjxrP+CEZKQ7g/vN3W7tD4o
cZJO2PsZBvaqZzaVLh8whAgkIEwyRg8ZsVYzvp7N61TAUpdRQe1a6a5hX9jVvo3P
Nq14PDS/sOueo7GpHV3ybkeCzD2JBc8I+CcyiFIFPOrdLrObTqThFap7g3xNtZF5
c0yXYUPxEjuXuiwFzBUe3STbpPr7CLEGHz0WPYN4XuW/+wlH/TQhlRSr8zSWy6iM
tcwJN0SyMib2Y5chiJXlzRihoA3ADbwtFqi/073CI6DMz7X07+LWoioq8n+qGGWS
exx35Uw0O/DlAeSIdE2S14n4CMFEoQKjNucNzhjO+vz22/Di6HobqTMe7E4WVIi6
ChOFTfAChEOgvPB2GNjCxkuJsj2pABkt1PLE9XWffH9gkA00QJdl3pPAMmPYMgm1
NOYqN0IpzivH/W5PGL6C2cVE3GcKqJHBTZXYD3sjmrAnUT1ETv7xpCP5X9DZYwBw
Tzd/8jmJmAP4RAWuVfpn84jzVhE4T26RWLi20JbxB8HWBl5kyFps4oWV3DZwWVOb
/Ax6FWALacoljCJEM3jwWh9ZsuA4mS83qqKJjnZp1emS4WXx4633AWAtsHnqLH2i
r/aHQ9lPyhF8lvY1+5KjCWKb8jJ4xPOXI+sTxkRQ9fF3pNUcY2wYH+hZANnvUP7K
qBTdnrj5v7db0Yf7obGvBxtucOMADuTXpGuraEJO0bxcoQokXFpso1wJCIvx6Yuc
TX+wOGW5H8LkfPlWVFkOjH0FBXhoo50gdbuJQzScjM4lrFuBlrnMGUGV8aE98SUd
32gV/gHP2ErImciiInVjloXKExU5eAxEeoNCPTPivnyfdxghcRyDuCzzYQ4=
=isB3
-----END PGP SIGNATURE-----
