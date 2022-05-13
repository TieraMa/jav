#!/bin/bash
#find /data/JAV/ -type f -name '*.jpg' -exec ln -s '{}' /data/JAV_thumbnail/ \; 2> /dev/null
OLDIFS="$IFS"
IFS=$'\n'
# for i in `du -sh /data/JAV/* | grep '^[0-9].*G.*\/data' | cut -f2`
# do
#	find "$i" -type f -name '*.jpg' -exec ln -s '{}' /data/JAV_thumbnail/available/ \; 2> /dev/null
# done

for i in `ls -t /data/hdd/JAV/ | head -500`
#for i in `ls -t /data/hdd/JAV/`
do
	req=$(du -sh "/data/hdd/JAV/${i}"  | grep -E '^[0-9].*G.*/data|[[:digit:]][[:digit:]][[:digit:]]M.*/data' | cut -f2)
	[[ -d ${req} ]] && ln -s ${req} /data/hdd/JAV_thumbnail/available/ 2> /dev/null
done

# gen latest
rm -f /data/hdd/JAV_thumbnail/latest/*
for i in $(ls -t /data/hdd/JAV_thumbnail/available/ | head -50)
do
	ln -s /data/hdd/JAV_thumbnail/available/${i} /data/hdd/JAV_thumbnail/latest/ &> /dev/null
done
IFS="$OLDIFS"
