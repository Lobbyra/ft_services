# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/22 17:40:08 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/22 17:51:30 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Nginx starting
openrc
touch /run/openrc/softlevel
service nginx start

tail -f /dev/null	# Freeze command to avoid end of container
