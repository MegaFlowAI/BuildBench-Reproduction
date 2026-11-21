FROM scratch
ADD bootstrap.tar.xz /
COPY install.sh expected.tsv /tmp/
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
RUN --mount=type=bind,source=pool,target=/tmp/pool /bin/sh /tmp/install.sh
COPY build-in-container.sh /usr/local/bin/build-case
