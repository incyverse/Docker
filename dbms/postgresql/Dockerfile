#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG POSTGRESQL_VERSION
FROM postgres:${POSTGRESQL_VERSION}

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

USER root

RUN set -xe; \
    apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq \
        vim && \
    apt-get clean

ARG TZ=UTC
ENV TZ=${TZ}
ARG LOCALE=en_US
RUN mv /etc/localtime /etc/localtime_UTC && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    localedef -i ${LOCALE} -c -f UTF-8 -A /usr/share/locale/locale.alias ${LOCALE}.UTF-8

ENV POSTGRES_DB=$POSTGRES_DB
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_INITDB_ARGS=$POSTGRES_INITDB_ARGS

CMD [ "postgres" ]

EXPOSE 5432