#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
FROM phusion/baseimage:focal-1.0.0

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM=xterm

RUN set -eux && \
    apt-get install -y software-properties-common && \
    #
    #───────────────────────────────────────────────────────────────────────────────
    # Software's Installation
    #───────────────────────────────────────────────────────────────────────────────
    #
    echo 'DPkg::options { "--force-confdef"; };' >> /etc/apt/apt.conf && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
        # libargon2-dev \
        # libc-dev \
        libcurl4-openssl-dev \
        libedit-dev \
        # libfreetype6-dev \
        # libjpeg62-dev \
        # libonig-dev \
        # libpng-dev \
        # libsodium-dev \
        libsqlite3-dev \
        # libssh2-1-dev \
        libssl-dev \
        libxml2-dev \
        libzip-dev \
        apt-utils \
        autoconf \
        # bash-completion \
        # ca-certificates \
        curl \
        # dirmngr \
        # dpkg-dev \
        file \
        g++ \
        # gcc \
        git \
        gnupg \
        # hostname \
        htop \
        iputils-ping \
        nasm \
        net-tools \
        pkg-config \
        postgresql-client \
        sqlite3 \
        # ssh \
        # sshpass \
        # supervisor \
        # telnet \
        tree \
        # tzdata \
        unzip \
        vim \
        wget \
        xz-utils \
        # zsh \
        zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*