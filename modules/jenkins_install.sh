#!/bin/bash

jenkinsWar="./jenkins.war"
tomcatHome="/opt/install/tomcat/tomcat9"
tomcatWebapps=$tomcatHome/webapps

echo "— — 检测是否安装jdk — —"
java=$(which java)
if [ -z $java ];
then
 echo "— — 未安装jdk — —"
 source ./jdk_install.sh
fi

echo "— — 检测是否安装tomcat — —"
if [ ! -e $tomcatHome/bin/startup.sh ];
then
 echo "— — 在/opt/install/tomcat/tomcat9/bin下未找到tomcat启动脚本，视为未安装，执行安装脚本:tomcat_install.sh — —"
 source ./tomcat_install.sh
fi

# 查询是否有jenkinsWar
if [ ! -e $jenkinsWar ];
then
 echo "— — jenkinsWar不存在，正在下载 — —"
 wget http://mirrors.jenkins.io/war-stable/2.319.1/jenkins.war
 echo "— — jenkinsWar下载完毕 — —"
fi

echo "移除旧的jenkins项目......"
rm -rf $tomcatWebapps/jenkins
rm -rf $tomcatWebapps/jenkins.war

echo "复制war包到部署目录......"
cp $jenkinsWar $tomcatWebapps

echo "停止tomcat服务中......"
tomcat_pid=`ps -ef | grep tomcat | grep -v grep | awk '{print $2}'`
if [ -z $tomcat_pid ]; then
        echo "tomcat服务未启动"
else
        kill -9 $tomcat_pid
        sleep 5
        echo "停止tomcat服务成功"
fi

echo "tomcat启动中......"
sudo $tomcatHome/bin/startup.sh
TomcatServiceCode=0
while [ "$TomcatServiceCode" != "200" ]; do
sleep 3
TomcatServiceCode=$(curl -I -m 10 -o /dev/null -s -w %{http_code} http://localhost:80)
done
echo "tomcat启动成功......"


