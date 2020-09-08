# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 16:43:03 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/08 16:57:14 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine

# Set workdir
RUN		mkdir /tmp/ft_services_payload /www
ADD		srcs/ /tmp/ft_services_payload
WORKDIR	/tmp/ft_services_payload

# Install core services
RUN		apk add openrc nginx openssl openssh

# Moving necessary files
ADD		srcs/nginx.conf /etc/nginx/
ADD		srcs/sshd_config /etc/ssh/
ADD		srcs/index.html /www

EXPOSE	80 443 22

CMD [ "/bin/ash", "/tmp/ft_services_payload/init.sh" ]
