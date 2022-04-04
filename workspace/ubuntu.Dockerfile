#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
FROM incyverse/workspace:ubuntu-20.04

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

ARG GROUP
ARG USER

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Start as root
#────:
USER root

# Add a non-root user to prevent files being created with root permission on host machine.
ARG PGID=1000
ENV PGID=${PGID}
ARG PUID=1000
ENV PUID=${PUID}

#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━OPTIONAL SOFTWARE's INSTALLATION━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    groupadd -g ${PGID} ${GROUP} && \
    useradd -l -u ${PUID} -g ${USER} -m ${USER} -G docker_env && \
    usermod -p '*' ${USER} -s /bin/bash && \
    apt-get install -yqq \
        apt-utils \
        libzip-dev \
        nasm \
        unzip \
        zip

# Set timezone
ARG TZ=UTC
ENV TZ=${TZ}
RUN mv /etc/localtime /etc/localtime_UTC && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# User aliases
COPY ./aliases.sh /root/aliases.sh
COPY ./aliases.sh /home/${USER}/aliases.sh

RUN sed -i 's/\r//' /root/aliases.sh && \
    sed -i 's/\r//' /home/${USER}/aliases.sh && \
    chown ${GROUP}:${USER} /home/${USER}/aliases.sh && \
    echo '' >> ~/.bashrc && \
    echo '# Load Custom Aliases' >> ~/.bashrc && \
    echo 'source ~/aliases.sh' >> ~/.bashrc

#────:
USER ${USER}

RUN echo '' >> ~/.bashrc && \
    echo '# Load Custom Aliases' >> ~/.bashrc && \
    echo 'source ~/aliases.sh' >> ~/.bashrc

#
#───────────────────────────────────────────────────────────────────────────────
# Crontab:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

# COPY ./cron.d /etc/cron.d

# RUN chmod -R 644 /etc/cron.d

# Update Repositories
RUN apt-get update -yqq

#
#───────────────────────────────────────────────────────────────────────────────
# Git:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG INSTALL_GIT_PROMPT=false

COPY git-prompt.sh /tmp/git-prompt

RUN if [ ${INSTALL_GIT_PROMPT} = true ]; then \
        git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1 && \
        cat /tmp/git-prompt >> /root/.bashrc && \
        rm /tmp/git-prompt; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# LinuxBrew:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG INSTALL_LINUXBREW=false

RUN if [ ${INSTALL_LINUXBREW} = true ]; then \
        # Preparation
        apt-get upgrade -y && \
        apt-get install -y \
            autoconf \
            autoconf-archive \
            automake \
            bison \
            build-essential \
            cmake \
            curl \
            flex \
            gettext \
            libbz2-dev \
            libcurl4-openssl-dev \
            libexpat-dev \
            libncurses-dev \
            libtool \
            make \
            ruby \
            scons && \
        # Install the Linuxbrew
        git clone --depth=1 https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew && \
        echo '' >> ~/.bashrc && \
        echo 'export PKG_CONFIG="/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc && \
        # Setup linuxbrew
        echo 'export LINUXBREWHOME="$HOME/.linuxbrew"' >> ~/.bashrc && \
        echo 'export PATH="$LINUXBREWHOME/bin:$PATH"' >> ~/.bashrc && \
        echo 'export MANPATH="$LINUXBREWHOME/man:$MANPATH"' >> ~/.bashrc && \
        echo 'export PKG_CONFIG_PATH="$LINUXBREWHOME/lib64/pkgconfig:$LINUXBREWHOME/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc && \
        echo 'export LD_LIBRARY_PATH="$LINUXBREWHOME/lib64:$LINUXBREWHOME/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# Node:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER ${USER}

# Check if NVM needs to be installed
ARG NODE_VERSION=node
ARG NPM_FETCH_RETRIES
ARG NPM_FETCH_RETRY_FACTOR
ARG NPM_FETCH_RETRY_MINTIMEOUT
ARG NPM_FETCH_RETRY_MAXTIMEOUT
ARG NPM_REGISTRY

