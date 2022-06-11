#!/bin/bash -i

OIFS=$IFS
IFS=$'\n'

e7z="7z"

count=0
total=0
for x in $(find . -maxdepth 1 -type f \( -iname "*.zip" -or -iname "*.7z" -or -iname "*.rar" \) -printf "%P\n"); do
	total=$((total+1))
done

for file in $(find . -maxdepth 1 -type f \( -iname "*.zip" -or -iname "*.7z" -or -iname "*.rar" \) -printf "%P\n"); do
	count=$(($count+1))
	echo "$count/$total $file"
	$e7z e -y -bso0 -bsp0 $file
	exitcode=$?
	if [[ $exitCode -eq 0 ]]; then
		rm $file
	else
		break
	fi
done

	
