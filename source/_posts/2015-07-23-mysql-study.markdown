---
layout: post
title: "MySQL数据库管理"
date: 2015-07-23 17:26:01 +0800
comments: true
categories: mysql
---

### MySQL权限

	mysql> grant all privileges on laravel5.* to laravel@localhost identified by 'secret' with grant option;
	flush privileges;

- 用户名：laravel
- 密码： secret
- 授权：数据库laravel5的所有表的所有权限

创建用户

	grant all privileges on *.* to dev@localhost identified by 'dev' with grant option;
	grant select on jikedb.* to webuser@localhost identified by '123';

刷新权限

	flush privileges;

回收权限

	revoke select on jikedb.* from webuser@localhost;
删除用户

	drop user webuser@localhost;
查看用户权限

	show grants for root@localhost;


### 参考链接
[分配权限](http://blog.csdn.net/wengyupeng/article/details/3290415)


