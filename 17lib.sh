#################################################
# 17lib.sh is a shell library script that contains 
# some functions that can be used often. 
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