#!/bin/bash
echo -e "\e[1;31m【==============================修改root密码】\e[0m"
sudo passwd root <<EOF
123456
123456
EOF
echo -e "\e[1;31m【==============================ssh开启密码连接】\e[0m"
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'  /etc/ssh/sshd_config
sudo service sshd restart

#从known_hosts文件中删除所有属于hostname的密钥。
#ssh-keygen -R hostname
