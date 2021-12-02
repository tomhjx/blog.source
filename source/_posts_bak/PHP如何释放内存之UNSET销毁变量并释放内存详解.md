---
title: PHP如何释放内存之UNSET销毁变量并释放内存详解
categories:
  - 编程语言
  - PHP
date: 2016-01-03 13:43:57
tags:
  - PHP内存释放
---


PHP的unset()函数用来清除、销毁变量，不用的变量，我们可以用unset()将它销毁。但是某些时候，用unset()却无法达到销毁变量占用的内存！我们先看一个例子：

```php
$s = str_repeat('1',255);       //产生由255个1组成的字符串
$m = memory_get_usage();        //获取当前占用内存
unset($s);
$mm = memory_get_usage();       //unset()后再查看当前占用内存
echo $m-$mm;
```

最后输出unset()之前占用内存减去unset()之后占用内存，如果是正数，那么说明unset($s)已经将$s从内存中销毁(或者 说，unset()之后内存占用减少了)，可是我在PHP5和windows平台下，得到的结果是：-48。这是否可以说明，unset($s)并没有起 到销毁变量$s所占用内存的作用呢？我们再作下面的例子：

```php
$s = str_repeat('1',256);       //产生由256个1组成的字符串
$m = memory_get_usage();        //获取当前占用内存
unset($s);
$mm = memory_get_usage();       //unset()后再查看当前占用内存
echo $m-$mm;
```

这个例子，和上面的例子几乎相同，唯一的不同是，$s由256个1组成，即比第一个例子多了一个1，得到结果是：224。这是否可以说明，unset($s)已经将$s所占用的内存销毁了？
通过上面两个例子，我们可以得出以下结论：
结论一、unset()函数只能在变量值占用内存空间超过256字节时才会释放内存空间。
那么是不是只要变量值超过256，使用unset就可以释放内存空间呢？我们再通过一个例子来测试一下：

```php
$s = str_repeat('1',256);               //这和第二个例子完全相同
$p = &$s;
$m = memory_get_usage();
unset($s);                                              //销毁$s
$mm = memory_get_usage();
echo $p . '<br />';
echo $m-$mm;
```

刷新页面，我们看到第一行有256个1，第二行是-48，按理说我们已经销毁了$s，而$p只是引用$s的变量，应该是没有内容了，另外，unset($s)后内存占用却比unset()前增加了！现在我们再做以下的例子：

```php
$s = str_repeat('1', 256);              //这和第二个例子完全相同
$p = &$s;
$m = memory_get_usage();
$s = null;                                              //设置$s为null
$mm = memory_get_usage();
echo $p . '<br />';
echo $m-$mm;
```

现在刷新页面，我们看到，输出$p已经是没有内容了，unset()前后内存占用量之差是224，即已经清除了变量占用的内存。本例中的$s=null也可以换成unset()，如下：

```php
$s = str_repeat('1', 256);              //这和第二个例子完全相同
$p = &$s;
$m = memory_get_usage();
unset($s);                                              //销毁$s
unset($p);
$mm = memory_get_usage();
echo $p . '<br />';
echo $m-$mm;
```


我们将$s和$p都使用unset()销毁，这时再看内存占用量之差也是224，说明这样也可以释放内存。那么，我们可以得到另外一条结论：
结论二、只有当指向该变量的所有变量（如引用变量）都被销毁后，才会释放内存。
相信经过本文的例子后，大家应该对unset()有所了解了，最起码，本人用unset()也是为了在变量不起作用时，释放内存。
