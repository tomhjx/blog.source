---
title: MySQL Select实测
categories:
  - 数据库
  - MySQL
tags:
  - 原创
  - MySQL
  - select
date: 2016-01-03 16:32:23
---

```sql

CREATE TABLE `case_article` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `mid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `title` VARCHAR(255) NOT NULL,
    `n_click` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `publishtime` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `status` TINYINT(3) UNSIGNED NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    INDEX `n_click` (`n_click`),
    INDEX `publishtime` (`publishtime`),
    INDEX `mid` (`mid`)
)
COLLATE='utf8_general_ci'
ENGINE=MyISAM;

CREATE TABLE `case_member` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `createtime` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `status` TINYINT(3) UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `createtime` (`createtime`)
)
COLLATE='utf8_general_ci'
ENGINE=MyISAM;

#set profiling=1; #开启运行记录日志
#show profiles;#查询运行记录
#reset query cache;#清空查询缓存
#flush tables;
#set session query_cache_type = 0;临时禁用查询缓存
#show variables like '%query_cache%';
#show status like '%Qcache%';


```

### 联表查询


```sql

select a.id,b.name from case_article as a inner join  case_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1;

```


```

+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows    | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 5000000 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |       1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+

5000000 rows in set (31.00355250 sec)

```


```sql

select a.id,b.name from case_article as a left join  case_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1;

```

```

+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows    | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 5000000 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |       1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+

5000000 rows in set (24.35417500 sec)


```


### 限制小记录数联表查询


```sql

select a.id,b.name from case_article as a left join  case_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 order by a.id desc limit 100000;

```

```

+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-----------------------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows    | Extra                       |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-----------------------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 5000000 | Using where; Using filesort |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |       1 | Using where                 |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-----------------------------+

100000 rows in set (3.17512150 sec)

```


```sql

select a.id,b.name from case_article as a inner join  case_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 order by a.id desc limit 100000;

```

```

+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-----------------------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows    | Extra                       |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-----------------------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 5000000 | Using where; Using filesort |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |       1 | Using where                 |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-----------------------------+


100000 rows in set (3.46428075 sec)

```

### 总记录数5000000，查询超过47853,a不用索引

```sql

select a.id,b.name from case_article as a left join  case_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 order by a.id desc limit 47853;

```

```
+----+-------------+-------+--------+---------------+---------+---------+------------+-------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows  | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+-------+-------------+
|  1 | SIMPLE      | a     | index  | mid           | PRIMARY | 4       | NULL       | 47853 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |     1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+-------+-------------+

47853 rows in set (0.30755625 sec)

```

```sql

select a.id,b.name from case_article as a left join  case_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 limit 47853;

```

```

+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows    | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 5000000 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |       1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+---------+-------------+

47853 rows in set (0.23440550 sec)

```


```sql

select id from case_article where mid > 1000000;

```

```

+----+-------------+--------------+------+---------------+------+---------+------+---------+-------------+
| id | select_type | table        | type | possible_keys | key  | key_len | ref  | rows    | Extra       |
+----+-------------+--------------+------+---------------+------+---------+------+---------+-------------+
|  1 | SIMPLE      | case_article | ALL  | mid           | NULL | NULL    | NULL | 5000000 | Using where |
+----+-------------+--------------+------+---------------+------+---------+------+---------+-------------+

2500814 rows in set (1.75442150 sec)

```



```sql

select id from case_article where mid > 1000000 limit 2500814;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+---------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows    | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+---------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL | 2625654 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+---------+-------------+

2500814 rows in set (4.93114550 sec)

```


```sql

select id from case_article where mid > 1900000;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows   | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL | 487187 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+

249909 rows in set (0.53250450 sec)

```


```sql

select id from case_article where mid > 1900000 limit 249909;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows   | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL | 487187 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+

249909 rows in set (0.52184200 sec)


```


```sql

select id,mid from case_article where mid >1900000 or mid <1000;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows   | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL | 256711 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+

252507 rows in set (0.58568825 sec)

```



```sql

(select id,mid from case_article where mid >1900000) union all (select id,mid from case_article where mid <1000);

```

```
+----+--------------+--------------+-------+---------------+------+---------+------+--------+-------------+
| id | select_type  | table        | type  | possible_keys | key  | key_len | ref  | rows   | Extra       |
+----+--------------+--------------+-------+---------------+------+---------+------+--------+-------------+
|  1 | PRIMARY      | case_article | range | mid           | mid  | 4       | NULL | 253595 | Using where |
|  2 | UNION        | case_article | range | mid           | mid  | 4       | NULL |   3116 | Using where |
| NULL | UNION RESULT | <union1,2>   | ALL   | NULL          | NULL | NULL    | NULL |   NULL |             |
+----+--------------+--------------+-------+---------------+------+---------+------+--------+-------------+

