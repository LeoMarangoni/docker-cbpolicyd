# Docker cbpolicyd


Ready to run image for Cluebringer policyd

Requirements:
- Docker
- MTA Server (Tested with postfix)
- Mysql database (tested with mariadb-server-10.1):
  - Create database (ex: cbpolicyd)
  - Create user and password (ex: cbp_user, cbp_pass)


### Usage
You will need to initialize database if it is a new server install.
Set CB_INIT_DB=1 envvar to do that!
```sh
docker run -ti \
    -e "CB_DB_HOST=10.0.1.110" \
    -e "CB_DB_USER=cbp_user" \
    -e "CB_DB_PASS=cbp_pass" \
    -e "CB_INIT_DB=1" \
    marangoni/cbpolicyd
```
Run cbpolicyd container, bind ports 80 (webui), and 10031 (police service):
```sh
docker run -ti \
    -e "CB_DB_HOST=10.0.1.110" \
    -e "CB_DB_USER=cbp" \
    -e "CB_DB_PASS=cbp" \
    -p 0.0.0.0:10031:10031 \
    -p 0.0.0.0:80:80 \
    marangoni/cbpolicyd
```