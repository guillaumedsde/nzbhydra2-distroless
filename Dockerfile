FROM alpine:latest as build

# download the latest release
RUN wget $(wget -O - -o /dev/null https://api.github.com/repos/theotherp/nzbhydra2/releases/latest | grep browser_download_url | grep linux.zip | head -n 1 | cut -d '"' -f 4) -O nzbhydra2.zip

# extract the release
# set the permissions
# delete unused files
# create fake readme.md so nzbhydra can start
RUN mkdir /nzbhydra2 \
    && unzip nzbhydra2.zip -d /nzbhydra2 \
    && cd nzbhydra2 \
    && chmod +x nzbhydra2 \
    && rm -r upstart sysv systemd rc.d *.py *.md \
    && touch readme.md

FROM gcr.io/distroless/java:11

USER 6666:6666

COPY --from=build --chown=6666:6666 /nzbhydra2 /

EXPOSE 5076

ENTRYPOINT ["/nzbhydra2"]

CMD ["--datafolder", "/config", "--nobrowser"]
