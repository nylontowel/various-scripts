#!/bin/bash -i

OIFS=$IFS
IFS=$'\n'
quality=40
v_opt="-c:v libsvtav1 -crf $quality -preset 8 -svtav1-params keyint=10s"
a_opt="-c:a libopus -b:a 128k"

for file in $(find . -maxdepth 1 -type f ! -iname "*_av1.mkv" -iname "*.mkv"); do
	fname=${file%.*}
	if [ -f "${fname}_av1.mkv" ]; then
		echo "Already converted. Skipping: $file"
		continue
	fi
	eval ffmpeg.exe -hide_banner -n -i \"$file\" -threads 8 -map 0:v:0 -map 0:a $v_opt $a_opt \"${fname}_av1.mkv\" 
	if [ $? -eq 0 ]; then
		continue
	else
		rm "${fname}_av1.mkv"
		break
	fi
done
