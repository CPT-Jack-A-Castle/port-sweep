#!/bin/bash
#----------
for port in $(seq "$2" "$3"); do
	result=$(nc -zvv "$1" "$port" 2>&1 | grep "succeeded" & wait)
	if [[ "$result" ]]; then
		echo "$result"
		continue
	fi
	echo "fail probing at port $port!"
done
