#!/bin/bash
for i in $(ls /data/hdd/JAV_thumbnail/available/)
do
	gen_nfo.sh /data/hdd/JAV_thumbnail/available/${i}/
done
