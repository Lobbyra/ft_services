# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/24 17:30:42 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/25 15:50:00 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# docker run -it -p 3306:3306 --network="bridge" -e WP_USER_PASS="1f6gs4fsg5" -e ADMIN_PASS="fd9s4fdg98sdfg" mysql_srv

# --- ENV VARIABLES
# WP_USER <- Typical user of wordpress username
# WP_USER_PASS <- Typical passwd of wordpress username
# ADMIN_PASS <- Administrator password for all DB

FROM	alpine

RUN		apk add mysql mysql-client openrc

ADD		srcs/init.sh /root

EXPOSE	3306

CMD		[ "/bin/ash", "/root/init.sh" ]
