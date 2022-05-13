#!/bin/bash
# 目标目录
target=$1
# 找到目录中的视频文件
video_file=$(find ${target} -type f -size +500M | head -1)
echo "video filename: ${video_file}"

# 定义海报文件名字
poster_file=${video_file%.*}.jpg
echo "poster filename: ${poster_file}"

# 找到封面文件
thumb_file=$(find ${target} -type f -name '*.jpg' | grep "(.*-.*).*(.*-.*)" | head -1)
echo "thumb filename: ${thumb_file}"

# 不用执行下去的情况判断
#if [[ ! -f ${poster_file} -o -z ${poster_file} ]];then
#	echo "ERROR"
#	exit
#fi

# 准备生成海报
cp ${thumb_file} /tmp/source.jpg

# 生成海报
podman run --rm -v /tmp:/imgs docker.io/dpokidov/imagemagick /imgs/source.jpg -crop 379x538+420+0 /imgs/dest.jpg

# 复制海报文件到target
cp /tmp/dest.jpg  ${poster_file}
