---
layout: post
title: "redis的数据类型(一)"
date: 2015-07-24 14:54:30 +0800
comments: true
categories: redis
---


#### Redis 的数据库内部结构
	Redis中每个数据库，都是由一个redis.h/redisDb结构表示：
		typedef struct redisDb{
		int id: //保存着数据库以整数表示的号码
		dict *dict；	//保存着所有键值对数据，这个属性也被称为键空间（key space）
		dict *expires; //保存着键的过期信息
		dict *blocking_keys;	//实现列表阻塞原语，
		dict *watched_keys; 	//用于实现WATCH命令
	}redisDb

因为Redis是一个键值对数据库（key-value-pairs database）,所以它的数据库本身也是一个字典（俗称 key space）
- 字典的的键是一个**字符串**对象
- 字典的值可以是包括**字符串、列表、哈希值、集合或有序集**在内的任意一种Redis类型对象。

在 redisDb  结构的 dict  属性中，保存着数据库的所有键值对数据。
下图展示了一个包含 number 、book 、message 三个键的数据库—其中 number
 键是一个列表，列表中包含三个整数值；book  键是一个哈希表，表中包含三个键
值对；而 message  键则指向另一个字符串。


![](http://7xkc1x.com1.z0.glb.clouddn.com/redis_hash.jpg)

- 命令
	- Redis中的命令不区分大小写，SET与set效果一样。
- 主键（key）
	- 可以用任何二进制序列作为key值，从形如“foo”的简单字符串到一个JPEG文件的内容都可以。空字符串也是有效的key值。
- 关于key的规则
	- 可以用任何二进制序列作为key值
	- 格式约定： object-type:id:field
	- 不用太长的键值。不仅消耗内存，而且在数据查找中计算成本很高。
	- 太短的键值通常也不是好主意，可读性差。
		- 如用“user:1000:password”来代替“u:1000:pwd”

#### Redis 的 String 类型的底层实现与操作命令
	
String是Redis最基本的类型，而且String类型是二进制安全的。意思是Redis的String可以包含任何数据。比如jpg图片或者序列化对象。从内部实现来看其实String可以看做byte数组，最大上限是1G字节。下面是String类型的定义。

	struct sdshdr{
		long len;	//len是buf数组的长度
		long free; 	//free是数组中剩余可用字节数
		char buf[];	//char数组用于贮存实际的字符串内容
	}String;


新增相关命令

	Set
	语法：set key value
	解释：把值value赋给key，如果key不存在，新增；否则，更新。
	Setnx
	语法：setnx  key  value
	解释：只 insert 不 update，即，仅仅key不存在时，则设置key的值为value，并返回1，否则返回0  。setnx 是set if not exists 的缩写。
	Setex
	语法： setex key secondes value
	解释： 设置KEY的过期时间和值。过期时间seconds单位是秒。设置过期时间和值是原子操作，如果redis仅仅当做缓存，这个命令很有用。
	msetnx
	语法：msetnx key value  [key value ...]
	解释：所有key都不存在才执行set操作。

查询相关命令

	get
	语法：get key
	解释：获取key所set的值。
	mget
	语法： mget key [key]
	解释：批量获取key的值。程序一次获取多个值，可以减少网络连接损耗。
	getrange
	语法：getrange  key star end
	解释：获取存储在key中value的字串。字符串的截取有star和end决定，字符串的第一个字符编号是0，第二个是1，一次类推；如果是负数，-1是最后一个字符，-2是倒数第二个字符，一次类推。


修改相关命令

	getset
	语法：getset key value
	解释：设置key的值，并返回key的旧值。
	append
	语法：append key value
	解释：key存在，在旧值的后面追加value；key不存在，直接set，返回长度。
	setrange (替换部分子串)
	语法：setrange  key offset value
	解释：用value重写key值的一部分，偏移量由offset指定 。
	Incr/decr
	语法：incr/decr  key
	解释：key中如果存储的是数字，则可以通过incr递增key的值，返回递增后的值。如果key不能存在，视为初始值为0。
	Incrby/decrby
	语法：incrby key increment
	解释：用指定的步长增加key存储的数字。如果步长increment是负数，则减。
	注意：递增递减系列的函数，只能对保存的是数字的key操作，不能是字符串。
删除及其它命令

	del
	语法：del key [key]
	解释：删除指定的key，返回删除key的个数。
长度

	strlen
	语法：strlen key
	解释：获取key中所存储值的长度。

场景案例

	案例：博客系统的设计与开发
	需求与实现
	文章的访问量：定义键 post:articleID:pageView，通过INCR命令递增
	自增ID：定义键article:count，通过INCR递增
	存储文章的数据：伪代码如下
	首先获得新文章的ID
	              $postID = INCR posts:count
	将博客文章的诸多元素序列化成字符串
	              $serializedPost = serialize($title,$content,$author,$time)
	把序列化后的字符串存入一个字符串类型的键中
	              SET post:$postID:data,$serializedPost
	获取文章数据的伪代码
	从Redis中读取文章的数据
	              $serializePost=GET post:42:data
	将文章数据反序列化成文章的各个元素
	               $title,$content,$author,$time = unserialize($serializePost)
	获取并递增文章的访问量
	              $count=INCR post:42:pageView

	post:count		  最后一次的文章ID
	post:42:data 	  序列化存储文章数据
	post:42:pageView  文章访问量
	
	组合使用多个字符串类型键来存储文章数据
	Post:42:title	第一篇日志
	Post:42:author  Michael
	Post:42:content 今天下雨了
	Post:42:time    2015-07-26

#### Redis 的 Hash 类型的底层实现与操作命令

Redis hash 是一个 string 类型的 field 和 value 的映射表，一个 key 可对应多个
field，一个 field 对应一个value。可以将 Redis 中的 Hash 类型看成具有 String 
Key 和 String  Value 的 map容器。将一个对象存储为 Hash 类型，较于每个字段
都存储成 string 类型更能节省内存。每一个Hash可以存储2的32次幂 -1个键值对。

Hash 对应 Value 内部实际就是一个 HashMap，实际这里会有2种不同实现，这个
Hash的成员比较少时 Redis 为了节省内存会采用类似一维数组的方式来紧凑存储即
zipmap（压缩列表），而不会采用真正的 HashMap 结构，对应的value
redisObject 的 encoding为 zipmap，当成员数量增大时会自动转成真正的
HashMap,此时 encoding 为ht。
![](http://7xkc1x.com1.z0.glb.clouddn.com/struct_hash.png)
dict.h/dict 给出了这个字典的定义：

	Typedef  struct  dict {
     dictType *type;  // 特定于类型的处理函数
     void *privdata;  // 类型处理函数的私有数据
     dictht ht[2];       // 哈希表（2 个）
     int rehashidx;  // 记录rehash 进度的标志，值为-1 表示rehash 未进行
     int iterators;    // 当前正在运作的安全迭代器数量
	} dict;

字典所使用的哈希表实现由 dict.h/dictht 类型定义：

	typedef struct dictht {
	     dictEntry  **table; // 哈希表节点指针数组（俗称桶，bucket）
	     unsigned long size; // 指针数组的大小
	     unsigned long sizemask; // 指针数组的长度掩码，用于计算索引值
	     unsigned long used; // 哈希表现有的节点数量
	  } dictht;

dictEntry 都保存着一个键值对，以及一个指向另一个 dictEntry 结构的指针:

	typedef struct dictEntry {
      void *key;// 键
      union {
         void *val;   …
        } v; // 值
      struct dictEntry *next;// 链往后继节点
    } dictEntry;

![](http://7xkc1x.com1.z0.glb.clouddn.com/redis_hash_struct_pic.png)

新增相关命令

	hset
	语法：hset key field value
	解释：设置hash表key中的field的值。如果hash表不存在，则创建，并执行设置field的值，如果hash表存在，值field的值覆盖或新增。
	hmset
	语法：hash key  field  value[key value]
	解释：批量设置hash表key的域。
	hsetnx
	语法：hsetnx key field value
	解释：仅仅当field域不存在时，设置hash表field的值。
查询相关命令

	hget
	语法：hget key field
	解释：获取哈希表key的field值。
	hmget
	语法：hmget key
	hgetall
	语法：hgetall key
	解释：获取hash表的所有域值。
	hkeys
	语法：hkeys key
	解释：获取hash表的所有域。
	hvals
	语法：hvals key
	解释：获取hash表的所有域值。
	hexists
	语法：hexists key field
	解释：判断hash表中是否存在某个域。
修改相关命令

	hincrby

	语法：hincrby key field increment
	解释：hash表field域的数值增加步长increment，如果increment是负值，则是递减。如果域不存在，初始值视为0。

删除及其它命令

	hdel
	语法：hdel key field[field]
	解释：删除hash的域，如果指定多个field，则删除多个。
~

	hlen
	语法：hlen key
	解释：获取hash的域数量。




场景案例
![](http://7xkc1x.com1.z0.glb.clouddn.com/hash_post.jpg)

#### List概念与底层实现

List是一个链表结构，主要功能是push、pop、获取一个范围的所有值等等，操作中key理解为链表的名字。Redis的list类型其实就是一个每个子元素都是string类型的双向链表。我们可以通过push、pop操作从链表的头部或者尾部添加删除元素， push和pop命令的算法时间复杂度都是O(1)，这样list既可以作为栈，又可以作为队列。链表的最大长度是2的32次幂-1。


#### List常用操作命令

LPUSH 与 LRANGE 命令

	LPUSH
	语法：LPUSH  key   value
	解释：用来向列表左边增加元素，返回值表示增加元素后列表的长度；LPUSH命令还支持同时增加多个元素。

	LRANGE
	语法：LRANGE  key   start  end
	解释：用来获得列表中的某一片段，返回索引从 Start 到 end 之间的所有元素，索引从0开始。LRANGE 命令也支持负索引，-1表示最右边的元素，-2表示最右边倒数第2个元素。


RPUSH 与 LINSERT 命令

	RPUSH
	语法：RPUSH  key   value
	解释：用来向列表右边增加元素，返回值表示增加元素后列表的长度；RPUSH命令还支持同时增加多个元素。
	LINSERT
	语法：LINSERT  key   BEFORE | AFTER  pivot  value
	解释：此命令首先会在列表中从左到右查找值为pivot的元素，然后根据第2个参数是BEFORE还是AFTER来决定将Value插入到前面还是后面。返回值是插入后元素的个数。


LPOP 与 RPOP 命令

	LPOP/RPOP
	语法：LPOP/RPOP   key
	解释：LPOP命令可以从列表左边弹出一个元素；RPOP从列表右边弹出一个元素。
	LPOP和LPUSH配合，RPOP和RPUSH配合可以把列表当作栈使用；LPUSH和RPOP配合，RPUSH和LPOP配合可以把列表当作队列使用。


LREM 命令

	LREM
	语法：LREM  key   count   value
	解释：LREM 命令会删除列表中前 count 个值为value 的元素，返回值是实际删除的元素的个数。
	当 count >0时，从左边开始删除；
	当 count <0时，从右边开始删除；
	当 count =0时，删除所有值为 value 的元素；

LTRIM 命令

	LTRIM
	语法：LTRIM  key   start   end
	解释：LTRIM 命令会删除列表中指定索引范围外的所有元素，返回值即指定索引内的元素。LTRIM 命令常和 LPUSH命令一起使用来限制列表中元素的数量，比如记录日志时我们希望只保留最近的100条记录，则每次添加日志时调用一次 LTRIM 命令即可。

RPOPLPUSH 命令

	RPOPLPUSH
	语法：RPOPLPUSH  src   dest
	解释：RPOPLPUSH 命令先从 src 列表的右边弹出一个元素，然后将其加入 dest 列表的左边，并返回这个元素的值。当把列表当作队列时，RPOPLPUSH 可以在多个队列中传递数据。当 src 与dest 相同时，此命令会不断的将队尾的元素移动到队首。

LINDEX 与 LSET命令

	LINDEX
	语法：LINDEX  key  index
	解释：LINDEX 命令用来返回指定索引的元素，索引从0开始。
	LSET
	语法：LSET key  index  value
	解释：将索引为 index 的元素赋值为 value。

LLEN 命令


#### List的应用场景

	Redis list应用场景非常多,比如：
	微博的关注列表
	粉丝列表
	博客评论
	消息队列
	取最新 N  个数据的操作
	排行榜应用，取 TOP  N 操作

String 类型存储文章 ID 的弊端:

	如何获取文章列表
	读取 post:count 键获得博客文章的最大 ID
	根据 ID 进行分页（假设每页10条），第 n 页的文章 ID 范围是“最大的文章ID-(n-1)*10”到“max(最大的文章 ID – n*10+1,1)”
	对每个ID使用HMGET命令来获取文章的数据，伪代码如下：
	
	# 每页显示10篇文章
	$postsPerPage  = 10
	# 获得最后发表的文章 ID
	$lastPostID = GET posts:count
	# 当前页码范围
	$start = $lastPostID – ($currentPage - 1) * $postsPerPage
	$end = max( $lastPostID – $currentPage  * $postsPerPage +1，1)
	
	# 遍历文章 ID 获取数据
	For $i = $start down to $end
	# 获取文章的标题和作者并打印出来
	post = HMGET post:$i，title，author
	         Print $post[0]
	         Print $post[1]
	缺点：删除文章时影响页码分布，都需要从最大文章 ID 开始遍历




List 类型存储文章 ID

	使用列表类型键 posts:list 记录文章 ID
	LPUSH posts:list  文章ID
	LREM    posts:list  1  文章 ID
	# 使用 LRANGE 实现分页
	$postsPerPage  = 10
	$start =  ($currentPage - 1) * $postsPerPage
	$end =  $currentPage  * $postsPerPage  - 1
	$postsID = LRANGE posts:list，$start，$end
	
	# 获取需要显示文章的 ID 列表
	For   each   $id   in   $postsID
	          $post = HGETALL post:$id
	           print  文章标题：$post.title

缺点： 文档内容较多的时候，访问中间的内容性能比较差。因为LIST是通过链表实现的，所以访问中间元素时，效率不高； 解决方法，使用有序集合来存储文章ID.

List 类型存储文章评论

	# 使用列表类型键post：文章 ID：comments来存储文章的评论
	$serializedComment = serialize($author，$email，$time，$content)
	LPUSH  post:42:comments，$serializedComment
	读取评论时使用 LRANGE 命令


