---
layout: post
title: "使用Homestead搭建本地Laravel开发环境"
date: 2015-08-09 15:06:33 +0800
comments: true
categories: laravel
---
### 环境说明

- 64bit Win7系统
- Git Bash
- Vagrant
- Virtual Box

### 约定

我们要创建一个项目blog，放在/d/sites/blog/目录下面
### 安装

创建项目目录

	cd /d/sites
	mkdir blog

下载laravel的box和homestead

	vagrant box add laravel/homestead
	git clone https://github.com/laravel/homestead.git Homestead

生成Homestead.yaml 到~/.homestead目录下
	
	cd /d/sites/blog/Homestead/
	init.sh

生成秘钥

	ssh-keygen -t rsa -C "you@homestead"

配置文件 ~/.homestead/Homestead.yaml

	---
	ip: "192.168.10.10"
	memory: 2048
	cpus: 1
	provider: virtualbox
	
	authorize: ~/.ssh/id_rsa.pub

	keys:
	    - ~/.ssh/id_rsa
	
	folders:
	    - map: d:\sites\blog
	      to: /home/vagrant/blog
	
	sites:
	    - map: blog.app
	      to: /home/vagrant/blog/public
	
	databases:
	    - homestead
	
	variables:
	    - key: APP_ENV
	      value: local
	
	# blackfire:
	#     - id: foo
	#       token: bar
	#       client-id: foo
	#       client-token: bar
	
	# ports:
	#     - send: 93000
	#       to: 9300
	#     - send: 7777
	#       to: 777
	#       protocol: udp

### Win下添加快捷键

	cd ~
	vi .bashrc
	alias vm="ssh vagrant@127.0.0.1 -p 2222"
	
	source .bashrc

### 启动虚拟机
	
	cd /d/sites/blog/Homestead/
	vagrant up

### 修改hosts文件

### 虚拟机的mysql
	host: 127.0.0.1
	port: 33060
	user: homestead
	pass: secret

### 虚拟机里的端口转发

	SSH: 2222 -> Forwards To 22
	HTTP: 8000 -> Forwards To 80
	MySQL: 33060 -> Forwards To 3306
	Postgres: 54320 -> Forwards To 5432
### 配置

	php artisan key:generate
将生成的key复制到config/app.php替换82行的APP_KEY键值。

### 参考链接
 [golaravel](http://www.golaravel.com/laravel/docs/5.1/homestead/)

[phphub.org](https://phphub.org/topics/2)