252507 rows in set (0.63561700 sec)

```

```sql

select count(id),mid from case_article where mid >1900000 or mid <1000 group by mid;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows   | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL | 256711 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+--------+-------------+

92702 rows in set (0.52456750 sec)


```



### title无做索引


```sql

select id from case_article where title = '(10).title';

```

```

+----+-------------+--------------+------+---------------+------+---------+------+---------+-------------+
| id | select_type | table        | type | possible_keys | key  | key_len | ref  | rows    | Extra       |
+----+-------------+--------------+------+---------------+------+---------+------+---------+-------------+
|  1 | SIMPLE      | case_article | ALL  | NULL          | NULL | NULL    | NULL | 5000000 | Using where |
+----+-------------+--------------+------+---------------+------+---------+------+---------+-------------+

1 row in set (1.23551125 sec)

```

### title做索引

```sql

select id from case_article where title = '(10).title';

```


```

+----+-------------+--------------+------+---------------+-------+---------+-------+------+-------------+
| id | select_type | table        | type | possible_keys | key   | key_len | ref   | rows | Extra       |
+----+-------------+--------------+------+---------------+-------+---------+-------+------+-------------+
|  1 | SIMPLE      | case_article | ref  | title         | title | 767     | const |    1 | Using where |
+----+-------------+--------------+------+---------------+-------+---------+-------+------+-------------+

1 row in set (0.00026075 sec)

```

```sql

select id from case_article where title = '(10).title' or title = '(40).title' or title = '(50).title';

```

```

+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | range | title         | title | 767     | NULL |    3 | Using where |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+

3 rows in set (0.00074250 sec)

```


```sql

select id from case_article where title in ('(10).title','(40).title','(50).title');

```

```

+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | range | title         | title | 767     | NULL |    3 | Using where |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+

3 rows in set (0.00074150 sec)

```



```sql

select id from case_article where title like '(10).title';

```

```

+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | range | title         | title | 767     | NULL |    1 | Using where |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+

1 row in set (0.00042425 sec)

```




```sql

select id from case_article where title like '%(10).title';

```


```

+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | range | title         | title | 767     | NULL |    1 | Using where |
+----+-------------+--------------+-------+---------------+-------+---------+------+------+-------------+

1 row in set (1.96752275 sec)


```

### group by与union方式查询比较


```sql

select count(id),mid from case_article where mid in (2,12,13) group by mid;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL |    5 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+------+-------------+

3 rows in set (0.00056525 sec)

```



```sql

(select count(id),mid from case_article where mid =2) union all (select count(id),mid from case_article where mid =12) union all (select count(id),mid from case_article where mid =13);

```

```

+----+--------------+--------------+------+---------------+------+---------+-------+------+-------+
| id | select_type  | table        | type | possible_keys | key  | key_len | ref   | rows | Extra |
+----+--------------+--------------+------+---------------+------+---------+-------+------+-------+
|  1 | PRIMARY      | case_article | ref  | mid           | mid  | 4       | const |    3 |       |
|  2 | UNION        | case_article | ref  | mid           | mid  | 4       | const |    1 |       |
|  3 | UNION        | case_article | ref  | mid           | mid  | 4       | const |    1 |       |
| NULL | UNION RESULT | <union1,2,3> | ALL  | NULL          | NULL | NULL    | NULL  | NULL |       |
+----+--------------+--------------+------+---------------+------+---------+-------+------+-------+

3 rows in set (0.00045425 sec)

```


```sql

select count(b.id),a.createtime from case_member as a left join case_article as b on a.id = b.mid where a.createtime = 1406038366 or a.createtime = 1406038367 group by a.createtime;

```

```

+----+-------------+-------+-------+---------------+------------+---------+-----------+------+-------------+
| id | select_type | table | type  | possible_keys | key        | key_len | ref       | rows | Extra       |
+----+-------------+-------+-------+---------------+------------+---------+-----------+------+-------------+
|  1 | SIMPLE      | a     | range | createtime    | createtime | 4       | NULL      |   15 | Using where |
|  1 | SIMPLE      | b     | ref   | mid           | mid        | 4       | test.a.id |   19 |             |
+----+-------------+-------+-------+---------------+------------+---------+-----------+------+-------------+

2 rows in set (0.00045750 sec)

```


```sql

select count(a.id),b.createtime from case_article as a left join case_member as b on a.mid = b.id where b.createtime = 1406038366 or b.createtime = 1406038367 group by b.createtime;

