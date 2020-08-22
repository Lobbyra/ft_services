# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 16:43:03 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/22 18:20:14 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine

# Alpine landing in OS
RUN		mkdir /tmp/ft_services_payload
ADD		srcs/ /tmp/ft_services_payload
WORKDIR	/tmp/ft_services_payload

RUN		apk add openrc nginx

# Nginx setup
RUN		adduser -D -g 'www' www
RUN		mkdir /www
RUN		chown -R www:www /var/lib/nginx
RUN		chown -R www:www /www
RUN		mv /etc/nginx/nginx.conf /etc/nginx/nginx.old

ADD		srcs/nginx.conf /etc/nginx/
ADD		srcs/index.html /www
ADD		srcs/server.crt /etc/ssl/certs/
ADD		srcs/server.key /etc/ssl/private/

EXPOSE	80 443 301

CMD [ "/bin/ash", "/tmp/ft_services_payload/init.sh" ]
