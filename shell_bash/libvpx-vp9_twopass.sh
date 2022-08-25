#!/bin/bash -i

crf=$1
file="$2"
fname=${file%.*}


vpx_options="-threads 8 -crf $crf -b:v 0 -cpu-used 1 -row-mt 1 -tile-columns 4"
ffmpeg -hide_banner -y -i "$file" -c:v libvpx-vp9 -pass 1 $vpx_options -an -f null NUL
ffmpeg -hide_banner -y -i "$file" -c:v libvpx-vp9 -pass 2 $vpx_options -c:a libopus -b:a 128k "${fname}_vp9.mkv"
