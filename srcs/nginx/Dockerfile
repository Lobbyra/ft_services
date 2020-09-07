# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 16:43:03 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/07 12:18:13 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine

# Set workdir
RUN		mkdir /tmp/ft_services_payload
ADD		srcs/ /tmp/ft_services_payload
WORKDIR	/tmp/ft_services_payload

# Install core services
RUN		apk add openrc nginx openssl openssh

# Moving necessary files
ADD		srcs/nginx.conf /etc/nginx/
ADD		srcs/sshd_config /etc/ssh/

EXPOSE	80 443 22

CMD [ "/bin/ash", "/tmp/ft_services_payload/init.sh" ]
