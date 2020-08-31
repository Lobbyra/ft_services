#!/bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/19 16:26:09 by jecaudal          #+#    #+#              #
#    Updated: 2020/08/21 17:40:26 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#>
## This script is to setup many services in Minikube.
## In this script you can find parts ordered by :
##		- Local Variables
##		- Functions
##		- Core Commands
#<

# Global Variables
# =================
NC="\033[0m"			# No Color
Black="\033[0;30m"
Red="\033[0;31m"
Green="\033[0;32m"
Yellow="\033[0;33m"
Blue="\033[0;34m"
Purple="\033[0;35m"
Cyan="\033[0;36m"
White="\033[0;37m"
Pink="\e[38;5;013m"
Grey="\e[38;5;240m"

Note="📝 ${Grey}Note${NC}"
Error="❌ ${Red}Error${NC}"
Warning="❗️ ${Pink}Warning${NC}"

Goinfre_path="/Volumes/Storage/goinfre/$USER"
# =================

# Functions
# ===================================================================================================================

fun_pushin_minikube ()
{
	minikube mount srcs/grafana/data:/mnt/grafana &> /dev/null &
	minikube mount srcs/nginx/www:/mnt/nginx &> /dev/null &
	minikube mount srcs/ftps/ftp:/mnt/ftp &> /dev/null &
}

fun_check_docker ()
{
	docker &> /dev/null
	if [ $? = 127 ]
	then
		printf "${Error} : Docker looks like not installed on your 42mac.\n"
		printf "${Note} : Please install it via managed software center.\n"
		exit 1
	fi
}

fun_load_anim ()
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

fun_install_minikube ()
{
	printf "🤖 : Installation of minikube...\n"
	minikube &> /dev/null
	if [ $? = 127 ]
	then
		brew install minikube > /dev/null &
		fun_load_anim $!
		printf "\b✅ : minikube installed.\n"
	elif [ $? = 0 ]
	then
		printf "minikube already installed.\n"
		return 0
	fi
	if [ -d ~/.minikube ] && [ ! -L ~/.minikube ]
	then
		mv ~/.minikube ${Goinfre_path}/
		ln -sf ${Goinfre_path}/.minikube ~/.minikube
	elif [ -L ~/.minikube ] && [ ! -d ${Goinfre_path}/.minikube ]
	then
		mkdir ${Goinfre_path}/.minikube
	elif [ ! -d ~/.minikube ]
	then
		mkdir ${Goinfre_path}/.minikube
		ln -sf ${Goinfre_path}/.minikube ~/.minikube
	fi
	if [ "$(minikube config get vm-driver)" != "virtualbox" ]
	then
		minikube config set vm-driver virtualbox
	fi
	ln -sf ${Goinfre_path}/.minikube ~/.minikube
	printf "\b✅ : minikube configured !\n"
}

fun_install_brew ()
{
	rm -rf $HOME/.brew >/dev/null &
	fun_load_anim $!
	printf "✅ 1/5 Done\n"
	git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew 2> /dev/null &
	fun_load_anim $!
	printf "✅ 2/5 Done\n"
	export PATH=$HOME/.brew/bin:$PATH > /dev/null &
	fun_load_anim $!
	printf "✅ 3/5 Done\n"
	brew update &> /dev/null &
	fun_load_anim $!
	printf "✅ 4/5 Done\n"
	echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc &
	fun_load_anim $!
	printf "✅ 5/5 Done\n"
}

fun_check_brew ()
{
	brew 2> /dev/null
	if [ $? = 127 ]
	then
		printf "${Warning} : Brew is not installed.\n"
		read -p 'Do you want to install it ? (N|[Y]) : ' REPLY
		if [ "${REPLY}" = "Y" ] || [ "${REPLY}" = "y" ] || [ "${REPLY}" = "" ]
		then
			printf "🤖 : Please wait during installation of brew...\n"
			fun_install_brew $1
		else
			printf "${Error} : Brew is needed to install componements.\n"
			exit 1
		fi
	fi
}

