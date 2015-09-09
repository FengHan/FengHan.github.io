---
layout: post
title: "性能瓶颈"
date: 2015-08-30 00:10:51 +0800
comments: true
categories: 
---

# 前言

今天和一位搞运维研发的同学聊天，问如何解决300万条订单数据的分析。

答：看性能瓶颈在哪里，**读慢加缓存，写慢加队列**

可以研究一下内容：hadoop、spark、分布式数据库hbase，其中Spark利用内存计算会快些。