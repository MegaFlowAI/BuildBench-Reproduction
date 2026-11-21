FROM ubuntu:20.04@sha256:8feb4d8ca5354def3d8fce243717141ce31e2c428701f6682bd2fafe15388214
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       sbuild=0.79.0-1ubuntu1 schroot sudo dpkg-dev fakeroot xz-utils \
    && dpkg-query -W sbuild
COPY upstream/bin/builder-prep upstream/bin/sbuild-package upstream/bin/check-implicit-pointer-functions /usr/share/launchpad-buildd/bin/
COPY upstream/sbuildrc /etc/buildbench/sbuildrc
COPY run_launchpad_host.sh /usr/local/bin/run-launchpad-host
ENTRYPOINT ["bash", "/usr/local/bin/run-launchpad-host"]
