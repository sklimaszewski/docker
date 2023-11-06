# Build arguments
ARG VERSION
ARG DB

# Alpine base image
FROM varnish:${VERSION}-alpine

USER root

RUN set -e; \
    apk add --no-cache $VMOD_DEPS; \
    install-vmod https://github.com/varnish/varnish-modules/releases/download/0.20.0/varnish-modules-0.20.0.tar.gz; \
    apk del --no-network $VMOD_DEPS

USER varnish