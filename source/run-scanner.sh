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
if [[ $o ]]; then 
	IFS='.' read -r -a ext_arr <<< "$o"
	check_ext=$(echo $o | cut -d '.' -f ${#ext_arr[@]})
	[[ "$check_ext" != "log" ]] && o+=".log"
	o_clean=$(echo $o | tr -d '[\!@#$%^*[]{}`~\\"]')
	[[ $(echo $o_clean | grep "/") ]] && path_o="$o_clean" || path_o="log/$o_clean"
	touch "$path_o"
	[[ -s "$path_o" ]] || echo "-------" >> "$path_o"
fi
#----------
# coba ngescan pakai proxychain (hide ip)
#----------
trapexit() {
	end=$(date +%s%N | cut -b1-13)		
	duration=$(($end-$start))			
	printf "\r\n${RED}[sweep]${ENDCOLOR}: ---"
	printf "\n${RED}[sweep]${ENDCOLOR}: Port-Sweep cancelled for $(bc <<< "scale=3; $duration/60000") minutes"	
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
	echo -e "${BLUE}[sweep]${ENDCOLOR}: Starting Port-Sweep 2.12 at ${YELLOW}$t${ENDCOLOR} [$datetime] ..."
	[[ $o ]] && echo "[sweep] Starting Port-Sweep 2.12 at $t [$datetime] ..." >> "$path_o"
	#----------
	check_host=$(curl -I "$t" 2>&1 | grep "Failed")
	if [[ "$check_host" ]]; then
		echo -e "${RED}[sweep]${ENDCOLOR}: Host seems is inactive. Aborting"	
		[[ $o ]] && echo -e "[sweep] Host seems is inactive. Aborting\n-------" >> "$path_o"		
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
	start=$(date +%s%N | cut -b1-13)		
	nc -zvv "$t" "$sample" 2>&1 | grep "succeeded" & wait
	end=$(date +%s%N | cut -b1-13)		
	duration=$(($end-$start))				
	echo -e "${BLUE}[sweep]${ENDCOLOR}: Probing estimation for each port is roughly $(bc <<< "scale=5; $duration/60000") minutes ..."
	echo -e "${BLUE}[sweep]${ENDCOLOR}: ---"	
	[[ $o ]] && echo -e "[sweep] Probing estimation for each port is roughly $(bc <<< "scale=5; $duration/60000") minutes ...\n::" >> "$path_o"
	start=$(date +%s%N | cut -b1-13)
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
				[[ $o ]] && echo -e "[sweep] $result" >> "$path_o"				
				if [[ "$probe" -eq "${port[1]}" && "$range" == "${segment[${#segment[@]}-1]}" ]]; then
					end=$(date +%s%N | cut -b1-13)
					duration=$(($end-$start))
					sleep 2s & wait
					echo -e "${BLUE}[sweep]${ENDCOLOR}: Port-Sweep done for $(bc <<< "scale=3; $duration/60000") minutes"
					[[ $o ]] && echo -e "::\n[sweep] Port-Sweep done for $(bc <<< "scale=3; $duration/60000") minutes\n-------" >> "$path_o"
				fi
				continue
			fi
			echo -e "${YELLOW}[sweep]${ENDCOLOR}: Probing port at $probe ! ...";
			if [[ "$probe" -eq "${port[1]}" && "$range" == "${segment[${#segment[@]}-1]}" ]]; then
				end=$(date +%s%N | cut -b1-13)		
				duration=$(($end-$start))						
				sleep 2s & wait
				printf "\033[2A"
				echo -e "\n${BLUE}[sweep]${ENDCOLOR}: ---                                            "		
				echo -e "${BLUE}[sweep]${ENDCOLOR}: Port-Sweep done for $(bc <<< "scale=3; $duration/60000") minutes"
				[[ $o ]] && echo -e "::\n[sweep] Port-Sweep done for $(bc <<< "scale=3; $duration/60000") minutes\n-------" >> "$path_o"				
				echo ""
			fi
			printf "\033[A"
		done
	done
fi

: '
test=0
a="1-20,80,443,3306"
IFS=',' read -r -a segment <<< "$a"
for range in "${segment[@]}"; do
	test=$((++test))
	echo "$range"
done
echo "${segment[${#segment[@]}-1]}"
'