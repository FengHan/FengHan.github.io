---
layout: post
title: "Redis数据结构类型2"
date: 2015-08-14 14:02:41 +0800
comments: true
categories: 
---
# 前言
本文记录是极客学院 [Redis系列课程](http://www.jikexueyuan.com/course/1693_1.html?ss=2)的文字记录

[文档](http://redisdoc.com/)
[Redis Desktop Manager](http://redisdesktop.com/download)
# 集合类型与有序集合类型

### 集合类型概述

Set， string类型的无序集合，不允许有重复元素。通过hash table实现，可以取并集、交集、差集，可以实现sns中好友推荐和blog的tag功能。

底层实现： 整数集合（都是整数值，数量不超过512），字典。

存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择。

集合还提供了判断某个成员是否在一个set集合内的接口。


sadd srem spop
- sadd key member 返回值，成功的数量
- srem key member 返回值，删除的的数量， 可删除多个
- spop key 随机弹出一个元素，返回弹出的元素

获取
- 
- smembers key	查看元素
- srandmember key count  count>0 返回不重复， count < 0,可能重复
- SISMEMBER key member  集合中是否存在key
- SCARD member  统计集合个数

运算命令
- SDIFF A B 差集， 所有属于A，不属于B; 1 2 3， 2 3 4 => 1 
- SINTER A B  交集  所有属于A, 且属于B
- SUNION A B  并集
- SDIFFSTORE  不会返回结果，而是会存储在dest结果中

## Redis 有序集合类型概述
Sorted Sort
底层实现： 

- 压缩列表（数量不超过128，且小于64字节）、
- 跳跃表（skiplist）

需要有序的，不重复的，可以选择它。 可以构建优先级的队列。

有序集合类型与列表的比较，相同点：

- 二者都是有序的。
- 二者都可以获得某一范围的元素。

不同点：

- 列表通过链表实现，获取靠近两端的数据速度快，适合“新鲜事”和“日志”。
- 有序集合使用散列表和跳跃表实现，读取中间数据速度也快。
- 列表不能简单的调整元素的位置，而有序集可以。
- 有序集合比列表类型更耗内存。
