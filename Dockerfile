FROM debian:bullseye-slim@sha256:5cf1d98cd0805951484f33b34c1ab25aac7007bb41c8b9901d97e4be3cf3ab04 AS base

# github metadata
LABEL org.opencontainers.image.source=https://github.com/uwcip/infrastructure-shibboleth

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends shibboleth-sp-utils openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# add any custom overrides. the actual configuration should come from the other
# container in the pod (e.g. attribute-map.xml, shibboleth2.xml) but anything
# in this directory will overwrite *those* configurations, too.
RUN mkdir -p /etc/shibboleth.local /etc/shibboleth.shared
COPY conf /etc/shibboleth.local

# before starting shibd, the entrypoint will copy the contents of
# /etc/shibboleth.local and /etc/shibboleth.shared to /etc/shibboleth.
# this way the other container (the apache container) in the pod can give us
# the same configuraiton that it is running.
COPY entrypoint /entrypoint
RUN chmod +x /entrypoint

ENTRYPOINT ["/entrypoint"]
