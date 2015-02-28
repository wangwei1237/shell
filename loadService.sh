#!/bin/bash

BASE_DIR=$HOME/local

modules=('redis' 'mysql' 'php' 'nginx')
for((i=0; i<${#modules[@]}; ++i))
do
    cd $BASE_DIR/${modules[i]} && load${modules[i]}.sh start
done

