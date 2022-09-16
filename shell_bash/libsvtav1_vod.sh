#!/bin/bash -i

OIFS=$IFS
IFS=$'\n'
quality=45
v_opt="-c:v libsvtav1 -preset 8 -svtav1-params input-depth=10:keyint=10s:crf=$quality"
a_opt="-c:a libopus -b:a 128k"
ffmpeg=ffmpeg
if [ ! -d "original_vods" ]; then
	mkdir original_vods
fi
for file in $(find . -maxdepth 1 -type f ! -iname \*_av1.mkv); do
	fname=${file%.*}
	if [ -f "${fname}_av1.mkv" ]; then
		echo "Already converted. Moving Original. Skipping: $file"
		mv "$file" original_vods
		continue
	fi
	echo "Processing: $file" 
	#eval $ffmpeg -hide_banner -n -i \"$file\" -threads 8 -map 0:v:0? -map 0:a? $v_opt:pass=1 -an outfile.ivf
	eval $ffmpeg -hide_banner -v quiet -stats -n -i \"$file\" -threads 8 -map 0:v:0? -map 0:a? $v_opt $a_opt \"${fname}_av1.mkv\" 
	#av1an -c mkvmerge -m lsmash -a="-c:a libopus -b:a 128k" -e svt-av1 -v="--crf 45 --keyint 10s --preset 8" -w 4 -i "$file" -o "$fname_av1.mkv"
	if [ $? -eq 0 ]; then
		if [ -f "${fname}_av1.mkv" ]; then
			#rm "$file"
			mv "$file" original_vods
		fi
		continue
	else
		rm "${fname}_av1.mkv"
		break
	fi
done
