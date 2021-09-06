#!/bin/bash
#----------
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#----------
scrap="log/scrap.log"
traverse="log/traverse.log"
main="log/main.log"
#----------
url="$1"
cat /dev/null > "$scrap"
cat /dev/null > "$traverse"
#----------
php source/run-crawler.php "$url" | sort | uniq > "$scrap"
while IFS= read -r each_dir; do
	## puter kesemua, append ke satu file temp
	## sort uniq ke main.log
	echo "crawling: $each_dir"
	php source/run-crawler.php "$each_dir" | sort | uniq > "$traverse" & wait
	cat "$traverse" >> "$main.tmp" & wait
	cat "$main.tmp" | sort | uniq > "$main" & wait
done < "$scrap"