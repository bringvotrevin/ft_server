FROM	debian:buster

MAINTAINER	dim@student.42seoul.kr

RUN		apt-get update && apt-get -y upgrade \
		&& apt-get -y install nginx \
		openssl \
		vim \
		php-fpm \
		mariadb-server \
		php-mysql \
		wget

COPY	srcs/run.sh /tmp
COPY	srcs/default /etc/nginx/sites-available/default
COPY	srcs/phpmyadmin.php /tmp 
COPY	srcs/wordpress.php /tmp

EXPOSE	80 443

WORKDIR /tmp

ENTRYPOINT	["bash","run.sh","bash"]
