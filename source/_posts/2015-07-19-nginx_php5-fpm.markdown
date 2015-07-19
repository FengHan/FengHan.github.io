---
layout: post
title: "在Ubuntu上搭建Nginx + php5-fpm"
date: 2015-07-19 11:25:56 +0800
comments: true
categories: [nginx, php5-fpm]
tags: [nginx, php5-fpm]
---

#前言
大学开发网站的时候，大部分的时候使用的是Apache服务器，但进入工作后，服务器都使用Nginx，因为它能承载的并发数是Apache2.2的10倍。

Nginx只负责静态文件，通过php5-fpm调用php-cgi来解析php。

那CGI是干嘛的？CGI是为了保证web server传递过来的数据是标准格式的，方便CGI程序的编写者的协议。

Fastcgi是用来提高CGI程序性能的，也是一个协议。

那PHP-FPM又是什么呢？是一个实现了Fastcgi的程序，被PHP官方收了。


可以[Nginx官方文档](http://nginx.org/en/docs/)深入学习，下面这些必看

- Installing nginx
- Beginner’s Guide
- Converting rewrite rules
- ngx_http_rewrite_module
- ngx_http_proxy_module
- ngx_http_log_module
#安装Nginx


**安装Nginx**

```
apt-get install nginx
```

**配置Nginx**

nginx配置文件

> /etc/nginx/nginx.conf中

nginx.conf配置里面包括了

> include /etc/nginx/conf.d/*.conf;

> include /etc/nginx/sites-enabled/*;

错误日志
> error_log /var/log/nginx/error.log;


网页的默认目录

> root /usr/share/nginx/html;


配置目录

> /etc/nginx/sites-available/default

修改配置


	location ~ \.php$ {
	
	  　　  try_files $uri =404;
	
	  　　  fastcgi_pass 127.0.0.1:9000;
	
	  　　  fastcgi_index index.php;
	
	  　　  include fastcgi_params;
	}
      　

**配置生效**

```
/etc/init.d/nginx reload
```

**启动Nginx**

```
/etc/init.d/nginx start
```
 
**测试Nginx**

在 /usr/share/nginx/html下新建index.php

	<? php
	phpinfo();
　　　　
nginx -t


#虚拟主机管理

创建 tech.hanfeng.name


``` 
cd /usr/share/nginx

mkdir tech.hanfeng.name

cd tech.hanfeng.name

echo '<?php phpinfo();' > index.php

cd /etc/nginx/sites-available/ 

cp default tech.hanfeng.name
#Apache需要以.conf结尾，Nginx不用

grep -v "#" tech.hanfeng.name

```

	server {
	        listen 80;
	        listen [::]:80;
	
	        root /usr/share/nginx/tech.hanfeng.name;
	        index index.php index.html;
	
	        server_name tech.hanfeng.name;
	
	        location / {
	                try_files $uri $uri/ =404;
	        }
	
	
	
	
	        location ~ \.php$ {
	                fastcgi_split_path_info ^(.+\.php)(/.+)$;
	
	                fastcgi_pass 127.0.0.1:9000;
	                fastcgi_index index.php;
	                include fastcgi_params;
	        }
	
	}


```
ln -s /etc/nginx/sites-available/tech.hanfeng.name  /etc/nginx/sites-enabled/tech.hanfeng.name

nginx -t

/etc/init.d/nginx reload
```




#安装PHP

```
sudo apt-get install php5-fpm

sudo apt-get install php5-gd  
# Popular image manipulation library; used extensively by Wordpress and it's plugins.

sudo apt-get install php5-cli   
# Makes the php5 command available to the terminal for php5 scripting

sudo apt-get install php5-curl    
# Allows curl (file downloading tool) to be called from PHP5

sudo apt-get install php5-mcrypt   
# Provides encryption algorithms to PHP scripts

sudo apt-get install php5-mysql   
# Allows PHP5 scripts to talk to a MySQL Database

sudo apt-get install php5-readline  
# Allows PHP5 scripts to use the readline function
```

查看php5运行进程

```
ps -waux | grep php5
```

打开关闭php5进程

```
sudo service php5-fpm stop
sudo service php5-fpm start
sudo service php5-fpm restart
sudo service php5-fpm status
```


#配置PHP5-FPM

配置php5监听端口  
> /etc/php5/fpm/pool.d/www.conf

	把
	listen = /var/run/php5-fpm.sock  改为
	listen = 127.0.0.1:9000

一台机器安装nginx，另一台安装php，用上面的修改

重新运行php进程

在浏览器中输入 localhost就可以看到了
