# Docker

## Create a docker development environment
___
Enter the ***.Docker*** folder and copy ***example.env*** to ***.env***
```bash
$ cp example.env .env
```

복사된 ***.env*** 파일을 열어 ***Environment*** 부분의 ***ENV_NAME***에 개발 환경 이름으로 변경하자. ***ENV_NAME***은 일부 ***container***에서 사용자 명으로 사용되기도 한다.

## Commands
___

### up
Build the environment and run it using `docker-compose`
```bash
$ docker-compose up -d --build [SERVICE ...]
$ docker-compose -f docker-compose.local.yml up -d --build [SERVICE ...]
```

### ps
List containers
```bash
$ docker-compose ps
```

### logs
Check service logs, usually with -f option to check in real time.
```bash
$ docker-compose logs -f [SERVICE ...]
```

### config
Check Docker Compose settings
```bash
$ docker-compose config
```

### exec
Enter the container, to execute commands like
```bash
# $ docker-compose exec [CONTAINER] /bin/bash
# $ docker-compose exec --user=[env name] [CONTAINER] /bin/bash
$ docker exec -it [CONTAINER] /bin/bash
```

### down
***docker-compose.yml*** 파일의 내용이 변경이 되었다면 기존 ***docker-compose.yml***로 생성된 container들을 삭제해준 후 재생성을 해야 한다. 그런데 수정하고 삭제를 하면 안되더라... 수정하기 전에 지워주자.
```bash
$ docker-compose down

# with volumes
$ docker-compose down -v
```

### rm
Removes stopped service containers.
```bash
$ docker-compose rm
```

## network
List networks
```bash
# List networks
$ docker network ls

# Remove all unused networks
$ docker network prune
```

## volume
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

## Modify the hosts domain of localhost(macOS)
___
Open the ***/etc/hosts***  file with administrator privileges and register the following
```text
127.0.0.1       <domain name>
127.0.0.1:80    <domain name>
```

After modifying the ***/etc/hosts*** file, `dscacheutil -flushcache`.  
Create the added domain-related ***< project name >.conf*** file on the Web Server.

docker 없이 api를 실행시키려면 아래와 같은 명령어가 필요해
```
$ ./gradlew build && java -jar incyverse-api/build/libs/incyverse-api-0.0.1-SNAPSHOT.jar
```

## log
```bash
$ tail -f <path>
```

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