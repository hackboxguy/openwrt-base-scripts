#!/bin/sh
#this script is used for re-configuring wifi ssid and password for interfaces like internet/localnet
USAGE="$0 <wifi-interface[internet/localnet]> <ssid> <key>"
ACTION="read"
[ -z $1 ] && echo $USAGE && return 1
[ ! -z $2 ] && SSID=$2
[ ! -z $3 ] && KEY=$3 && ACTION="write"

if [ $1 == "internet" ]; then
	UCISSID="wireless.wifinet1.ssid"
	UCIKEY="wireless.wifinet1.key"
	UCICTRL="wireless.wifinet1.disabled"
elif [ $1 == "localnet" ]; then
	UCISSID="wireless.default_radio0.ssid"
	UCIKEY="wireless.default_radio0.key"
	UCICTRL="wireless.default_radio0.disabled"
else
	echo "invalid wifi-interface name passed as argument!! allowed are <internet/localnet>"
	echo $USAGE
	return 1
fi

if [ $ACTION == "read" ]; then
	VALSSID=$(uci -q get $UCISSID)
	VALKEY=$(uci -q get $UCIKEY)
	echo "ssid=$VALSSID : key=$VALKEY"
	return 0
else
	/etc/init.d/WrtXmproxyStartupScr stop
	sleep 3
	uci set $UCISSID=$SSID
	uci set $UCIKEY=$KEY
	uci set $UCICTRL=0
	uci commit
	wifi reload
	sleep 3	
	/etc/init.d/WrtXmproxyStartupScr start
	return $?
fi
