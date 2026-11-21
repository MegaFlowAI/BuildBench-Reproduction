FROM ubuntu:20.04@sha256:8feb4d8ca5354def3d8fce243717141ce31e2c428701f6682bd2fafe15388214
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       sbuild=0.79.0-1ubuntu1 schroot sudo dpkg-dev fakeroot python3 xz-utils \
    && dpkg-query -W sbuild
COPY upstream/bin/builder-prep upstream/bin/sbuild-package upstream/bin/check-implicit-pointer-functions /usr/share/launchpad-buildd/bin/
COPY upstream/lpbuildd/__init__.py upstream/lpbuildd/check_implicit_pointer_functions.py /usr/lib/python3/dist-packages/lpbuildd/
RUN /usr/share/launchpad-buildd/bin/check-implicit-pointer-functions --inline </dev/null
COPY upstream/sbuildrc /etc/buildbench/sbuildrc
COPY run_launchpad_host.sh /usr/local/bin/run-launchpad-host
ENTRYPOINT ["bash", "/usr/local/bin/run-launchpad-host"]
