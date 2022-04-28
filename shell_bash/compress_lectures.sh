#!/bin/bash

file=$1
ftitle=_$2
fname=${file%.*}${ftitle}
unsilence -y -ss 100 -as 1.15 "$file" "${fname}_tmp.mp4"
ffmpeg -y -loglevel quiet -stats -hwaccel cuvid -i "${fname}_tmp.mp4" -c:v libx265 -c:a libopus -b:a 32k -q:v 28 "${fname}.mkv" && rm "$file" && rm "${fname}_tmp.mp4"
