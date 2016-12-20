FROM alpine:latest

MAINTAINER Port Direct <pete@port.direct>

COPY ./assets /opt/harbor/assets

RUN set -e && \
    set -x && \
    cp -rfav /opt/harbor/assets/* / && \
    rm -rf /opt/harbor/assets && \
    apk upgrade --no-cache && \
    apk add --no-cache --virtual run-deps \
        bash \
        util-linux \
        python && \
    apk add --no-cache --virtual build-deps \
        curl \
        tar && \
    curl -L https://github.com/gliderlabs/sigil/releases/download/v0.4.0/sigil_0.4.0_Linux_x86_64.tgz | tar -zxC /usr/bin && \
    apk del build-deps

WORKDIR /opt/ceph

ENTRYPOINT ["/bin/bash"]

CMD ["/start.sh"]
