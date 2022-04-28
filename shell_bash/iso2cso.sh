#!/bin/bash -i

count=0
total=0

IFS=$'\n'

for x in $(find . -type f -iname "*.iso" -printf '%P\n'); do
	echo $x
	maxcso --threads 4 "$x" && rm "$x"
	if [[ $? -ne 0 ]]; then
		echo "Interrupted"
		rm ${x%.*}.cso
		break
	fi
done
	