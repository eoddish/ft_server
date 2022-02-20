FROM debian:buster

#docker build -t nginx .
#docker run -it -p 80:80 -p 443:443 nginx

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo\
	 php-gd php-cli php-mbstring wget nginx mariadb-server

RUN openssl req -x509 -nodes -days 1 -newkey rsa:4096\
	 -subj "/C=RU/ST=Moscow/L=Moscow/O=21school/OU=development/CN=eoddish"\
	 -keyout /etc/ssl/private/ft_server.key -out /etc/ssl/certs/ft_server.crt;

COPY ./srcs/ft_server /etc/nginx/sites-available/ft_server
RUN ln -s /etc/nginx/sites-available/ft_server /etc/nginx/sites-enabled/ft_server
RUN unlink /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default

WORKDIR /var/www/html/

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xf latest.tar.gz && rm latest.tar.gz
COPY ./srcs/wp-config.php wordpress

RUN chown -R www-data:www-data *
RUN chmod -R 755 *

RUN rm index.nginx-debian.html
RUN nginx -t

WORKDIR /
COPY ./srcs/start.sh start.sh
COPY ./srcs/configSQL.ini configSQL.ini
RUN chmod 755 start.sh
ENTRYPOINT ["sh", "start.sh"]
