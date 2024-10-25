FROM	alpine:3.19

RUN		apk update && apk upgrade \
		&& apk add --no-cache wget tar php82 php82-fpm php82-mysqli \
		php82-zlib php82-curl php82-json php82-xml php82-phar php82-xmlreader  \
		php82-ctype php82-session php82-mbstring mariadb-client

RUN		addgroup -S nginx && adduser -S nginx -G nginx

WORKDIR	/var/www/html/

RUN    wget https://fr.wordpress.org/wordpress-6.6-fr_FR.tar.gz \
       && tar -xzf wordpress-6.6-fr_FR.tar.gz \
       && rm wordpress-6.6-fr_FR.tar.gz

RUN		sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf \
		&& echo "clear_env = no" >> /etc/php82/php-fpm.d/www.conf

RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp \
		&& chmod +x /usr/local/bin/wp

COPY	./tools/docker-entrypoint.sh /usr/local/bin/

RUN		chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE	9000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
