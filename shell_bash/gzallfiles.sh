#!/bin/bash -i
OIFS=$IFS
IFS=$'\n'

compress="gz"
format="gz"

count=0
total=0

for x in $(find . -maxdepth 1 -type f -printf "%P\n"); do
	if [[ $x == *"$format" ]]; then
		continue
	fi 
	total=$((total+1))
done

for file in $(find . -maxdepth 1 -type f -printf "%P\n"); do
	if [[ $file == *"$format" ]]; then
		continue
	fi 
	count=$(($count+1))
	echo "$count/$total $file"
	filename=${file%.*}
	$compress "$file"
done;

IFS=$OIFS
