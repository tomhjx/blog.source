---
title: PHP扩展安装
categories:
  - 编程语言
  - PHP
date: 2016-01-03 14:03:56
tags:
  - PHP扩展
---

### PECL扩展库

PECL 的全称是 The PHP Extension Community Library ，是一个开放的并通过 PEAR(PHP Extension and Application Repository，PHP 扩展和应用仓库)打包格式来打包安装的 PHP扩展库仓库。通过 PEAR 的 Package Manager 的安装管理方式，可以对 PECL 模块进行下载和安装。

http://pecl.php.net/


可跑命令：

pecl install {package}


### 扩展通用编译流程

1: 到软件的官方(如 memcached)或 pecl.php.net 去寻找扩展源码并下载解压

2: 进入到 path/memcache 目录

3: 根据当前的 php 版本动态的创建扩展的 configure 文件
#/xxx/path/php/bin/phpize \
--with-php-config=/xxx/path/php/bin/php-config

4: ./configure
-with-php-config=/xxx/path/php/bin/php-config

5: make && make install

6:把生成的.so 扩展, 在 php.ini 里引入.

7：重启web服务器
