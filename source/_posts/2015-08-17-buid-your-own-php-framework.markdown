---
layout: post
title: "搭建自己的PHP开发框架"
date: 2015-08-17 17:24:04 +0800
comments: true
categories: 
---

# 前言
想要搭建一个自己的PHP框架，需要哪些功能呢？

- 单一入口
- 类的自动加载
- MVC
- 易于配置
- 有电子商务相关的接口：购物车，订单，支付

# 如何实现

### 单一入口
nginx配置

	location / {
		try_files $uri $uri/ /index.php?/$uri;
	}
1. 将uri全部定向到index.php
2. 在入口文件，实现路由分发，实化例Ccontroller类，然后调用方法。

### 类的自动加载

1. 维护命名空间与绝对路径的映射
2. 使用spl_autoload_register注册函数，当调用不存在的类时，自动加载。

### MVC

1. 每个Controller继承一个Controoler，在这个类中实现存储数据和include模板文件
2. 用工厂模式和注册树模式来实例化对应的Model类

### 易于配置

1. 定义Config类实现\ArrayAccess， 然后加载config目录下的所有文件。也是用注册树和工厂模式。