---
layout: post
title: "在ubuntu上安装mariadb"
date: 2015-07-23 10:50:50 +0800
comments: true
categories: mariadb 
---

# 前言
MySQL被SUN收购后，又被Oracle收购。它的作者从新开发了一个完全兼容MySQL的数据库，并且以他的女儿命名，叫做[MariDB](https://mariadb.org/)

# 安装

首先从 [MariaDB 下载页面](http://downloads.mariadb.org/mariadb/repositories/) 选择贴近你的 Ubuntu 版本的资料库镜像，然后下载页面会在底部显示镜像信息（如下所示），然后执行这些命令

	sudo apt-get install software-properties-common
	sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
	sudo add-apt-repository 'deb http://mirrors.hustunique.com/mariadb/repo/5.5/ubuntu trusty main'
开始安装

	sudo apt-get update
	sudo apt-get install mariadb-server

这样 MariaDB 5.5 就已经安装成功，你就可以像使用 MySQL 那样对它进行配置和使用了。

使用mysql -h -uroot -p1234测试。