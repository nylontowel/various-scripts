#!/bin/bash

dirName=$(dirname '$0')

for x in $(ls); do
	echo "file '$x'" >> $dirname.txt
done

ffmpeg -f concat -i $dirname.txt -c copy $dirname.mp4 && rm $dirname.txt
