#! /bin/ash

ps > liveness.tmp
cat liveness.tmp | grep telegraf > liveness2.tmp
ret=$(cat liveness2.tmp | wc -l)

if [ $ret = 1 ]
then
	return 0
else
	return 1
fi
