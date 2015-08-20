---
layout: post
title: "使用Composer搭建自己的PHP框架"
date: 2015-08-15 08:45:27 +0800
comments: true
categories: 
---

# 前言

今天参照[教程](http://lvwenhan.com/php/410.html)，使用Composer来搭建自己的框架。

我给它起了一个名字叫做Hilda PHP Framework.

通过构建这样的微型框架，有利于我们学习框架的自动加载、单入口文件、MVC的原理，因为需要什么，就加载什么。这样，自己的框架就像搭积木一样完成了，避免了重复发明轮子的烦恼。


## Hilda特性：

- 单入口文件
- MVC架构
- 微型路由，基于[codingbean/macaw](https://packagist.org/packages/codingbean/macaw)
- 数据库的ORM 采用 [Eloquent](http://laravel-china.org/docs/5.0/eloquent)


# 安装方法
它的Github地址为：<https://github.com/FengHan/hilda>



