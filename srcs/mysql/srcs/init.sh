# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/24 17:29:14 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/25 15:55:01 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- ENV VARIABLES
# WP_USER_PASS <- Typical passwd of wordpress username
# ADMIN_PASS <- Administrator password for all DB

openrc &> /dev/null
touch /run/openrc/softlevel
/etc/init.d/mariadb setup &> /dev/null
sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
service mariadb restart &> /dev/null

mysql --user=root << EOF
  CREATE DATABASE wordpress;
  CREATE USER 'wpuser'@'%' IDENTIFIED BY '$WP_ADMIN_PASS';
  GRANT ALL ON wordpress.* TO 'wpuser'@'%' IDENTIFIED BY '$WP_USER_PASS' WITH GRANT OPTION;
  CREATE USER 'admin'@'%' IDENTIFIED BY '$ADMIN_PASS';
  GRANT ALL ON *.* TO 'admin'@'%' IDENTIFIED BY '$ADMIN_PASS' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
EOF

printf "Database started !\n"

/bin/ash
