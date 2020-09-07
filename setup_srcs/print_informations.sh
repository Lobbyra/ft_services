#! /bin/bash

# --- STEPS ---
# Print all services with their IPs
# Print all passwords for services

Pink="\e[0;33m"
Blue="\e[38;5;033m"
Orange="\e[0;33m"
NC="\033[0m"
White="\e[1;37m"

function print_passwords ()
{
	if [ $1 = "ftps" ]
	then
		pass="$(cat setup_srcs/secret.yaml | grep ftps_pass | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "passwords :\n"
		printf "\tuser\t-> ${Blue}login${NC} = michel\t${Orange}password${NC} = $pass\n"
	elif [ $1 = "influxdb" ]
	then
		pass="$(cat setup_srcs/secret.yaml | grep influxdb_admin_pass | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "passwords :\n"
		printf "\tadmin\t-> ${Blue}login${NC} = admin\t${Orange}password${NC} = $pass\n"
		pass="$(cat setup_srcs/secret.yaml | grep influxdb_tele_pass | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "\ttelegraf-> ${Blue}login${NC} = user_telegraf${Orange}password${NC} = $pass\n"
	elif [ $1 = "mariadb" ]
	then
		pass="$(cat setup_srcs/secret.yaml | grep maria_admin_pass | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "passwords :\n"
		printf "\tadmin\t-> ${Blue}login${NC} = admin\t${Orange}password${NC} = $pass\n"
		pass="$(cat setup_srcs/secret.yaml | grep wp_user_password | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "\twp_user\t-> ${Blue}login${NC} = wp_user\t${Orange}password${NC} = $pass\n"
	elif [ $1 = "wordpress" ]
	then
		pass="$(cat setup_srcs/secret.yaml | grep wp_user_password | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "passwords :\n"
		printf "\twp_user\t-> ${Blue}login${NC} = wp_user\t${Orange}password${NC} = $pass\n"
	elif [ $1 = "nginx" ]
	then
		pass="$(cat setup_srcs/secret.yaml | grep ssh_root_password | cut -d ":" -f 2 | cut -c2- | base64 --decode)"
		printf "passwords :\n"
		printf "\troot\t-> ${Blue}login${NC} = root\t\t${Orange}password${NC} = $pass\n"
	fi
}

function print_informations ()
{
	for i in $(seq 3 10)
	do
		name=$(kubectl get svc | sed -n "$i"p | cut -d " " -f 1 | cut -d "-" -f 2)
		ip=$(kubectl get svc | sed -n "$i"p | cut -c50- | cut -d " " -f 1)
		if [ $name != "telegraf" ]
		then
			printf "${White}$name${NC} :\n"
		fi
		if [ "$(kubectl get svc | grep LoadBalancer | grep $name)" != "" ]
		then
			printf "\tIP : $ip\n"
		fi
		print_passwords $name
		printf "\n"
	done
}

print_informations