```

```
+----+-------------+-------+-------+---------------+------------+---------+-----------+------+-------------+
| id | select_type | table | type  | possible_keys | key        | key_len | ref       | rows | Extra       |
+----+-------------+-------+-------+---------------+------------+---------+-----------+------+-------------+
|  1 | SIMPLE      | a     | range | createtime    | createtime | 4       | NULL      |   15 | Using where |
|  1 | SIMPLE      | b     | ref   | mid           | mid        | 4       | test.a.id |   19 |             |
+----+-------------+-------+-------+---------------+------------+---------+-----------+------+-------------+

2 rows in set (0.00068375 sec)

```


```sql

(select count(b.id),a.createtime from case_member as a left join case_article as b on a.id = b.mid where a.createtime = 1406038366) union all (select count(b.id),a.createtime from case_member as a left join case_article as b on a.id = b.mid where a.createtime = 1406038367);

```

```

+----+--------------+------------+------+---------------+------------+---------+-----------+------+-------+
| id | select_type  | table      | type | possible_keys | key        | key_len | ref       | rows | Extra |
+----+--------------+------------+------+---------------+------------+---------+-----------+------+-------+
|  1 | PRIMARY      | a          | ref  | createtime    | createtime | 4       | const     |    8 |       |
|  1 | PRIMARY      | b          | ref  | mid           | mid        | 4       | test.a.id |   19 |       |
|  2 | UNION        | a          | ref  | createtime    | createtime | 4       | const     |    7 |       |
|  2 | UNION        | b          | ref  | mid           | mid        | 4       | test.a.id |   19 |       |
| NULL | UNION RESULT | <union1,2> | ALL  | NULL          | NULL       | NULL    | NULL      | NULL |       |
+----+--------------+------------+------+---------------+------------+---------+-----------+------+-------+

2 rows in set (0.00085850 sec)

```



```sql

select count(b.id),a.createtime from case_member as a,case_article as b where a.id = b.mid and (a.createtime = 1406038366 or a.createtime = 1406038367) group by a.createtime;

```

```
+----+-------------+-------+-------+--------------------+------------+---------+-----------+------+-------------+
| id | select_type | table | type  | possible_keys      | key        | key_len | ref       | rows | Extra       |
+----+-------------+-------+-------+--------------------+------------+---------+-----------+------+-------------+
|  1 | SIMPLE      | a     | range | PRIMARY,createtime | createtime | 4       | NULL      |   15 | Using where |
|  1 | SIMPLE      | b     | ref   | mid                | mid        | 4       | test.a.id |   19 |             |
+----+-------------+-------+-------+--------------------+------------+---------+-----------+------+-------------+

2 rows in set (0.00057425 sec)

```

```sql

(select count(b.id),a.createtime from case_member as a,case_article as b where a.id = b.mid and (a.createtime = 1406038366)) union all (select count(b.id),a.createtime from case_member as a,case_article as b where a.id = b.mid and (a.createtime = 1406038367));

```

```

+----+--------------+------------+------+--------------------+------------+---------+-----------+------+-------+
| id | select_type  | table      | type | possible_keys      | key        | key_len | ref       | rows | Extra |
+----+--------------+------------+------+--------------------+------------+---------+-----------+------+-------+
|  1 | PRIMARY      | a          | ref  | PRIMARY,createtime | createtime | 4       | const     |    8 |       |
|  1 | PRIMARY      | b          | ref  | mid                | mid        | 4       | test.a.id |   19 |       |
|  2 | UNION        | a          | ref  | PRIMARY,createtime | createtime | 4       | const     |    7 |       |
|  2 | UNION        | b          | ref  | mid                | mid        | 4       | test.a.id |   19 |       |
| NULL | UNION RESULT | <union1,2> | ALL  | NULL               | NULL       | NULL    | NULL      | NULL |       |
+----+--------------+------------+------+--------------------+------------+---------+-----------+------+-------+

2 rows in set (0.00053550 sec)

```


```sql

select count(b.id),a.createtime from case_member as a inner join case_article as b on a.id = b.mid where a.createtime = 1406038366 or a.createtime = 1406038367 group by a.createtime;

```

```

+----+-------------+-------+-------+--------------------+------------+---------+-----------+------+-------------+
| id | select_type | table | type  | possible_keys      | key        | key_len | ref       | rows | Extra       |
+----+-------------+-------+-------+--------------------+------------+---------+-----------+------+-------------+
|  1 | SIMPLE      | a     | range | PRIMARY,createtime | createtime | 4       | NULL      |   15 | Using where |
|  1 | SIMPLE      | b     | ref   | mid                | mid        | 4       | test.a.id |   19 |             |
+----+-------------+-------+-------+--------------------+------------+---------+-----------+------+-------------+

2 rows in set (0.00046050 sec)

```


### 查询单条记录


```sql

select id from case_article limit 1;

```

```

