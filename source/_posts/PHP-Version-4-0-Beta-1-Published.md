---
title: PHP Version 4.0 Beta 1 Published
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - 历史
  - PHP发展史
  - 技术发展史
date: 1999-06-19 15:00:00
---

# 有什么变化

1998 年的冬天，PHP 3.0 官方发布不久，Andi Gutmans 和 Zeev Suraski 开始重新编写 PHP 代码。设计目标是增强复杂程序运行时的性能和 PHP 自身代码的模块性。PHP 3.0 的新功能和广泛的第三方数据库、API的支持使得这样程序的编写成为可能，但是 PHP 3.0 没有高效处理如此复杂程序的能力。

Andi Gutmans 和 Zeev Suraski 重写了PHP词法解析器，称为“Zend Engine”（这是 Zeev 和 Andi 的缩写）

源码提交到了github（https://github.com/php/php-src）

## 新增了什么

* Zend Engine

在PHP运行过程中引入了“Zend虚拟机”后，PHP架构发生了变化

![](http://segmentfault.com/img/bVcGi8)


# 为了解决什么问题

* PHP3 采用的是边解释、边执行的运行方式，运行效率很差，故此没法提供高效处理如此复杂程序的能力。
* 代码整体耦合度比较高，可扩展性也不够好，维护成本将会越来越高。

# 关键思路是什么

* 模块化设计实现解耦

* 词法解析器的核心优化：执行机制划分为编译和执行，先进行预编译(Compile)，然后再执行(Execute)