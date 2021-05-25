#!/bin/sh

cd /
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj \
			"/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" \
			-keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
cp -rp var/www/html/phpmyadmin/config.sample.inc.php var/www/html/phpmyadmin/config.inc.php
cp /tmp/phpmyadmin.php /var/www/html/phpmyadmin/config.inc.php

/etc/init.d/nginx start
/etc/init.d/php7.3-fpm start
/etc/init.d/mysql start

mysql < var/www/html/phpmyadmin/sql/create_tables.sql -u root --skip-password
echo "CREATE DATABASE IF NOT EXISTS wordpress;" \
    | mysql -u root --skip-password
echo "CREATE USER IF NOT EXISTS 'dim'@'localhost' IDENTIFIED BY '1234';" \
    | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'dim'@'localhost' WITH GRANT OPTION;" \
    | mysql -u root --skip-password

wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
cp /tmp/wordpress.php /var/www/html/wordpress/wp-config.php

/etc/init.d/nginx restart
/etc/init.d/php7.3-fpm restart
/etc/init.d/mysql restart

bash
