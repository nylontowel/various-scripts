#!/bin/bash -i

IFS=$'\n'
auth_cookie=$(cat /c/Users/Admin/AppData/Roaming/tor/control_auth_cookie)

nc_tor=""

nc_tor+="authenticate $auth_cookie"$'\n'
nc_tor+="signal newnym"$'\n'
nc_tor+="quit"$'\n'

echo $nc_tor | nc localhost 9090
for x in $nc_tor; do
	echo "$x" | nc localhost 9090 | continue;
done
