#!/bin/bash -i

while true; do
	$@
	echo restarting "$1"...
	sleep 1
done
