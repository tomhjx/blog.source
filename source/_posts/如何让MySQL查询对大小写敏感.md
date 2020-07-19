---
title: 如何让MySQL查询对大小写敏感?
categories:
  - 数据库
  - MySQL
tags:
  - MySQL
date: 2020-07-19 17:47:22
---

当我们输入不管大小写都能查询到数据，例如：输入 aaa 或者aaA ,AAA都能查询同样的结果，说明查询条件对大小写不敏感。
解决方案一：
于是怀疑Mysql的问题。做个实验：直接使用客户端用sql查询数据库。 发现的确是大小不敏感 。
通过查询资料发现需要设置collate（校对） 。 collate规则：
\*\_bin: 表示的是binary case sensitive collation，也就是说是区分大小写的
\*\_cs: case sensitive collation，区分大小写
\*\_ci: case insensitive collation，不区分大小写
解决方法。
1.可以将查询条件用binary()括起来。 比如：
select \* from TableA where binary columnA ='aaa';

2.  可以修改该字段的collation 为 binary
    比如：

```sql
ALTER TABLE TABLENAME
MODIFY COLUMN COLUMNNAME VARCHAR(50) BINARY CHARACTER
SET utf8 COLLATE utf8_bin DEFAULT NULL;

```

解决方案二：
mysql查询默认是不区分大小写的 如:

```sql
select * from some_table where str=‘abc';
select * from some_table where str='ABC';

```

得到的结果是一样的，如果我们需要进行区分的话可以按照如下方法来做：
第一种方法：
要让mysql查询区分大小写，可以：

```sql
select * from some_table where binary str='abc'
select * from some_table where binary str='ABC'

```

第二方法：
在建表时时候加以标识

```sql
create table some_table( str char(20) binary )

```

原理：
对于CHAR、VARCHAR和TEXT类型，BINARY属性可以为列分配该列字符集的 校对规则。BINARY属性是指定列字符集的二元 校对规则的简写。排序和比较基于数值字符值。因此也就自然区分了大小写。