---
layout: post
title: "Composer自动加载的原理"
date: 2015-08-17 15:29:35 +0800
comments: true
categories: 
---

# 前言

当PHP引擎试图实例化未知类的操作时，就会调用__autoload(),并将类名当做字符串传递给它。但__autoload()有个缺点，就是 一个进程中只能定义一次。这是就可以使用spl_autoload_register()函数。它可以把函数注册到__autoload队列中. 现在我们来看看composer是如何实现自动加载的。


composer.json 文件
```json
{
    "autoload": {
        "classmap" : [
            "app/controllers",
            "app/models"
        ]
    }

}
```

当我们composer dump-autoload的时候，文件/vendor/composer/autoload_clasmap.php会把类名和绝对地址做个想射。

```php
$vendorDir = dirname(dirname(__FILE__));
$baseDir = dirname($vendorDir);

return array(
    'Article' => $baseDir . '/app/models/Article.php',
    'BaseController' => $baseDir . '/app/controllers/BaseController.php',
    'HomeController' => $baseDir . '/app/controllers/HomeController.php',
);
```

首页index.php调用composer的autoload文件

	require '../vendor/autoload.php';

会调用ComposerAutoloaderInit类的静态方法getLoader(）

```php
<?php
require_once __DIR__ . '/composer' . '/autoload_real.php';

return ComposerAutoloaderInita488c85ce5c077906f9c1829b6492f6b::getLoader();
```


verdor/composer/目录下有四个配置文件：

- autoload_classmap.php：	要加载的class映射
- autoload_files.php：		要加载的文件
- autoload_namespaces.php：	psr-0标准
- psr4.php：					psr-4标准

getLoader(）这个方法会先把这些配置文件放到ClassLoader的私有属性中。

然后通过$loader->register(true);来调用spl_autoload_register()

```
public function register($prepend = false)
{
    spl_autoload_register(array($this, 'loadClass'), true, $prepend);
}
```
spl_autoload_register()把loadClass()方法注册到了autoload队列中,然后当PHP引擎试图实例化未知类的操作时，就会根据类名和命名空间加载这个类文件。

```php
public function loadClass($class)
{
    if ($file = $this->findFile($class)) {
        includeFile($file);

        return true;
    }
}
```

# psr-0 与psr - 4 的不同
1. PSR-4中，在类名中使用下划线没有任何特殊含义。而PSR-0则规定类名中的下划线_会被转化成目录分隔符。
2. composer的PSR-4带来更简洁的文件结构。
3. 参考：[PSR-4——新鲜出炉的PHP规范](http://segmentfault.com/a/1190000000380008)

总结：
1. 命名空间前缀对应相应的文件夹
2. 类名和文件名相同，文件后缀为PHP




### psr-4

	{
		"psr-4" : {
	       "Foo\\": "src/"
	    },
	}

按照PSR-4的规则，当试图自动加载 "Foo\\Bar\\Baz" 这个class时，会去寻找 "src/Bar/Baz.php" 这个文件，如果它存在则进行加载。


### prs-0

    {
		"psr-0" : {
	       "Foo\\": "src/",
	    },
	}

PSR-0有此配置，那么会去寻找 "src/Foo/Bar/Baz.php"

PSR-0当试图自动加载 "Foo\\A_B" 这个class时，会去寻找 "src/Foo/A/B.php" 这个文件.

参考链接<http://www.tuicool.com/articles/mARrMj6>


### classmap

	{
		"autoload": {
				"classmap": [
					"database"
				],
		}
	}

classmap 做的是类名和文件所在位置的映射