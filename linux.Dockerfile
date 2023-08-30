# escape=`

FROM debian:bookworm-slim

LABEL org.opencontainers.image.source https://github.com/LacledesLAN/SteamCMD
LABEL org.opencontainers.image.title SteamCMD in Docker, for use as a builder image
LABEL org.opencontainers.image.url https://github.com/LacledesLAN/README.1ST
LABEL org.opencontainers.image.vendor "Laclede's LAN"

HEALTHCHECK NONE

# Install dependencies
RUN apt-get update && apt-get install -y `
        bzip2 ca-certificates curl libarchive13 lib32gcc-s1 locales p7zip-full tar unzip wget xz-utils &&`
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen &&`
        locale-gen --no-purge en_US.UTF-8 &&`
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

ENV LANG=en_US.UTF-8 `
    LANGUAGE=en_US.UTF-8

# Set up User Enviornment
RUN useradd --home /app --gid root --system SteamCMD &&`
    mkdir -p /app/ll-tests /output &&`
    chown SteamCMD:root -R /app &&`
    chown SteamCMD:root -R /output;

COPY --chown=SteamCMD:root /dist/linux/ll-tests/ /app/ll-tests/

RUN chmod +x /app/ll-tests/*.sh;

USER SteamCMD

WORKDIR /app

# Download SteamCMD; run it once for self-updates
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C /app &&`
    chmod +x /app/steamcmd.sh &&`
    /app/steamcmd.sh +force_install_dir /output +login anonymous +quit;

ONBUILD USER root
