#!/bin/bash
#----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
#----------
t="$1"
p="$2"
o="$3"
#----------
trapexit() {
	duration=$SECONDS		
	printf "\r\n${RED}[sweep]${ENDCOLOR}: ---"
	printf "\n${RED}[sweep]${ENDCOLOR}: Port-Sweep cancelled for $(($duration / 60)) minutes $((duration % 60)) seconds"	
	echo ""
	exit 0
}
trap trapexit SIGINT
#----------
check_curl=$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")
check_nmap=$(dpkg-query -W -f='${Status}' nmap 2>/dev/null | grep -c "ok installed")
check_ncat=$(dpkg-query -W -f='${Status}' netcat-openbsd 2>/dev/null | grep -c "ok installed")
if [[ "$check_nmap" -eq 0 || "$check_ncat" -eq 0 || "$check_curl" -eq 0 ]]; then
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: You have unmet dependencies";
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Use flag -i for auto installation";
	exit 0
else
	#----------
	datetime=$(date +"%d/%m/%y %T")
	SECONDS=0
	echo -e "${BLUE}[sweep]${ENDCOLOR}: Starting Port-Sweep 2.12 at $datetime ..."
	#----------
	check_host=$(curl -I "$t" 2>&1 | grep "Failed")
	if [[ "$check_host" ]]; then
		echo -e "${RED}[sweep]${ENDCOLOR}: Host seems is inactive. Aborting"	
		exit 0
	fi
	#----------
	range=0
	sample=0
	IFS=',' read -r -a segment <<< "$p"
	for section in "${segment[@]}"; do
		IFS='-' read -r -a port <<< "$section"
		if [[ ! "${port[1]}" ]]; then
			port[1]="${port[0]}"
		else
			if [[ "${port[0]}" -gt "${port[1]}" ]]; then
				port_temp="${port[0]}"
				port[0]="${port[1]}"
				port[1]="$port_temp"
			fi
		fi
		for probe in $(seq "${port[0]}" "${port[1]}"); do
			range=$(($range+1))
			sample="${port[0]}"
		done
	done
	nc -zvv "$t" "$sample" 2>&1 | grep "succeeded" & wait
	duration=$SECONDS						
	estimate=$(($duration * $range))
	echo -e "${BLUE}[sweep]${ENDCOLOR}: Probing estimation finished in $(($estimate / 60)) minutes $((estimate % 60)) seconds ..."
	echo -e "${BLUE}[sweep]${ENDCOLOR}: ---"	
	SECONDS=0	
	#----------
	for range in "${segment[@]}"; do
		IFS='-' read -r -a port <<< "$range"	
		if [[ ! "${port[1]}" ]]; then
			port[1]="${port[0]}"
		else
			if [[ "${port[0]}" -gt "${port[1]}" ]]; then
				port_temp="${port[0]}"
				port[0]="${port[1]}"
				port[1]="$port_temp"
			fi
		fi		
		for probe in $(seq "${port[0]}" "${port[1]}"); do
			result=$(netcat -zvv "$t" "$probe" 2>&1 | grep "succeeded" & wait)
			if [[ "$result" ]]; then
				echo -e "${GREEN}[sweep]${ENDCOLOR}: $result"
				#nmap -sS -sV "$t" -p "$probe" -T5
				if [[ "$probe" -eq "${port[1]}" && "$range" == "${segment[${#segment[@]}-1]}" ]]; then
					duration=$SECONDS					
					sleep 2s & wait
					echo -e "${BLUE}[sweep]${ENDCOLOR}: Port-Sweep done for $(($duration / 60)) minutes $((duration % 60)) seconds"
				fi
				continue
			fi
			echo -e "${YELLOW}[sweep]${ENDCOLOR}: Probing port at $probe ! ...";
			if [[ "$probe" -eq "${port[1]}" && "$range" == "${segment[${#segment[@]}-1]}" ]]; then
				duration=$SECONDS				
				sleep 2s & wait
				printf "\033[2A"
				echo -e "\n${BLUE}[sweep]${ENDCOLOR}: ---                                            "		
				echo -e "${BLUE}[sweep]${ENDCOLOR}: Port-Sweep done for $(($duration / 60)) minutes $((duration % 60)) seconds"
				echo ""
			fi
			printf "\033[A"
		done
	done
fi