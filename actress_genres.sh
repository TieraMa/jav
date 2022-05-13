#!/bin/bash
OLDIFS="$IFS"
IFS=$'\n'
echo '' > /data/hdd/JAV_thumbnail/lib/actress_genres.db
# get all actress and count
#list=$(ls /data/JAV/ | cut -d'_' -f3 | tr ',' '\n' | grep -Ev '^$' | sort | uniq -c | sort -n -k1)
ls /data/ssd/JAV_thumbnail/all_jpg/ | sed 's/\.jpg//g' | cut -d'_' -f3 | tr ',' '\n' | grep -Ev '^$' | sort | uniq -c | sort -rn -k1 > /data/hdd/JAV_thumbnail/lib/actress_count.db

for i in `cat /data/hdd/JAV_thumbnail/lib/actress_count.db`
do
	actress=$(echo $i | awk '{print $NF}')
	# get 5 tags
	tags=$(ls /data/hdd/JAV/ | grep "${actress}" | cut -d'_' -f2 | sed 's/,/\n/g' | sort | uniq -c | sort -n -k1 | tail -5 | awk '{print $2}' | tr '\n' ',' | sed 's/,$//g')
	echo -e "${i}\t\t${tags}" >> /data/hdd/JAV_thumbnail/lib/actress_genres.db
done
IFS="$OLDIFS"