ARG NVM_VERSION
ARG NVM_NODEJS_ORG_MIRROR
ENV NVM_NODEJS_ORG_MIRROR=${NVM_NODEJS_ORG_MIRROR}

ARG INSTALL_NODE=false

ENV NVM_DIR=/home/${USER}/.nvm

RUN if [ ${INSTALL_NODE} = true ]; then \
        # Install nvm (A Node Version Manager)
        mkdir -p $NVM_DIR && \
        # https://github.com/nvm-sh/nvm#installing-and-updating
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
        . $NVM_DIR/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm use ${NODE_VERSION} && \
        nvm alias ${NODE_VERSION} && \
        npm config set fetch-retries ${NPM_FETCH_RETRIES} && \
        npm config set fetch-retry-factor ${NPM_FETCH_RETRY_FACTOR} && \
        npm config set fetch-retry-mintimeout ${NPM_FETCH_RETRY_MINTIMEOUT} && \
        npm config set fetch-retry-maxtimeout ${NPM_FETCH_RETRY_MAXTIMEOUT} && \
        if [ ${NPM_REGISTRY} ]; then \
            npm config set registry ${NPM_REGISTRY}; \
        fi && \
        ln -s `npm bin --global` /home/${USER}/.node-bin; \
    fi

# Wouldn't execute when added to the RUN statement in the above block
# Source NVM when loading bash since ~/.profile isn't loaded on non-login shell
RUN if [ ${INSTALL_NODE} = true ]; then \
        echo '' >> ~/.bashrc && \
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
        echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc; \
    fi

# Add NVM binaries to root's .bashrc
#────:
USER root

ENV USER=${USER}

RUN if [ ${INSTALL_NODE} = true ]; then \
        echo '' >> ~/.bashrc && \
        echo 'export NVM_DIR="/home/$USER/.nvm"' >> ~/.bashrc && \
        echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc; \
    fi

# Add PATH for node
ENV PATH=$PATH:/home/${USER}/.node-bin

# Make it so the node modules can be executed with 'docker-compose exec'
# We'll create symbolic links into '/usr/local/bin'.
RUN if [ ${INSTALL_NODE} = true ]; then \
        find $NVM_DIR -type f -name node -exec ln -s {} /usr/local/bin/node \; && \
        NODE_MODS_DIR="$NVM_DIR/versions/node/$(node -v)/lib/node_modules" && \
        ln -s $NODE_MODS_DIR/npm/bin/npm-cli.js /usr/local/bin/npm && \
        ln -s $NODE_MODS_DIR/npm/bin/npx-cli.js /usr/local/bin/npx; \
    fi

RUN if [ ${NPM_REGISTRY} ]; then \
        . ~/.bashrc && npm config set registry ${NPM_REGISTRY}; \
    fi

# Mount .npmrc into home folder
COPY ./.npmrc /root/.npmrc
COPY ./.npmrc /home/${USER}/.npmrc

#
#───────────────────────────────────────────────────────────────────────────────
# Oh My ZSH:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG SHELL_OH_MY_ZSH=false
ARG SHELL_OH_MY_ZSH_AUTOSUGESTIONS=false
ARG SHELL_OH_MY_ZSH_HIGHLIGHTING=false

RUN if [ ${SHELL_OH_MY_ZSH} = true ]; then \
        apt install -y zsh; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# Python3:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG INSTALL_PYTHON3=false

RUN if [ ${INSTALL_PYTHON3} = true ]; then \
        apt-get -y install python3 python3-pip python3-dev build-essential && \
        python3 -m pip install --upgrade --force-reinstall pip && \
        python3 -m pip install --upgrade virtualenv; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# ssh:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG INSTALL_SSH=false

COPY insecure_id_rsa /tmp/id_rsa
COPY insecure_id_rsa.pub /tmp/id_rsa.pub

