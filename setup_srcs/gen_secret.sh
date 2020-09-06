#!/bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    gen_secret.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jecaudal <jecaudal@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/01 15:18:42 by jecaudal          #+#    #+#              #
#    Updated: 2020/09/01 15:37:39 by jecaudal         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

Note="📝 ${Grey}Note${NC}"
Error="❌ ${Red}Error${NC}"
Warning="❗️ ${Pink}Warning${NC}"

function generator ()
{
	sed=$1
	nsecret=6
	if [ ! -f setup_srcs/secret.yaml ]
	then
		cp setup_srcs/secret_model.yaml setup_srcs/secret.yaml
	fi
	for i in $(seq 1 $nsecret)
	do
		password=$(openssl rand -base64 32 | tr -dc _A-Z-a-z-0-9 | base64 )
		sedpayload=s/\$$i/$password/g
		sedpayload=$sedpayload
		$sed -i "$sedpayload" setup_srcs/secret.yaml
	done
} 

function main ()
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
		generator "gsed"
	elif [ "$1" = "42linux" ]
	then
		generator "sed"
	fi
}

main $1
