

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/04 09:38:15 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/04 11:18:18 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	if [ "$(kubectl get secrets --namespace metallb-system | grep memberlist)" = "" ]
	then
		kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	fi
}

function main ()
{
	parsing_arg $1 $2 $3
	exit_checker $?
	printf "🤖 : Dependances checking.\n"
	setup_srcs/dependancer.sh $1
	printf "🤖 : Minikube will be started...\n"
	minikube start --vm-driver=virtualbox > /dev/null &
	fun_load_anim $!
	setup_srcs/gen_secret.sh
	deploy_metallb
	setup_srcs/deploy_all.sh
}

main $1 $2 $3
