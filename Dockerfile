FROM debian:bullseye-slim@sha256:10b622c6cf6daa0a295be74c0e412ed20e10f91ae4c6f3ce6ff0c9c04f77cbf6 AS base

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
