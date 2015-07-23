---
layout: post
title: "使用Vagrant搭建本地Ubuntu开发环境"
date: 2015-07-22 14:13:27 +0800
comments: true
categories: [vagrant,ubuntu]
---

# 前言

使用PHP做Web开发已有4年，4年间只有第二年是在Ubuntu下开发，其它都是在Windows下开发，但Win下开发有如下缺点：

1. Windows 不区分大小写，在Win下OK, 上传到服务器上有了Bug。
2. Windows 不能测试cron是否写得正确，执行php-cli麻烦
2. 开发环境与生产环境不同，莫名的产生了一些Bug
3. 自己的Linux水平下降，对服务器的一些配置慢慢感到了生疏。

但在Ubuntu下开发，也有问题：

1. 不习惯的编辑器，那时使用IDEA作为编辑器，真心不好用。
2. 当初用Word写文档，Ubuntu里没有。（现在用Markdown了）
3. 团队开发使用QQ作为通讯工具，还要装一个QQ。（QQ真不适合作为沟通工具，其它无关内容总分心）

![](http://7xkc1x.com1.z0.glb.clouddn.com/cto_vagrant.png)
# Vagrant优点
[Vagrant](http://docs.vagrantup.com/)是用来管理虚拟机的，它有如下好处：

1. 对于开发人员来说，Vagrant可以帮你统一团队成员的开发环境。
2. 对于运维人员来说，Vagrant可以给你提供一个与线上一致的测试环境。
3. 对于设计人员来说，Vagrant可以让你只需要专注在设计上。

Vagrant适合用来管理虚拟机，而Docker适合用来管理应用环境。

### 需要安装的软件：

- Vagrant
- Virtual Box
- putty
- box [虚拟机镜像查看](https://atlas.hashicorp.com/boxes/search)

添加box ubuntu/trusty64

	vagrant version
	#查看版本

	vagrant add box ubuntu/trusty64
	# download the box named "ubuntu/trusty64" from Internet
	#下载ubuntu14.04 lts(long term supporting)
添加的boxes会被多个项目重复利用。每个项目都会克隆它，而不会修改它。两个项目之间不会相互影响

	vagrant box list
	#查看box列表
	
	vagrant init ubuntu/trusty64; 
	vagrant init

	vagrant up --provider virtualbox
	vagrant up
	
	vagrant ssh

bootstrap.sh 文件

	#!/usr/bin/env bash
	
	apt-get update
	apt-get install -y apache2
	if ! [ -L /var/www ]; then
	  rm -rf /var/www
	  ln -fs /vagrant /var/www
	fi

Vagrantfile文件 配置文件

	Vagrant.configure("2") do |config|
	   config.vm.box = "hashicorp/precise32"
	   config.vm.provision :shell, path: "bootstrap.sh"
	   config.vm.network :forwarded_port, guest: 80, host: 4567
	   config.vm.network :private_network, ip: "192.168.33.10"
	   #重启虚拟机，这样我们就能用 192.168.33.10 访问这台机器了，你可以把 IP 改成其他地址，只要不产生冲突就行。
	end
vagrant load --provision

vagrant login
输入用户名和密码

vagrant share

将产生一个网址，互联网上的其他人能够访问

### 停止工作
	vagrant suspend
	vagrant halt
	vagrant destroy

	


### 打包分发
	vagrant package
	vagrant package --output NAME 导出box (NAME.box)

打包完成后会在当前目录生成一个 package.box 的文件，将这个文件传给其他用户，其他用户只要添加这个 box 并用其初始化自己的开发目录就能得到一个一模一样的开发环境了。

### 注意事项
使用 Apache/Nginx 时会出现诸如图片修改后但页面刷新仍然是旧文件的情况，是由于静态文件缓存造成的。需要对虚拟机里的 Apache/Nginx 配置文件进行修改：

	# Apache 配置添加:
	EnableSendfile off
	
	# Nginx 配置添加:
	sendfile off;

### 补充

Putty工具连接：

注：虚拟机的默认IP|Port：127.0.0.1:2222   用户：vagrant | root   密码：vagrant

### 参考链接

[CI&T: 使用VAGRANT构建DRUPAL本地开发环境 - WINDOWS](http://www.ciandt.com.cn/blog/how-to-use-vagrant-build-drupal-development-environment-windows)

[使用 Vagrant 打造跨平台开发环境](http://segmentfault.com/a/1190000000264347)


