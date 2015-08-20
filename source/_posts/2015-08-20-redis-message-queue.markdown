---
layout: post
title: "用Redis实现消息队列"
date: 2015-08-20 22:40:48 +0800
comments: true
categories: 
---

# 目标

1. 用户注册时，将注册信息（例如用户名、密码、邮箱等）Push到Redis的List里。
2. 用PHP-CLI脚本，读取队列的消息，存取到数据库。

代码如下：

- [PHPMQ CLASS](https://github.com/hildalove/tiny/blob/master/Tiny/MessageQueue/PHPMQ.php)
- [UserMQ CLASS](https://github.com/hildalove/tiny/blob/master/Tiny/MessageQueue/UserMQ.php)
- [user reg Controller](https://github.com/hildalove/tiny/blob/master/App/Controller/MQ.php)
- [PHP-CLI CRON](https://github.com/hildalove/tiny/blob/master/cron/user_mq.php)