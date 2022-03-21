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

ENV POSTGRES_DB=$POSTGRES_DB
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_INITDB_ARGS=$POSTGRES_INITDB_ARGS

CMD [ "postgres" ]

EXPOSE 5432