# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/24 18:13:28 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/31 15:25:10 by jecaudal         ###   ########.fr        #
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

# Fix libc dependency to run the grafana binary
RUN		mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# --- Download and install telegraf
# Download :
RUN		cd /tmp \
		&& wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz \
		&& tar -zxf telegraf-1.15.2_linux_amd64.tar.gz \
		&& mv telegraf-1.15.2 telegraf

# Installation :
RUN		cp -rf /tmp/telegraf/usr/* /usr \
		&& cp -rf /tmp/telegraf/etc/* /etc

EXPOSE	8086

CMD [ "/bin/ash", "/root/init.sh" ]
