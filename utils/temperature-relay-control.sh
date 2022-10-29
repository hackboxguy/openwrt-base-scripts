#!/bin/sh
#this script accepts temperature value and controls the relay by comparing with
#awsiot-demo.Settings.subhysteresis and awsiot-demo.Settings.subthreshold values stored in uci
#limitation of this script is - it can control single relay(usb-relay or 1st-relay of 4channel modbus relay)

RELAYCTRL=/usr/sbin/usb-relay.sh

#if no args passed, then just return
if [ -z $1 ]; then
	echo "usage: $0 <temp_value> or </tmp/temp-value.json>" && return 1
fi

if [ -f $1 ]; then
	#check if argument $1 is a json file
	JQOBJ=$(jq type < $1)
	if [ $? = "0" ]; then #this is a valid json file
		TEMPVAL=$(jq -r .temperature $1)
	else
		echo "usage: $0 <temp_value> or </tmp/temp-value.json>" && return 1
	fi
else
	#temperature value has been passed directly as cmdline arg instead of json file
	TEMPVAL=$1
fi

THRESHOLD=$(uci show awsiot-demo | grep "awsiot-demo.Settings.subthreshold" | sed 's|.*=||g' | sed "s|'||g")
HYSTERESIS=$(uci show awsiot-demo | grep "awsiot-demo.Settings.subhysteresis"| sed 's|.*=||g'| sed "s|'||g")

let X=$((THRESHOLD))
let Y=$((HYSTERESIS))
X=$((X-Y))

RELAYSTS=$($RELAYCTRL 1)
JQOBJ=$(echo $RELAYSTS | jq type )
if [ $? = "0" ]; then #this is a valid json file
	RELAYVAL=$(echo $RELAYSTS | jq -r .powerstate)
fi
if [ $RELAYVAL = "on" ]; then
	if [ $TEMPVAL -le $X ]; then
		$RELAYCTRL 1 "off" #temp has cooled down, so switch OFF the relay
	fi
else
	if [ $TEMPVAL -ge $THRESHOLD ]; then
		$RELAYCTRL 1 "on" #temp has crossed the threshold,  so switch ON the relay
	fi
fi

#echo "th: $THRESHOLD : hy:$HYSTERESIS : val:$MYARG : sum:$X : sts:$RELAYVAL"


#write action
#if [ $MYARG = "on" ]; then
#	echo 1 > $USB_NODE
#	return 0
#elif [ $MYARG = "off" ]; then
#	echo 0 > $USB_NODE
#	return 0
#else
#	echo "usb-power: valid arguments are on/off"
#	return 1
#fi
