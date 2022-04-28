#!/bin/bash

OIFS=$IFS

# Threshold is in megabytes.
threshold=1000

# Time it takes before executing the script again. Can take fractions.
delta=60


# Initialization

if [[ -n "$1" ]]; then
	pushd "$1"
fi

count=0
skip=0
busyFiles=()
delta=$(($delta))

threshold=$((threshold*1024))

IFS=$'\n'

checkDirSize () {
	du -s . | awk 'END { print $1 }'
}

checkDirSizeHuman () {
	du -s -h . | awk 'END { print $1 }'
}

checkFileSize () {
	input=$1
	ls -s $input | awk 'END { print $1 }'
}

checkFileSizeHuman () {
	input=$1
	ls -s -h $input | awk 'END { print $1 }'
}

deleteFiles () {
	currentSize=$(checkDirSize)
	for file in $(ls -1utrR $(find . -type f -printf "%P\n")); do\
	
		fileSize=$(checkFileSize $file)
		fileSizeHuman=$(checkFileSizeHuman $file)
		rm --interactive=never $file
		exitCode=$?
		currentSize=$(($currentSize - $fileSize))
		
		if [[ $exitCode -eq 0 ]]; then
			echo Current Directory Size: $(($currentSize/1024))M. Deleted $fileSizeHuman $file
		elif [[ $exitCode -ne 0 ]]; then
			continue
		fi
		
		if [[ $currentSize -gt $threshold ]]; then
			continue
		fi
		
		break
	done

}

while true; do
	if [[ $(checkDirSize) -gt $threshold ]]; then
		deleteFiles
	else
		sleep $delta
	fi
done

if [[ -n "$1" ]]; then
	popd
fi

IFS=$OIFS