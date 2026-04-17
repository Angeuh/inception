#!/bin/sh

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then 
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)
mariadb-install-db --user=mysql --datadir=/var/lib/mysql
mariadbd --user=mysql --datadir=/var/lib/mysql &

until mariadb-admin ping 2>&1; do
    echo "Waiting for MariaDB to boot..."
    sleep 2
done
mariadb -u root -p${DB_ROOT_PASSWORD} <<-EOSQL
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL

# Stop temporary server
mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown

chown -R mysql:mysql /var/lib/mysql
fi
# cmd to run mariadb
exec mysqld_safe