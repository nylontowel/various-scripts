#!/bin/bash -i

if [ -z "$OIFS" ]; then
  OIFS="$IFS"
fi

path=$1

if [ $path ]; then
  pushd "$path"
fi

IFS=$'\n,'

# This script is intended for batch compressing images into webp
# without losing File Modification and Creation tags.
# Video compression has been fixed, but doesn't carry over a lot of
# metadata except for date and time.

# Comment this if you are using Linux. This is just a dirty way of fixing
# a bug when using Windows Git Bash
# COLUMNS=100

# Options on what media to process.
compressImages=true
compressVideos=true # This doesn't work as intended. Modification date does not work.

# If zero byte files are to be deleted. Disabling will cause
# visual issues but harmless. Disable if you have zero byte files that
# is important.
delZeroByteFiles=true
deleteFiles=true

# File types to process
## Images
imgLossyTypes="jpg,jpeg"
imgLosslessTypes="png"

## Videos
vidTypes="mp4"

# File extensions
## Media file outputs.
imgOutExt="webp"
vidOutExt="mkv"

# Image config, backend used is imagemagick
imgQuality=85
lossyQuality=85
losslessQuality=85

imgLosslessArgs="-define webp:lossless=true"
imgLossyArgs="-define webp:lossless=false"

# FFMPEG config

#ffmpegThreads=1
preInputFfmpeg=""

## Video
videoCodec="libsvtav1"
videoQuality="38"  # Uses -q:v if value is numbers
      # Uses -b:v if value has letters (e.g. 100k,5M)

## Video Filters (Optional)
vFil=""
vParams="-preset 8 -svtav1-params input-depth=10:keyint=10s"

## Audio
audioCodec="libopus"
audioQuality="96k"  # Uses -q:a if value is numbers
      # Uses -b:a if value has letters (e.g. 100k,5M)

## Audio Filters (Optional)
## -af "$aFilters"
aFil=""
aParams=""

## Filter_Complex (Optional)
## -filter_complex "$fComplex"
fComplex=""

ffmpegArgs=""

#######################################################
################ END OF CONFIGURATION. ################
#######################################################

# Variable Initialization.

if [[ $videoQuality =~ ^[0-9]+$ ]]
then
    videoMode='q'
else
    videoMode='b'
fi

if [[ $audioQuality =~ ^[0-9]+$ ]]
then
    audioMode='q'
else
    audioMode='b'
fi

if [ $videoMode = 'b' ]; then
    vidQ="-b:v $videoQuality"
else
    vidQ="-q:v $videoQuality"
fi

if [ $audioMode = 'b' ]; then
    audQ="-b:a $audioQuality"
else
    audQ="-q:a $audioQuality"
fi

if [ -z ${vFil} ]; then
  vFilter=""
else
  vFilter="-vf $vFil"
fi

if [ -z ${aFil} ]; then
  aFilter=""
else
  aFilter="-af $aFil"
fi

if [ -z ${fComplex} ]; then
  filterComplex=""
else
  filterComplex="-filter_complex $fComplex"
fi

imgTypes="${imgLossyTypes},${imgLosslessTypes}"

if [ -z "$ffmpegArgs" ]; then
  ffmpegArgs="-c:v $videoCodec $vidQ $vFilter $vParams -c:a $audioCodec $audQ $aFilter $aParams $filterComplex"
fi

count=0
total=0

# Initialization

exiftoolPresent=0
ffmpegPresent=0
magickPresent=0

exiftool -ver &> /dev/null && exiftoolPresent=1
ffmpeg -hide_banner -version &> /dev/null && ffmpegPresent=1
magick -version &> /dev/null && magickPresent=1

depCheck () {
  echo "Dependency $1 not present."
}
if [[ $exiftoolPresent -eq 0 ]]; then
  depCheck exiftool
elif [[ $ffmpegPresent -eq 0 ]]; then
  depCheck ffmpeg
elif [[ $magickPresent -eq 0 ]]; then
  depCheck magick
else
  echo "All is good. Proceeding..."
fi

if [[ $exiftoolPresent -eq 0 ]]; then
  exit
elif [[ $ffmpegPresent -eq 0 ]]; then
  exit
elif [[ $magickPresent -eq 0 ]]; then
  exit
fi

# Functions
set_counter () {
    count=0
    total=0
}

resetCount () {
  count=0
}

