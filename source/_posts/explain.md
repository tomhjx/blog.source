---
title: explain
categories:
  - 数据库
  - MySQL
tags:
  - 实录
  - MySQL
  - explain
date: 2016-01-03 16:26:06
---

```sql

CREATE TABLE `case1_article` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `mid` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `title` VARCHAR(255) NOT NULL,
    `n_click` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `content` TEXT NOT NULL,
    `publishtime` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `status` TINYINT(4) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    INDEX `mid` (`mid`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=100001;

CREATE TABLE `case1_member` (
    `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `createtime` INT(10) UNSIGNED NOT NULL,
    `status` TINYINT(4) NOT NULL,
    PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=10001;

```

```sql

explain select a.id,b.name from case1_article as a left join  case1_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1;

```

```

+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows   | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 100752 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |      1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+

```

-----


```sql

explain select a.id,b.name from case1_article as a left join  case1_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 order by a.id desc limit 100;

```

```

+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
|  1 | SIMPLE      | a     | index  | mid           | PRIMARY | 4       | NULL       |  100 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |    1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+

```

-----



```sql

explain select a.id,b.name from case1_article as a left join  case1_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 limit 100;

```

```
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows   | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 100752 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |      1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+

```

-----



```sql

explain select a.id,b.name from case1_article as a left join  case1_member as b on a.mid = b.id where a.`status`=1 and b.`status`=1 order by a.id asc limit 100;

```
```
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
|  1 | SIMPLE      | a     | index  | mid           | PRIMARY | 4       | NULL       |  100 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |    1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
```


-----


```sql

explain select a.id,b.name from case1_article as a,case1_member as b where a.mid = b.id and  a.`status`=1 and b.`status`=1;

```
```
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows   | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 100752 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |      1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
```

-----


```sql

explain select a.id,b.name from case1_article as a,case1_member as b where a.mid = b.id and  a.`status`=1 and b.`status`=1 limit 100;

```

```
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows   | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+
|  1 | SIMPLE      | a     | ALL    | mid           | NULL    | NULL    | NULL       | 100752 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |      1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+--------+-------------+

```

-----

```sql

explain select a.id,b.name from case1_article as a,case1_member as b where a.mid = b.id and  a.`status`=1 and b.`status`=1 order by a.id limit 100;

```


```
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
| id | select_type | table | type   | possible_keys | key     | key_len | ref        | rows | Extra       |
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+
|  1 | SIMPLE      | a     | index  | mid           | PRIMARY | 4       | NULL       |  100 | Using where |
|  1 | SIMPLE      | b     | eq_ref | PRIMARY       | PRIMARY | 4       | test.a.mid |    1 | Using where |
+----+-------------+-------+--------+---------------+---------+---------+------------+------+-------------+

```

-----


```sql

explain select * from case1_article where mid = 1;

```

```
+----+-------------+---------------+------+---------------+------+---------+-------+------+-------+
| id | select_type | table         | type | possible_keys | key  | key_len | ref   | rows | Extra |
+----+-------------+---------------+------+---------------+------+---------+-------+------+-------+
|  1 | SIMPLE      | case1_article | ref  | mid           | mid  | 4       | const |   10 |       |
+----+-------------+---------------+------+---------------+------+---------+-------+------+-------+
```

-----


```sql

explain select id from case1_article where mid = 2 or mid =12 or mid=13;

```

```

+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
| id | select_type | table         | type  | possible_keys | key  | key_len | ref  | rows | Extra                    |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
|  1 | SIMPLE      | case1_article | range | mid           | mid  | 4       | NULL |   27 | Using where; Using index |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+

```

-----


```sql

explain select id from case1_article where mid in (2,12,13);

```

```
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
| id | select_type | table         | type  | possible_keys | key  | key_len | ref  | rows | Extra                    |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
|  1 | SIMPLE      | case1_article | range | mid           | mid  | 4       | NULL |   27 | Using where; Using index |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
```

-----


```sql

explain select id from case1_article where mid between 2 and 13;

```


```

+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
| id | select_type | table         | type  | possible_keys | key  | key_len | ref  | rows | Extra                    |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
|  1 | SIMPLE      | case1_article | range | mid           | mid  | 4       | NULL |  122 | Using where; Using index |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+

```

-----


```sql

explain select count(id),mid from case1_article where mid in (2,12,13) group by mid;

```

```

+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
| id | select_type | table         | type  | possible_keys | key  | key_len | ref  | rows | Extra                    |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+
|  1 | SIMPLE      | case1_article | range | mid           | mid  | 4       | NULL |   27 | Using where; Using index |
+----+-------------+---------------+-------+---------------+------+---------+------+------+--------------------------+

```

-----


```sql


explain (select count(id),mid from case1_article where mid =2) union all (select count(id),mid from case1_article where mid =12) union all (select count(id),mid from case1_article where mid =13);

```

```

+----+--------------+---------------+------+---------------+------+---------+-------+------+-------------+
| id | select_type  | table         | type | possible_keys | key  | key_len | ref   | rows | Extra       |
+----+--------------+---------------+------+---------------+------+---------+-------+------+-------------+
|  1 | PRIMARY      | case1_article | ref  | mid           | mid  | 4       | const |   10 | Using index |
|  2 | UNION        | case1_article | ref  | mid           | mid  | 4       | const |   10 | Using index |
|  3 | UNION        | case1_article | ref  | mid           | mid  | 4       | const |    7 | Using index |
| NULL | UNION RESULT | <union1,2,3>  | ALL  | NULL          | NULL | NULL    | NULL  | NULL |             |
+----+--------------+---------------+------+---------------+------+---------+-------+------+-------------+

```