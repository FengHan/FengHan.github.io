---
layout: post
title: "Redis的安装与配置"
date: 2015-07-24 10:36:56 +0800
comments: true
categories: redis
---

# Redis 的历史与特性

Redis 是Remote Dictionary Server的缩写，Redis是一个**开源、基于C语言、基于内存可持久化**的高性能NoSQL的**键值对**数据库。在众多场合中均可使用Redis代替传统的数据库或缓存系统。

与Memcache类似的NoSQL型数据库，但它的数据可以持久化的保存在磁盘上，解决了服务重启后数据不丢失的问题。

![](http://7xkc1x.com1.z0.glb.clouddn.com/show_redis.jpg)

2015年Redis3.0.1 发布
	Redis 3.0 最重要的特征是对Redis集群的支持
Redis约定**次版本号**为偶数的版本是稳定版

主要特性：

- 存储结构丰富
- 内存存储与持久化： 1s内读写10万个键值，异步写入硬盘；
- 功能丰富：可用于数据库，缓存系统，队列
- 简单稳定

# 安装
安装最新版本的3.0， <http://redis.io/download>

	apt-get install make gcc
	wget http://download.redis.io/releases/redis-3.0.3.tar.gz
	tar xzf redis-3.0.3.tar.gz
	cd redis-3.0.3/src
	make install

### Redis可执行文件
redis-cli  #客户端
redis-server #服务器

	ls /usr/local/bin/redis*

	cd ..
	mkdir /etc/redis
	cp redis.conf /etc/redis/6379.conf

	cd utils/
	cp redis_init_script /etc/init.d/redisd

	sudo update-rc.d redisd defaults
	service redisd start

### 启动方法
1. redis-server&
	- ps -ef |grep redis 检测后台进程是否存在
	- netstat -tunpl |grep 6379  检测6379端口是否在监听
	- redis-cli检测， shutdown退出
2. 指定配置文件启动

	redis-server /usr/local/redis/etc/redis.conf

	修改配置文件 daemonize yes

3. 使用Redis启动脚本设置开机启动

启动脚本位于redis_init_script位于安装目录的/utils目录下，

	-	新建目录/etc/redis
	-	复制redis.conf到/etc/redis/重命名为6379.conf
	-	修改6379.conf配置
	-	复制redis_init_script脚本文件复制到/etc/init.d目录中，并重命名redisd
	-	执行随系统自动启动命令 
		-	sudo update-rc.d redisd defaults
		-	service redisd start

### 停止方法
1. 退出客户端用CTRL + C
2. 在客户端下，执行SHUTDOWN，停止服务
3. kill -9 PID

### redis 的配置

redis.conf #redis server的配置文件

sentinel.conf #redis sentine配置文件，用于监控


- 基本项配置
- **持久化（Persistence）**相关配置
- **Replication配置**
- Security配置
- Limit配置
- SlowLog配置
- Advanced配置
- INCLUEDS配置
##### 基本配置
- daemonize 如果需要在后台运行，把该项改为yes
- pidfile 配置多个pid地址， 默认在/var/run/redis.pid
- bind  绑定ip， 设置后只接受来自该ip的请求
- port 监听端口，默认6379
- timeout 设置客户端连接的超时时间，单位为秒
- loglevel分为4级， debug， verbose, notice, warning
- logfile 配置log文件地址

总结: 上述配置基本项中，port为必配项，其余项一般情况下保持默认即可。

#####  持久化配置项目
- databases 设置数据库的个数， 默认使用的数据库为0
- save 设置redis进行数据库镜像的频率
- rdbcompression 在进行镜像备份时，是否进行压缩
- Dbfilename 镜像备份文件的文件名
- Dir 数据库镜像备份的文件放置路径
##### Limit配置项目
maxclients 客户端的并发连接数，默认10000
maxmemory配置Redis Server可占用的最大内存
##### Security配置项
Requirepass 设置登录时需要使用的密码




