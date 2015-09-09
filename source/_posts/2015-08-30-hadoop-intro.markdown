---
layout: post
title: "Hadoop介绍"
date: 2015-08-30 16:22:21 +0800
comments: true
categories: hadoop
---
慕课网[Hadoop大数据平台架构与实践--基础篇](http://www.imooc.com/learn/391) 的文字记录
# 初识Hadoop
## 课程简介
#### 介绍的内容：
1. 大数据技术的相关概念
2. Hadoop的架构和运行机制
3. 实战：Hadoop的安装和配置
4. 实战： Hadoop的开发

#### 学习目标：
1. 掌握大数据存储与处理技术的原理（理论知识）
2. 掌握Hadoop的使用和开发能力（实践能力） 

#### 课程学习建议：
1. 书籍：
	1. 《Hadoop权威指南》
	2. 《Hadoop技术详解》 
2. 实践很重要，边听边实践

#### 课程预备知识
1. Linux常用命令
2. Java编程基础
## Hadoop的前世今生
单机的系统瓶颈： 存储容量，读写速率，计算效率

Google大数据技术：
1. MapReduce
2. BigTable
3. GFS

- 革命性的变化1：成本降低，能用PC机，就不用大型机和高端存储。
- 革命性得变化2： 软件容错硬件故障视为常态，通过软件保证可靠性
- 革命性的变化3： 简化并行分布式计算，无须控制节点同步和数据交换

Google只发表了论文，没有开放源代码。

Hadoop是一个模仿大数据技术的开源实现。
## Hadoop的功能与优势

#### 什么是Hadoop
Hadoop是**开源的**， **分布式存储** + **分布式计算平台**。
<http://hadoop.apache.org/>

它包括两个核心组成：

- HDFS: 分布式文件系统，存储海量的数据
- MapReduce: 并行处理框架，实现任务分解和调度

#### Hadoop可以用来做什么?

搭建大型数据仓库，PB级数据的存储、处理、分析、统计业务。

- 搜索引擎
- 商业智能
- 日志分析
- 数据挖掘

#### Hadoop的优势
1. 高扩展
2. 低成本	
3. 成熟的生态圈
	
#### Hadoop的应用情况
- 国外： facebook twitter yahoo intel hulu linkedIn
- 国内： 百度，京东，淘宝，华为，新浪微博，小米，腾讯，网易 

Hadoop已成为业内大数据平台的首选

#### Hadoop的人才需求
1. Hadoop开发人才
2. Hadoop运维人才

## Haoop的生态系统及版本
#### 生态系统
- Hive 
	- 中文：小蜜蜂，不需要Hadoop任务程序，只需要写SQL语句。降低了使用Hadoop的使用门槛
	- 它是基于Hadoop之上的一个数据仓库
- HBase 存储结构化数据的分布式数据库。
	- 与传动数据相比：放弃事务特性，最求更高的扩展
	- 与HDFS的区别：随机读写和实时访问，实现对表数据的读写功能
- zookeeper 
	- 像动物管理员一样，监控Hadoop集群里面每一个节点的状态。管理配置，维护节点之前的一致性
#### 版本

1.x 与 2.x （现在2.6）

我们选择1.2的版本，因为1.x稳定，且对于新手易于理解容易上手。

---
# Hadoop的核心 - HDFS简介
## HDFS设计架构
- Blocks
	- HDFS的文件被分成块进行存储
	- HDFS块的默认大小为64M
	- 块是文件存储处理的逻辑单元
- NameNode
	- NameNode是管理节点，存放文件元数据 
	- 文件与数据块的映射表
	- 数据块（Block）与数据节点(DataNode)的映射表
- DataNode
	- 用来存放数据块的。

## 数据管理策略
#### HDFS数据管理与容错
每个数据块3个副本，分布在两个机架内的三个节点

#### 心跳检测

- DataNode定期向NameNode发送心跳信息
- 二级NameNode定期同步元数据镜像文件和修改日志， NameNode发生故障时，备胎转正。

#### HDFS读取文件流程

#### HDFS特点



---
# Hadoop的核心 - MapReduce简介