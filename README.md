# Docker

## Create a docker development environment
___
Enter the ***.Docker*** folder and copy ***example.env*** to ***.env***

```bash
cp example.env .env
```

***.env*** 파일을 열어 ***Environment*** 부분의 ***ENV_NAME***에 개발 환경 이름을 작성 한다.  
***ENV_NAME***은 특정 container에서 사용자 명으로 사용 되기도 한다.

## Docker Commands
___
Build the environment and run it using `docker-compose`
```bash
# docker-compose up -d --build <service name>
docker-compose up -d --build nginx mariadb
```

List containers
```bash
docker-compose ps
```

List networks
```bash
docker network ls
```

Remove all unused networks
```bash
docker network prune
```

Check settings
```bash
docker-compose config
```

Enter the Workspace container, to execute commands like
```bash
docker-compose exec workspace zsh
docker-compose exec --user=<environment name> workspace zsh
```

Check container logs, usually with -f option to check in real time.
```bash
docker-compose logs -f <container name>
```

***docker-compose.yml*** 파일의 내용이 변경이 되었다면 기존 ***docker-compose.yml***로 생성된 container들을 삭제해준 후 재생성을 해야 한다.
```bash
docker-compose down

# with volumes
docker-compose down -v
```

## Build my docker account
___
Deploy Docker
```bash
docker build -t < docker username >/< docker repository >:< tagname > -f Dockerfile .
docker run --rm -it < docker username >/< docker repository >:< tagname > /bin/bash
docker push < docker username >/< docker repository >:< tagname >
```

## Modify the hosts domain of localhost(macOS)
___
Open the ***/etc/hosts***  file with administrator privileges and register the following
```text
127.0.0.1    < domain name >
```

After modifying the ***/etc/hosts*** file, `dscacheutil -flushcache`.  
Create the added domain-related ***< project name >.conf*** file on the Web Server.
