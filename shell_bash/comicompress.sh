#!/bin/bash

quality=85
psize=1200\>
lsize=x1200\>

name=`basename "${PWD}"`
echo $name

rm "$name.jpg"

mkdir tmp
mv *.{jpg,jpeg,png} tmp

for x in $(ls tmp)
do
    file="tmp/$x"
    fname=${x%.*}
    magick $file -resize 1200x1200 -quality $quality -strip -limit area 250MB "$name.jpg"
    break
done

for x in $(ls tmp)
do
        file="tmp/$x"
        fname=${x%.*}
        width=`magick identify -format %w $file`
        height=`magick identify -format %h $file`

        if [[ $height -ge $width ]]; then
        # waifu2x-caffe-cui.exe -w $psize -p cpu -n 3 -m auto_scale -i $file -o scaled/$basefile.png
        magick $file -resize $psize -quality $quality -strip -define webp:lossless=false -limit area 250MB $fname.webp
        elif [[ $width -ge $height ]]; then
        # waifu2x-caffe-cui.exe -h $lsize -p cpu -n 3 -m auto_scale -i $file -o scaled/$basefile.png
        magick $file -resize $lsize -quality $quality -strip -define webp:lossless=false -limit area 250MB $fname.webp
        else
        # waifu2x-caffe-cui.exe -h $lsize -p cpu -n 3 -m auto_scale -i $file -o scaled/$basefile.png
        magick $file -resize 1600x1600 -quality $quality -strip -define webp:lossless=false -limit area 250MB $basefile.webp
  fi
done

7z a -sdel "$name.cb7" *.{webp,gif}
rm -r tmp
