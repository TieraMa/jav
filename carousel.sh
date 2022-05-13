#!/bin/bash
rm -f /data/hdd/JAV_thumbnail/random/*
ls /data/hdd/JAV_thumbnail/available/ > /tmp/database.tmp
max=`cat /tmp/database.tmp | wc -l`
num=$(($RANDOM%$max+1))
filename=`cat /tmp/database.tmp | sed -n "${num}p" | cut -d')' -f1`
ln -s /data/hdd/JAV_thumbnail/available/${filename}* /data/hdd/JAV_thumbnail/random/
num=$(($RANDOM%$max+1))
filename=`cat /tmp/database.tmp | sed -n "${num}p" | cut -d')' -f1`
ln -s /data/hdd/JAV_thumbnail/available/${filename}* /data/hdd/JAV_thumbnail/random/
