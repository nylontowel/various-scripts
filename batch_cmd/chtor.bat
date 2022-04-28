@echo off

REM Read control auth cookie into variable
set /p auth_cookie=<C:\Users\Admin\AppData\Roaming\tor\control_auth_cookie

REM Create file with control commands
echo AUTHENTICATE "%auth_cookie%" > commands.txt
echo SIGNAL NEWNYM >> commands.txt
echo QUIT >> commands.txt

REM Connect to control port and issue commands
nc localhost 9090 < commands.txt

REM Delete commands file
del /Q commands.txt