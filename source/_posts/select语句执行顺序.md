---
title: select语句执行顺序
categories:
  - 数据库
  - MySQL
tags:
  - MySQL
date: 2016-01-03 17:39:04
---

### SELECT语句定义

一个完成的SELECT语句包含可选的几个子句。SELECT语句的定义如下：

```
<SELECT clause> [<FROM clause>] [<WHERE clause>] [<GROUP BY clause>] [<HAVING clause>] [<ORDER BY clause>] [<LIMIT clause>]
```

SELECT子句是必选的，其它子句如WHERE子句、GROUP BY子句等是可选的。

一个SELECT语句中，子句的顺序是固定的。例如GROUP BY子句不会位于WHERE子句的前面。

### SELECT语句执行顺序

SELECT语句中子句的执行顺序与SELECT语句中子句的输入顺序是不一样的，所以并不是从SELECT子句开始执行的，而是按照下面的顺序执行：

```

开始->FROM子句->WHERE子句->GROUP BY子句->HAVING子句->ORDER BY子句->SELECT子句->LIMIT子句->最终结果

```

每个子句执行后都会产生一个中间结果，供接下来的子句使用，如果不存在某个子句，就跳过