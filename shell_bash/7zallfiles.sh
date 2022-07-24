#!/bin/bash -i
OIFS=$IFS
IFS=$'\n'

e7z="7z"

count=0
total=0

max_dSize=$(numfmt --from=iec 128M)
min_dSize=$(numfmt --from=iec 128K)

get_dSize () {
	size=${1%.*}
	if [[ "$size" -ge "$max_dSize" ]]; then
	       dSize=$max_dSize
       elif [[ "$size" -le "$min_dSize" ]]; then
	       dSize=$min_dSize
       else
	       dSize=$size
	fi
	dSize=$(numfmt --to=iec $dSize)
	if [[ "$dSize" == *.* ]]; then
		dSizeNum=${dSize%.*}
		dSizeExt=${dSize: -1}
		hDicSize=${dSizeNum}${dSizeExt}
	else
		hDicSize=$dSize
	fi
}

for x in $(find . -maxdepth 1 -type f -printf "%P\n"); do
	if [[ $x == *"7z" ]]; then
		continue
	fi 
	total=$((total+1))
done

for file in $(find . -maxdepth 1 -type f -printf "%P\n"); do
	if [[ $file == *"7z" ]]; then
		continue
	fi
       	fSize=$(ls -l "$file" | awk '{print $5}')
	get_dSize "$fSize"
	count=$(($count+1))
	echo "$count/$total DicSize $hDicSize FileSize $(numfmt --to=iec $size) $file"
	filename=${file%.*}
	$e7z a -t7z -sdel -mx9 -mmt4 -md$hDicSize -bso0 -bsp0 "${filename}.7z" "$file"
	if [[ $? -ne 0 ]]; then
		rm "${filename}.7z"
		break
	fi
		
done;

IFS=$OIFS
