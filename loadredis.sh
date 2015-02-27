#!/bin/bash

REDIS_HOME="$HOME/local/redis"
REDIS_PIDFILE="$REDIS_HOME/var/redis.pid"

function start() 
{
	if [ -f $REDIS_PIDFILE ]
	then
		stop
	else
		$REDIS_HOME/bin/redis-server $REDIS_HOME/conf/redis.conf
	fi

	if [ $? -eq 0 ]
	then
		echo "start redis success."
	else
		echo "start redis failed."
	fi 

	return $?
}

function stop()
{
	if [ -f $REDIS_PIDFILE ]
	then
        kill $(cat $REDIS_PIDFILE)
    fi

	if [ $? -eq 0 ]
	then
		echo "stop redis success."
	else
		echo "stop redis failed."
	fi 

	return $?
}

function restart() 
{
	stop
    start
	if [ $? -eq 0 ]
	then
		echo "restart redis success."
	else
		echo "restart redis failed."
	fi 
}

case "$1" in 
start)
	start
	;;
stop)
	stop
	;;
restart)
	restart
	;;
*)
echo "Usage: $0 {start|stop|restart}"
esac
