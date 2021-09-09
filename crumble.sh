#!/bin/bash
#----------
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#----------
while getopts ":u:c:s:t:f:h" opt; do
	case $opt in
		u)
			u="${OPTARG}";;
		c)
			c="${OPTARG}";;
		s)
			s="${OPTARG}";;			
		t)
			t="${OPTARG}";;
		f)
			f="${OPTARG}";;
		h)
			h="active"
			bash source/run-usage.sh;;			
		*)
			bash source/run-usage.sh;;			
	esac
done
#----------
if [[ -z "${u}" || -z "${c}" || -z "${s}" || -z "${t}" ]]; then
	if [[ "$h" != "active" ]]; then
		bash source/run-usage.sh
	fi
fi

if [[ -s "$f" ]]; then
	echo "use directory listing"
else
	echo "use web crawler"
fi
#----------
echo "$u $c $s $t $f"