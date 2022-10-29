#!/bin/sh

TEMPER=$(tempered)
VAL=$(echo $TEMPER | awk '{print $4}')
UNIT=$(echo $TEMPER | awk '{print $5}')
echo "{ \"temperature\" : \"$VAL\"}"
