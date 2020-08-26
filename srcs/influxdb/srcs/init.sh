# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/25 18:06:13 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/26 15:16:29 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Env variables
# INFLUX_ADM_PASS <- InfluxDB admin password.
# INFLUX_TELE_PASS <- Telegram account password in influxDB.
# DB_NAME <- Name of the database you want to complete with telegraf.
#			/!\ The DB is created if needed.

openrc
touch /run/openrc/softlevel
service influxdb start 
sleep 2
influx << EOF
CREATE USER admin WITH PASSWORD '$INFLUX_ADM_PASS' WITH ALL PRIVILEGES;
CREATE USER telegraf WITH PASSWORD '$INFLUX_TELE_PASS' WITH ALL PRIVILEGES;
EOF

envsubst '${INFLUX_TELE_PASS}' < /root/telegraf.conf > /etc/telegraf/telegraf.conf

telegraf
