# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 17:40:08 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/01 15:02:33 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Env Variables
# SSH_ROOT_PASSWORD <- Password to access to nginx container through SSH

echo "root:$SSH_ROOT_PASSWORD" | chpasswd

# Creating SSL keys
openssl req -x509 -nodes -subj '/CN=localhost' -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt

# Nginx setup
adduser -D -g 'www' www
chown -R www:www /var/lib/nginx
chown -R www:www /www

# Nginx & SSH starting
openrc
touch /run/openrc/softlevel
service nginx start
service sshd start

tail -F /dev/null
