# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/02 14:15:45 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/02 14:22:53 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- ENV VARIABLES
# INFLUX_TELE_PASS <- password of telegraf user in influxdb

FROM	alpine

ADD		srcs /root

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


CMD		[ "/bin/ash", "/root/init.sh" ]
