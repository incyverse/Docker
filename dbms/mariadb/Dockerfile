#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG MARIADB_VERSION=latest
FROM mariadb:${MARIADB_VERSION}

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

ARG TZ=UTC
ENV TZ=${TZ}
RUN mv /etc/localtime /etc/localtime_UTC && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    chown -R mysql:root /var/lib/mysql/

COPY my.cnf /etc/mysql/conf.d/my.cnf

RUN chmod -R 644 /etc/mysql/conf.d/my.cnf

CMD [ "mysqld" ]

EXPOSE 3306