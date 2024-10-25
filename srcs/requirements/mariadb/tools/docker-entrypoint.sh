#!/bin/sh

set -e

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_DATABASE=$(grep 'WP_DB_NAME=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
MYSQL_USER=$(grep 'WP_DB_USER=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initialisation de la base de donnees..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --datadir=/var/lib/mysql --socket='/var/run/mysqld/mysqld.sock' &
pid="$!"

until mysqladmin ping -h "127.0.0.1" --silent; do
    echo "Waiting for database connection..."
    sleep 1
done
 
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';" 
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

kill "$pid"
wait "$pid"

exec mysqld_safe --datadir=/var/lib/mysql --socket='/var/run/mysqld/mysqld.sock'
