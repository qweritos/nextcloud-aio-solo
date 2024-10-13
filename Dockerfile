FROM mirror.gcr.io/debian:12

LABEL org.opencontainers.image.title="Nextcloud AIO Solo"
LABEL org.opencontainers.image.authors="Andrey Artamonychev<me@andrey.wtf>"
LABEL org.opencontainers.image.vendor="Andrey Artamonychev"
LABEL org.opencontainers.image.source="https://github.com/qweritos/nextcloud-aio-solor"
LABEL org.opencontainers.image.documentation="https://github.com/qweritos/nextcloud-aio-solo/wiki"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.description="Standalone version of Nextcloud AIO. Fully functional and running in single container."

ARG OS_AGENT_VERSION=1.6.0
ARG SUPERVISED_INSTALLER_GIT_REF=main
ARG DATA_SHARE=/usr/share/hassio

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  systemd \
  wget \
  curl \
  libglib2.0-bin \
  lsb-release \
  apt-utils \
  nano \
  inetutils-ping \
  iproute2 \
  httping \
  bash-completion

RUN curl -fsSL get.docker.com | sh

RUN rm -f \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /etc/systemd/system/etc-resolv.conf.mount \
  /etc/systemd/system/etc-hostname.mount \
  /etc/systemd/system/etc-hosts.mount

RUN systemctl mask -- \
      tmp.mount \
      etc-hostname.mount \
      etc-hosts.mount \
      etc-resolv.conf.mount \
      swap.target \
      getty.target \
      getty-static.service \
      dev-mqueue.mount \
      cgproxy.service \
      systemd-tmpfiles-setup-dev.service \
      systemd-remount-fs.service \
      systemd-ask-password-wall.path \
      systemd-logind && \
      systemctl set-default multi-user.target || true

RUN systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

STOPSIGNAL SIGRTMIN+3

ADD ./rootfs /
RUN systemctl enable nc-aio-setup

CMD ["/sbin/init", "--log-level=info", "--log-target=console"]
