#!/bin/bash

PHP_HOME="$HOME/local/php"
PHP_PIDFILE="$PHP_HOME/var/php-fpm.pid"

function start() 
{
	if [ -f $PHP_PIDFILE ]
	then
		stop
	else
		$PHP_HOME/sbin/php-fpm
	fi

	if [ $? -eq 0 ]
	then
		echo "start php success."
	else
		echo "start php failed."
	fi 

	return $?
}

function stop()
{
	if [ -f $PHP_PIDFILE ]
	then
        kill $(cat $PHP_PIDFILE)
    fi

	if [ $? -eq 0 ]
	then
		echo "stop php success."
	else
		echo "stop php failed."
	fi 

	return $?
}

function restart() 
{
	stop
    start
	if [ $? -eq 0 ]
	then
		echo "restart php success."
	else
		echo "restart php failed."
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
