#! /bin/bash

services[0]="ftps"
services[1]="grafana"
services[2]="nginx"
services[3]="phpmyadmin"
services[4]="wordpress"
services[5]="telegraf"
services[6]="mariadb"
services[7]="influxdb"

Note="📝 ${Grey}Note${NC}"
Error="❌ ${Red}Error${NC}"
Warning="❗️ ${Pink}Warning${NC}"

function mount_local_volumes ()
{
	mkdir -p srcs/ftps/ftp &> /dev/null
	minikube mount srcs/nginx/www:/mnt/nginx &> /dev/null &
	minikube mount srcs/ftps/ftp:/mnt/ftp &> /dev/null &
}

function deploy_all ()
{
	mount_local_volumes
	kubectl apply -f setup_srcs/secret.yaml
	for i in $(seq 0 7)
	do
		kubectl apply -f srcs/${services[$i]} > /dev/null
		printf "🤖 : ${services[$i]} deployed.\n"
	done
	printf "✅ : All services are deployed in k8s !.\n"
}

deploy_all
