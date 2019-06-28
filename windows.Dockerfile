# escape=`

FROM microsoft/nanoserver

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

LABEL maintainer="Laclede's LAN <contact @lacledeslan.com>" `
      com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.description="SteamCMD in Docker" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/SteamCMD"

HEALTHCHECK NONE

RUN powershell; `
    New-Item -type directory c:\app; `
    New-Item -type directory c:\output; `
    Invoke-WebRequest -OutFile c:\app\steamcmd.zip https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip; `
    Expand-Archive -Path c:\app\steamcmd.zip -DestinationPath c:\app\; `
    Remove-Item –path c:\app\steamcmd.zip;

WORKDIR C:\app\

ENTRYPOINT [ "powershell" ]
