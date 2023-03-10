#!/bin/sh
#this script is used for enabling/disabling wifi interfaces like internet/localnet
USAGE="$0 <wifi-interface[internet/localnet]> <action[on/off]>"
ACTION="read"
[ -z $1 ] && echo $USAGE && return 1
[ ! -z $2 ] && ACTION=$2

if [ $1 == "internet" ]; then
	UCIKEY="wireless.wifinet1.disabled"
elif [ $1 == "localnet" ]; then
	UCIKEY="wireless.default_radio0.disabled"
else
	echo "invalid wifi-interface name passed as argument!!"
	echo $USAGE
	return 1
fi

if [ $ACTION == "read" ]; then
	STATE=$(uci -q get $UCIKEY)
	if [ $STATE == 0 ]; then
		echo "on"
		return 0
	else
		echo "off"
		return 0
	fi
elif [ $ACTION == "on" ]; then
	uci set $UCIKEY=0
	uci commit
	wifi reload
	return $?
elif [ $ACTION == "off" ]; then
	uci set $UCIKEY=1
	uci commit
	wifi reload
	return $?
else
	echo "on or off are the allowed 2nd argument!!"
	echo $USAGE
	return 1
fi
