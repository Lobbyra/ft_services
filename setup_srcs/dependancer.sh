#! /bin/bash

# --- DEFINE PART ---
# ===========================================
NC="\033[0m"
Red="\033[0;31m"
Green="\033[0;32m"
Pink="\e[38;5;013m"
Grey="\e[38;5;240m"

Note="📝 ${Grey}Note${NC}"
Error="❌ ${Red}Error${NC}"
Warning="❗️ ${Pink}Warning${NC}"

Goinfre_path="/Volumes/Storage/goinfre/$USER"
# ===========================================

# --- SETUP MINIKUBE ---
# ===============================================================
function setup_minikube ()
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
# =================================================

# --- SETUP VIRTUALBOX ---
# =======================================================
function setup_vbox ()
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
# =======================================================

# --- SETUP DOCKER ---
# ===================================================================================================================
function config_docker ()
{
	# Goinfre config
	if [ ! -d "${Goinfre_path}" ] && [ "${Goinfre_path}" = "/Volumes/Storage/goinfre/$USER" ]
	then
		printf "${Warning} : You have no $USER/ directory in goinfre.\n"
		printf "${Note} : Docker will be installed in your sgoinfre.\n"
		Goinfre_path="/sgoinfre/goinfre/Perso/$USER"
		mkdir -p Goinfre_path
		exit_checker $?
	fi

	# Symlink configuration
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

function check_docker_install ()
{
	# Is installed ?
	where docker &> /dev/null
	if [ $? = 1 ]
	then
		printf "${Error} : Docker is not installed.\n"
		printf "${Note} : Please install it via managed software center.\n"
		exit 1
	fi
	# Is configured ?
	config_docker
}

function check_docker_status ()
{
	# Docker Start
	printf "🤖 : Docker starting... (May take a long minute)\n"
	docker ps &> /dev/null
	if [ $? = 1 ]
	then
		open /Applications/Docker.app
	fi

	# Wait until Docker is nicely launched with time out
	while [ 1 = 1 ]
	do
		docker ps &> /dev/null
		if [ "$?" = "0" ]
		then
			printf "✅ : Docker started !\n"
			return 0
		fi
		sleep 2
		printf "Loading...\n"
	done
}

function setup_docker ()
{
	check_docker_install
	exit_checker $?
	check_docker_status
	exit_checker $?
}
# ===================================================================================================================

# --- SETUP BREW ---
# =================================================================================
function install_brew ()
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

setup_brew ()
{
	brew &> /dev/null
	if [ $? = 127 ]
	then
		printf "${Warning} : Brew is not installed.\n"
		read -p 'Do you want to install it ? (N|[Y]) : ' REPLY
		if [ "${REPLY}" = "Y" ] || [ "${REPLY}" = "y" ] || [ "${REPLY}" = "" ]
		then
			printf "🤖 : Please wait during installation of brew...\n"
			install_brew $1
		else
			printf "${Error} : Brew is needed to install componements.\n"
			exit 1
		fi
	fi
}
# =================================================================================

# --- MAIN PART ---
# ===========================
function exit_checker ()
{
	if [ "$?" != 0 ]
	then
		exit
	fi
}

function dependancer_42mac ()
{
	printf "🤖 : Checking your brew installation...\n"
	setup_brew
	exit_checker $?
	printf "🤖 : Checking your Docker installation...\n"
	setup_docker
	exit_checker $?
	printf "🤖 : Checking your virtualbox installation...\n"
	setup_vbox
	exit_checker $?
	printf "🤖 : Checking your minikube installation...\n"
	setup_minikube
	exit_checker $?
	return 0
}

function dependancer ()
{
	if [ $1 = "42mac" ]
	then
		dependancer_42mac
	fi
	return 0
}
# ===========================

dependancer $1
