#!/bin/bash -i
OIFS=$IFS
IFS=$'\n'

e7z="/r/7-Zip/7z.exe"

count=0
total=0

for x in $(find . -maxdepth 1 -type f -printf "%P\n"); do
	if [[ $x == *"7z" ]]; then
		continue
	fi 
	total=$((total+1))
done

for file in $(find . -maxdepth 1 -type f -printf "%P\n"); do
	if [[ $file == *"7z" ]]; then
		continue
	fi 
	count=$(($count+1))
	echo "$count/$total $file"
	filename=${file%.*}
	$e7z a -t7z -sdel -mx1 -bso0 -bsp0 "${filename}.7z" "$file"
	if [[ $? -ne 0 ]]; then
		rm "${filename}.7z"
		break
	fi
		
done;

IFS=$OIFS