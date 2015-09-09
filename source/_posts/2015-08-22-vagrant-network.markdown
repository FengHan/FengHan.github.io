---
layout: post
title: "Vagrant的网络设置"
date: 2015-08-22 14:34:46 +0800
comments: true
categories: vagrant
---
# 前言

今天要做Mysql主从配置，就需要两台Ubuntu的服务器，所以先要研究下Vagrant的网络配置。

Vagrant有三种网络配置

1. Forwarded port
2. Private network
3. Public network


# Private Network

我的需求是两台Ubutu在同一网段，并且都访问主机和外部网络。所以我选择private network。 它的缺点是外部网络无法访问。

设定语法为：

	config.vm.network "private_network", ip: "192.168.50.4"

配置hostname

	config.vm.hostname = "master"
 


# 参考链接

[Vagrant网络配置](http://www.williamsang.com/archives/2401.html?utm_source=tuicool#private)