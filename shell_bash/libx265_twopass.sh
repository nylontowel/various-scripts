#!/bin/bash -i

file=$1
vidsize=$(numfmt --from=auto "$2")
vidtime=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" | tr -d [:cntrl:])

bitrate=$(bc -l <<< "$vidsize*8/$vidtime")

videobitrate=$(bc -l <<< "$bitrate*0.9")
audiobitrate=$(bc -l <<< "$bitrate*0.1")

maxabitrate=$(numfmt --from=auto "192Ki")
minabitrate=$(numfmt --from=auto "96Ki")
if [[ ${audiobitrate%.*} -ge $maxabitrate ]]; then
	audiobitrate=$maxabitrate
	videobitrate=$(bc -l <<< "$bitrate-$maxabitrate")
elif [[ ${audiobitrate%.*} -lt $minabitrate ]]; then
	audiobitrate=$minabitrate
	videobitrate=$(bc -l <<< "$bitrate-$minabitrate")
fi

echo File: "$file"
echo Duration: $vidtime
echo Video Bitrate: $(numfmt --to=iec "$videobitrate")
echo Audio Bitrate: $(numfmt --to=iec "$audiobitrate")
echo Estimated Output File Size: $(numfmt --to=iec-i "$(bc -l <<< "$bitrate/8*$vidtime")")

ffmpeg -y -v quiet -stats -hide_banner -i "$file" -c:v libx265 -b:v "$videobitrate" -an -x265-params "pass=1:log-level=error" -f null /dev/null && \
	ffmpeg -y -v quiet -stats -hide_banner -i "$file" -c:v libx265 -b:v "$videobitrate" -x265-params "log-level=error:pass=2" -c:a libopus -b:a "$audiobitrate" "${file%.*}_twopass.mkv"
