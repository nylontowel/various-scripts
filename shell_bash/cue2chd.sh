#!/bin/bash -i
OIFS=$IFS
IFS=$'\n'

for x in $(find . -type f -iname \*.cue -printf "%P\n"); do
	fname=${x%.*}
	chdman createcd -i "$x" -o "$fname.chd" -f && rm "$x" 
	find . -type f -iname $fname\*.bin -delete
	# rm "${x%.*}*.bin"
done

IFS=$OIFS
