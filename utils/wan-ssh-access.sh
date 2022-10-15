#!/bin/sh
#this script is used for enabling/disabling ssh access from the WAN side of the router network
SSHACC=$(uci show | grep "firewall.@rule\[.\]\.dest_port='22'")
if [ $? != 0 ]; then
	SSHACC=$(uci show | grep "firewall.@rule\[..\]\.dest_port='22'")
	if [ $? != 0 ]; then
		NOTSET=1
	else
		#double digit firewall rule number
		RULENUM=$(uci show | grep "firewall.@rule\[..\]\.dest_port='22'" |sed 's|firewall.@rule\[||g' | sed 's|].*||g')
		NOTSET=0
	fi
else
	#single digit firewall rule number
	RULENUM=$(uci show | grep "firewall.@rule\[.\]\.dest_port='22'" |sed 's|firewall.@rule\[||g' | sed 's|].*||g')
	NOSET=0
fi

#if request is for reading the current status
if [ -z $1 ]; then
	#show current http-wan-access status and return
	if [ $NOTSET = 1 ]; then
		echo "off"
		return 0
	else
		#STATE=$(uci show | grep "firewall.@rule\[$RULENUM\]\.enabled='1'")
		STATE=$(uci -q get firewall.@rule[$RULENUM].enabled)
		if [ $STATE = 0 ]; then
			echo "off"
			return 0
		else
			echo "on"
			return 0
		fi
	fi
fi

#check if argument is valid on or off string
if [ $1 != "on" ]; then
	if [ $1 != "off" ]; then
		echo "$0 <on/off> [no arg means read current status]"
		return -1
	fi
fi

if [ $NOTSET = 0 ]; then
	if [ $1 = "on" ]; then
		uci set firewall.@rule[$RULENUM].enabled=1 #target=ACCEPT
		uci set firewall.@rule[$RULENUM].target=ACCEPT
	else
		uci set firewall.@rule[$RULENUM].enabled=0 #target=REJECT
		uci set firewall.@rule[$RULENUM].target=REJECT
	fi
else
	uci add firewall rule > /dev/null
	uci set firewall.@rule[-1].src=wan
	uci set firewall.@rule[-1].proto=tcp
	uci set firewall.@rule[-1].dest_port=22
	if [ $1 = "on" ]; then
		uci set firewall.@rule[-1].enabled=1
		uci set firewall.@rule[-1].target=ACCEPT
	else
		uci set firewall.@rule[-1].enabled=0
		uci set firewall.@rule[-1].target=REJECT
	fi
fi

uci commit firewall
/etc/init.d/firewall restart
return 0
