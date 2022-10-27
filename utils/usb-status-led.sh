#!/bin/sh
#this script is used for read/write of led colors for blink(1) - usb-to-rgb-led dongle
#if no argument is passed then its a read action
#if argument is a json file, then value of a key is extracted and written to blink(1) dongle
#if argument is a string, then value of this string will be written to blink(1) dongle.
#valid argument values are [off/white/red/green/blue/cyan/magenta/yellow]
LAST_STATE_FILE=/tmp/last-rgb-led-state.txt
FVER=$(blinkone-tool --fwversion)
if [ $? != 0 ]; then
	echo "{\"ledstate\":\"not_found\"}"
	return 1
fi

#read action
if [ -z $1 ]; then
	CURSTATE=$(blinkone-tool --rgbread|awk '{print $5}')
	case "$CURSTATE" in
	"0x00,0x00,0x00")
		echo "{\"ledstate\":\"off\"}"
		;;
	"0xff,0xff,0xff")
		echo "{\"ledstate\":\"white\"}"
		;;
	"0xff,0x00,0x00")
		echo "{\"ledstate\":\"red\"}"
		;;
	"0x00,0xff,0x00")
		echo "{\"ledstate\":\"green\"}"
		;;
	"0x00,0x00,0xff")
		echo "{\"ledstate\":\"blue\"}"
		;;
	"0x00,0xff,0xff")
		echo "{\"ledstate\":\"cyan\"}"
		;;
	"0xff,0x00,0xff")
		echo "{\"ledstate\":\"magenta\"}"
		;;
	"0xff,0xff,0x00")
		echo "{\"ledstate\":\"yellow\"}"
		;;
	*)
		echo "{\"ledstate\":\"unknown\"}"
		;;
	esac
	return 0
fi

if [ -f $1 ]; then
        #check if argument $1 is a json file
        JQOBJ=$(jq type < $1)
        if [ $? = "0" ]; then #this is a valid json file
		MYARG=$(jq -r .ledstate $1)
		#also accept { powerstate: on}
		if [ $MYARG = "null" ]; then
			MYARG=$(jq -r .powerstate $1)
			if [ $MYARG = "null" ]; then
				echo "invalid json arguments!!"
				return 1
			fi
		fi
        else
                MYARG=$1 #just take argument as color string
        fi
else
        MYARG=$1
fi

#also accept { powerstate: on}
if [ $MYARG = "on" ]; then
	MYARG=white
fi

if [ $MYARG = "toggle" ]; then
	CURSTATE=$(blinkone-tool --rgbread|awk '{print $5}')
	if [ $CURSTATE = "0x00,0x00,0x00" ]; then
		if [ -f $LAST_STATE_FILE ]; then
			LASTSTATE=$(cat $LAST_STATE_FILE)
			blinkone-tool --$LASTSTATE
		else
			echo "white" > $LAST_STATE_FILE
			blinkone-tool --white #we dont know the last state, hence just turn ON full white
		fi
	else
		case "$CURSTATE" in
		"0xff,0x00,0x00")
			echo "red" > $LAST_STATE_FILE
			;;
		"0x00,0xff,0x00")
			echo "green" > $LAST_STATE_FILE
			;;
		"0x00,0x00,0xff")
			echo "blue" > $LAST_STATE_FILE
			;;
		"0x00,0xff,0xff")
			echo "cyan" > $LAST_STATE_FILE
			;;
		"0xff,0x00,0xff")
			echo "magenta" > $LAST_STATE_FILE
			;;
		"0xff,0xff,0x00")
			echo "yellow" > $LAST_STATE_FILE
			;;
		*)
			echo "white" > $LAST_STATE_FILE
			;;
		esac
		blinkone-tool --off
	fi
	return 0
fi
echo "$MYARG" > $LAST_STATE_FILE
blinkone-tool --$MYARG > /dev/null
return $?
