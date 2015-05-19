#!/bin/bash
PHP_BIN=$HOME/local/php/bin/php

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

##############################################################################
# @breif  检查php的语法正确性
# @param  file 待检查的文件.
# @return 0    php文件不存在语法错误;
#         1    php文件中存在语法错误;
function checkPHPStaticByLanguageValidation()
{
    local PHPLanguageValidation=1
    local result=$($PHP_BIN -l $1)
    result=${result%% *}
    if [ "$result" = 'No' ]
    then
        PHPLanguageValidation=0;
    fi

    echo $PHPLanguageValidation
    return 0
}

##############################################################################
# @breif  检查php代码中是否包含未注释掉的var_dummp.
# @param  file 待检查的文件.
# @return 0    php文件中不存在var_dump;
#         1    php文件存在var_dump;
function checkPHPStaticByVardump()
{
    local PHPVardump=0
    local result=""

    result=$(echo $1 | grep -v "script" | grep -v 'tool' | grep -v 'misuser')
    if [ ${#result} -eq 0 ]
    then
        echo $PHPVardump
        return 0
    fi

    result=$(grep 'var_dump' $1 | grep -v '//' | grep -v '#' | grep -v '*')
    if [ ${#result} -ne 0 ]
    then
        PHPVardump=1
    fi
    echo $PHPVardump
    return 0
}

##############################################################################
# @brief wrap color 
red() {
  echo -e "\033[0;31m$@\033[0m"
}

green() {
  echo -e "\033[0;32m$@\033[0m"
}

yellow() {
  echo -e "\033[0;33m$@\033[0m"
}

blue() {
  echo -e "\033[0;34m$@\033[0m"
}

magenta() {
  echo -e "\033[0;35m$@\033[0m"
}

cyan() {
  echo -e "\033[0;36m$@\033[0m"
}

##############################################################################
# @brief run.
# @param  file 待检查的文件.
# @return 0    file检查未通过
#         1    file检查通过
function run()
{
    local file=$1
    local isOK=1

    if [ $(checkBOM $file) -eq 1 ] 
    then
        isOK=0
        echo "$(red [BOM chech]) $(blue $file) has BOM"
    fi 


    if [ $(checkPHPTag $file) -eq 1 ]
    then
        isOK=0
        echo "$(red [php tag check]) $(blue $file) does not start with <?php"
    fi

    if [ $(checkPHPStaticByLanguageValidation $file) -eq 1 ]
    then
        isOK=0
        echo "$(red [parse error]) in $(blue $file)"
    fi

    if [ $(checkPHPStaticByVardump $file) -eq 1 ]
    then
        isOK=0
        echo "$(red [has var_dump function]) in $(blue $file)"
    fi

    return $isOK
}

run $1;
#if [ $? -eq 1 ]
#then
#    echo "No error in $1"
#fi