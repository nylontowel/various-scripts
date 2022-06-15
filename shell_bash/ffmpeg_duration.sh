#!/bin/bash

file=$1
sduration=$2
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
speedup=$(bc -l <<< "$duration / $sduration" )
ffmpeg -y -hide_banner -i "$1" -vf scale=1280:-2,setpts=PTS/$speedup -r 60 -preset ultrafast -an "${1%.*}_speedup.mkv"
