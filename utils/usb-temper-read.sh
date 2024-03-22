#!/bin/sh

TEMPER=$(tempered)
VAL=$(echo $TEMPER | awk '{print $4}')
UNIT=$(echo $TEMPER | awk '{print $5}')
#if raw value is requested then print it, else print in json format
if [ "$1" = "-r" ]; then 
	echo "$VAL"
else
	echo "{ \"temperature\" : \"$VAL\"}"
fi
