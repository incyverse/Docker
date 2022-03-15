#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG APACHE_VERSION=latest
FROM httpd:${APACHE_VERSION}

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

USER root

RUN set -xe; \
    apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq \
        apache2-dev \
        curl \
        gcc+ \
        make \
        tar \
        vim && \
    apt-get clean

RUN mv /etc/localtime /etc/localtime_UTC && \
    ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

COPY conf/vhosts.conf /usr/local/apache2/conf/vhosts.conf

#
#───────────────────────────────────────────────────────────────────────────────
# Tomcat Connector:
#───────────────────────────────────────────────────────────────────────────────
#
ARG CONNECTOR_VERSION
ARG INSTALL_TOMCAT_CONNECTOR=false

RUN if [ ${INSTALL_TOMCAT_CONNECTOR} = true ]; then \
        curl -kSL https://downloads.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-${CONNECTOR_VERSION}-src.tar.gz -o tomcat-connectors-${CONNECTOR_VERSION}-src.tar.gz && \
        mkdir -p tomcat-connectors && \
        tar xzf tomcat-connectors-${CONNECTOR_VERSION}-src.tar.gz -C ./tomcat-connectors --strip-components=1 && \
        rm -f tomcat-connectors-${CONNECTOR_VERSION}-src.tar.gz && \
        cd ./tomcat-connectors/native && ./configure --with-apxs=/usr/local/apache2/bin/apxs && make && make install && \
        cp apache-2.0/mod_jk.so /usr/local/apache2/modules && \
        rm -rf ../../tomcat-connectors; \
    fi

#
#───────────────────────────────────────────────────────────────────────────────
# HTTP2:
#───────────────────────────────────────────────────────────────────────────────
#
ARG INSTALL_HTTP2=false
ENV APACHE_HTTP2=${INSTALL_HTTP2}


#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━FINAL TOUCH━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG DOCUMENT_ROOT=/usr/local/apache2/htdocs
ENV WEB_DOCUMENT_ROOT=${DOCUMENT_ROOT}

ENV LOG_STDOUT=/var/log/access.log
ENV LOG_STDERR=/var/log/error.log

WORKDIR /var/www

RUN chown -R www-data:www-data /var/www

# ENTRYPOINT [ "/opt/docker/bin/entrypoint.sh" ]

ADD startup.sh /opt/startup.sh

# CMD [ "/bin/bash", "/opt/startup.sh" ]

EXPOSE 80 443