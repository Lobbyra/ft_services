#! /bin/ash

printf "nginx liveness test : "
service nginx status
ret_nginx=$?
printf "\n"
printf "sshd  liveness test : "
service sshd status
ret_sshd=$?
printf "\n"
if [ $ret_nginx = 0 ] && [ $ret_sshd = 0 ]
then
	exit 0
else
	exit 1
fi
