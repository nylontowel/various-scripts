#!/bin/bash -i

file=$1
fname=${1%.*}

crf=28

v_opt="-c:v libx265 -crf $crf"
a_opt="-c:a libopus -b:a 128k"
ffmpeg -hide_banner -y -i "$file" -threads 8 -map 0 $v_opt $a_opt "${fname}_x265.mkv"
