FROM	debian:buster

MAINTAINER	dim@student.42seoul.kr

RUN		apt-get update && apt-get -y install \
		nginx \
		openssl \
		vim \
		php-fpm \
		mariadb-server \
		php-mysql \
		wget \

COPY	./srcs/run.sh ./
COPY	./srcs/default ./tmp??
COPY	./srcs/config.inc.php ./tmp?? 
COPY	./srcs/wp-config.php ./tmp??

EXPOSE	80 443

ENTRYPOINT	["run.sh"]
