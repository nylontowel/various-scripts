#!/bin/bash -i

file=$1
pagecount=$(magick identify -format "%n\n" "$file" | head -n1)

echo $file \n pagecount: $pagecount

x=0
while [[ $x -le $(($pagecount-1)) ]];
do
	magick -density 1200 "$file[$(($x))]" "${x}_${file%.*}.png"
	x=$(($x+1))
done
