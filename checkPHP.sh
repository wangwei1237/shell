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
    local result=$(head -n 1 $1 | od -A x -t c | tr -s ' ' | cut -d' ' -f2,3,4)
    result=($result)
    if [ ${#result} -eq 3 ] && [ ${result[0]} = "357" ] && \
       [ ${result[1]} = "273" ] && [ ${result[2]} = "277" ]
    then
        isBOMFile=1 
    fi

    echo $isBOMFile
    return 0
}

##############################################################################
# @breif  检查文件是否以<?php开始.
# @param  file 待检查的文件.
# @return 0    以<?php开始，文件合法;
#         1    不以<?php开始，文件非法;
function checkPHPTag()
{
    local PHPTagValid=1
    local result=$(head -n1 $1)
    local tag=${result:0:5}

    #echo $tag
    if [ "$tag" = '<?php' ] || [ "$tag" = '<?PHP' ]
    then
        PHPTagValid=0
    fi

    echo $PHPTagValid
    return 0
}

if [ $(checkBOM $file) -eq 1 ] 
then
    echo "[BOM chech] $file has BOM"
fi 


if [ $(checkPHPTag $file) -eq 1 ]
then
    echo "[php tag check] $file does not start with <?php"
fi