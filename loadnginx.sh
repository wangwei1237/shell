#!/bin/bash

NGINX_HOME="$HOME/local/nginx"
NGINX_PIDFILE="$NGINX_HOME/logs/nginx.pid"

function start() 
{
	if [ -f $NGINX_PIDFILE ]
	then
		stop
	else
		$NGINX_HOME/sbin/nginx
	fi

	if [ $? -eq 0 ]
	then
		echo "start nginx success."
	else
		echo "start nginx failed."
	fi 

	return $?
}

function stop()
{
	if [ -f $NGINX_PIDFILE ]
	then
        $NGINX_HOME/sbin/nginx -s stop
    fi

	if [ $? -eq 0 ]
	then
		echo "stop nginx success."
	else
		echo "stop nginx failed."
	fi 

	return $?
}

function restart() 
{
	stop
    sleep 1
    start
	if [ $? -eq 0 ]
	then
		echo "restart nginx success."
	else
		echo "restart nginx failed."
	fi 
}

function reload() 
{
   $NGINX_HOME/sbin/nginx -s reload 
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
reload)
    reload
    ;;
*)
echo "Usage: $0 {start|stop|restart|reload}"
esac
