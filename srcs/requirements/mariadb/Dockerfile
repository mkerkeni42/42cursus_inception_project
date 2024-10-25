FROM 	alpine:3.19

RUN		apk update && apk upgrade \
		&& apk add --no-cache mariadb mariadb-client mariadb-server-utils

COPY	./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY	./tools/docker-entrypoint.sh /usr/local/bin/

RUN		chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE	3306

ENTRYPOINT	["docker-entrypoint.sh"]
