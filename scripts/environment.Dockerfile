FROM scratch
ADD bootstrap.tar.xz /
COPY pool/ /tmp/pool/
COPY install.sh expected.tsv /tmp/
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
RUN /bin/sh /tmp/install.sh && rm -rf /tmp/pool
COPY build-in-container.sh /usr/local/bin/build-case
