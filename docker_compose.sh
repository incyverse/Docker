#!/bin/bash

action=""
project=""
error="false"

function down() {
    echo "Docker Down!!"
    if [ $project ]; then
        docker-compose -p $project down -v
    else
        docker-compose down -v
    fi
    rm -rf ../docker-storage
}

function up() {
    echo "Docker Up!!"
    if [ $project ]; then
        docker-compose -p $project up -d --build $service
    else
        docker-compose up -d --build $service
    fi
}

function updown() {
    down
    up
}

while (( $# )); do
    case $1 in
        -a|--action)
            if [ -z $2 ] || [ ${2:0:1} = "-" ]; then
                action="updown"
                shift 1
            elif [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
                action=$2
                shift 2
            else
                error="miss"
                break
            fi
            ;;
        -p|--project)
            if [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
                project=$2
                shift 2
            else
                error="miss"
                break
            fi
            ;;
        -s|--service)
            if [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
                service=$2
                shift 2
            else
                error="miss"
                break
            fi
            ;;
        -h|--help)
            echo "Usage:    $0 -a <action> [options...]" >&2
            echo "          -a | --action" >&2
            echo "          -p | --project" >&2
            echo "          -s | --service" >&2
            exit 0
            ;;
        *)
            echo "Error: Arguments with not proper flag: $1" >&2
            echo "$0 -h | --help for help message" >&2
            exit 1
            ;;
    esac
done

if [ $error = "miss" ]; then
    echo "Error: Argument for $1 is missing"
    exit 1
fi

if [ $action = "down" ]; then
    down
elif [ $action = "up" ]; then
    up
else
    updown
fi