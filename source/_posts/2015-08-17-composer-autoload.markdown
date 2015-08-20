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