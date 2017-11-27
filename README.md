[SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) in a [Docker](https://www.docker.com/what-docker) container. The project is maintained by [Laclede's LAN](https://lacledeslan.com). Source files are hosted on [GitHub](https://github.com/LacledesLAN/SteamCMD) and public images are stored on [Docker Hub](https://hub.docker.com/r/lacledeslan/steamcmd/).

- [Linux](#Linux-Container)
- [Windows](#Windows-Container)

# Linux-Container
[![](https://images.microbadger.com/badges/image/lacledeslan/steamcmd:linux.svg)](https://microbadger.com/images/lacledeslan/steamcmd:linux "Get your own image badge on microbadger.com")

* `/app/` contains the SteamCMD binaries.
* `/output/` is a convenience directory for stashing SteamCMD downloaded content.

## Downloading
```
docker pull lacledeslan/steamcmd:linux
```

## Use as a [Multi-Stage](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) Builder
WARNING: In our experience Docker Cloud's automated builds doesn't reliably work when the builder container exceeds ~4GB.

```
FROM lacledeslan/steamcmd:linux as hl2dm-builder
RUN /app/steamcmd/steamcmd.sh +login anonymous +force_install_dir /output +app_update 232370 validate +quit;
FROM ...
COPY --from=hl2dm-builder /output /destination-path
```

## Copy SteamCMD into a Container
Useful for overcoming cloud limitations.

```
FROM lacledeslan/steamcmd:linux as builder
FROM ...
COPY --from=builder /app /destination-steamcmd-directory
```

## Use as a Containerized Application
Use this SteamCMD Docker container to install steam network content to your local hard drive.

```shell
mkdir ~/steamcmd-output

chmod +w ~/steamcmd-output

docker run -i --rm -v ~/steamcmd-output:/output lacledeslan/steamcmd:linux ./steamcmd.sh +login anonymous +force_install_dir /output +app_update 740 validate +quit
```

## Run Automated Tests
```
docker run lacledeslan/steamcmd:linux --rm /app/ll-tests/steamcmd.sh
```

# Windows-Container

Work in progress
