FROM	alpine:3.19

RUN		apk update && apk upgrade \
		&& apk add --no-cache nginx openssl

RUN		mkdir -p /etc/nginx/ssl \
		&& openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=PACA/L=Nice/O=42/OU=mkerkeni/CN=mkerkeni.42.fr"

RUN		mkdir -p /var/www/html/ \
		&& chown -R nginx:nginx /var/www/html/ \
		&& chmod -R 755 /var/www/html/

COPY	./conf/nginx.conf /etc/nginx/nginx.conf

RUN		chmod +x /etc/nginx/nginx.conf

EXPOSE	443

CMD 	[ "nginx", "-g", "daemon off;" ]
