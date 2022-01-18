#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#

FROM incyverse/workspace:ubuntu-20.04

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

ARG ENV_NAME

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Start as root
#────:
USER root

# Add a non-root user to prevent files being created with root permission on host machine.
ARG PGID=1000
ARG PUID=1000

#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━OPTIONAL SOFTWARE's INSTALLATION━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Always run apt update when start and after add new source list, then clean up at end.
RUN set -xe; \
    apt-get update -yqq && \
    groupadd -g ${PGID} ${ENV_NAME} && \
    useradd -l -u ${PUID} -g ${ENV_NAME} -m ${ENV_NAME} -G docker_env && \
    usermod -p '*' ${ENV_NAME} -s /bin/bash

# Set timezone
ARG TZ=UTC

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# User Aliases
COPY ./aliases.sh /root/aliases.sh
COPY ./aliases.sh /home/${ENV_NAME}/aliases.sh

RUN sed -i 's/\r//' /root/aliases.sh && \
    sed -i 's/\r//' /home/${ENV_NAME}/aliases.sh && \
    chown ${ENV_NAME}:${ENV_NAME} /home/${ENV_NAME}/aliases.sh && \
    echo '' >> ~/.bashrc && \
    echo '# Load Custom Aliases' >> ~/.bashrc && \
    echo 'source ~/aliases.sh' >> ~/.bashrc

#────:
USER ${ENV_NAME}

RUN echo '' >> ~/.bashrc && \
    echo '# Load Custom Aliases' >> ~/.bashrc && \
    echo 'source ~/aliases.sh' >> ~/.bashrc



#
#───────────────────────────────────────────────────────────────────────────────
# Final Touch:
#───────────────────────────────────────────────────────────────────────────────
#
#────:
USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# Set default work directory
WORKDIR /var/www
