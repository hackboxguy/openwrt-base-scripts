#!/bin/sh
#this script is used for read/write of led colors for blink(1) - usb-to-rgb-led dongle
#if no argument is passed then its a read action
#if argument is a json file, then value of a key is extracted and written to blink(1) dongle
#if argument is a string, then value of this string will be written to blink(1) dongle.
#valid argument values are [off/white/red/green/blue/cyan/magenta/yellow]
TTY_RELAY_ID="1a86:7523"
HID_RELAY_ID="16c0:05df"
TTY_RELAY="no"
HID_RELAY="no"
JSONARG="no"
TTY_DEVICE="/dev/ttyUSB0"
#dmesg | awk '/tty/ && /USB/ {print "/dev/"$10}'|tail -1

lsusb | grep $TTY_RELAY_ID > /dev/null
if [ $? = 0 ]; then
	TTY_RELAY="yes"
fi

lsusb | grep $HID_RELAY_ID > /dev/null
if [ $? = 0 ]; then
	HID_RELAY="yes"
fi

if [ -z $1 ]; then
	echo "usage: $0 <relay-position> <on/off>"
	return 1
fi

if [ -f $1 ]; then
        #check if argument $1 is a json file
        JQOBJ=$(jq type < $1)
        if [ $? = "0" ]; then #this is a valid json file
                MYARG1=$(jq -r .position $1)
                MYARG2=$(jq -r .state $1)
        	JSONARG="yes"
	else
                MYARG1=$1 #just take argument as position
        fi
else
        MYARG1=$1
fi

#check if second arg existing incase if 1st one is not a json file
if [ "$JSONARG" = "no" ]; then
	if [ -z $2 ]; then
		echo "usage: $0 <relay-position> <on/off>"
		return 1
	else
		MYARG2=$2
	fi
fi

if [ $TTY_RELAY = "yes" ]; then
	usb-tty-relay -d $TTY_DEVICE -n 1 -s $MYARG2 > /dev/null
	return $?
fi

if [ $HID_RELAY = "yes" ]; then
	COUNT=$(usb-hid-relay|wc -l)
	if [ $COUNT != "2" ]; then
		echo "unknown relay board"
		return 1
	fi
	
	if [ "$MYARG1" == "1" ]; then
		USBDEV=$(usb-hid-relay | head -n 1 | sed 's|=.||')
	elif [ "$MYARG1" == "2" ]; then
		USBDEV=$(usb-hid-relay | tail -n 1 | sed 's|=.||')
	else
		echo "relay position is out of range(allowed is 1/2)"
		return 1
	fi
	if [ "$MYARG2" == "on" ]; then
		usb-hid-relay $USBDEV=1 > /dev/null
	else
		usb-hid-relay $USBDEV=0 > /dev/null
	fi
fi

#echo "arg1:$MYARG1  arg2:$MYARG2 count:$COUNT"
