#!/bin/bash -i

file=$1
fname=${1%.*}

crf=38

v_opt="-c:v libvpx-vp9 -b:v 0 -crf $crf -speed 2 -row-mt 1 -tile-columns 4"
a_opt="-c:a libopus -b:a 128k"
ffmpeg -hide_banner -y -hwaccel auto -i "$file" -threads 8 -map 0 $v_opt $a_opt "${fname}_vp9.mkv"
