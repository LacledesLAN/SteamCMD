# escape=`

FROM debian:stable-slim

ARG IMAGE_NAME
ARG SOURCE_COMMIT

LABEL maintainer="Laclede's LAN <contact @lacledeslan.com>" `
      org.label-schema.schema-version="1.0" `
      org.label-schema.name=$IMAGE_NAME `
      org.label-schema.url="https://github.com/LacledesLAN" `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.description="Builder with SteamCMD" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/SteamCMD"

HEALTHCHECK NONE

# Install dependencies
RUN apt-get update &&`
    apt-get install -y `
        bzip2 curl git lib32gcc1 tar wget &&`
    apt-get autoremove &&`
    apt-get clean &&`
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

# Set up Enviornment
RUN mkdir -p /app /output /test
ENV PATH "$PATH:/test:/test/bin"

## Set Up Testing
RUN git clone https://github.com/sstephenson/bats.git /test/ &&`
    PATH=$PATH:~/test/bin

COPY ./tests.bats /test/tests.bats

#Add user "SteamCMD". Assign to group "root" until [github.com/moby/moby/pull/34263] makes it into CE stable
RUN useradd `
        --home /app `
        --gid root `
        --system `
        SteamCMD &&`
    chown SteamCMD:root -R /app &&`
    chown SteamCMD:root -R /output &&`
    chown SteamCMD:root -R /test;

USER SteamCMD

# SteamCMD
RUN cd /app &&`
        curl --silent http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -C /app -vxz &&`
        rm -f steamcmd_linux.tar.gz &&`
    # Run SteamCMD so it self-updates &&`
        chmod +x /app/*.sh &&`
        /app/steamcmd.sh +login anonymous +force_install_dir /output +quit;
        

WORKDIR /app

ONBUILD USER root

USER root
