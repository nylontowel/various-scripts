#!/bin/bash -i 

file=$1
fname=${file%.*}

crf_values="15 18 20 23 25 28 30 33 35 38 40 43 45 48 50"

ff_test () {
	codec=$1
	preset=$2
	crf=$3
	v_opt=$4
	if [ ! -d "$fname" ]; then
		mkdir "$fname"
	fi
	outname="${fname}/${codec}_${preset}_${crf}.mkv"
	echo Processing $outname
	eval "ffmpeg -v quiet -stats -n -hide_banner -i '$file' -c:v $codec -crf $crf -preset $preset $v_opts -an $outname"
}

for crf in $crf_values; do
	mpeg_presets="ultrafast superfast veryfast faster fast medium slow slower veryslow"
	svtav1_presets="3 4 5 6 7 8 9 10 11 12"
	aomav1_cpuused="1 2 3 4 5 6"
	for preset in $mpeg_presets; do
		ff_test libx264 $preset $crf 
		ff_test libx265 $preset $crf
	done
	for preset in $svtav1_presets; do
		ff_test libsvtav1 $preset $crf "-threads 8 -svtav1-params keyint=10s" 
	done
	
done
