---
layout: post
title: "使用Octopress在GitHub上搭建静态博客"
date: 2015-07-17 12:52:50 +0800
comments: true
categories: [Git,Octopress]
tags: [octopress, github, blog, seo]
keywords: seo, octopress, github, blog
description: 使用Octopress在GitHub上搭建静态博客
---

#前言

本博客基于Octopress+Github Pages搭建，可以搭建全免费、稳定运行的个人博客。 本文将简述在Windows平台（Win7 64bit）上搭建这套系统的全流程和要点。 在继续看本文之前，请先确定你具有折腾的精神。

![image](http://7xkc1x.com1.z0.glb.clouddn.com/ctooctopress.jpg)

#介绍

[Octopress](https://github.com/imathis/octopress)是一个基于Ruby语言的开源静态网站框架， 所谓静态，是指网站的所有内容都是生成好的静态HTML，不含任何后台处理程序，也没有数据库。 这样的好处是网站的加载速度会非常快，整体程序规模也非常轻量级。

[Github Pages](https://pages.github.com/)是Github上的一项服务， 注册用户可以申请一个和自己账号关联的二级域名， 在上面可以托管一个静态网站，网站内容本身就是Github的一个repository也就是项目， 维护这个项目的代码就是在维护自己的网站。
此外，用户撰写日志使用的是Markdown语法。这是一种极简化的语法， 它的好处在于可以以纯文本形式表现文章，用户不用关心排版的问题。 基本上来说它相当于HTML标签的最小子集做了一个转义。

综上所述，你将获得一个这样的博客

- 命令行操作		
- 纯文本写博客		
- 定制性高				
- 纯静态				
- 尤其适合程序员
- 版本化管理
- 迁移成本低
- 简洁的 Ruby 框架
- Markdown 语法

#安装
- Git：版本管理工具，将代码托管到 GitHub
{% codeblock lang:ruby %}
ruby -v

{% endcodeblock %}
- Ruby + DevKit：生成静态网页
- MarkdownPad：Windows 下 Markdown 语法编辑器
- **安装 Octopress**
{% codeblock lang:ruby %}
#1.克隆 Octopress 至本地
git clone git://github.com/imathis/octopress.git octopress
#2.参考 ruby.taobao.org, 配置RubyGems 镜像
#3.安装依赖项
gem install bundler
bundle install
#4.安装并使用默认主题
rake install
$ gem install rails
{% endcodeblock %}
- Pygments: Jekyll 里默认的语法高亮插件是 Pygments
	- 安装 Python
	- 安装 ‘Easy Install’
	- 安装 Pygments
{% codeblock lang:ruby %}
python -V
{% endcodeblock %}

#部署博客至 GitHub

1.新建仓库
	username.github.io

2.与本地 Octopress 目录绑定

{% codeblock lang:ruby %}
rake setup_github_pages
rake deploy
{% endcodeblock %}

##托管源码至 GitHub

将 source 目录更新到远程仓库

{% codeblock lang:ruby %}
git add .
git commit -m 'your message'
git push origin source
{% endcodeblock %}

#相关配置

**多说评论**

**JiaThis分享**

**自定义 404 页面**

**自定义导航**

**主配置文件**

在 _config.yml 文件中，设置 url、title、author 等基本信息

## GitHub 上找主题文件

{% codeblock lang:ruby %}
rake install['themename']
rake generate
{% endcodeblock %}

##在 GitHub 上绑定自定义域名

创建 source/CNAME 文件并指定域名
{% codeblock lang:bash  %}
echo 'hanfeng.com' >> source/CNAME
# OR
echo 'tech.hanfeng.name' >> source/CNAME
{% endcodeblock %}


解析域名至 GitHub

- 使用子域名
对于子域名(www.hanfeng.name)，创建 CNAME 记录指向 fenghan.github.io

- 使用顶级域名
对于顶级域名(hanfeng.name)，使用 A 记录指向 192.30.252.153(154)

#常用目录
source  存放程序、博客源码
public  存放生成的静态网站

#国内访问加速

**修改字体**：

source/_includes/custom/head.html, 

将其中的https://fonts.googleapis.com 改为 http://fonts.useso.com 即可。

**jquery库**:

/source/_includes/head.html,把google的jQuery库改为libs.baidu.com的

**关闭twitter**: 

_config.yml中twitter_tweet_butto改为false即可

#SEO

使用百度统计工具进行统计

#常用命令

{% codeblock lang:ruby %}
rake new_page['about']			#creates /source/about/index.markdown
rake new_post['octopress-blog'] 

rake generate
rake preview
{% endcodeblock %}

#参考链接

软件安装： [oukongli的专栏](http://blog.csdn.net/kong5090041/article/details/38408211)

SEO参考： [笨跑的一刀](http://yidao620c.github.io/blog/20150318/octopress-blog.html)

 [软件下载](http://pan.baidu.com/s/1bndNlTl)   密码: e3p3 
