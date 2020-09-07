#! /bin/bash

# ===========================================
NC="\033[0m"			# No Color
Red="\033[0;31m"
Green="\033[0;32m"
Pink="\e[38;5;013m"
Grey="\e[38;5;240m"

Note="📝 ${Grey}Note${NC}"
Error="❌ ${Red}Error${NC}"
Warning="❗️ ${Pink}Warning${NC}"

Goinfre_path="/Volumes/Storage/goinfre/$USER"
# ===========================================

# --- Order
# Argument selector
# Install dependances
# Check and setup configuration
# Generation des mots de passe
# minikube start
# eval $(minikube docker-env)
# docker build
# deployements services
# En fonction de l'ip du services de ftps, changer l'ip pour ftps
# Création des dossiers pour les volumes locales
# Montage des volumes locales
# Deployer le rester
# Afficher toutes les IP des services
# Afficher tout les mots de passes pour chaque service
# Lancer le dashboard

function exit_checker ()
{
	if [ "$?" != 0 ]
	then
		exit
	fi
}

function print_usage ()
{
	printf "USAGE: ./setup.sh [${Green}42mac${NC}|${Green}42linux${NC}]\n"
	printf "\tUse ${Green}42mac${NC} at 42 School iMac.\n"
	printf "\tUse ${Green}42linux${NC} for any linux.\n"
}

function parsing_arg ()
{
	if [ "$#" = 0 ]
	then
		printf "${Error} : Argument missing.\n"
		print_usage
		exit 1
	fi
	if [ "$1" != "42mac" ] && [ "$1" != "42linux" ]
	then
		printf "${Error} : Illegal argument.\n"
		print_usage
		exit 1
	fi
	if [ "$2" = "--goinfre" ] && [ "$#" = 3 ]
	then
		Goinfre_path=$3
		printf "Goinfre path changed to ${Goinfre_path}.\n"
		if [ ! -d ${Goinfre_path} ]
		then
			printf "${Error} : The goinfre path specified does not exist.\n"
			exit 1
		fi
	fi
}

function deploy_metallb ()
{
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml > /dev/null
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml > /dev/null
	if [ "$(kubectl get secrets --namespace metallb-system | grep memberlist)" = "" ]
	then
		kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" > /dev/null
	fi
	if [ $1 = "42mac" ]
	then
		kubectl apply -f srcs/metallb-config-mac.yaml > /dev/null
	else
		kubectl apply -f srcs/metallb-config-linux.yaml > /dev/null
	fi
}

function load_anim ()
{
	spin='-\|/'
	i=0

	while kill -0 $1 2>/dev/null
	do
	  i=$(( (i+1) %4 ))
	  printf "\r${spin:$i:1}"
	  sleep .1
	done
	printf "\b"
}

function main ()
{
	parsing_arg $1 $2 $3
	exit_checker $?
	printf "🤖 : Dependances checking.\n"
	sleep 1
	setup_srcs/dependancer.sh $1
	printf "🤖 : Minikube clean up...\n"
	minikube delete 2> /dev/null
	sleep 1
	printf "🤖 : Minikube starting...\n"
	if [ "$1" = "42mac" ]
	then
		minikube start --vm-driver=virtualbox
		exit_checker $?
	else
		echo "user42\nuser42" | sudo -S chmod 666 /var/run/docker.sock
		minikube start --vm-driver=docker
		exit_checker $?
	fi
	eval $(minikube docker-env)
	minikube addons enable logviewer
	minikube addons enable metrics-server
	setup_srcs/gen_secret.sh $1
	deploy_metallb $1
	setup_srcs/docker_build.sh
	setup_srcs/deploy_all.sh $1
	setup_srcs/print_informations.sh
}

main $1 $2 $3
