#
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━IMAGE SETUP━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
ARG TOMCAT_VERSION
FROM tomcat:${TOMCAT_VERSION}-jdk8-openjdk

LABEL maintainer="Anthony Oh <incyverse@gmail.com>"

USER root

ARG PROJECT_NAME

RUN rm -rf /usr/local/tomcat/webapps/ROOT.war
COPY ./${PROJECT_NAME}.war /usr/local/tomcat/webapps/ROOT.war

WORKDIR /usr/local/tomcat

EXPOSE 8080

CMD [ "./catalina.sh", "run" ]