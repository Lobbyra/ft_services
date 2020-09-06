#! /bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    docker_build.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/04 16:18:44 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/04 16:19:19 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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

function docker_build ()
{
	eval $(minikube docker-env)
	arr_img_dir=()
	while IFS= read -r line; do
		arr_img_dir+=( "$line" )
	done < <(find srcs -d 1 -type d)
	for i in ${arr_img_dir[@]}
	do
		printf "🐳 : Building $(echo $i | cut -d "/" -f 2) image.\n"
		docker build $i -t img-$(echo $i | cut -d "/" -f 2) > /dev/null &
		load_anim $!
	done
}

docker_build
