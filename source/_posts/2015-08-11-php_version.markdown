---
layout: post
title: "PHP各个版本的新特性"
date: 2015-08-11 14:19:23 +0800
comments: true
categories: 
---


两年前，公司由PHP5.2 升级到了PHP5.3,此后在PHP5.3上开发了有一年的时间，此后不断的升级，现在记录一些我用到的特性。

# PHP5.3


 PHP5.3一方面在面向对象开发等方面有所加强, 另一方面也增加了不少实用的语法特性和新扩展。

1. 支持命名空间
2. 新增两个魔术方法__invoke 和__callStatic
3. 三元符增加了一个快捷方式来书写。
4. 支持闭包



命名空间的分隔符为反斜杠\

以函数形式来调用对象时，__invoke()方法将被自动调用。

当尝试调用类中不存在的静态方法时，__callStatic()魔术方法将被自动调用。 


# PHP 5.4

当升级到PHP5.4版本的时候，我们的开发环境有XP全部升级到了WIN7

- 数组简写形式  [1,2,3]  ['foo' => 'banana', 'bar' => 'apple']
- 内置Web服务器  php -S localhost:8000 -t public
- <?=（精简回显语法）现在始终可用，无论 short_tags ini 设置的值为何。   
- PHP 5.4版本将是最后一个支持Windows XP 和 Windows 2003的版本，今后将不再提供针对这些操作系统的二进制包。

- 返回数组的函数调用现在可以直接解除引用：


	function fruits() {  
    	return ['apple', 'banana', 'orange'];  
	}  

	echo fruits()[0]; // Outputs: apple  


# PHP 5.5 

Laravel 框架对PHP的版本要求是大于等于PHP5.5.9

- 不推荐使用 mysql 函数，推荐使用 PDO 或 MySQL


# PHP 5.6

- 命名空间支持常量和函数：

# PHP 7

2015年11月发布