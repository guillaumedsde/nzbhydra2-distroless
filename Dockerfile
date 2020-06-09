FROM alpine:latest as build

ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz s6-overlay-amd64.tar.gz

# download the latest release
RUN wget $(wget -O - -o /dev/null https://api.github.com/repos/theotherp/nzbhydra2/releases/latest | grep browser_download_url | grep linux.zip | head -n 1 | cut -d '"' -f 4) -O nzbhydra2.zip

# extract the release
# set the permissions
# delete unused files
# create fake readme.md so nzbhydra can start
RUN mkdir -p /rootfs/etc/services.d/nzbhydra2 \
    && tar xzf s6-overlay-amd64.tar.gz -C /rootfs \
    && unzip nzbhydra2.zip -d /rootfs/etc/services.d/nzbhydra2 \
    && cd /rootfs/etc/services.d/nzbhydra2 \
    && chmod 755 nzbhydra2 \
    && rm -r upstart sysv systemd rc.d *.py *.md \
    && touch readme.md 

FROM gcr.io/distroless/java:11

COPY --from=build /rootfs /

COPY /rootfs /

EXPOSE 5076

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PUID=1000 \
    PGID=1000

ENTRYPOINT ["/init"]