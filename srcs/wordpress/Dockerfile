# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/25 13:09:25 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/31 17:39:12 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# docker run -it --network="bridge" -p 5050:5050 -e WP_USER_PASS="1f6gs4fsg5" -e MYSQL_IP="172.17.0.2" wp_srv

# --- Environnement Variables
# WP_USER_PASS <- password of the wordpress mysql account

FROM	alpine

ADD		srcs/ /root/

RUN		mkdir -p /srv/www/wordpress

RUN		apk add wget php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN		wget http://fr.wordpress.org/latest-fr_FR.tar.gz -P /tmp	\
		&& tar xzf /tmp/latest-fr_FR.tar.gz -C /srv/www/wordpress

EXPOSE	5050

CMD		[ "/bin/ash", "/root/init.sh" ]
