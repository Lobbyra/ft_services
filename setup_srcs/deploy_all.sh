#! /bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    deploy_all.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/04 14:01:37 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/04 16:22:16 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

services[0]="ftps"
services[1]="grafana"
services[2]="nginx"
services[3]="phpmyadmin"
services[4]="wordpress"
services[5]="telegraf"
services[6]="mariadb"
services[7]="influxdb"

function mount_local_volumes ()
{
	mkdir -p srcs/ftps/ftp &> /dev/null
	minikube mount srcs/nginx/www:/mnt/nginx &> /dev/null &
	minikube mount srcs/ftps/ftp:/mnt/ftp &> /dev/null &
}

Note="📝 ${Grey}Note${NC}"
Error="❌ ${Red}Error${NC}"
Warning="❗️ ${Pink}Warning${NC}"

function editor_ftps_address ()
{
	sed=$1
	if [ "$2" = "42mac" ]
	then
		$sed -i "s/172.0.0/192.168.99/g" srcs/ftps/srcs/init.sh
	else
		$sed -i "s/192.168.99/172.0.0/" srcs/ftps/srcs/init.sh
	fi
} 

function rename_ftps_init ()
{
	if [ "$1" = "42mac" ]
	then
		gsed &> /dev/null
		if [ $? = 127 ]
		then
			brew install gnu-sed > /dev/null
			if [ $? != 0 ]
			then
				printf "${Error} : Error while installing script dependance, please check logs.\n"
				return 1
			fi
		fi
		generator "gsed" $1
	elif [ "$2" = "42linux" ]
	then
		generator "sed" $1
	fi
}

function deploy_all ()
{
	rename_ftps_init $1
	for i in $(seq 0 7)
	do
		kubectl apply -f srcs/${services[$i]} > /dev/null
		printf "🤖 : ${services[$i]} deployed.\n"
	done
	mount_local_volumes
	printf "✅ : All services are deployed in k8s !.\n"
}

deploy_all
