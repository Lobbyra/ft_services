# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/24 12:12:54 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/07 11:36:22 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Env variables
# FTPS_USER <- Username of the user you want to create
# FTPS_PASS <- The password of the user

# Command to run this container manually
# docker run -p 21:21 -p 21000-21010:21000-21010 -e USERS="test1|1test" -e ADDRESS="localhost" -it ftps_srv

FROM	alpine

RUN		apk add vsftpd openssl openrc curl

ADD		srcs/vsftpd.conf /etc/vsftpd/
ADD		srcs/ /root

EXPOSE	20 21 21000-21004

VOLUME [ "/ftp" ]

CMD [ "/bin/ash", "/root/init.sh" ]
