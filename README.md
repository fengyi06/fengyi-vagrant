# fengyi-vagrant


## 目标

该项目的目标是使研发以及运维人员能够便捷的使用Vagrant来搭建分布式项目本地测试环境。

1. 目前使用的是 Ubuntu 21.10版，未来考虑支持centOS7.
2. 该项目将为用户提供虚拟机初始化脚本，并提供各种流行的框架或者工具初始化的脚本，可灵活选择。
3. 目前项目可通过脚本快速的集成docker、k8s、jenkins、jdk、tomcat、maven等。
4. 未来计划支持Ansible、AWX。

## 依赖关系

* Vagrant `2.2.19`+
    * 使用 `vagrant -v` 检查版本
* 支持多种虚拟化软件，推荐使用Vitualbox

## 用法

**首先**, 编辑Vagrantfile，依据使用环境配置虚拟机，默认k8s搭配了1个master和一个node。

**其次**, 运行vagrant。主子节点分别执行关键脚本。
```bash
$ vagrant up
#退出相应虚拟机，k8s搭建需要root用户执行。
$ ssh root@ip 
# master
$ ./scripts/master_init.sh
# node
$ ./scripts/node_init.sh
#node虚拟机运行完脚本后，执行master最后的join命令就能加入节点了。
```
**最后**, 框架或者工具初始化的脚本自行选择安装即可。