FROM openjdk:8u312-jre-alpine

COPY . /usr/src/webapp

WORKDIR /usr/src/webapp

RUN javac Main.java

CMD [ "java", "Main" ]