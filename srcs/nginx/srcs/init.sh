# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 17:40:08 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/26 18:51:53 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Creating SSL keys
openssl req -x509 -nodes -subj '/CN=localhost' -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt

# Nginx starting
openrc
touch /run/openrc/softlevel
service nginx start 2> /dev/null

tail -F /dev/null
