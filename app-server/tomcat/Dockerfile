#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   TOMCAT IMAGE SETUP
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG VERSION=latest
FROM tomcat:${VERSION}

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

#────:
USER root

RUN set -xe; \
    apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq \
        vim

ARG TZ=UTC
ENV TZ=${TZ}
RUN mv /etc/localtime /etc/localtime_UTC && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

ENV CATALINA_HOME=/usr/local/tomcat
ENV CATALINA_BASE=/usr/local/tomcat

ENV JAVA_OPTS="-Dspring.profiles.active=$PROFILE"

ADD setenv.sh /usr/local/tomcat/bin

# ARG PROJECT_NAME
RUN rm -rf /usr/local/tomcat/webapps/*
# COPY ./${PROJECT_NAME}.war /usr/local/tomcat/webapps/ROOT.war

# ENTRYPOINT [ "/usr/local/tomcat/bin/catalina.sh", "run" ]

# Clean up
RUN apt-get clean

WORKDIR /usr/local/tomcat

CMD [ "catalina.sh", "run" ]

EXPOSE 8009
