---
layout: post
title: "Docker小结"
date: 2015-07-21 21:07:41 +0800
comments: true
categories: docker
---

# 前言

这2天里，我了解Docker的初步使用, 并对本博客在[Daocloud](www.daocloud.io)上的自动同步做了设置，<http://hanfeng.daoapp.io>, Daocloud正在搞活动，[写Dockerfile](https://github.com/FengHan/fenghan.github.io/blob/master/Dockerfile)，生成镜像，部署Github代码，[免费送T-shirt！](http://blog.daocloud.io/build-dockerfile-campaign/)。 本文主要记录两天所学，记录Docker的学习过程。

![](http://7xkc1x.com1.z0.glb.clouddn.com/cto_Tshirt.jpg)
# 构建镜像

构建镜像的目的：

- 保存对容器的修改， 并在此使用
- 自定义镜像的能力
- 以软件的形式打包并分发服务器及其运行环境。

构建镜像的两种方法：

1. docker build 通过Dockfile文件构建

2. docker commit 通过容器构建

### Dockerfile的制作
对于开发人员来说，主要是使用Dockerfile来构建镜像，现在简单讲一下Dockerfile的语法

	FROM <image> 已经存在的镜像（基础镜像）
	FROM <image:tag>

必须是第一条

	
	MAINTAIER hanfeng "contact@hanfeng.name"

指定镜像所有者信息

	RUN
指定当前镜像中运行得命令

	RUN echo hello  (shell模式)

	RUN ["executable", "param1", "param2"] (exec模式)

	RUN["/bin/bash", "-c", "echo hello"]
每个RUN指令都会在当前的RUN指令上新创建一个镜像，是分层的。
	
	EXPOSE <port>[<port>]
	EXPOSE 80
	EXPOSE 80:80
	EXPOSE 0.0.0.0:80:80
指定运行该镜像的容器使用的端口
	
只是告诉容器应该打开哪个端口，Dokcer不会自动打开。还是需要启动的时候指定端口
	
	CMD
	CMD["executable",'param1','['param2'](exec模式)
能够被Docker run 后面的命令覆盖掉

	ENTRYPOINT
	ENTRYPOINT COMMAND P1 P1
不会被docker run覆盖

容器运行时的指令

	ADD
适用于文件路径中有空格的情况

ADD 包含类似tar的解压功能

如果单独复制文件，建议使用COpy

	COPY

	VOLUME
	VOLUME["/data"]
镜像的目录和文件

	WORKDIR
	WORKDIR /path/to/workdir
	WORKDIR 使用绝对路径

	ENV<key><value>

	USER daemon
	USER nginx
	USER root:root

环境设置
	
	ONBUILD
镜像触发器

当一个镜像被其他镜像作为基础镜像时执行。

会在构建过程中插入指令

简单的例子：

	# First dockerfile for test
	FROM ubuntu:14.04
	MAINTAINER hanfeng "contact.hanfeng.name"
	RUN apt-get update
	RUN apt-get install -y nginx
	EXPOSE 80
Dockerfile的构建过程

	docker build -t ="hanfeng/nginx"
	
	docker run  --name=web01 -p 80 -d hanfeng/nginx -g "daemon off;"

执行Dockerfile的每一条指令，执行相当于执行了docker commit一次，每条命令都会产生一个新的镜像层
执行Dockerfile的下一条命令


	docker history image
	#查看构建镜像的历史命令
### 镜像的发布

	docker push qthhanfeng/nginx	


# 常用命令

	docker run  --name=web01 -it ubuntu /bin/bash
为容器制定一个名字

	docker start [-i] 容器名
重新启动停止的容器：

参数 -i 以参数的方式

在交互式时，Ctrl + P ，然后 Ctrl + Q

docker attach + 容器ID

-----
查看容器日志
	
	docker logs -f -t --tail 容器名

-f 更新

-t 时间戳

--tail  显示最新的

------


	docker top 容器
	#查看容器内进程
	docker exec -d -i -t 容器名字
	#在运行中的容器启动新进程
	docker stop
	#发送信号给容器，等待停止

	docker kill 容器
	#直接停止容器

设置容器的端口映射

	docker run -P -it ubuntu /bin/bash

-P --publish-all=true|false默认为fale，所有端口映射

-p --publish=[]

	docker run -p 80 -it ubuntu /bin/bash
	#容器端口
	docker run -p 8080:80 -it ubuntu /bin/bash
	#宿主机端口：容器端口
	docker run -p 0.0.0.0:80 -it ubuntu /bin/bash
	#IP:容器端口
	docker run -p 0.0.0.0:8080:80 -it ubuntu /bin/bash
	#IP:宿主机端口：容器端口

	docker run -p 80 --name web -it ubuntu /bina/bash
	
	docker port web
	docker top web

重启后，容器没有启动nginx, IP地址和端口映射都会发生改变

	docker exec web nginx
	docker top web

#DaoCloud提供的加速

	vim /etc/default/docker
	DOCKER_OPTS="$DOCKER_OPTS --registry-mirror=http://字符串.m.daocloud.io"
	#文件末尾添加

常用命令：

	docker inspect +仓库名:TAG名
	#查看镜像
	
	docker rmi +仓库名:TAG名
	#删除TAG

	docker rmi + 镜像ID
	#删除这个镜像对应的所有TAG
	
	docker rmi $(docker images ubuntu -q)


#Docker Hub

<https://registry.hub.docker.com>




	


