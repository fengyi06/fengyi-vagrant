#!/bin/bash

echo -e "\e[1;31m【==============================k8s初始化master】\e[0m"
kubeadm init --pod-network-cidr=10.244.0.0/16
echo -e "\e[1;31m【------------------------------保存授权相关的配置信息在用户目录下（admin.conf）】\e[0m"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo -e "\e[1;31m【==============================添加网络插件】\e[0m"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml