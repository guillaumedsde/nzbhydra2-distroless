ARG BUILD_DATE
ARG VCS_REF
ARG NZBHYDRA2_VERSION=3.8.0

FROM alpine:3.13 as build

ARG NZBHYDRA2_VERSION

ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz s6-overlay-amd64.tar.gz

# download the latest release
RUN if [ "${NZBHYDRA2_VERSION}" -eq "latest" ]; \
    then wget "$(wget -O - -o /dev/null https://api.github.com/repos/theotherp/nzbhydra2/releases/latest | grep browser_download_url | grep linux.zip | head -n 1 | cut -d \" -f 4)" -O nzbhydra2.zip ; \
    else wget "https://github.com/theotherp/nzbhydra2/releases/download/v${NZBHYDRA2_VERSION}/nzbhydra2-${NZBHYDRA2_VERSION//v}-linux.zip" -O nzbhydra2.zip; fi


# extract the release
# set the permissions
# delete unused files
# create fake readme.md so nzbhydra can start
RUN mkdir -p /rootfs/etc/services.d/nzbhydra2 \
    && tar xzf s6-overlay-amd64.tar.gz -C /rootfs 
RUN unzip nzbhydra2.zip -d /rootfs/etc/services.d/nzbhydra2 
RUN cd /rootfs/etc/services.d/nzbhydra2 \
    && chmod 755 nzbhydra2 \
    && rm -r upstart sysv systemd rc.d *.py *.md \
    && touch readme.md 

ARG BUSYBOX_VERSION=1.31.0-i686-uclibc
ADD https://busybox.net/downloads/binaries/$BUSYBOX_VERSION/busybox_WGET /rootfs/wget
RUN chmod a+x /rootfs/wget

FROM gcr.io/distroless/java:11-nonroot as distroless

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG NZBHYDRA2_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="nzbhydra2-distroless" \
    org.label-schema.description="Distroless container for the NZBHydra2 program" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/nzbhydra2-distroless/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version=$NZBHYDRA2_VERSION-distroless \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/nzbhydra2-distroless" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.schema-version="1.0"

COPY --from=build /rootfs/wget /rootfs/etc/services.d/nzbhydra2 /

COPY rootfs /

EXPOSE 5076

VOLUME /blackhole

HEALTHCHECK  --start-period=15s --interval=1m --timeout=3s \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:5076/"]

ENTRYPOINT ["/nzbhydra2"]
CMD ["--datafolder", "/config", "--nobrowser"]


FROM gcr.io/distroless/java:11 as s6

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG NZBHYDRA2_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="nzbhydra2-distroless" \
    org.label-schema.description="Distroless container for the NZBHydra2 program" \
    org.label-schema.url="https://guillaumedsde.gitlab.io/nzbhydra2-distroless/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.version=$NZBHYDRA2_VERSION-s6-overlay \
    org.label-schema.vcs-url="https://github.com/guillaumedsde/nzbhydra2-distroless" \
    org.label-schema.vendor="guillaumedsde" \
    org.label-schema.schema-version="1.0"

COPY --from=build /rootfs /

COPY rootfs /

EXPOSE 5076

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PUID=1000 \
    PGID=1000

VOLUME /blackhole

HEALTHCHECK  --start-period=15s --interval=1m --timeout=3s \
    CMD [ "/wget", "--quiet", "--tries=1", "--spider", "http://localhost:5076/"]

ENTRYPOINT ["/init"]
