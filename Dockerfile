FROM debian:bullseye-slim@sha256:94133c8fb81e4a310610bc83be987bda4028f93ebdbbca56f25e9d649f5d9b83

# github metadata
LABEL org.opencontainers.image.source=https://github.com/uwcip/infrastructure-shibboleth

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && \
    apt-get install -y --no-install-recommends shibboleth-sp-utils openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# add specific configurations and links to custom configurations
COPY shibd.logger /etc/shibboleth/shibd.logger
RUN mkdir -p /etc/shibboleth.local && cd /etc/shibboleth \
    ln -sf /etc/shibboleth.local/shibboleth2.xml && \
    ln -sf /etc/shibboleth.local/attribute-map.xml

ENTRYPOINT ["/usr/sbin/shibd", "-F"]
