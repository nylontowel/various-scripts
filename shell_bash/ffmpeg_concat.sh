#!/bin/bash

if [[ -z $OIFS ]]; then
	OIFS=$IFS
	IFS=$'\n'
fi


dirName=$(basename '$0')
filename=${1}

for x in $@; do
	echo file \'$x\' >> "${filename}.txt"
done

ffmpeg -safe 0 -f concat -i "${filename}.txt" -c copy "${filename}_concat.mp4" && rm ${filename}.txt
