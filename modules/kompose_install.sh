#!/bin/bash

kompose="./kompose"

# 查询是否有kompose
if [ ! -e $kompose ];
then
 echo "— — kompose不存在，正在下载 — —"
 curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.0/kompose-linux-amd64 -o kompose
 echo "— — kompose下载完毕 — —"
fi
	echo "---------------------------------"
	echo "复制到/usr/local/bin目录下..."
	echo "---------------------------------"
	sudo cp ./kompose /usr/local/bin/kompose
	echo "给kompose执行权限..."
    chmod +x /usr/local/bin/kompose

