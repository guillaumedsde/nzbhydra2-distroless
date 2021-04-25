# [🐋 NZBHydra2-distroless](https://github.com/guillaumedsde/nzbhydra2-distroless)

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless/builds)
[![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/guillaumedsde/nzbhydra2-distroless?label=documentation)](https://guillaumedsde.gitlab.io/nzbhydra2-distroless/)
[![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless/builds)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless/tags)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless)
[![GitHub stars](https://img.shields.io/github/stars/guillaumedsde/nzbhydra2-distroless?label=Github%20stars)](https://github.com/guillaumedsde/nzbhydra2-distroless)
[![GitHub watchers](https://img.shields.io/github/watchers/guillaumedsde/nzbhydra2-distroless?label=Github%20Watchers)](https://github.com/guillaumedsde/nzbhydra2-distroless)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumedsde/nzbhydra2-distroless)](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless)
[![GitHub](https://img.shields.io/github/license/guillaumedsde/nzbhydra2-distroless)](https://github.com/guillaumedsde/nzbhydra2-distroless/blob/master/LICENSE.md)

This repository contains the code to build a small and secure **[distroless](https://github.com/GoogleContainerTools/distroless)** **docker** image for **[NZBHydra2](https://github.com/theotherp/nzbhydra2)** running as an unprivileged user.
The final images are built and hosted on the [dockerhub](https://hub.docker.com/r/guillaumedsde/nzbhydra2-distroless) and the documentation is hosted on [gitlab pages](https://guillaumedsde.gitlab.io/nzbhydra2-distroless/)

## ✔️ Features summary

- 🥑 [distroless](https://github.com/GoogleContainerTools/distroless) minimal image
- 🤏 As few Docker layers as possible
- 🛡️ only basic runtime dependencies
- 🛡️ Runs as unprivileged user with minimal permissions

## 🏁 How to Run

### `docker run`

```bash
$ docker run  -v /your/config/path/:/config \
              -v /your/torrent/blackhole/path/:/blackhole \
              -v /etc/localtime:/etc/localtime:ro \
              -e PUID=1000 \
              -e PGID=1000 \
              -p 5076:5076 \
              guillaumedsde/nzbhydra2-distroless:latest
```

#### 🧊 Read-only `docker run`

If you want your container to be _even_ more secure, you can run it with a read-only filesystem:

```bash
$ docker run  -v /your/config/path/:/config \
              -v /your/torrent/blackhole/path/:/blackhole \
              -v /etc/localtime:/etc/localtime:ro \
              -e PUID=1000 \
              -e PGID=1000 \
              -e S6_READ_ONLY_ROOT=1 \
              -p 5076:5076 \
              --read-only \
              --tmpfs /var:rw,exec \
              --tmpfs /tmp \
              guillaumedsde/nzbhydra2-distroless:latest
```

### `docker-compose.yml`

```yaml
version: "3.3"
services:
  nzbhydra2-distroless:
    volumes:
      - "/your/config/path/:/config"
      - "/your/torrent/blackhole/path/:/blackhole"
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - PUID=1000
      - PGID=1000
    ports:
      - "5076:5076"
    image: "guillaumedsde/nzbhydra2-distroless:latest"
```

#### 🧊 Read-only `docker-compose.yml`

If you want your container to be _even_ more secure, you can run it with a read-only filesystem:

```yaml
version: "3.3"
services:
  jackett-distroless:
    volumes:
      - "/your/config/path/:/config"
      - "/your/torrent/blackhole/path/:/blackhole"
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - PUID=1000
      - PGID=1000
      - S6_READ_ONLY_ROOT=1
    ports:
      - "5076:5076"
    tmpfs:
      - "/var:rw,exec"
      - "/tmp:rw,exec"
    read_only: true
    image: "guillaumedsde/nzbhydra2-distroless:latest"
```

## ⚙️ Available tags

Each NZBHydra2 docker image is published in two versions:

- `latest` `v3.14.1-s6-overlay` distroless base image with the s6 overlay added
- `latest-distroless` `v3.14.1-distroless` plain distroless base image

## 🖥️ Supported platforms

Currently this container supports only one (but widely used) platform:

- linux/amd64

## 🙏 Credits

A couple of projects really helped me out while developing this container:

- 💽 [NZBHydra2](https://github.com/theotherp/nzbhydra2) _the_ awesome software
- 🏁 [s6-overlay](https://github.com/just-containers/s6-overlay) A simple, relatively small yet powerful set of init script for managing processes (especially in docker containers)
- 🥑 [Google's distroless](https://github.com/GoogleContainerTools/distroless) base docker images
- 🐋 The [Docker](https://github.com/docker) project (of course)
