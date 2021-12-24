#!/bin/bash

tomcatTargz="./apache-tomcat-9.0.56.tar.gz"

# 查询是否有tomcat.tar.gz
if [ ! -e $tomcatTargz ];
then
 echo "— — tomcat压缩包不存在，正在下载 — —"
 wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.56/bin/apache-tomcat-9.0.56.tar.gz
 echo "— — tomcat压缩包下载完毕 — —"
fi
  	echo "正在解压tomcat压缩包..."
	tar -zxvf $tomcatTargz -C ./
	if [ -e "/opt/install/tomcat" ];then
		echo "存在该文件夹，删除..."
		rm -rf /opt/install/tomcat
	fi
	echo "---------------------------------"
	echo "正在建立tomcat文件路径..."
	echo "---------------------------------"
	mkdir -p /opt/install/tomcat/
	mv ./apache-tomcat-9.0.56 /opt/install/tomcat/tomcat9
	# change port 8080 to 80
	echo "变更tomcat默认端口号为80..."
	sed -i 's/8080/80/' /opt/install/tomcat/tomcat9/conf/server.xml


