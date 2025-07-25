FROM ghcr.io/linuxserver/baseimage-selkies:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RPCS3_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=RPCS3 \
    SDL_JOYSTICK_DEVICE=/dev/input/js0

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/rpcs3-logo.png && \
  echo "**** install packages ****" && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest" \
    | awk -F '(": "|")' '/browser.*AppImage/ {print $3}') && \
  curl -o \
    /tmp/rpcs3.app -L \
    "${DOWNLOAD_URL}" && \
  cd /tmp && \
  chmod +x rpcs3.app && \
  ./rpcs3.app --appimage-extract && \
  mv \
    AppDir \
    /opt/rpcs3 && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
