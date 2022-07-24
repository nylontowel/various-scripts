#!/bin/bash -i

OIFS=$IFS
IFS=$'\n'

pushd "/cygdrive/b/Videos/x265"

for file in $(find . -type f -iname \*.mkv -printf "%P\n"); do
	fname=${file%.*}
	mkdir -p "/cygdrive/b/Videos/x264/${fname%/*}"
	ffmpeg -hide_banner -loglevel error -stats -y -i $(cygpath -w ${file}) -vf scale=1280:-1 -c:v libx264 -c:a aac -b:a 128k -crf 23 -preset fast "$(cygpath -w "/cygdrive/b/Videos/x264/$fname.mp4")"
done
IFS=$OIFS
