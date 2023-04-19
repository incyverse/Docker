#!/bin/bash

DOCKER_APP_NAME=project_name

EXIST_BLUE=$(/usr/local/bin/docker-compose -p ${DOCKER_APP_NAME})
