#!/bin/bash

jdkTargz="./jdk-8u311-linux-x64.tar.gz"

# 检查原先是否已配置java环境变量
checkExist(){
	jdk1=$(grep -n "export JAVA_HOME=.*" /etc/profile | cut -f1 -d':')
        if [ -n "$jdk1" ];then
                echo "JAVA_HOME已配置，删除内容"
                sed -i "${jdk1}d" /etc/profile
        fi
	jdk2=$(grep -n "export CLASSPATH=.*\$JAVA_HOME.*" /etc/profile | cut -f1 -d':')
        if [ -n "$jdk2" ];then
                echo "CLASSPATH路径已配置，删除内容"
                sed -i "${jdk2}d" /etc/profile
        fi
	jdk3=$(grep -n "export PATH=.*\$JAVA_HOME.*" /etc/profile | cut -f1 -d':')
        if [ -n "$jdk3" ];then
                echo "PATH-JAVA路径已配置，删除内容"
                sed -i "${jdk3}d" /etc/profile
        fi
}

# 查询是否有jdk.tar.gz
if [ ! -e $jdkTargz ];
then
 echo "— — jdk压缩包不存在，正在下载 — —"
 #jdk下载必须登录oracle官网，最好自己留一份儿,或者考虑openjdk
 wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn/java/jdk/8u311-b11/4d5417147a92418ea8b615e228bb6935/jdk-8u311-linux-x64.tar.gz?AuthParam=1640168665_d45fcd65a25ff624282a98680c33c9ba
 echo "— — jdk压缩包下载完毕 — —"
fi
  	echo "正在解压jdk压缩包..."
	tar -zxvf $jdkTargz -C ./
	if [ -e "/opt/install/java" ];then
		echo "存在该文件夹，删除..."
		rm -rf /opt/install/java
	fi
	echo "---------------------------------"
	echo "正在建立jdk文件路径..."
	echo "---------------------------------"
	mkdir -p /opt/install/java/
	mv ./jdk1.8.0_311 /opt/install/java/java8
	# 检查配置信息
	checkExist	
	echo "---------------------------------"
	echo "正在配置jdk环境..."
	sed -i '$a export JAVA_HOME=/opt/install/java/java8' /etc/profile
	sed -i '$a export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' /etc/profile
	sed -i '$a export PATH=$PATH:$JAVA_HOME/bin' /etc/profile
	echo "---------------------------------"
	echo "JAVA环境配置已完成..."
	echo "---------------------------------"
    echo "正在重新加载配置文件..."
    echo "---------------------------------"
    source /etc/profile
    echo "配置版本信息如下："
    java -version

