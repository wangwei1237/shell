#!/bin/bash

WORK="work"
HOME="home"
SCRIPT="alterDnsServices.sh"

function usage() 
{
    echo "Usage: $SCRIPT [work | home]"
}

function getWiFiDnsServices()
{
    local wifi=$(networksetup listallnetworkservices | grep Wi-Fi);
    if [ ${#wifi} -le 0 ];
    then
        echo "The Wi-Fi network is not in this computer."
        return 3;
    fi

    local wifiDnsServices=$(networksetup getdnsservers Wi-Fi);
    local dnsAddress="127.127.127.127";
    if [ ${#wifiDnsServices} -gt ${#dnsAddress} ];
    then
        wifiDnsServices=" ";
    fi

    echo "$wifi $wifiDnsServices";
    return 0;
}

function setDnsServicesForWork() 
{
    local dnsInfo=$(getWiFiDnsServices);
    if [ $? -ne 0 ];
    then
        echo "error code: $?";
        return 4;
    fi
    
    dnsInfo=($dnsInfo);
    if [ ${#dnsInfo[*]} -eq 2 ];
    then
        networksetup setdnsservers Wi-Fi empty;
    fi
    
    getWiFiDnsServices;
}

function setDnsServicesForHome() 
{
    local dnsInfo=$(getWiFiDnsServices);
    if [ $? -ne 0 ];
    then
        echo "errorcode: $?";
        return 4;
    fi
    
    if [ ${#dnsInfo[*]} -eq 1 ] || [ ! ${dnsInfo[1]} = '8.8.8.8' ];
    then
        networksetup setdnsservers Wi-Fi 8.8.8.8;
    fi
    
    getWiFiDnsServices;
}


if [ $# -ne 1 ] 
then
    usage;
    exit 1;
fi

case "$1" in
$WORK)
        setDnsServicesForWork;
        ;;
$HOME)
        setDnsServicesForHome;
        ;;
*)
        usage;
        exit 2; 
        ;;
esac

