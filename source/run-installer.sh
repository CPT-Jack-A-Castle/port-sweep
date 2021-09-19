#!/bin/bash
#----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
#----------
check_curl=$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")
check_nmap=$(dpkg-query -W -f='${Status}' nmap 2>/dev/null | grep -c "ok installed")
check_ncat=$(dpkg-query -W -f='${Status}' ncat 2>/dev/null | grep -c "ok installed")
#----------
echo -e "${YELLOW}[sweep]${ENDCOLOR}: Updating Packages ...\n---"
apt-get update -y & wait
echo "---"			
#----------	
if [[ "$check_nmap" -eq 0 ]]; then
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Installing nmap ...\n---"		
	apt-get install nmap -y & wait
	echo "---"		
else
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: nmap have been installed ..."				
fi
if [[ "$check_curl" -eq 0 ]]; then
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Installing curl ...\n---"		
	apt-get install curl -y & wait
	echo "---"		
else
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: curl have been installed ..."				
fi
if [[ "$check_ncat" -eq 0 ]]; then
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Installing ncat ...\n---"		
	apt-get install ncat -y & wait
	echo "---"		
else
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: ncat have been installed ..."				
fi
#----------
check_curl=$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")
check_nmap=$(dpkg-query -W -f='${Status}' nmap 2>/dev/null | grep -c "ok installed")
check_ncat=$(dpkg-query -W -f='${Status}' ncat 2>/dev/null | grep -c "ok installed")
if [[ "$check_nmap" -eq 1 && "$check_ncat" -eq 1 && "$check_curl" -eq 1 ]]; then
	echo -e "${YELLOW}[sweep]${ENDCOLOR}: Dependencies have been met successfully"
	exit 0						
fi
