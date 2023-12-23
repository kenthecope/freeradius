FROM ubuntu

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.opencontainers.image.vendor="kenthecope" \
    org.opencontainers.image.url="https://github.com/kenthecope/freeradius" \
    org.opencontainers.image.title="FreeRadius Docker Container" \
    org.opencontainers.image.description="FreeRadius Docker Container" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.source="https://github.com/kenthecope/freeradius" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.licenses="Apache-2.0"

ENV \
    DEBUG=false \
    PGID=1812 \
    PUID=1812 \
    RADIUSD_OPTS=

COPY root /

RUN \
    apt update \
    && apt-get install -y freeradius freeradius-yubikey freeradius-ldap  freeradius-dhcp freeradius-utils freeradius-postgresql \
    && mkdir -p /var/log/radius \
    && chown freerad:freerad /var/log/radius \
    && mkdir -p /freerad/config \
    && mkdir -p /freerad/share \
    && chown freerad:freerad /freeradius \
    && chown freerad:freerad /freeradius/config \
    && chown freerad:freerad /freeradius/share \
    && echo "RUN DONE"


EXPOSE 1812/udp 1813/udp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["radiusd"]
