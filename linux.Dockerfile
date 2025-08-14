# escape=`

FROM debian:trixie-slim

LABEL `
    org.opencontainers.image.authors="Laclede's LAN <contact@lacledeslan.com>" `
    org.opencontainers.image.description="SteamCMD, along with a collection of other tools. It's intended to be used as a builder image in multi-stage builds." `
    org.opencontainers.image.documentation="https://github.com/LacledesLAN/SteamCMD" `
    org.opencontainers.image.source="https://hub.docker.com/r/lacledeslan/steamcmd" `
    org.opencontainers.image.title="SteamCMD in Docker, for use as a builder image." `
    org.opencontainers.image.url="https://github.com/LacledesLAN/SteamCMD" `
    org.opencontainers.image.vender="Laclede's LAN"

HEALTHCHECK NONE

ENV LANG=en_US.UTF-8 `
    LANGUAGE=en_US.UTF-8 `
    LC_ALL=en_US.UTF-8 `
    # $HOME is used by SteamCMD; see https://github.com/ValveSoftware/steam-for-linux/issues/10979
    HOME=/app

# Install dependencies
RUN apt-get update && apt-get install -y `
        bzip2 ca-certificates curl libarchive13 lib32gcc-s1 locales p7zip-full tar unzip wget xz-utils &&`
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen &&`
        locale-gen --no-purge en_US.UTF-8 &&`
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

COPY /dist/linux /app

# Set up User Environment
RUN useradd --home /app --gid root --system SteamCMD &&`
    mkdir -p /app/ll-tests /output /scratch &&`
    chown SteamCMD:root -R /app &&`
    chown SteamCMD:root -R /output &&`
    chown SteamCMD:root -R /scratch &&`
    chmod +x /app/ll-tests/*.sh;

USER SteamCMD

WORKDIR /app

# Download SteamCMD; run it once for self-updates
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C /app &&`
    chmod +x /app/steamcmd.sh &&`
    /app/steamcmd.sh +force_install_dir /output +login anonymous +quit;

ONBUILD USER root
