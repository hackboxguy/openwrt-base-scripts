#!/bin/sh
#this script is used for blinking the blink(1) usb led using pattern command(non-blocking command)

#we support write only action
if [ -z $1 ]; then
	echo "$0 <blink_color[red/green/blue/cyan/magenta/yellow/orange/white/on/off]> <blink_ms>"
	exit 0
else
	#if blink time(ms) is not passed, then used 1000ms as default	
	if [ -z $2 ]; then
		BLINK_TIME=1000
	else
		BLINK_TIME=$2
	fi
	case "$1" in
		"red")
			BLINK_VALUE="0xff,0x00,0x00"
			;;
		"green")
			BLINK_VALUE="0x00,0xff,0x00"
			;;
		"blue")
			BLINK_VALUE="0x00,0x00,0xff"
			;;
		"cyan")
			BLINK_VALUE="0x00,0xff,0xff"
			;;
		"magenta")
			BLINK_VALUE="0xff,0x00,0xff"
			;;
		"yellow")
			BLINK_VALUE="0xff,0xff,0x00"
			;;
		"orange")
			BLINK_VALUE="0xff,0xa5,0x00"
			;;
		"white")
			BLINK_VALUE="0xff,0xff,0xff"
			;;
		"on")
			BLINK_VALUE="0xff,0xff,0xff"
			;;
		"off")
			blinkone-tool --play 0 > /dev/null;blinkone-tool --off > /dev/null
			exit 0
			;;
		*)
			BLINK_VALUE="$1" #lets assume user has passed custom color(e.g 0xff,0xa5,0x00)
			#echo "$0 <blink_color[red/green/blue/cyan/magenta/yellow/orange/white/on/off]> <blink_ms>"
			#exit 0
		;;
	esac
fi
blinkone-tool --clearpattern > /dev/null
blinkone-tool -m $BLINK_TIME --rgb $BLINK_VALUE --setpattline 0 > /dev/null
blinkone-tool -m $BLINK_TIME --rgb 0x00,0x00,0x00 --setpattline 1 > /dev/null
blinkone-tool -m $BLINK_TIME --rgb $BLINK_VALUE --setpattline 2 > /dev/null
blinkone-tool -m $BLINK_TIME --rgb 0x00,0x00,0x00 --setpattline 3 > /dev/null
blinkone-tool --savepattern > /dev/null
blinkone-tool --play 1 > /dev/null
exit 0
