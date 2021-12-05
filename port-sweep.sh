#!/bin/bash
#----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
#----------
if [[ $UID == 0 ]]; then
	while getopts ":t:p:o: :i :h" opt; do
		case $opt in
			t) t="${OPTARG}";;
			p) p="${OPTARG}";;
			o) o="${OPTARG}";;
			i) bash source/run-installer.sh; exit 0;;
			h) bash source/run-usage.sh; exit 0;;
			*) h="active";;
		esac
	done
	#----------
	if [[ -z "${t}" || -z "${p}" ]]; then
	    if [[ "$h" != "active" ]]; then
	        bash source/run-usage.sh
	        exit 0
	    fi
	fi
	#----------
	bash source/run-scanner.sh "$t" "$p" "$o"
else
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Installation require root privileges. Aborting"
	exit 0
fi