#!/bin/bash
#----------
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#----------
while getopts ":t:p:h" opt; do
	case $opt in
		t) t="${OPTARG}";;
		p) p="${OPTARG}";;
		h) h="active";;
		*) h="active";;
	esac
done
#----------
if [[ -z "${t}" || -z "${p}" ]]; then
    if [[ "$h" != "active" ]]; then
        echo "helper"
    fi
fi
#----------
IFS='-' read -r -a port <<< "$p"
if [[ ! "${port[1]}" ]]; then
	port[1]="${port[0]}"
else
	if [[ "${port[0]}" -gt "${port[1]}" ]]; then
		port_temp="${port[0]}"
		port[0]="${port[1]}"
		port[1]="$port_temp"
		echo "change"
	fi
fi
#----------
check_nmap=$(dpkg-query -W -f='${Status}' nmap 2>/dev/null | grep -c "ok installed")
echo "$check_nmap"
if [[ "$check_nmap" -eq 0 ]]; then
	sudo apt-get update
fi
#----------
for probe in $(seq "${port[0]}" "${port[1]}"); do
	result=$(nc -zvv "$t" "$probe" 2>&1 | grep "succeeded" & wait)
	if [[ "$result" ]]; then
		echo -e "${GREEN}[sweep]${ENDCOLOR}: $result"
		nmap -sV -sS $t -p $probe -T5 & wait
		continue
	fi
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Fail probing at port $probe!"
	printf "\033[A";
done