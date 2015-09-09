---
layout: post
title: "Laravel5 基础"
date: 2015-09-09 11:09:29 +0800
comments: true
categories: laravel
---

# 前言

Laravel 5 的很多新功能是来自 Jeffrey Way的 idea, 

如: Form Requests, Laravel Elixir, Command bus etc..

所以, 他的这套视频就很有观看的必要
 <https://laracasts.com/series/laravel-5-fundamentals>

现已看完，做下记录

## Laravel5 Foundation

#### 需求分析：

1. Article模块
	- Articles List
	- Create Article :title , body, published_at, tag
	- Edit Article 
2. 用户登录模块


#### 细节： 
1. Create Article的输入内容，要进行validate，使用Request进行验证。
2. Create Article成功时，用Flash Message提示。 

#### 学习的内容
- Composer 的安装与使用
- Virtual Box, Vagrant, Homestead安装与使用
- Route 路由的使用
- Blade  模板文件
- .env 开发环境的设置
- migration 创建和修改数据库的结构
- MVC在Laravel中的工作流
- Form表单
- Model 中的 Dates : Carbon\Carbon
- Model 中的 Scopes : 封装判断条件（例如： article是否发布）
- Model 中的 set Attributes : 插入记录时，自动插入（例如时间）
- View Partials 视图文件的局部选软
- Eloquent  这个很强大，但感觉复杂查询会很麻烦，// todo 继续深入学习
- Auth  Laravel5.0 提供了简单的注册、登录和找回密码
- Middleware （用处：例如验证是否用户登录）
- Many to Many Relation (A article has many tags, and a tag has many articles.)
- Tag 选择地时候用了Select2插件
- View Partial Always Receive Data (例如首页导航条)
- Service Container (又叫 Ioc Container,是Laravel框架的核心所在)

### 用到的第三方包

	{
		“require” : {
			"barryvdh/laravel-ide-helper": "^2.1",
			"illuminate/html": "^5.0",
		  	"laracasts/flash": "~1.3",
		}
	}
- barryvdh/laravel-ide-helper  用来提示Laravel的Facade
- illuminate/html Html Form封装了form表单
- laracasts/flash Jeffrey Way写的 flash message

以上文件放在composer.json中，第二步是在config/app.php配置 provider 和 alias.

### 经常用到的命令

	php artisan make:controller --plain
	php artisan dump-autoload 