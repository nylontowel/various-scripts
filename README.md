# various-scripts
A collection of scripts nylontowel made.

Various scripts I've made to automate things I do on the daily.

## Batch_CMD scripts
### chtor.bat
	- Changes tor circuit/identity using nc.exe
	
### cue2chd.bat
	- Compresses every `cue` file to `chd` with chdman.exe. Meant to be used for PSX games.
	
### shizuku.bat
	- Script to quickly run shizuku on target phone.
	
### tcpip555.bat
	- Quickly starts adb daemon to tcpip port 5555

## Shell_bash scripts
### 7zallfiles.sh
	- personalized script that just compresses every file inside a directory regardless of extension.
	
### chtor.sh
	- an attempt to change tor identity with cygwin. (Not working)

### comicompress.sh
	- a script that takes in all images in a directory and converts it into WEBP, then packs it all into a CB7 archive.
	- Depends on:
		- imagemagick

### compress_lectures.sh
	- Depends on:
		- lagmoellertim/unsilence
		- ffmpeg
	- Removes silence from the video using Unsilence, then compressing it to libx265 with ffmpeg. Could be more efficient but it works for me. Adds a string after the original name and before the extension if you add a second argument.
	- Usage:
		compress_lectures.sh {file} {string}
### dbase64 scripts
	- A few scripts to quickly decode base64 strings.
### deleteOldest.sh
	- A script originally to run in the background, automatically deleting the file with the oldest access date.
	- Usage:
		deleteOldest.sh {directory}
### iso2cso.sh
	- A script that uses maxcso.exe to compress PSP ISO files into a more compact format, CSO.
### shrink_media.sh
	- Depends on:
		- imagemagick
		- ffmpeg
	- Script that converts every image to webp and every video to mkv. Lossless images have added name before the extension to indicate that they're lossy. Videos are encoded in libx265 and libopus, and is in mkv format. Configurable inside the script. Images retain their file modification and creation date. Videos don't.
	- Usage:
		shrink_media.sh {directory}
### startTor.sh
	- a test script. (not working)
### unzipall.sh
	- a simple script that unzips all 7z and zip files in the directory.


This is for personal use and if anyone decides to use it, please modify the script to your needs.
