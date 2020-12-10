# SteamCMD Docker Image

[SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) in a [Docker](https://www.docker.com/what-docker) container. The project is maintained by [Laclede's LAN](https://lacledeslan.com). Source files are hosted on [GitHub](https://github.com/LacledesLAN/SteamCMD) and public images are stored on [Docker Hub](https://hub.docker.com/r/lacledeslan/steamcmd/).

## Linux/amd64

![linux/amd64](https://github.com/LacledesLAN/SteamCMD/workflows/linux/amd64/badge.svg?branch=master)

- `/app/` contains the SteamCMD binaries.
- `/output/` is a convenience directory for stashing SteamCMD downloaded content.

### Download

```shell
docker pull lacledeslan/steamcmd:linux
```

### Use as a [Multi-Stage](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) Builder

WARNING: In our experience Docker Cloud's automated builds doesn't reliably work when the builder container exceeds ~4GB.

```(shell)
FROM lacledeslan/steamcmd:linux as hl2dm-builder
RUN /app/steamcmd.sh +login anonymous +force_install_dir /output +app_update 232370 validate +quit;
FROM ...
COPY --from=hl2dm-builder /output /destination-path
```

### Copy SteamCMD into a Container

Useful for overcoming cloud limitations.

```shell
FROM lacledeslan/steamcmd:linux as builder
FROM ...
COPY --from=builder /app /destination-steamcmd-directory
```

### Use as a Containerized Application

Use this SteamCMD Docker container to install steam network content to your local hard drive.

```shell
mkdir ~/steamcmd-output

chmod +w ~/steamcmd-output

docker run -i --rm -v ~/steamcmd-output:/output lacledeslan/steamcmd:linux ./steamcmd.sh +login anonymous +force_install_dir /output +app_update 740 validate +quit
```

### Run Automated Self-Tests

```shell
docker run --rm lacledeslan/steamcmd:linux /app/ll-tests/steamcmd.sh
```

## Windows Image

Work in progress
