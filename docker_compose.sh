#!/bin/bash

# prints colored text
print_style () {
    if [ "$2" == "info" ]; then
        COLOR="96m"
    elif [ "$2" == "success" ]; then
        COLOR="92m"
    elif [ "$2" == "warning" ]; then
        COLOR="93m"
    elif [ "$2" == "danger" ]; then
        COLOR="91m"
    else # default color
        COLOR="0m"
    fi

    STARTCOLOR="\e[$COLOR"
    ENDCOLOR="\e[0m"

    printf "$STARTCOLOR%b$ENDCOLOR" "$1"
}

display_options () {
    printf "Usage: $0 COMMAND [OPTIONS]\n\n";

    printf "Available Commands:\n";
    # print_style "   install" "info"; printf "\t\t Installs docker-sync gem on the host machine.\n"
    print_style "   up [PROJECT] [SERVICES]" "success"; printf "\t Create and start containers\n"
    print_style "\t\t\t\t usage: $0 up [PROJECT] [SERVICES]\n" "info"
    print_style "   down" "success"; printf "\t\t\t\t Stop and remove containers, networks, volumes\n"
    print_style "\t\t\t\t usage: $0 down\n" "info"
    print_style "   bash [SERVICE]" "success"; printf "\t\t Execute a command in a running container.\n"
    print_style "\t\t\t\t usage: $0 bash [SERVICE]\n" "info"
    # print_style "   sync" "info"; printf "\t\t\t Manually triggers the synchronization of files.\n"
    # print_style "   clean" "danger"; printf "\t\t Removes all files from docker-sync.\n"
    print_style "   reup [PROJECT] [SERVICES]" "danger"; printf "\t Removes all containers, networks, volumes and Create conatiners, networks, volumes\n"
    print_style "\t\t\t\t usage: $0 reup [PROJECT] [SERVICES]\n\n" "info"

    printf "Options:\n";
    print_style "   -p, --project string" "success"; printf "\t\t Project name\n"
    print_style "   -s, --service [SERVICES]" "success"; printf "\t Service name\n"
}

missing_argument () {
    print_style "Argument for $2 is missing." "warning"; printf "$0 -h | --help for help message\n";
}

not_options () {
    print_style "Arguments with not proper option: $1" "warning"; printf "$0 -h | --help for help message\n";
}

if [[ $# -eq 0 ]]; then
    missing_argument
    exit 1
fi

if [ "$1" == "up" ]; then
    # while [ $# -gt 1 ]; do
    #     case $2 in
    #         -p|--project)
    #             echo "project"
    #             ;;
    #         -s|--service)
    #             echo "service"
    #             ;;
    #     esac
    #     shift
    # done
    print_style "May take a long time (15min+) on the first run\n" "info"
    shift # removing first argument
    docker compose up -d --build
fi

#     print_style "Initializing Docker Sync\n" "info"
#     print_style "May take a long time (15min+) on the first run\n" "info"
#     # docker-sync start;

#     print_style "Initializing Docker Compose\n" "info"
#     shift # removing first argument
#     # docker-compose up -d ${@}

# while (( $# )); do
#     case $1 in
#         -a|--action)
#             if [ -z $2 ] || [ ${2:0:1} = "-" ]; then
#                 action="updown"
#                 shift 1
#             elif [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
#                 action=$2
#                 shift 2
#             else
#                 error="miss"
#                 break
#             fi
#             ;;
#         -p|--project)
#             if [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
#                 project=$2
#                 shift 2
#             else
#                 error="miss"
#                 break
#             fi
#             ;;
#         -s|--service)
#             if [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
#                 service=$2
#                 shift 2
#             else
#                 error="miss"
#                 break
#             fi
#             ;;
#     esac
# done



#     if [ -z $2 ] || [ ${2:0:1} = "-" ]; then
#         echo "aa"
#         echo "$1"
#     else
#         echo "a"
#         missing_argument
#         exit 1
#     fi
#     # if [ -z $2 ] || [ ${2:0:1} = "-" ]; then
#     #             action="updown"
#     #             shift 1
#     #         elif [ ! -z $2 ] && [ ${2:0:1} != "-" ]; then
#     #             action=$2
#     #             shift 2
#     #         else
#     #             error="miss"
#     #             break
#     #         fi







# if [ "$1" == "up" ]; then


# elif [ "$1" == "down" ]; then
#     print_style "Stopping Docker Compose\n" "info"
#     docker-compose stop

#     print_style "Stopping Docker Sync\n" "info"
#     docker-sync stop

# elif [ "$1" == "bash" ]; then
#     docker-compose exec --user=incyverse Workspace bash

# elif [ "$1" == "install" ]; then
#     print_style "Installing docker-sync\n" "info"
#     gem install docker-sync

# elif [ "$1" == "sync" ]; then
#     print_style "Manually triggering sync between host and docker-sync container.\n" "info"
#     docker-sync sync

# elif [ "$1" == "clean" ]; then
#     print_style "Removing and cleaning up files from the docker-sync container.\n" "warning"
#     docker-sync clean

# else
#     print_style "Invalid arguments.\n" "danger"
#     display_options
#     exit 1

# fi






# error="false"


# function down() {
#     echo "Docker Down!!"
#     if [ $project ]; then
#         docker-compose -p $project down -v
#     else
#         docker-compose down -v
#     fi
#     rm -rf ../docker-storage
# }

# function up() {
#     echo "Docker Up!!"
#     if [ $project ]; then
#         docker-compose -p $project up -d --build $service
#     else
#         docker-compose up -d --build $service
#     fi
# }

# function updown() {
#     down
#     up
# }

# if [ $error = "miss" ]; then
#     echo "Error: Argument for $1 is missing"
#     exit 1
# fi

# if [ $action = "down" ]; then
#     down
# elif [ $action = "up" ]; then
#     up
# else
#     updown
# fi