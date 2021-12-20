host_list = [
  {
    :name => "ubuntu",
    :box => "generic/ubuntu2110",
    :box_version => "3.6.0",
    :disk_size => "20GB",
    :private_ip => "192.168.56.20",
    :ssh_host_prot => "9020"
  },
  {
    :name => "ubuntu-node",
    :box => "generic/ubuntu2110",
    :box_version => "3.6.0",
    :disk_size => "80GB",
    :private_ip => "192.168.56.21",
    :ssh_host_prot => "9021"
  }

]

Vagrant.configure("2") do |config|
   config.vm.provider "virtualbox" do |vb| 
     # Display the VirtualBox GUI when booting the machine 当启动机器的时候显示VirtualBox的图形化界面
     vb.gui = false
     # Customize the amount of memory on the VM:定制虚拟机的内存
     vb.memory = "4096"
     #设置CPU个数
     vb.cpus = 4
     #修改显存30M
     vb.customize ["modifyvm", :id, "--vram", "32"]

   end

    #共享文件夹，把当前路径共享给虚拟机的/vagrant目录，开启nfs,
     #mac系统已经继承nfs只需要修改/etc/eprots文件，如果没有则新建
     #虚拟机安装nfs服务，yum -y install nfs-utils rpcbind
     config.vm.synced_folder ".", "/vagrant",create: true
     #执行shell脚本
     config.vm.provision "shell", path: "./scripts/ssh_init.sh"
    
  host_list.each do |item|
    config.vm.define item[:name] do |host|
     #设置box
     host.vm.box = item[:box]
     #设置box版本
     host.vm.box_version = item[:box_version]
     #设置主机名称
     host.vm.hostname = item[:name]
     #调整主磁盘大小
     host.vm.disk :disk, size: item[:disk_size], primary: true
     #创建个私有网络，单机器可互相访问
     host.vm.network "private_network", ip: item[:private_ip]
     #创建一个bridge桥接网络
     #mac系统地址不通，先注释掉
     #host.vm.network "public_network", bridge: "en0: Wi-Fi (Wireless)"
     host.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: "true"
     host.vm.network "forwarded_port", guest: 22, host: item[:ssh_host_prot], id: "new-ssh"
    end
  end

end