RUN if [ ${INSTALL_SSH} = true ]; then \
        rm -f /etc/service/sshd/down && \
        cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && \
        cat /tmp/id_rsa.pub >> /root/.ssh/id_rsa.pub && \
        cat /tmp/id_rsa >> /root/.ssh/id_rsa && \
        rm -f /tmp/id_rsa* && \
        chmod 644 /root/.ssh/authorized_keys /root/.ssh/id_rsa.pub && \
        chmod 400 /root/.ssh/id_rsa && \
        cp -rf /root/.ssh /home/${USER} && \
        chown -R ${GROUP}:${USER} /home/${USER}/.ssh; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# Supervisor:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG INSTALL_SUPERVISOR=false

RUN if [ ${INSTALL_SUPERVISOR} = true ]; then \
        if [ ${INSTALL_PYTHON} = true ]; then \
            python -m pip install --upgrade supervisor && \
            echo_supervisord_conf > /etc/supervisord.conf && \
            sed -i 's/\;\[include\]/\[include\]/g' /etc/supervisord.conf && \
            sed -i 's/\;files\s.*/files = supervisord.d\/*.conf/g' /etc/supervisord.conf; \
        fi; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# Yarn:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER ${USER}

ARG INSTALL_YARN=false
ARG YARN_VERSION=latest
ENV YARN_VERSION=${YARN_VERSION}

RUN if [ ${INSTALL_YARN} = true ]; then \
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
        if [ ${YARN_VERSION} = "latest" ]; then \
            curl -o- -L https://yarnpkg.com/install.sh | bash; \
        else \
            curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION}; \
        fi && \
        echo '' >> ~/.bashrc && \
        echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bashrc; \
    fi

#────:
# Add YARN binaries to root's .bashrc
USER root

RUN if [ ${INSTALL_YARN} = true ]; then \
        echo '' >> ~/.bashrc && \
        echo 'export YARN_DIR="/home/$USER/.yarn"' >> ~/.bashrc && \
        echo 'export PATH="$YARN_DIR/bin:$PATH"' >> ~/.bashrc; \
    fi

# Add PATH for YARN
ENV PATH=$PATH:/home/${USER}/.yarn/bin

#
#───────────────────────────────────────────────────────────────────────────────
# Oh My ZSH!:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

ARG INSTALL_OH_MY_ZSH=false
RUN if [ ${INSTALL_OH_MY_ZSH} = true ]; then \
        apt install -y zsh; \
    fi

USER ${USER}
# RUN if [ ${INSTALL_OH_MY_ZSH} = true ]; then \
        # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --keep-zshrc" && \
        # sed -i -r 's/^plugins=\(.*?\)$/plugins=(laravel5)/' /home/laradock/.zshrc && \
        # echo '\n\
# bindkey "^[OB" down-line-or-search\n\
# bindkey "^[OC" forward-char\n\
# bindkey "^[OD" backward-char\n\
# bindkey "^[OF" end-of-line\n\
# bindkey "^[OH" beginning-of-line\n\
# bindkey "^[[1~" beginning-of-line\n\
# bindkey "^[[3~" delete-char\n\
# bindkey "^[[4~" end-of-line\n\
# bindkey "^[[5~" up-line-or-history\n\
# bindkey "^[[6~" down-line-or-history\n\
# bindkey "^?" backward-delete-char\n' >> /home/laradock/.zshrc && \
        # sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions /home/laradock/.oh-my-zsh/custom/plugins/zsh-autosuggestions" && \
        # sed -i 's~plugins=(~plugins=(zsh-autosuggestions ~g' /home/laradock/.zshrc && \
        # sed -i '1iZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' /home/laradock/.zshrc && \
        # sed -i '1iZSH_AUTOSUGGEST_STRATEGY=(history completion)' /home/laradock/.zshrc && \
        # sed -i '1iZSH_AUTOSUGGEST_USE_ASYNC=1' /home/laradock/.zshrc && \
        # sed -i '1iTERM=xterm-256color' /home/laradock/.zshrc && \
        # echo "" >> /home/laradock/.zshrc && \
        # echo "# Load Custom Aliases" >> /home/laradock/.zshrc && \
        # echo "source /home/laradock/aliases.sh" >> /home/laradock/.zshrc && \
        # echo "" >> /home/laradock/.zshrc \
    # fi

#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━FINAL TOUCH━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
#────:
USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Set default work directory
WORKDIR /var/www
