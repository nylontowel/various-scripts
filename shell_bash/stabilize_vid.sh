#!/bin/bash -i

file=$1

ffmpeg -y -hide_banner -i "$file" -vf vidstabdetect -an -f null /dev/null
ffmpeg -y -hide_banner -i "$file" -vf vidstabtransform -c:a copy -c:v libx264 -crf 18 ${file%.*}.stab.mkv
