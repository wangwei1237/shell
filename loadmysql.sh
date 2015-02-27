#!/bin/bash

MYSQL_HOME="$HOME/local/mysql"
MYSQL_PID="$MYSQL_HOME/data/wangwei.local.pid"

function start() 
{
    nohup $MYSQL_HOME/bin/mysqld_safe>/dev/null 2>&1 &

	if [ $? -eq 0 ]
	then
		echo "start mysql success."
	else
		echo "start mysql failed."
	fi 

	return $?
}

function stop() 
{
    $MYSQL_HOME/bin/mysqladmin -uroot shutdown
	
    if [ $? -eq 0 ]
	then
		echo "stop mysql success."
	else
		echo "stop mysql failed."
	fi 

	return $?
}

case "$1" in 
start)
	start
	;;
stop)
    stop
    ;;
*)
echo "Usage: $0 {start|stop}"
esac