fun_check_vbox ()
{
	VBoxManage &> /dev/null
	if [ $? != 0 ]
	then
		printf "${Error} : Vbox looks not installed on your 42mac, please install it via Managed Software Center.\n"
		exit 1
	else
		printf "${Note} : Virtual box already installed.\n"
	fi
	return $?
}

fun_print_usage ()
{
	printf "USAGE: ./setup.sh [${Green}42mac${NC}|${Green}42linux${NC}]\n"
	printf "\tUse ${Green}42mac${NC} at 42 School iMac.\n"
	printf "\tUse ${Green}42linux${NC} for any linux.\n"
}

fun_parsing_arg ()
{
	if [ "$#" = 0 ]
	then
		printf "${Error} : Argument missing.\n"
		fun_print_usage
		exit 1
	fi
	if [ "$1" != "42mac" ] && [ "$1" != "42linux" ]
	then
		printf "${Error} : Illegal argument.\n"
		fun_print_usage
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

fun_build_images ()
{
	arr_img_dir=()
	while IFS= read -r line; do
		arr_img_dir+=( "$line" )
	done < <(find srcs -d 1 -type d)
	for i in ${arr_img_dir[@]}
	do
		printf "🤖 : Building $(echo $i | cut -d "/" -f 2) image.\n"
		docker build $i -t img-$(echo $i | cut -d "/" -f 2) > /dev/null &
		fun_load_anim $!
	done
}

# ====================================================================================================================

fun_parsing_arg $1 $2 $3

# Setup all software needed for this project
# ============================================

printf "🤖 : Checkup of your configuration...\n"

if [ "$1" = "42mac" ]
then
	fun_check_brew
	fun_check_vbox
	fun_install_minikube
	fun_check_docker
fi

printf "✅ : Your configuration is ready !\n"

# ============================================

# Minikube starting
printf "🤖 : Let's launch this images to the moon ! 🚀 \n"
printf "🤖 : Minikube will be started : Continue ? (N|[Y]) : "
read answer
printf "\n"
if [ "$answer" != "Y" ] && [ "$answer" != "" ]
then
	printf "🤖 : You need to start minikube to launch images.\n"
	exit 0
else
	minikube start &
	fun_load_anim $!
	eval $(minikube docker-env)
	#kubectl get configmap kube-proxy -n kube-system -o yaml | \
	#sed -e "s/strictARP: false/strictARP: true/" | \
	#kubectl apply -f - -n kube-system
	#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	#if [ "$(kubectl get secrets --namespace metallb-system | grep memberlist)" = "" ]
	#then
	#	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	#fi
	if [ $? != 0 ]
	then
		printf "${Error} : Minikube failed to start. Please solve error(s) and restart the script.\n"
		exit 1
	fi
	printf "✅ : Minikube started !\n"
fi

# Docker images creation
# =============
printf "🤖 : Docker image will be created : Continue ? (N|[Y]) : "
read answer
printf "\n"
if [ "$answer" != "Y" ] && [ "$answer" != "" ]
then
	printf "🤖 : You need this images to start services.\n"
	exit 0
else
	fun_build_images
	printf "✅ : Images created !\n"
fi

# =============

# K8s deployements and setup
# =============

printf "🤖 : Finally let's deploy all this stuff ! : Continue ? (N|[Y]) : "
read answer
printf "\n"
if [ "$answer" != "Y" ] && [ "$answer" != "" ]
then
	printf "🤖 : You need to deploy if you want your services.\n"
	exit 0
else
	# kubectl apply -f srcs/metallb-config.yaml
	kubectl apply -f srcs/nginx/deployment.yaml
	kubectl apply -f srcs/ftps/deployment.yaml
	kubectl apply -f srcs/influxdb/deployment.yaml
	kubectl apply -f srcs/grafana/deployment.yaml
	fun_pushin_minikube
	printf "✅ : Deployment finished !\n"
fi

#-Secret file creation and applyment
#-Deployements of pods

#-Services applyments

# =============
