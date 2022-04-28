chcp 65001

for %%a in (.) do set curDir=%%~na

for %%i in (*.cue, *.gdi) do (
	chdman createcd -np 4 -i "%%i" -o "%%~ni.chd"
	del "%%~ni*.bin"
	del "%%i"
	echo "%%~ni.chd" >> "%curDir%.m3u"
	)
