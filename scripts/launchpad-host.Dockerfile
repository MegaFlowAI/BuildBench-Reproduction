ARG HOST_IMAGE
FROM ${HOST_IMAGE}
ARG SBUILD_VERSION
COPY sbuild-debs/ /sbuild-debs/
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       /sbuild-debs/*.deb schroot sudo dpkg-dev fakeroot python3 xz-utils \
    && test "$(dpkg-query -W -f='${Version}' sbuild)" = "$SBUILD_VERSION" \
    && dpkg-query -W sbuild libsbuild-perl
COPY upstream/bin/builder-prep upstream/bin/sbuild-package upstream/bin/check-implicit-pointer-functions /usr/share/launchpad-buildd/bin/
COPY upstream/lpbuildd/__init__.py upstream/lpbuildd/check_implicit_pointer_functions.py /usr/lib/python3/dist-packages/lpbuildd/
RUN /usr/share/launchpad-buildd/bin/check-implicit-pointer-functions --inline </dev/null
COPY upstream/sbuildrc /etc/buildbench/sbuildrc
COPY run_launchpad_host.sh /usr/local/bin/run-launchpad-host
ENTRYPOINT ["bash", "/usr/local/bin/run-launchpad-host"]
