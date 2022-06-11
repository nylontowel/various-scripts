#!/bin/bash -i

chdman createcd -i "$1" -o "${1%.*}.chd" -f
rm "$1" 
find . -type f -iname "${1%.*}*.bin" -delete