+----+-------------+--------------+-------+---------------+---------+---------+------+---------+-------------+
| id | select_type | table        | type  | possible_keys | key     | key_len | ref  | rows    | Extra       |
+----+-------------+--------------+-------+---------------+---------+---------+------+---------+-------------+
|  1 | SIMPLE      | case_article | index | NULL          | PRIMARY | 4       | NULL | 5000000 | Using index |
+----+-------------+--------------+-------+---------------+---------+---------+------+---------+-------------+

1 rows in set (0.00040625 sec)

```


```sql

select id from case_article order by id asc limit 1;

```

```

+----+-------------+--------------+-------+---------------+---------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key     | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+---------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | index | NULL          | PRIMARY | 4       | NULL |    1 | Using index |
+----+-------------+--------------+-------+---------------+---------+---------+------+------+-------------+

1 rows in set (0.00034825 sec)

```


```sql

select id from case_article order by mid asc limit 1;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+------+-------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows | Extra |
+----+-------------+--------------+-------+---------------+------+---------+------+------+-------+
|  1 | SIMPLE      | case_article | index | NULL          | mid  | 4       | NULL |    1 |       |
+----+-------------+--------------+-------+---------------+------+---------+------+------+-------+

1 rows in set (0.00036500 sec)

```



```sql

select id,mid from case_article where mid between  1000 and 1500 order by mid asc;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+------+-------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows | Extra       |
+----+-------------+--------------+-------+---------------+------+---------+------+------+-------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL | 1521 | Using where |
+----+-------------+--------------+-------+---------------+------+---------+------+------+-------------+

1304 rows in set (0.04822150 sec)

```




### 查询最近发布文章的用户列表


```sql

select mid,max(publishtime) as max_publishtime from case_article group by mid order by max_publishtime;


```

```

+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+
| id | select_type | table        | type | possible_keys | key  | key_len | ref  | rows    | Extra                           |
+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+
|  1 | SIMPLE      | case_article | ALL  | NULL          | NULL | NULL    | NULL | 5000000 | Using temporary; Using filesort |
+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+

1835947 rows in set (52.97973200 sec)

```


```sql
 
select mid,max(publishtime) as max_publishtime from case_article where mid in (1000,10000,100000) group by mid order by max_publishtime;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+------+----------------------------------------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows | Extra                                        |
+----+-------------+--------------+-------+---------------+------+---------+------+------+----------------------------------------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL |    5 | Using where; Using temporary; Using filesort |
+----+-------------+--------------+-------+---------------+------+---------+------+------+----------------------------------------------+

2 rows in set (0.00034525 sec)

```


```sql

select mid,max(publishtime) as max_publishtime from case_article group by mid;

```

```

+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+
| id | select_type | table        | type | possible_keys | key  | key_len | ref  | rows    | Extra                           |
+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+
|  1 | SIMPLE      | case_article | ALL  | NULL          | NULL | NULL    | NULL | 5000000 | Using temporary; Using filesort |
+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+


1835947 rows in set (47.17097075 sec)

```


### 查询最近发布文章的前10用户列表



```sql

select mid,max(publishtime) as max_publishtime from case_article group by mid order by max_publishtime desc limit 10;

```

```

+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+
| id | select_type | table        | type | possible_keys | key  | key_len | ref  | rows    | Extra                           |
+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+
|  1 | SIMPLE      | case_article | ALL  | NULL          | NULL | NULL    | NULL | 5000000 | Using temporary; Using filesort |
+----+-------------+--------------+------+---------------+------+---------+------+---------+---------------------------------+

10 rows in set (47.24095550 sec)

```

### 统计mid数

```sql

select count(distinct mid) from case_article where mid < 290000;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+------+---------------------------------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows | Extra                                 |
+----+-------------+--------------+-------+---------------+------+---------+------+------+---------------------------------------+
|  1 | SIMPLE      | case_article | range | mid           | mid  | 4       | NULL |    1 | Using where; Using index for group-by |
+----+-------------+--------------+-------+---------------+------+---------+------+------+---------------------------------------+

1 row in set (0.40 sec)

```

```sql

select count(1) from (select mid from case_article where mid < 290000 group by mid) as a;

```

```

+----+-------------+--------------+-------+---------------+------+---------+------+------+---------------------------------------+
| id | select_type | table        | type  | possible_keys | key  | key_len | ref  | rows | Extra                                 |
+----+-------------+--------------+-------+---------------+------+---------+------+------+---------------------------------------+
|  1 | PRIMARY     | NULL         | NULL  | NULL          | NULL | NULL    | NULL | NULL | Select tables optimized away          |
|  2 | DERIVED     | case_article | range | mid           | mid  | 4       | NULL |    2 | Using where; Using index for group-by |
+----+-------------+--------------+-------+---------------+------+---------+------+------+---------------------------------------+


1 row in set (0.46 sec)

```