---
layout: post
title: "MySQL主从配置及读写分离"
date: 2015-08-23 21:53:41 +0800
comments: true
categories: mysql
---

# 前言

以前在公司的时候，公司配了MySQL主从，在线上用PHPMyAdmin查看从库信息，但只给了读权限，用于查看线上信息。今天记录一下MySQL主从的搭建过程。（我使用的是MariaDb5.5）

## Notice

在用户不多、并发不大、mysql服务器在同一个局域网内，MySQL主从是没有问题的。

主从数据库缺点：

1. 因为开启了bin log日志，所以会有性能开销。
2. 在实时性非常高的情况下，做了读写分离就不行。因为单线程同步需要花时间，时间上不允许。




# MySQL主从配置

1. mysql的版本相同， mysql主从同源，即具有相同的库、表及记录。
2. 数据迁移的时候，从库的版本高于主库。
3. 把主库从库都停掉。因为打包主库的时候会花很长时间，这时如果主库还有文件写入，很容易出错。

	cd /var/lib/
	tar zcvf mysql.tar.gz ./mysql

	scp mysql.tar.gz vagrant@192.168.33.10:/tmp
4. 配置/etc/mysql/my.cnf

	server-id               = 1
	log_bin                 = /var/log/mysql/mysql-bin.log
	expire_logs_days        = 10
	max_binlog_size         = 100M		每个bin log文件最大的大小

开启log_bin日志，性能就会降低。没修改一条数据，就会写入文件。硬盘不大的情况下，会写满数据库

要放到msyql有权限的目录里。


我们的目的是用从库修复主库。
靠从库的bin_log来恢复主机。


写bin_log性能降低，但因为我们做了主从，我们靠读多个从库来提高并发量。

让从库能够通过tcp 来连接主库，
5. 为从库专门准备一个用户。

	create user 'slave_1'@'%' IDENTIFIED BY 'abcd' ;
	grant replication slave  on *.* to 'slave_1'@'%';
	或者一条命令
	GRANT REPLICATION SLAVE ON *.* to 'mysync'@'%' identified by 'q123456'; 
6.
通过  SHOW MASTER STATUS; 显示当前主库的binlog文件与文件位置，我们需要将这个位置记录下来

	 SHOW MASTER STATUS;

连接到从库   开启主从同步

	CHANGE MASTER TO MASTER_HOST = '192.168.33.12' ,MASTER_USER='slave_2' ,MASTER_PASSWORD = '1234' ,MASTER_LOG_FILE ='mysql-bin.000002', MASTER_LOG_POS=973

 不想同步系统库可以选择忽略系统库 

	binlog_ignore_db        = mysql
SALVE命令

	START SLAVE
	STOP  SLAVE
	SHOW SLAVE STATUS\G

我在安装的时候遇到的错误：
[MySQL refuses to accept remote connections](http://serverfault.com/questions/586651/mysql-refuses-to-accept-remote-connections)

解决方法：

	sudo netstat -ntlup | grep mysql
	tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      127018/mysqld

修改/etc/mysql/my.cnf

	bind-address = 0.0.0.0
# 读写分离
主库创建新用户

	GRANT all privileges  ON tiny.* to 'michael'@'%' identified by '1234'; 
	flush privileges;
从库创建新用户，只给读的权限。

	GRANT SELECT  ON tiny.* to 'michael2'@'%' identified by '1234'; 

	flush privileges;


### 代码
代码我放到了我的GitHub上，我自己写了一个MVC的简易框架。这样，框架的任何一个部分我都了解，大大节约了我写代码示例的时间。然后学习优秀框架的思想，继续维护我的框架。

[代理模式](https://github.com/hildalove/tiny/blob/master/Tiny/Proxy/Proxy.php)

[获取数据库实例](https://github.com/hildalove/tiny/blob/master/Tiny/Service/Factory.php)

[控制器](https://github.com/hildalove/tiny/blob/master/App/Controller/Mysql.php)



