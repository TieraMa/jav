#!/bin/bash
#for i in `find /data/hdd/Downloads/ -type f -name *.mp4`
#do
#	id=`echo $i | awk -F/ '{print $NF}' | sed 's/-C.mp4//g' | sed 's/.mp4//g' | sed 's/^HD-//g' | tr '[a-z]' '[A-Z]' | grep -E "[[:upper:]]\-[[:digit:]]"`
#	dir=/data/hdd/JAV/`ls "/data/hdd/JAV/" | grep "(${id})"`
#	if [ -n "$id" ];then
#		if [ -d $dir ];then
#			echo $dir
#			mv ${i} $dir
#		fi
#	fi
#done
OLDIFS="$IFS"
IFS=$'\n'
for fullname in `find /data/hdd/Downloads/ -type f -name '*.mp4' -size +1G`
do
	id=`echo $fullname | awk -F/ '{print $NF}' | grep -E '[[:alpha:]]*-[[:digit:]]*' | sed 's/\([[:alpha:]][[:alpha:]]*-[[:digit:]][[:digit:]]*\).*/\1/' | sed 's/^HD_//g' | sed 's/big2048.com@//g'`
	if [ -d "$(getdir $id)" ];then
		echo $fullname
		mv $fullname `getdir $id`
	fi
done
IFS="$OLDIFS"
