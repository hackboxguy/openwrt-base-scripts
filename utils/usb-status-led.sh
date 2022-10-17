#!/bin/sh
#this script is used for read/write of led colors for blink(1) - usb-to-rgb-led dongle
#if no argument is passed then its a read action
#if argument is a json file, then value of a key is extracted and written to blink(1) dongle
#if argument is a string, then value of this string will be written to blink(1) dongle.
#valid argument values are [off/white/red/green/blue/cyan/magenta/yellow]
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
fi

if [ -f $1 ]; then
        #check if argument $1 is a json file
        JQOBJ=$(jq type < $1)
        if [ $? = "0" ]; then #this is a valid json file
                MYARG=$(jq -r .ledstate $1)
        else
                MYARG=$1 #just take argument as color string
        fi
else
        MYARG=$1
fi

blinkone-tool --$MYARG > /dev/null
return $?
