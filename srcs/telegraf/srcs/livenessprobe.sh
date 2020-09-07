#! /bin/ash

if [ $(ps | grep telegraf | wc -l) = 2 ]
then
	return 0
else
	return 1
fi
