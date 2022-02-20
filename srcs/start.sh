if [ -n "$1" ]
then
        {
                if [ "$1" = "0" ]
                then
                        sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/ft_server
                fi

        }
fi

service nginx start && service mysql start && service php7.3-fpm start
mysql -u root  < configSQL.ini

bash
