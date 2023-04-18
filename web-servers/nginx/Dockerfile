#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   NGINX IMAGE SETUP
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG NGINX_VERSION=latest
FROM nginx:${NGINX_VERSION}

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

RUN set -xe; \
    apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq \
        curl \
        gcc \
        g++ \
        libpcre3-dev \
        libssl-dev \
        logrotate \
        make \
        openssl \
        tar \
        vim \
        wget

# COPY ../../nginx.conf /etc/nginx

RUN touch /var/log/messages

COPY logrotate/nginx /etc/logrotate.d/

# ARG UPSTREAM_CONTAINER=php-fpm
# ARG UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
# RUN echo "upstream php-upstream { server ${UPSTREAM_CONTAINER}:${UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf && rm /etc/nginx/conf.d/default.conf

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# ADD ./startup.sh /opt/startup.sh
# RUN sed -i 's/\r//g' /opt/startup.sh
# CMD [ "/bin/bash", "/opt/startup.sh" ]

# CMD [ "sh", "-C", "cron && nginx -g deamon off" ]
CMD [ "nginx", "-g", "daemon off;" ]

EXPOSE 80 81 443
