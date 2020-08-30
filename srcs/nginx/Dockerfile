# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 16:43:03 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/30 16:06:25 by Lobbyra          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM alpine

# Set workdir
RUN		mkdir /tmp/ft_services_payload
ADD		srcs/ /tmp/ft_services_payload
WORKDIR	/tmp/ft_services_payload

# Install core services
RUN		apk add openrc nginx openssl

# Moving necessary files
ADD		srcs/nginx.conf /etc/nginx/

EXPOSE	80 443

CMD [ "/bin/ash", "/tmp/ft_services_payload/init.sh" ]
