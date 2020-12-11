# escape=`

FROM debian:stable-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

LABEL com.lacledeslan.build-node = $BUILDNODE `
        org.opencontainers.image.source = "https://github.com/LacledesLAN/SteamCMD" `
        org.opencontainers.image.title = "SteamCMD in Docker, for use as a builder image" `
        org.opencontainers.image.url = "https://github.com/LacledesLAN/README.1ST" `
        org.opencontainers.image.vendor = "Laclede's LAN" `
        org.opencontainers.image.version = $SOURCE_COMMIT

HEALTHCHECK NONE

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive &&`
    apt-get update && apt-get install -y `
        bzip2 ca-certificates curl libarchive13 lib32gcc1 locales p7zip-full tar unzip wget &&`
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

# Obtain SteamCMD; run so it self-updates
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C /app &&`
    chmod +x /app/steamcmd.sh &&`
    /app/steamcmd.sh +login anonymous +force_install_dir /output +quit;

ONBUILD USER root
