#!/bin/bash
#----------
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#----------
scrap="log/scrap.log"
traverse="log/traverse.log"
main_tmp="log/main.log.tmp"
main="log/main.log"
csv_tmp="log/result.csv.tmp"
csv="log/result.csv"

#----------
url="$1"
cat /dev/null > "$scrap"
cat /dev/null > "$traverse"
cat /dev/null > "$main_tmp"
cat /dev/null > "$csv_tmp"
#----------
php source/run-crawler.php "$url" | sort | uniq > "$scrap"
while IFS= read -r each_dir; do
	## puter kesemua, append ke satu file temp
	## sort uniq ke main.log
	echo "crawling: $each_dir"
	php source/run-crawler.php "$each_dir" | sort | uniq > "$traverse" & wait
	cat "$traverse" >> "$main_tmp" & wait
	cat "$main_tmp" | sort | uniq > "$main" & wait
done < "$scrap"
#----------
clear
counter=1
while IFS= read -r each_stat; do
	width_term=$(tput cols)
	width_term=$((--width_term))
	width_term+="s"
	check=$(echo "$each_stat" | grep "0")
	mod=$(($counter%5))
	counter=$((++counter))		
	if [[ "$check" && $mod -eq 0 ]]; then
		counter=1
		echo "$each_stat" > "$csv_tmp" & wait
		termgraph "$csv_tmp" --color {cyan,red,yellow,green}; sleep 1s
		printf "\033[6A ";
	fi
done < "$csv"
printf "\033[7B"		
echo -e "--\nEND\n--"
#  termgraph log/result.csv --color {cyan,red,yellow,green}
# slowhttptest -c 3000 -H -u http://localhost:3000/ -g -o log/result
