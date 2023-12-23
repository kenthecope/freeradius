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
    PGID=1000 \
    PUID=1000 \
    RADIUSD_OPTS=

COPY root /

RUN \
    apt update \
    && id \
    && mkdir -p /tmp/freeradius \
    && mkdir -p /freeradius/config \
    && mkdir -p /freeradius/share \
    && mkdir -p /freeradius/log \
    && groupadd --gid $PGID --gid $PUID -r freerad \
    && useradd -c "FreeRADIUS"  -b /freeradius -M --gid $PGID --uid $PUID -r -s /usr/sbin/nologin freerad \
    && chown freerad:freerad /freeradius \
    && chown freerad:freerad /freeradius/config \
    && chown freerad:freerad /freeradius/share \
    && chown freerad:freerad /freeradius/log \
    && chown freerad:freerad /tmp/freeradius \
    && apt-get install -y freeradius freeradius-yubikey freeradius-ldap  freeradius-dhcp freeradius-utils freeradius-postgresql \
    && echo "RUN DONE"


EXPOSE 1812/udp 1813/udp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["radiusd"]
