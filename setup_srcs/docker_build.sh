#! /bin/bash

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

function ftps_ip_assign_exec ()
{
	sed=$1
	if [ "$2" = "42mac" ]
	then
		$sed -i "s/172.17.0/192.168.99/g" srcs/ftps/srcs/init.sh
		$sed -i "s/172.17.0/192.168.99/g" srcs/mariadb/srcs/wordpress.sql
	else
		$sed -i "s/192.168.99/172.17.0/" srcs/ftps/srcs/init.sh
		$sed -i "s/192.168.99/172.17.0/g" srcs/mariadb/srcs/wordpress.sql
	fi
}

function ip_assign ()
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
		ip_assign_configs "gsed" $1
	elif [ "$2" = "42linux" ]
	then
		ip_assign_configs "sed" $1
	fi
}

function docker_build ()
{
	ip_assign $1
	eval $(minikube docker-env)
	arr_img_dir=()
	if [ "$1" = "42mac" ]
	then
		while IFS= read -r line; do
			arr_img_dir+=( "$line" )
		done < <(find srcs -d 1 -type d)
	else
		while IFS= read -r line; do
			arr_img_dir+=( "$line" )
		done < <(find srcs -maxdepth 1 -type d | cut -d $'\n' -f 2-22)
	fi
	for i in ${arr_img_dir[@]}
	do
		printf "🐳 : Building $(echo $i | cut -d "/" -f 2) image.\n"
		docker build $i -t img-$(echo $i | cut -d "/" -f 2) > /dev/null &
		load_anim $!
	done
}

docker_build $1
