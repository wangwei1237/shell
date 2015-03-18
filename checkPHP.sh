#!/bin/bash

file=$1


##############################################################################
# @breif  检查文件是否为BOM格式编码.
# @param  file 待检查的文件.
# @return 0    无BOM;
#         1    含BOM;
function checkBOM()
{
    local isBOMFile=0
    local result=$(od -A x -t c $1 | head -n 1 | tr -s ' ' | cut -d' ' -f2,3,4)
    result=($result)
    if [ ${#result} -eq 3 ] && [ ${result[0]} = "357" ] && \
       [ ${result[1]} = "273" ] && [ ${result[2]} = "277" ]
    then
        isBOMFile=1 
    fi

    echo $isBOMFile
    return 0
}


if [ $(checkBOM $file) -eq 1 ] 
then
    echo "$file has BOM"
fi 

