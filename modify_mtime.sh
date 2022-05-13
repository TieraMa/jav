#!/bin/bash
ID=$1
DATE=$2
if [ "${ID}" == '' -o "${DATE}" == '' ];then
	echo -e "usage:\n  modify_mtime.sh <ID> <DATE>"
	exit 1
fi
#sudo chattr -R -ai /data/JAV/*${ID}*
find /data/hdd/JAV/ -iname "*${ID}*" -exec touch -m -d "${DATE}" '{}' \;
