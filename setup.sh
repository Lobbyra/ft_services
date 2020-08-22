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

fun_install_docker ()
{
	printf "🤖 : Checking your Docker setup...\n"
	if [ ! -d "/Applications/Docker.app" ]
	then
		printf "${Error} : Docker isn't installed on your computer.\n"
		printf "${Note} : Install it via Managed Software Center and rerun the script.\n"
		exit 1
	fi
	if [ ! -d "$HOME/.docker" ] && [ ! -L "$HOME/.docker" ]
	then
		rm -rf ${Goinfre_path}/.docker
		mkdir "${Goinfre_path}/.docker"
		ln -sf ${Goinfre_path}/.docker $HOME/.docker
	fi
	if [ -L "$HOME/.docker" ] && [ ! -d "${Goinfre_path}/.docker" ]
	then
		mkdir ${Goinfre_path}/.docker
	fi
	if [ -d "$HOME/.docker" ] && [ ! -L "$HOME/.docker" ]
	then
		mv $HOME/.docker ${Goinfre_path}/
		ln -sf ${Goinfre_path}/.docker $HOME/.docker
	fi
	printf "✅ : Docker setup 1/2.\n"
	if [ ! -d "$HOME/Library/Containers/com.docker.docker" ] && [ ! -L "$HOME/Library/Containers/com.docker.docker" ]
	then
		mkdir ${Goinfre_path}/com.docker.docker
		ln -sf ${Goinfre_path}/com.docker.docker $HOME/Library/Containers/com.docker.docker
	fi
	if [ -L "$HOME/Library/Containers/com.docker.docker" ] && [ ! -d "${Goinfre_path}/com.docker.docker" ]
	then
		mkdir ${Goinfre_path}/com.docker.docker
	fi
	if [ -d "$HOME/Library/Containers/com.docker.docker" ] && [ ! -L "$HOME/Library/Containers/com.docker.docker" ]
	then
		rm -rf $HOME/Library/Containers/com.docker.docker
		rm -rf ${Goinfre_path}/com.docker.docker
		ln -sf ${Goinfre_path}/com.docker.docker $HOME/Library/Containers/com.docker.docker
	fi
	printf "✅ : Docker setup 2/2.\n"
	printf "✅ : Docker is correctly setup !\n"
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
}
# ====================================================================================================================

fun_parsing_arg $1

# Setup all software needed for this project
# =============


if [ "$1" = "42mac" ]
then
	fun_check_brew
	fun_check_vbox
	fun_install_minikube
	fun_install_docker
fi

# =============

# Docker images creation
# =============
# =============

# K8s deployements and setup
# =============
#-Secret file creation and applyment
#-Deployements of pods

#-Services applyments

# =============
