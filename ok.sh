#!/bin/bash
test=0
a="1-20,80,443,3306"
IFS=',' read -r -a segment <<< "$a"
for range in "${segment[@]}"; do
	test=$((++test))
	echo "$range"
done
echo "${segment[${#segment[@]}-1]}"
