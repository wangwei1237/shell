#################################################
# 17lib.sh is a shell library script that contains 
# some functions which can be used. 
#################################################
DEBUG=1


# debug info.
# @param string info
function debug_info() {
    local info=$1
    if [ $DEBUG -eq 1 ]
    then
        echo $info 
    fi
}


# post the local file with http protocol.
#
# @param string the local file full path, must with the pattern: key1=@/fullpath/file.
#               if this request has other post parameters, then append the k-v parameter
#               after ' '.
#               etc. "file=@/Users/wangwei/test.mp4"
#                    "file=@/Users/wangwei/test.mp4 key1=value1 key2=value2"
# @param string the url that wangt to post.
# 
# @return the response content.
function post_local_file() {
    if [ $# -ne 2 ]
    then
        echo "post_local_file() parameters error, please check!"
        exit 1
    fi

    local params=($1)
    local url=$2 

    local param_for_curl=""
    for ((i=0; i<${#params[@]};i++)) {
        param_for_curl="${param_for_curl} -F ${params[i]}"
    }

    local res=$(curl ${param_for_curl} "${url}")
    echo $res
}


# get the setting content (according by regular expression) from string.
#
# @param string string from which to extract the needed content.
#        for example: "taskId:12345"
# @param string regular-expression-string
#        for example: "(taskId).([0-9]+)"
# @param int  capture number
#         1
#
# @return the captured result by the regular expression
#         r1: taskId, r2: 12345
function get_content_from_string() {
    if [ $# -ne 3 ]
    then
        echo "get_content_from_string() parameters error, please check!"
        exit 1
    fi

    local str=$1
    local reg=$2
    local num=$3
    echo $str | \
    awk \
    '
    BEGIN{
        reg="'${reg}'"; 
        num="'${num}'"
    } 
    
    {
        if (match($0, reg, o)) {
            for (i = 1; i <= num; i++) {
                if (i != num) {
                    printf "%s ", o[i]
                } else {
                    printf "%s", o[i]
                }
                
            }
        }
    }
    '
}