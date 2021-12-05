#!/bin/bash
#----------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
#----------
echo -e "Usage: port-sweep [OPTION]... [ARG]..."
echo -e "Lightweight Port and Vulnerability Scanning for TCP Connection.\n"
echo -e "Available flag options. Starred one are meant to be optional\n"
echo -e "  ${GREEN}-t${ENDCOLOR}\t full FQDN / IP Address of the target host"
echo -e "  ${GREEN}-p${ENDCOLOR}\t port number to be scanned. could be in range or individual"
echo -e "  ${GREEN}-i ${YELLOW}**${ENDCOLOR}\t perform dependencies checking & auto installation"
echo -e "  ${GREEN}-o ${YELLOW}**${ENDCOLOR}\t save the scan result to a specified file"
echo -e "  ${GREEN}-h ${YELLOW}**${ENDCOLOR}\t launch command usage for avilable flag options"
echo -e "\nExamples:\n"
echo -e "  bash port-sweep ${GREEN}-t${ENDCOLOR} api.example.com ${GREEN}-p${ENDCOLOR} 80,443 ${GREEN}-o${ENDCOLOR} result.log"
echo -e "  bash port-sweep ${GREEN}-t${ENDCOLOR} 192.168.1.100 ${GREEN}-p${ENDCOLOR} 1-3000,8080\n"
echo -e "Full documentation at hotpotcookie.github.io/docs/port-sweep"
echo -e "Open issues and report bugs to github.com/hotpotcookie/port-sweep"
	