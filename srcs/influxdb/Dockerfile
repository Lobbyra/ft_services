# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/24 18:13:28 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/02 14:17:39 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- Env variables
# INFLUX_ADM_PASS <- InfluxDB admin password.
# INFLUX_TELE_PASS <- Telegram account password in influxDB.
# DB_NAME <- Name of the database you want to complete with telegraf.
#			/!\ The DB is created if needed.

FROM	alpine

ADD		srcs/ /root

RUN		apk add openrc influxdb gettext

EXPOSE	8086

CMD [ "/bin/ash", "/root/init.sh" ]
