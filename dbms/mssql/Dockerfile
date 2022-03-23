#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG MSSQL_VERSION
FROM mcr.microsoft.com/mssql/server:${MSSQL_VERSION}

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

USER root

ARG TZ=UTC
ENV TZ=${TZ}
RUN mv /etc/localtime /etc/localtime_UTC && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

ENV MSSQL_PID=$MSSQL_PID
ENV MSSQL_DATABASE=$MSSQL_DATABASE
ENV MSSQL_COLLATION=$MSSQL_COLLATION
ENV SA_PASSWORD=$SA_PASSWORD
ENV ACCEPT_EULA=$ACCEPT_EULA

VOLUME [ "/var/opt/mssql" ]

EXPOSE 1433