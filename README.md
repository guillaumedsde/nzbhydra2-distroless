# [🐋 NZBHydra2-distroless](https://github.com/guillaumedsde/nzbhydra2-distroless)

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless/builds)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless/builds)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/guillaumedsde/nzbhydra2-distroless?label=version)](https://github.com/guillaumedsde/nzbhydra2-distroless/releases)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless)
[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/nzbhydra2-distroless?label=Github%20stars)](https://github.com/guillaumedsde/nzbhydra2-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/nzbhydra2-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/nzbhydra2-distroless)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/nzbhydra2-distroless)](https://github.com/guillaumedsde/nzbhydra2-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure **[distroless](https://github.com/GoogleContainerTools/distroless)** **docker** image for **[NZBHydra2](https://github.com/theotherp/nzbhydra2)** running as an unprivileged user.
The final images are built and hosted on the [dockerhub](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless).

## ✔️ Features summary

- 🥑 [distroless](https://github.com/GoogleContainerTools/distroless) minimal image
- 🤏 As few Docker layers as possible
- 🛡️ only basic runtime dependencies
- 🛡️ Runs as unprivileged user with minimal permissions

## 🏁 How to Run

### `docker run`

```bash
$ docker run  -v /your/config/path/:/config \
              -v /etc/localtime:/etc/localtime:ro \
              -e PUID=1000 \
              -e PGID=1000 \
              -p 5076:5076 \
              guillaumedsde/nzbhydra2-distroless:latest
```

### `docker-compose.yml`

```yaml
version: "3.3"
services:
  nzbhydra2-distroless:
    volumes:
      - "/your/config/path/:/config"
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - PUID=1000
      - PGID=1000
    ports:
      - "5076:5076"
    image: "guillaumedsde/nzbhydra2-distroless:latest"
```

## 🖥️ Supported platforms

Currently this container supports only one (but widely used) platform:

- linux/amd64

I am waiting to see if Google implement their distroless Java images for other platforms (e.g. ARM based), for more information, see [here](https://github.com/GoogleContainerTools/distroless/issues/406) or [here](https://github.com/GoogleContainerTools/distroless/issues/377)

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 🏁 [s6-overlay](https://github.com/just-containers/s6-overlay) A simple, relatively small yet powerful set of init script for managing processes (especially in docker containers)
- 🥑 [Google's distroless](https://github.com/GoogleContainerTools/distroless) base docker images
- 🐋 The [Docker](https://github.com/docker) project (of course)
