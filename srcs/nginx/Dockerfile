# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 16:43:03 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/22 23:07:45 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine

# Set workdir
RUN		mkdir /tmp/ft_services_payload
ADD		srcs/ /tmp/ft_services_payload
WORKDIR	/tmp/ft_services_payload

# Install core services
RUN		apk add openrc nginx openssl

# Nginx setup
RUN		adduser -D -g 'www' www \
		&& mkdir /www \
		&& chown -R www:www /var/lib/nginx \
		&& chown -R www:www /www \
		&& mv /etc/nginx/nginx.conf /etc/nginx/nginx.old

# Moving necessary files
ADD		srcs/nginx.conf /etc/nginx/
ADD		srcs/index.html /www

EXPOSE	80 443 301

CMD [ "/bin/ash", "/tmp/ft_services_payload/init.sh" ]
