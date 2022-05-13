#!/bin/bash
source_dir=$1
movie_file=$(find ${source_dir}/ -type f -size +500M | head -1)
thumb_file=$(find ${source_dir}/ -name '(*-*)*_*.jpg' | head -1)
nfo_file=${movie_file%.*}.nfo

original_filename=$(echo ${movie_file} | awk -F'/' '{print $NF}')
title=$(echo ${source_dir} | sed 's/\/$//g' | awk -F'/' '{print $NF}' | sed 's/(//g' | sed 's/)/ /g' | awk -F'_' '{print $1}')
# 日期
premiered=$(/usr/bin/ls --time-style=+%F -l ${thumb_file} | awk '{print $(NF-1)}')
# 类别
genre=$(echo ${source_dir} | sed 's/\/$//g' | awk -F'/' '{print $NF}' | awk -F'_' '{print $2}' | tr ',' ' ')
# 演员
actor=$(echo ${source_dir} | sed 's/\/$//g' | awk -F'/' '{print $NF}' | awk -F'_' '{print $3}' | tr ',' ' ')

# title
nfo_demo1="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<movie>
  <title>${title}</title>
  <premiered>${premiered}</premiered>"
# all genre
nfo_demo2=$(for i in ${genre};do echo "  <genre>${i}</genre>";done)
# all acctress name
nfo_demo3=$(for i in ${actor};do echo "  <actor><name>$i</name><thumb/><profile/></actor>";done)
# video filename
nfo_demo4="  <original_filename>${original_filename}</original_filename>
</movie>"


echo -e "${nfo_demo1}
${nfo_demo2}
${nfo_demo3}
${nfo_demo4}" > ${nfo_file}
