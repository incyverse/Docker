# Docker

## Create a docker development environment
___
Enter the ***.Docker*** folder and copy ***example.env*** to ***.env***
```bash
$ cp example.env .env
```

복사된 ***.env*** 파일을 열어 ***Environment*** 부분의 ***PROJECT_NAME***에 프로젝트 이름으로 변경하자. ***PROJECT_NAME***은 일부 ***container***에서 사용자 명으로 사용되기도 한다.

## Overview of docker-compose CLI
___
You can also this information by running `docker-compose --help` from the command line.

### Usage
Define and run multi-container applications with Docker.
```bash
docker-compose [-f <arg>...] [--profile <name>...] [options] [COMMAND] [ARGS...]
```

### Options
```
-f, --file FILE             Specify an alternate compose file (default: docker-compose.yml)
-p, --project-name NAME     Specify an alternate project name
--profile NAME              Specify a profile to enable
--verbose                   Show more output
--log-level LEVEL           DEPRECATED and not working from 2.0 - Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
--no-ansi                   Do not print ANSI control characters
-v, --version               Print version and exit
-H, --host HOST             Daemon socket to connect to

--tls                       Use TLS; implied by --tlsverify
--tlscacert CA_PATH         Trust certs signed only by this CA
--tlscert CLIENT_CERT_PATH  Path to TLS certificate file
--tlskey TLS_KEY_PATH       Path to TLS key file
--skip-hostname-check       Don't check the daemon's hostname against the name specified in the client certificate
--project-directory PATH    Specify an alternate working directory (default: the path of the Compose file)
--compatibility             If set, Compose will attempt to convert deploy keys in v3 files to their non-Swarm equivalent
```

### Commands
#### build
Build or rebuild services
#### bundle
Generate a Docker bundle from the Compose file

#### config
Validate and view the Compose file
```bash
$ docker-compose config
```

#### create
Create services

#### down
Stop and remove containers, networks, images, and volumes  
***docker-compose.yml*** 파일의 내용이 변경이 되었다면 기존 ***docker-compose.yml***로 생성된 container들을 삭제해준 후 재생성을 해야 한다. 그런데 수정하고 삭제를 하면 안되더라... 수정하기 전에 지워주자.
```bash
$ docker-compose down

# with volumes
$ docker-compose down -v
```

#### events
Receive real time events from containers

#### exec
Execute a command in a running container
```bash
# $ docker-compose exec [CONTAINER] /bin/bash
# $ docker-compose exec --user=[env name] [CONTAINER] /bin/bash
$ docker exec -it [CONTAINER] /bin/bash
```

#### help
Get help on a command
#### images
List Images
#### kill
Kill containers

#### logs
View output from containers  
Check service logs, usually with `-f` option to check in real time.
```bash
$ docker-compose logs -f [SERVICE...]
```

#### pause
Pause services
#### port
Print the public port for a port binding

#### ps
List containers
```bash
$ docker-compose ps
```

#### pull
Pull service images
#### restart
Restart services

#### rm
Remove stopped containers
```bash
$ docker-compose rm
```

#### run
Run a one-off command
#### scale
Set number of containers for a service
#### start
Start services
#### stop
Stop services
#### top
Display the running processes
#### unpause
Unpause services

#### up
Create and start containers
```bash
$ docker-compose -p [PROJECT NAME] up -d --build [SERVICE ...]
$ docker-compose -f [COMPOSE FILE NAME] -p [PROJECT NAME] up -d --build [SERVICE ...]
```

#### version
Show the Docker-Compose version information


### Network
```bash
# List networks
$ docker network ls

# Remove all unused networks
$ docker network prune
```

### Volume
```bash
$ docker volume ls
```

## Build my docker account
___
Deploy Docker
```bash
$ docker build -t <account>/<docker repository>:<tagname> -f Dockerfile .
$ docker run --rm -it <account>/<docker repository>:<tagname> /bin/bash
$ docker push <account>/<docker repository>:<tagname>
```

# Environment

## Modify the hosts domain of localhost(macOS)
___
Open the ***/etc/hosts***  file with administrator privileges and register the following
```text
127.0.0.1       <domain name>
127.0.0.1:80    <domain name>
```
After modifying the ***/etc/hosts*** file, `dscacheutil -flushcache`.  
Create the added domain-related ***< project name >.conf*** file on the Web Server.

# Linux

## Command
___

### Information about the OS version
```bash
$ uname -a
$ cat /etc/issue
$ cat /etc/*release*
$ getconf LONG_BIT

# Ubuntu
$ lsb_release -a
```

### log
```bash
$ tail -f <path>
```

# Kotlin

docker 없이 api를 실행시키려면 아래와 같은 명령어가 필요하다.
```
$ ./gradlew build && java -jar incyverse-api/build/libs/incyverse-api-0.0.1-SNAPSHOT.jar
```

# React

# Laravel
> 참조
> 
> [PHP](https://php.watch/)  
> [Laravel Permission](https://spatie.be/docs/laravel-permission/v3/installation-laravel/)

## Create laravel project
Workspace container access
```bash
# Use laravel installer
$ composer create-project --prefer-dist laravel/laravel <project name>
$ laravel new <project name>
```

# Composer
```bash
$ composer require "<package name>"
$ cat composer.json | grep "<package name>"
$ composer remove "<package name>"
```