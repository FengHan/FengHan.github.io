---
layout: post
title: "PHP设计模式"
date: 2015-08-11 16:59:07 +0800
comments: true
categories: 
---
## 前言
- 本文是慕课网《大话PHP设计模式》的文字记录

- 视频内容：[大话PHP设计模式](http://www.imooc.com/view/236)
-  [GitHub代码](https://github.com/FengHan/php_pattern/)

### 目标：

- 掌握PHP各类设计模式
- 具备设计纯面向对象框架和系统的能力

### 编辑器的选择

PHP IDE 建议使用phpstorm, 因为适合PHP面向对象的开发

### 选择编程字体
因为1, l, i  o,O,0 不好区分

1. 必须选择等宽字体
2. 常见的等宽编程字体包括Courier New, Consolas.
3. 推荐使用 Source Code pro, 是有Adobe公司专门为程序员设计，免费开源。

PHPstorm在File -> Settings -> Editor -> Colors & Fonts -> Font 先Save As, 再更改 


### 命名空间与 autoload

开发符合PSR-0规范的基础框架

1. 全部使用命名空间
2. 所有PHP文件必须自动载入，不能有include/require
3. 单一入口


PSR-0规范被PSR-4规范代替（2014.10

- [PSR-4 English](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-4-autoloader.md)
- [PSR-4 中文](http://segmentfault.com/a/1190000002521658)


一个关于 文件路径 自动加载 的规范

1. “命名空间前缀”，其必须与至少一个“文件基目录”相对应；

2. 末尾的类名必须与对应的以 .php 为后缀的文件同名。

 
[一个遵循PSR-4的文件autoload的例子](http://www.bubuko.com/infodetail-557809.html)


### PHP面向对象的高级特性

#### SPL库的使用（php标准库） PHP5.5
1. SplStack, SplQueue, SplHeap, SplFixedArray

#### 魔术方法

1. __get __set
2. __call __callStatic
3. __toString
4. __invoke  将一个对象当做函数使用

### 11种PHP设计模式

1. 工厂模式： 工厂方法或类生成对象，而不是在代码中直接new
2. 单例模式： 使某个类的对象仅允许创建一个
3. 注册模式： 全局共享和交换对象


```php
class Database
{
    protected static $db;
    private function __construct()
    {
    }

    public static function getInstance()
    {
        if (empty(self::$db)) {
            self::$db = new self();
        }
        return self::$db;
    }
}
```
工厂模式的好处：
1. 工厂里被实例化的类，类名可修改，参数可调

单例模式说明：

1. __construct 的可见性为 protectd 或 privated，防止被实例化
2. 方法getInstance为静态方法（static），ps：静态方法内，只能调用静态属性。静态属性类似于函数的全部变量。
3. 静态属性$db的可见性为private或protected.

```php
class Register
{
    protected static $objests;
    public static function set($alias, $object)
    {
        self::$objests[$alias] = $object;
    }

    public static function get($name)
    {
        return self::$objests[$name];
    }
    public function _unset($alias)
    {
        unset(self::$objests[$alias]);
    }
}
```
注册树模式说明：

1. 好处： 被注册的对象在任何地方想要调用，不需要再调用工厂模式或单例模式，直接从注册树上拿即可。例如：Register::get('db');

### 适配器模式

1. 适配器模式，可以将截然不同的函数接口封装成统一的API
2. example： PHP的数据库操作有mysql，mysqli，pdo3种，可以用适配器模式统一成一致。类似的场景还有cache适配器，将memcache, redis, file, apc等不同的缓存函数，统一成一致。

### 策略模式

将一组特定的行为和算法封装成类，以适应默写特定的上下文环境，这种模式就是策略模式。

实际应用举例，例如一个电商网站系统，针对男性女性用户要各自跳转到不同的商品类目，并且所有广告位展示不同的广告。

使用策略模式可以实现Ioc，依赖倒置，控制反转

ps， 不同的支付接口也可以调用策略模式

### 数据对象映射模式
1. 数据对象映射模式，是将对象和数据存储映射起来，对一个对象的操作会映射为对数据存储的操作
2. 在代码中实现数据对象映射模式，我们将实现一个ORM类，将复杂的SQL语句映射成对象属性的操作。
3. 结合使用数据对象模式，工厂模式，注册模式

###  观察者模式
1. 观察者模式(Observer),当一个对象状态发生改变时，依赖它的对象全部收到通知，并自动更新
2. 一个事件发生后，要执行一连串的更新操作。传统的编程方式，就是在时间的代码之后直接加入处理逻辑。当更新的逻辑增多之后，代码会变得难以维护。这种方式是耦合的，侵入式的，增加新的逻辑需要改变事件主体的代码
3. 观察者模式实现了低耦合，非侵入式的通知和更新机制

### 原型模式
1. 与工厂模式作用类似，都是用来创建对象
2. 与工厂模式实现不同，原型模式是先创建好一个原型对象，然后通过clone原型对象来创建新的对象。这样就免去了类创建时重复的初始化操作。
3. 原型模式适用于大对象的创建。创建一个大对象需要很大的开销，如果每次new就会消耗很大，原型模式仅需要内存拷贝即可。

ps: 就是使用关键字clone对实例化好的类进行克隆。

### 装饰器模式
1. 注释七模式（Decorator），可以动态地添加修改类的功能
2. 一个类提供了一项功能，如果要在修改并添加额外的功能，传统的编程模式，需要一个子类来继承它，并重新实现类的方法
3. 使用装饰器模式，仅需在运行时添加一个装饰器对象极客实现，可以实现最大的灵活性

### 迭代器模式 iterator
1. 迭代器模式，在不需要了解内部实现的前提下，遍历一个聚合对象内部元素
2. 相比传统的编程模式，迭代器可以隐藏遍历元素所需要的操作。

### 代理模式

1. 在客户端与实体之间建立一个代理对象（proxy）,客户端对实体进行操作全部委派给代理对象，隐藏实体的具体实现细节。
2. Proxy 还可以与业务代码分离，部署到另外的服务器。业务代码中通过RPC来委派任务。
3. 典型的应用实例就是读写分离。读去连接从库，写去连接主库。 

### 面向对象鞭策的基本原则
1. 单一原则： 一个类，只做好一件事情。不要用类完成复杂的问题，拆分小的类。
2. 开放封闭：一个类，应该是可扩展的，而不可修改的。对扩展开放，对修改封闭。
3. 依赖倒置： 一个类，不应该依赖另外一个类。每个类对于另外一个类是可以替换的。用依赖注入的方式，例如，A类调用B类，应将B类对象注入给A类。
4. 配置化：尽可能地使用配置，而不是硬编码
5. 面向接口编程：只需关心接口，不需要关心实现。

##ＭＶＣ

1. 模型（Model): 数据和存储的封装
2. 视图(View): 展现层的封装，如Web系统中的模板文件
3. 控制器（Controller）： 逻辑层的封装

Apache/Nginx URL映射

将所有非静态文件的URL映射到PHP

## 配置与设计模式

1. PHP使用ArrayAccess实现配置文件的加载
2. 在工厂方法读取配置，生成可配置化的对象
3. 使用装饰器模式实现权限验证，模板渲染，JSON串化
4. 使用观察者模式实现数据更新事件的一系列更新操作
5. 使用代理模式实现数据库主从自动切换


### 更多的设计模式

在工程中思考并实践