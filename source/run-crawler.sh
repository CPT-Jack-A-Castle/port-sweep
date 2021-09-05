#!/bin/bash
#----------
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#----------
## get status code of each link    : curl -q --head https://hotpotcookie.github.io/index.html | grep "HTTP" | cut -d ' ' -f 2
## get potential directory to file : curl https://hotpotcookie.github.io | grep "href=" | cut -d '"' -f 2 | sort | uniq