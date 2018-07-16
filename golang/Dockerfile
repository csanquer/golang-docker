ARG SRC_TAG=1.10
FROM golang:${SRC_TAG}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    git \
    sudo

ENV GOSU_VERSION 1.10
RUN set -x \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

RUN go get github.com/kardianos/govendor
RUN go get github.com/canthefason/go-watcher

RUN groupadd -f -g 900 admin
RUN echo '%admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY ssh_config /ssh_config

EXPOSE 4343

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && chown root:root /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /srv/apps
