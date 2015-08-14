---
layout: post
title: "Ubuntu 14.04远程登录服务器--ssh的安装和配置"
date: 2015-07-27 15:22:47 +0800
comments: true
categories: ssh
---
	sudo apt-get update
	sudo apt-get install openssh-server
	sudo ps -e |grep ssh
	
	#没有启动，输入
	service ssh start


vi /etc/ssh/sshd_config

把配置文件中的"PermitRootLogin without-password"加一个"#"号,把它注释掉-->再增加一句"PermitRootLogin yes"-->保存，修改成功。