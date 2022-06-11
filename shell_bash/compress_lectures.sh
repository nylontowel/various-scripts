#!/bin/bash

file=$1
ftitle=_$2
fname=${file%.*}${ftitle}
unsilence -y -ss 100 -as 1.15 "$file" "${fname}_tmp.mp4"
ffmpeg -y -loglevel quiet -stats -i "${fname}_tmp.mp4" -vf fps=12 -c:v libx265 -c:a libopus -b:a 32k -crf 28 "${fname}.mkv" && rm "$file" && rm "${fname}_tmp.mp4"
