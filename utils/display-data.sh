#!/bin/sh

DISPCLT=/opt/fmw/bin/dispclt
DISP_CLEARED=/tmp/disp-cleared.tmp
if [ -z $1 ]; then
	echo "$0: <json.file.path>" && return 1
fi

if [ -f $1 ]; then
	#check if argument $1 is a json file
	JQOBJ=$(jq type < $1)
	if [ $? = "0" ]; then #this is a valid json file
		KEY=$(cat $1 | jq 'keys' | jq -r .[0])
		VAL=$(cat $1 | jq -r .[])
	else
		echo "Invalid json file!!" && return 1
	fi
else
	KEY=$1
	VAL=""
fi

if [ ! -f $DISP_CLEARED ]; then
	$DISPCLT --dispclear > /dev/null
	touch $DISP_CLEARED #clear the display only for the first time
fi
$DISPCLT --printline=line1,$KEY > /dev/null
$DISPCLT --printline=line3,$VAL > /dev/null
