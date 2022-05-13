#!/bin/bash
URL=$1

#if [ $1 == 'local' ];then
#	cp "$(ls -rt /data/ssd/Downloads/tmp/*.htm* | awk 'END{print}')" /tmp/jav_web_source.html
#else
#	echo '开始拉取数据...'
#	#curl -kL ${URL} > /tmp/jav_web_source.html
#	ssh tiera@www.tierama.com "curl -kL ${URL} > /tmp/jav_web_source.html" \
#	&& scp tiera@www.tierama.com:/tmp/jav_web_source.html /tmp/jav_web_source.html \
# 	|| (echo -e "\033[31m数据拉取失败,退出当前任务!\033[0m" && exit)
#fi


touch_jav() {
	#获取标题,并去除特殊符号
	echo '正在获取标题...'
	TITLE=`grep 'JAVLibrary</title>' /tmp/jav_web_source.html | sed 's/<title>//g' | sed 's/\ -\ JAVLibrary<\/title>//g' | sed 's/\ /)/' | sed 's/^/(/g' | sed 's/://g' | sed 's/\*//g' | sed 's/?//g' | sed 's/\ /-/g'`
	#获取番号
	echo '正在获取番号ID...'
	ID=`echo $TITLE | cut -d\( -f2 | cut -d\) -f1`
	[ -z $ID ] && echo -e "\033[31m数据拉取失败,退出当前任务!\033[0m" && exit
	#检查重复
	echo '检查重复...'
	ls -d /data/hdd/JAV/\(${ID}\)*
	if [ $? -eq 0 ];then
		echo -e "\033[33m此番号已存在,退出当前任务!\033[0m"
		return 1
	fi
	#获取封面图片链接
	echo '正在获取封面图片URL...'
	IMAGE_URL=https://`grep video_jacket_img /tmp/jav_web_source.html | sed 's/.*src=\"\/\///g' | sed 's/\.jpg.*/\.jpg/g' | sed 's/.*src=\"https:\/\///g'`
	echo "封面URL为: $IMAGE_URL"
	#获取标签
	echo '正在获取标签...'
	TAG=`grep 'category tag' /tmp/jav_web_source.html | sed 's/rel="category tag">/\n/g' | sed 's/<\/a><\/span>/\n/g' | grep -Ev '<|>' | tr '\n' , | sed 's/,$//g'`
	#获取演员名
	echo '正在获取演员列表...'
	ACTOR=`grep 'span class="star"' /tmp/jav_web_source.html | sed 's/rel="tag">/\n/g' | sed 's/<\/a><\/span>/\n/g' | grep -Ev '<|>' | tr '\n' , | sed 's/,$//g'`
	# 更新actress.db
	grep 'span class="star"' /tmp/jav_web_source.html | sed 's/<a\ href=\"vl_star\.php?s=/\n/g' | sed 's/<\/span>\ <span\ id=\"star/\n/g' | grep 'rel="tag"' | sed 's/" rel="tag">/|/g' | sed 's/<\/span>\ <span\ id=\"alias[[:digit:]]*\"\ class=\"alias\">/|/g' | sed 's/<\/a>//g' >> /data/hdd/JAV_thumbnail/lib/actress.db
	sort -u /data/hdd/JAV_thumbnail/lib/actress.db -o /data/hdd/JAV_thumbnail/lib/actress.db
	#获取发布日期
	echo '正在获取发布日期...'
	JAV_DATE=`grep -A1 发行日期 /tmp/jav_web_source.html | grep -v 发行日期 | sed 's/.*>2/2/' | sed 's/<.*//' | head -1`
	#将标题信息存入临时文件
	echo '格式化数据...'
	echo ${TITLE} > /tmp/full_title_tmp.txt
	echo ${TAG} >> /tmp/full_title_tmp.txt
	echo ${ACTOR} >> /tmp/full_title_tmp.txt
	#格式化数据
	dos2unix /tmp/full_title_tmp.txt
	#整合标题名
	FULL_TITLE=`cat /tmp/full_title_tmp.txt | tr '\n' _ | sed 's/_$//g'`
	#判断标题名是否过长,如果超过80个字符,删除标题后面字符,再重新生成标题名
	while [ `sed -n '1p' /tmp/full_title_tmp.txt | wc -L` -ge 80 ]
	do
		sed -i '1s/...$//' /tmp/full_title_tmp.txt
	done
	#判断演员名是否过长,如果超过60个字符,删除标题后面字符,再重新生成标题名
	while [ `sed -n '3p' /tmp/full_title_tmp.txt | wc -L` -ge 60 ]
	do
		sed -i '3s/..$//' /tmp/full_title_tmp.txt
	done
	
	# 确定最终标题名
	FULL_TITLE=`cat /tmp/full_title_tmp.txt | tr '\n' _ | sed 's/_$//g' | tr -d \/`
	while [ ${#FULL_TITLE} -ge 95 ]
	do
		FULL_TITLE=`echo ${FULL_TITLE} | sed 's/..$//'`
	done
	#开始创建JAV目录
	echo "正在创建目录 ${FULL_TITLE}"
	result=$(echo ${FULL_TITLE} | grep '(.*).*_.*')
	if [ "$result" != "" ];then
		mkdir "/data/hdd/JAV/${FULL_TITLE}"
	fi
	#下载封面图...
	echo '正在下载封面图...'
	wget --no-check-certificate -O "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg" "${IMAGE_URL}"
	#ssh tiera@www.tierama.com "wget -O /tmp/jav.jpg "${IMAGE_URL}"" \
	#&& scp tiera@www.tierama.com:/tmp/jav.jpg "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg"
	#curl -k -o "/data/jav/${FULL_TITLE}/${FULL_TITLE}.jpg" "${IMAGE_URL}"
	
	# 验证是否获取成功
	#{ [ -n $TITLE ] && [ -n $IMAGE_URL ] && [ -f "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg" ] && echo -e "\033[31m ${str}\033[0m" '文件验证成功' } || { echo -e "\033[31m ${str}\033[0m" '数据获取失败,请手动获取文件数据' && exit 1 }
	if [ -f "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg" -a $(ls -s --block-size=k "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg" | cut -d'K' -f1) -gt 10 ];then
		echo -e "\033[32m 文件验证成功\033[0m"
	else
		echo -e "\033[31m 数据获取失败,请手动获取文件数据\033[0m"
		echo "手动执行"
		echo -e "wget --no-check-certificate -O \"/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg\" \"${IMAGE_URL}\""
		echo -e "find \"/data/hdd/JAV/$FULL_TITLE\" -exec touch -m -d "${JAV_DATE}" '{}' \;"
		exit 9
	fi
	
	#更改文件mtime为发行日期
	echo '更改发行日期...'
	echo $FULL_TITLE | grep $ID \
	&& find "/data/hdd/JAV/$FULL_TITLE" -exec touch -m -d "${JAV_DATE}" '{}' \; \
	|| echo -e "\033[31m日期错误\033[0m"

	# chattr增加文件权限
	# echo '增加文件权限...'
	# sudo chattr +a /data/hdd/JAV/${FULL_TITLE}/ \
	# && sudo chattr +i "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg" \
	# && echo '完成'


	echo -e '\n\n\n\n'

	# Also copy jpg file to SSD
	cp -p "/data/hdd/JAV/${FULL_TITLE}/${FULL_TITLE}.jpg" /data/ssd/JAV_thumbnail/all_jpg/
}


if [ $1 == 'local' ];then
	OLDIFS="$IFS"
	IFS=$'\n'
	# 使用本地html链接到jav_web_source.html
	for i in `ls -t /data/ssd/Downloads/tmp/*.htm*`
	do
		ln -f -s "${i}" /tmp/jav_web_source.html
		# 调用touch_jav
		touch_jav
	done
	IFS="$OLDIFS"
	# 清空本地临时文件
	rm -f /data/ssd/Downloads/tmp/*
else
	# 通过URL下载jav_web_source.html
	#ssh tiera@www.tierama.com "curl -kL ${URL} > /tmp/jav_web_source.html" \
	#	&& scp tiera@www.tierama.com:/tmp/jav_web_source.html /tmp/jav_web_source.html \
	#	|| (echo -e "\033[31m数据拉取失败,退出当前任务!\033[0m" && exit)
	# 调用touch_jav
	# curl -kL ${URL} > /tmp/jav_web_source.html
	touch_jav
fi
