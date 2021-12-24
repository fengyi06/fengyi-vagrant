#!/bin/bash

mavenTargz="./apache-maven-3.8.4-bin.tar.gz"

# 检查原先是否已配置java环境变量
checkExist(){
	maven1=$(grep -n "export MAVEN_HOME=.*" /etc/profile | cut -f1 -d':')
        if [ -n "$maven1" ];then
                echo "MAVEN_HOME已配置，删除内容"
                sed -i "${maven1}d" /etc/profile
        fi
	maven2=$(grep -n "export CLASSPATH=.*\$MAVEN_HOME.*" /etc/profile | cut -f1 -d':')
        if [ -n "$maven2" ];then
                echo "CLASSPATH路径已配置，删除内容"
                sed -i "${maven2}d" /etc/profile
        fi
	maven3=$(grep -n "export PATH=.*\$MAVEN_HOME.*" /etc/profile | cut -f1 -d':')
        if [ -n "$maven3" ];then
                echo "PATH-MAVEN路径已配置，删除内容"
                sed -i "${maven3}d" /etc/profile
        fi
}

# 查询是否有maven.tar.gz
if [ ! -e $mavenTargz ];
then
 echo "— — maven压缩包不存在，正在下载 — —"
 #jdk下载必须登录oracle官网，最好自己留一份儿,或者考虑openjdk
 wget https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
 echo "— — maven压缩包下载完毕 — —"
fi

  	echo "正在解压maven压缩包..."
	tar -zxvf $mavenTargz -C ./
	if [ -e "/opt/install/maven3" ];then
		echo "存在该文件夹，删除..."
		rm -rf /opt/install/maven3
	fi
	echo "---------------------------------"
	echo "正在建立maven文件路径..."
	echo "---------------------------------"
	mkdir -p /opt/install
	mv ./apache-maven-3.8.4 /opt/install/maven3
	# 检查配置信息
	checkExist	
	echo "---------------------------------"
	echo "正在配置maven环境..."
	sed -i '$a export MAVEN_HOME=/opt/install/maven3' /etc/profile
	sed -i '$a export CLASSPATH=$CLASSPATH:$MAVEN_HOME/lib' /etc/profile
	sed -i '$a export PATH=$PATH:$MAVEN_HOME/bin' /etc/profile
	echo "---------------------------------"
	echo "maven环境配置已完成..."
	echo "---------------------------------"
    echo "正在重新加载配置文件..."
    echo "---------------------------------"
    source /etc/profile

	echo "备份maven的settings文件..."
    sudo cp /opt/install/maven3/conf/settings.xml /opt/install/maven3/conf/settings.xml.bak
	echo "---------------------------------"
    echo "修改maven镜像为阿里云..."
	echo "---------------------------------"
	echo "<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" 
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <pluginGroups>
  </pluginGroups>
  <proxies>
  </proxies>
  <servers>
  </servers>
  <mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
  <profiles>
  </profiles>
</settings>
" > /opt/install/maven3/conf/settings.xml

    echo "配置版本信息如下："
    mvn -v

