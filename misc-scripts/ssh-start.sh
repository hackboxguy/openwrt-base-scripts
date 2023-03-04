#!/bin/sh
DEF_SRVPORT=22
DEF_REMSRVPORT=22
DEF_REMSRVHOST=localhost
DEF_REMOTEPORT=4202
DEF_SSHUSER=root
SSH_RUNNING=/usr/bin/ssh-running.sh
USAGE="$0 <ssh_server_ip> <remote_tunnel_port> <ssh_server_port> <remote_srv_port> <remote_host> <ssh_user>"
if [ $# -eq 0 ]; then
	echo "No arguments supplied!!!"
	echo $USAGE
	exit 1
fi

if [ -f "$1" ]; then #check if ipaddr is in a file
	REMOTEIP=$(cat $1)
else
	REMOTEIP=$1
fi

if [ -z "$2" ]; then
	REMOTEPORT=$DEF_REMOTEPORT
else
	if [ -f "$2" ]; then #check if remote-port is in a file
		REMOTEPORT=$(cat $2)
	else
		REMOTEPORT=$2
	fi
fi

if [ -z "$3" ]; then
	SERVERPORT=$DEF_SRVPORT
else
	if [ -f "$3" ]; then #check if server-port is in a file
		SERVERPORT=$(cat $3)
	else
		SERVERPORT=$3
	fi
fi

if [ -z "$4" ]; then
	REMSRVPORT=$DEF_REMSRVPORT
else
	if [ -f "$4" ]; then #check if remote-srv-port is in a file
		REMSRVPORT=$(cat $4)
	else
		REMSRVPORT=$4
	fi
fi

if [ -z "$5" ]; then
	REMSRVHOST=$DEF_REMSRVHOST
else
	if [ -f "$5" ]; then #check if remote-srv-port is in a file
		REMSRVHOST=$(cat $5)
	else
		REMSRVHOST=$5
	fi
fi

if [ -z "$6" ]; then
	SSHUSER=$DEF_SSHUSER
else
	if [ -f "$6" ]; then #check if ssh-username is in a file
		SSHUSER=$(cat $6)
	else
		SSHUSER=$6
	fi
fi

$SSH_RUNNING
if [ $? = 0 ]; then
	#echo "ssh already running!"
	exit 1
fi

while true
do
	ssh -p $SERVERPORT -y -i /root/.ssh/id_rsa -N -g -R $REMOTEPORT:$REMSRVHOST:$REMSRVPORT $SSHUSER@$REMOTEIP 1>/tmp/remote-ssh.log 2>/tmp/remote-ssh.log
	sleep 15
done
