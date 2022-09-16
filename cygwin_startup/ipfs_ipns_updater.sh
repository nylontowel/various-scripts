#!/bin/bash -i

cid=$(ipfs files stat /Octavio/Twitch/ | awk '{ printf $1; exit }')
ipnskey=octatwitch
sharedir="/Octavio/Twitch/"
interval=60


while true;
do
	statcmd="ipfs files stat $sharedir | awk '{ printf \$1; exit }'"
	newcid=$(eval $statcmd) 
	if [ "$cid" != "$newcid" ]; then
		cid=$newcid
		ipfs name publish --key=octatwitch $cid
	fi
	count=$interval
	while [[ $count -gt 0 ]]; do
		echo -ne "Waiting for file update ($count)\r"
		count=$(($count-1))
		sleep 1
	done
done
