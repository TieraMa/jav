#!/bin/bash
rm -f /tmp/result*.txt
i=1
if [ "$1" == '-e' ];then
  shift
  until [ $# -eq 0 ]
  do
    ls /data/ssd/JAV_thumbnail/all_jpg/ | grep $1 | grep -v '精选' | awk -F'_' '{print $3}' | sed 's/\.jpg//g' | tr ',' '\n' | grep -Ev '^$' | sort | uniq -d > /tmp/result${i}.txt
    ((i++))
    shift
    # [[ $# -eq 0 ]] && break
  done

elif [ "$1" == '-ee' ];then
  shift
  until [ $# -eq 0 ]
  do
    ls /data/ssd/JAV_thumbnail/all_jpg/ | grep $1 | grep -v '精选' | grep '单体作品' | awk -F'_' '{print $3}' | sed 's/\.jpg//g' | tr ',' '\n' | grep -Ev '^$' | sort | uniq -d > /tmp/result${i}.txt
    ((i++))
    shift
  done
  
else
  # for i in $(seq 1 5)
  until [ $# -eq 0 ]
  do
    ls /data/ssd/JAV_thumbnail/all_jpg/ | grep $1 | awk -F'_' '{print $3}' | sed 's/\.jpg//g' | tr ',' '\n' | grep -Ev '^$' | sort | uniq > /tmp/result${i}.txt
    ((i++))
    shift
    # [[ $# -eq 0 ]] && break
  done
fi
((i--))
cat /tmp/result*.txt | sort | uniq -c | grep "$i "