carriagePrint () {
  cols=$(tput cols)
  windowColumn=$(( $cols - 5 ))
  outString="$1"
  if (( $cols >= ${#outString} )); then
    padding=$(( ( $cols ) - ( ${#outString} ) ))
    dotString=$(printf "%${padding}s")
    outString="${outString}${dotString// /' '}"
  else
    outString="${outString:0:$windowColumn}..."
  fi
  outputString="${outString:0:$cols}"
  echo -ne $outputString\\r
}

deleteZeroByteFiles () {
  if [ $delZeroByteFiles = 'true' ]; then
    carriagePrint "Deleting zero-byte files... "
    find . -type f -size 0 -iname "*.${1}" -exec rm {} \;
  fi
}

deleteOriginal () {
  if [ $deleteFiles = 'true' ]; then
    rm $1
  fi
}

count_files () {
    for file in $(find . -type f -iname "*.${1}" -printf "%P\n")
    do
        total=$((${total}+1))
    done
}


renameInvalidFiles () {
  IFS=$'\n'
  lastfile="none"
  lastcount="none"
  for file in $(find . -type f -iname "*.${1}" -printf "%P\n")
  do
    count=$((${count}+1))
    fname=${file%.*}
    fext=${file##*.}
    newfname=$(echo ${fname//[^[:ascii:]]/}.${fext} | tr -d ,)
    mv "$file" "$newfname" &> /dev/null
    if [ "$file" != "${newfname}" ]; then
      lastfile=$newfname
      lastcount=$count
      carriagePrint "Renamed $file"
    else
      carriagePrint "Checked ($count/$total). Last renamed ($lastcount): $lastfile"
    fi
  done
  IFS=$'\n,'
}

file2Exif () {
  exiftool -q -overwrite_original -FileModifyDate\>ModifyDate -FileCreateDate\>CreateDate ${1} &> /dev/null
}

exif2File () {
  exiftool -q -overwrite_original -FileCreateDate\<CreateDate -FileModifyDate\<ModifyDate ${1} &> /dev/null
}

oldExif2File () {
  exiftool -q -tagsfromfile "${1}" -FileModifyDate\<ModifyDate -FileCreateDate\<CreateDate "${2}" &> /dev/null
}

magickLossy () {
  varTwo="$(echo $2 | tr -d [:cntrl:])"
  eval "magick \"$1\" $varTwo -quality $3 \"$4\" &> /dev/null"
}

magickLossless () {
  varTwo="$(echo $2 | tr -d [:cntrl:])"
  eval "magick \"$1\" $varTwo -quality $3 \"$4\" &> /dev/null"
}

ffmpegCommand () {
  args="$(echo $2 | tr -d [:cntrl:])"
  eval "ffmpeg -hide_banner -loglevel warning -y -threads $(($(nproc)-1)) $preInputFfmpeg -i \"$1\" $args \"$3\""
}

loop_files () {
    for file in $(find . -type f -iname "*.${1}" -printf "%P\n")
    do
        count=$((${count}+1))
        fname=${file%.*}
        if [ -z $(exiftool -DateTimeOriginal $file) ]; then
          file2Exif $file
          # exiftool -q -overwrite_original -FileModifyDate\>ModifyDate -FileCreateDate\>CreateDate $file &> /dev/null
        fi

        for img in $imgTypes;
        do
            if [ ${1} = $img ]; then
                for lossyType in $imgLossyTypes; do
                    if [ $lossyType = $img ]; then
                        newfile="${fname}.${imgOutExt}"
                        # magick $file $(echo $imgLossyArgs | tr -d [:print:]) -quality $lossyQuality $newfile &> /dev/null && rm $file
                        magickLossy "$file"  "$imgLossyArgs" "$imgQuality" "$newfile"
                        errorCode=$?
                    fi
                done
                for losslessType in $imgLosslessTypes; do
                    if [ $losslessType = $img ]; then
                        newfile="${fname}.lossless.${imgOutExt}"
                        # magick $file $(echo $imgLosslessArgs | tr -d [:print:]) -quality $losslessQuality $newfile &> /dev/null && rm $file
                        magickLossless "$file" "$imgLosslessArgs" "$imgQuality" "$newfile"
                        errorCode=$?
                    fi
                done
        if [ $errorCode -eq 0 ]; then
          exif2File $newfile
          oldExif2File "$file" "$newfile"
          deleteOriginal "$file"
          carriagePrint "${count}/${total} images processed: $file"
        else
          carriagePrint "${count}/${total} images error: $file"
        fi
            fi
        done

        for vid in $vidTypes;
        do
            if [ ${1} = $vid ]; then
                newfile=${fname}.${vidOutExt}
                carriagePrint "${count}/${total} videos processing: $file"
                # ffmpeg -loglevel quiet -y -i "$file" $(echo "$ffmpegArgs" | tr -d [:print:] ) "$newfile"
                ffmpegCommand "$file" "$ffmpegArgs" "$newfile"
                errorCode=$?
                if [ $errorCode -eq 0 ]; then
                    # exif2File $newfile ## This doesn't work on MKV.
                    oldExif2File "$file" "$newfile"
                    carriagePrint "${count}/${total} videos processed: $file"
                    deleteOriginal $file
                else
                    carriagePrint "${count}/${total} videos error: $file"
                fi
            fi
        done

    done
}

set_counter

# Code Start

# Images
if [ $compressImages = 'true' ]; then

  echo "Compressing Images..."

    set_counter

  carriagePrint "Counting Files..."
    for x in $imgTypes;
    do
        count_files "$x"
    done

  echo -ne "Preparing files..." \\r
  for x in $imgTypes;
    do
    deleteZeroByteFiles $x
    renameInvalidFiles "$x"
    done

  carriagePrint "."
    echo Total images to compress: $total

  resetCount

    for x in $imgTypes;
    do
        loop_files "$x"
    done

  carriagePrint "."
    echo Finished compressing $total images.
else
  echo Skipping images...
fi

# Videos
if [ $compressVideos = 'true' ]; then
  echo "Compressing Videos..."
    set_counter

    for x in $vidTypes;
    do
        count_files "$x"
    done

  echo -ne "Preparing files..." \\r
  for x in $vidTypes;
    do
    deleteZeroByteFiles $x
    renameInvalidFiles "$x"
    done

  carriagePrint "."
    echo Total videos to compress: $total

  resetCount

    for x in $vidTypes;
    do
        loop_files "$x"
    done

  carriagePrint "."
    echo Finished compressing $total videos.
else
  echo "Skipping Videos..."
fi

if [ $path ]; then
  popd
fi

IFS=$OIFS
unset OIFS
