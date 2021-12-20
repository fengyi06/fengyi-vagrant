#!/bin/bash

echo -e "\e[1;31m【==============================禁用防火墙】\e[0m"
sudo ufw disable
# systemctl stop firewalld
# systemctl disable firewalld
# systemctl status firewalld
# echo -e "\e[1;31m【==============================禁用selinux】\e[0m"
# sleep 5
# sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config

echo -e "\e[1;31m【==============================apt换源并更新升级】\e[0m"
if [ -f "/etc/apt/sources.list.bak" ]; then
  echo -e "\e[1;31m【------------------------------发现sources.list备份文件，依据备份文件重置原文件】\e[0m"
  sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list
  else
  echo -e "\e[1;31m【------------------------------备份sources.list文件】\e[0m"
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi
echo "deb https://mirrors.ustc.edu.cn/ubuntu/ impish main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ impish main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ impish-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ impish-security main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ impish-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ impish-updates main restricted universe multiverse

deb https://mirrors.ustc.edu.cn/ubuntu/ impish-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ impish-backports main restricted universe multiverse

## Not recommended
# deb https://mirrors.ustc.edu.cn/ubuntu/ impish-proposed main restricted universe multiverse
# deb-src https://mirrors.ustc.edu.cn/ubuntu/ impish-proposed main restricted universe multiverse" > /etc/apt/sources.list

sudo apt update && sudo apt upgrade -y
echo -e "\e[1;31m【==============================安装常用工具】\e[0m"
apt install wget vim git gcc psmisc lrzsz zip unzip telnet perl net-tools -y

# echo -e "\e[1;31m【==============================同步系统时间】\e[0m"
# yum info ntp && ntpdate cn.ntp.org.cn

# echo -e "\e[1;31m【==============================安装jdk】\e[0m"
# sleep 5
# rpm -ivh jdk-8u231-1inux-x64.rpm
# echo 'export JAVA_HOME=/usr/java/jdk1.8.0_231-amd64' >> /etc/profile
# echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile
# source /etc/profile
#echo -e "\e[1;31m【==============================安装tomcat】\e[0m"
#sleep 5
#tar -zxf apache-tomcat-8.5.47.tar.gz
#mv apache-tomcat-8.5.47 /opt/app
# echo -e "\e[1;31m【==============================执行完毕】\e[0m"

echo -e "\e[1;31m【==============================配置阿里和谷歌的dns服务器】\e[0m"
if [ -f "/etc/systemd/resolved.conf.bak" ]; then
echo -e "\e[1;31m【------------------------------发现resolved.conf备份文件，依据备份文件重置原文件】\e[0m"
  sudo cp /etc/systemd/resolved.conf.bak /etc/systemd/resolved.conf
fi
sed -i.bak '/DNS=.*/{x;s/^/./;/^\.\{2\}$/{x;s/.*/DNS=223.5.5.5 8.8.8.8/;x};x;}' /etc/systemd/resolved.conf
echo -e "\e[1;31m【------------------------------重启本地DNS服务,resolvectl命令可查看DNS信息】\e[0m"
systemctl restart systemd-resolved
echo -e "\e[1;31m【------------------------------给resolv.conf建立软连接】\e[0m"
ln -snf /run/systemd/resolve/resolv.conf /etc/resolv.conf

echo -e "\e[1;31m【==============================安装docker】\e[0m"
#install some tools
# sudo yum install -y git vim gcc glibc-static telnet psmisc
#install docker
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
if [ ! $(getent group docker) ]; then
    sudo groupadd docker
else
    echo "docker user group already exists"
fi

sudo gpasswd -a $USER docker
sudo systemctl start docker
rm -rf get-docker.sh

echo -e "\e[1;31m【==============================配置docker镜像加速器】\e[0m"
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://akrhqkgo.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

echo -e "\e[1;31m【==============================禁用虚拟内存】\e[0m"
sudo swapoff -a

echo -e "\e[1;31m【==============================开启bridge-nf-call-iptables】\e[0m"
#表示 bridge 设备在二层转发时也去调用 iptables 配置的三层规则 (包含 conntrack)
sysctl net.bridge.bridge-nf-call-iptables=1

echo -e "\e[1;31m【==============================安装k8s集群工具】\e[0m"
# Debian/Ubuntu
apt-get update && apt-get install -y apt-transport-https
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

# echo -e "\e[1;31m【------------------------------k8s集群工具禁止更新】\e[0m"
# apt-mark hold kubelet kubeadm kubectl

#kubeadm：部署kubernetes集群的工具，kubectl：Kubernetes集群的命令行工具，Kubelet：master派到node节点代表，管理本机容器
# CentOS/RHEL/Fedora
# cat <<EOF > /etc/yum.repos.d/kubernetes.repo
# [kubernetes]
# name=Kubernetes
# baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
# enabled=1
# gpgcheck=1
# repo_gpgcheck=1
# gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
# EOF
# setenforce 0
# yum install -y kubelet kubeadm kubectl
echo -e "\e[1;31m【==============================安装k8s集群所需镜像】\e[0m"
 cp ./azk8spull /usr/local/bin/azk8spull
 chmod +x /usr/local/bin/azk8spull

images=$(kubeadm config images list)
for imageName in ${images[@]} ; do
azk8spull $imageName
done






