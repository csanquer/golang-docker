ARG SRC_TAG=1.11-alpine
FROM golang:${SRC_TAG}

RUN apk add --no-cache ca-certificates \
        dpkg \
        gcc \
        git \
        musl-dev \
        shadow \
        sudo \
        bash

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

ENV GOSU_VERSION 1.11
RUN set -x \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

RUN go get github.com/kardianos/govendor
RUN go get github.com/oxequa/realize
RUN go get github.com/spf13/cobra/cobra

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && chown root:root /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["realize", "start"]
