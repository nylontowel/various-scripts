#!/bin/bash -i

yt-dlp -f "251/ba" -x --sponsorblock-mark all --embed-thumbnail --embed-metadata -o "$HOME/Music/Newpipe/%(uploader)s/%(title)s - (%(id)s).%(ext)s" $1
