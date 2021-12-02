---
title: mySQL查询优化
categories:
  - 数据库
  - MySQL
tags:
  - MySQL
date: 2016-01-03 17:35:28
---


糟糕的SQL查询语句可对整个应用程序的运行产生严重的影响，其不仅消耗掉更多的数据库时间，且它将对其他应用组件产生影响。

　　如同其它学科，优化查询性能很大程度上决定于开发者的直觉。幸运的是，像MySQL这样的数据库自带有一些协助工具。本文简要讨论诸多工具之三种：使用索引，使用EXPLAIN分析查询以及调整MySQL的内部配置。

　　一、使用索引
　
　　MySQL允许对数据库表进行索引，以此能迅速查找记录，而无需一开始就扫描整个表，由此显著地加快查询速度。每个表最多可以做到16个索引，此外MySQL还支持多列索引及全文检索。

　　给表添加一个索引非常简单，只需调用一个CREATE INDEX命令并为索引指定它的域即可。列表A给出了一个例子：


mysql> CREATE INDEX idx_username ON users(username); 
Query OK， 1 row affected (0.15 sec) 
Records: 1  Duplicates: 0  Warnings: 0

　　列表 A

　　这里，对users表的username域做索引，以确保在WHERE或者HAVING子句中引用这一域的SELECT查询语句运行速度比没有添加索引时要快。通过SHOW INDEX命令可以查看索引已被创建（列表B）。

　　 
 
　　列表 B

　　值得注意的是：索引就像一把双刃剑。对表的每一域做索引通常没有必要，且很可能导致运行速度减慢，因为向表中插入或修改数据时，MySQL不得不每次都为这些额外的工作重新建立索引。另一方面，避免对表的每一域做索引同样不是一个非常好的主意，因为在提高插入记录的速度时，导致查询操作的速度减慢。这就需要找到一个平衡点，比如在设计索引系统时，考虑表的主要功能（数据修复及编辑）不失为一种明智的选择。

　　二、优化查询性能

　　在分析查询性能时，考虑EXPLAIN关键字同样很管用。EXPLAIN关键字一般放在SELECT查询语句的前面，用于描述MySQL如何执行查询操作、以及MySQL成功返回结果集需要执行的行数。下面的一个简单例子可以说明（列表C）这一过程：

　　 
 
　　列表 C

　　这里查询是基于两个表连接。EXPLAIN关键字描述了MySQL是如何处理连接这两个表。必须清楚的是，当前设计要求MySQL处理的是 country表中的一条记录以及city表中的整个4019条记录。这就意味着，还可使用其他的优化技巧改进其查询方法。例如，给city表添加如下索引（列表D）：


mysql> CREATE INDEX idx_ccode ON city(countrycode); 
Query OK， 4079 rows affected (0.15 sec) 
Records: 4079  Duplicates: 0  Warnings: 0

　　列表 D

　　现在，当我们重新使用EXPLAIN关键字进行查询时，我们可以看到一个显著的改进（列表E）：

　　

　　列表 E

　　在这个例子中，MySQL现在只需要扫描city表中的333条记录就可产生一个结果集，其扫描记录数几乎减少了90％！自然，数据库资源的查询速度更快，效率更高。

三、调整内部变量

　　MySQL是如此的开放，所以可轻松地进一步调整其缺省设置以获得更优的性能及稳定性。需要优化的一些关键变量如下：

　　改变索引缓冲区长度(key_buffer)

　　一般，该变量控制缓冲区的长度在处理索引表（读/写操作）时使用。MySQL使用手册指出该变量可以不断增加以确保索引表的最佳性能，并推荐使用与系统内存25％的大小作为该变量的值。这是MySQL十分重要的配置变量之一，如果你对优化和提高系统性能有兴趣，可以从改变 key_buffer_size变量的值开始。

　　改变表长(read_buffer_size)

　　当一个查询不断地扫描某一个表，MySQL会为它分配一段内存缓冲区。read_buffer_size变量控制这一缓冲区的大小。如果你认为连续扫描进行得太慢，可以通过增加该变量值以及内存缓冲区大小提高其性能。

　　设定打开表的数目的最大值(table_cache)

　　该变量控制MySQL在任何时候打开表的最大数目，由此能控制服务器响应输入请求的能力。它跟max_connections变量密切相关，增加 table_cache值可使MySQL打开更多的表，就如增加max_connections值可增加连接数一样。当收到大量不同数据库及表的请求时，可以考虑改变这一值的大小。

　　对缓长查询设定一个时间限制(long_query_time)

　　MySQL带有“慢查询日志”，它会自动地记录所有的在一个特定的时间范围内尚未结束的查询。这个日志对于跟踪那些低效率或者行为不端的查询以及寻找优化对象都非常有用。long_query_time变量控制这一最大时间限定，以秒为单位。

　　以上讨论并给出用于分析和优化SQL查询的三种工具的使用方法，以此提高你的应用程序性能。使用它们快乐地优化吧！

使用EXPLAIN语句检查SQL语句

　　当你在一条SELECT语句前放上关键词EXPLAIN，MySQL解释它将如何处理SELECT，提供有关表如何联结和以什么次序联结的信息。

　　借助于EXPLAIN，你可以知道你什么时候必须为表加入索引以得到一个使用索引找到记录的更快的SELECT。

EXPLAIN tbl_name

or  EXPLAIN SELECT select_options
EXPLAIN tbl_name是DESCRIBE tbl_name或SHOW COLUMNS FROM tbl_name的一个同义词。

　　从EXPLAIN的输出包括下面列：

　　·table 
　　输出的行所引用的表。

　　· type 
　　联结类型。各种类型的信息在下面给出。 
　　不同的联结类型列在下面，以最好到最差类型的次序： 
system const eq_ref ref range index ALL possible_keys

　　· key 
　　key列显示MySQL实际决定使用的键。如果没有索引被选择，键是NULL。

　　· key_len 
　　key_len列显示MySQL决定使用的键长度。如果键是NULL，长度是NULL。注意这告诉我们MySQL将实际使用一个多部键值的几个部分。

　　· ref 
　　ref列显示哪个列或常数与key一起用于从表中选择行。

　　· rows 
　　rows列显示MySQL相信它必须检验以执行查询的行数。

　　·Extra 
　　如果Extra列包括文字Only index，这意味着信息只用索引树中的信息检索出的。通常，这比扫描整个表要快。如果Extra列包括文字where used，它意味着一个WHERE子句将被用来限制哪些行与下一个表匹配或发向客户。
 
　　通过相乘EXPLAIN输出的rows行的所有值，你能得到一个关于一个联结要多好的提示。这应该粗略地告诉你MySQL必须检验多少行以执行查询。

　　例如，下面一个全连接：


mysql> EXPLAIN SELECT student.name From student，pet  
-> WHERE student.name=pet.owner;

　　其结论为：

+---------+------+---------------+------+---------+------+------+------------+
| table   | type | possible_keys | key  | key_len | ref  | rows | Extra      |
+---------+------+---------------+------+---------+------+------+------------+
| student | ALL  | NULL          | NULL |    NULL | NULL |   13 |            |
| pet     | ALL  | NULL          | NULL |    NULL | NULL |    9 | where used |
+---------+------+---------------+------+---------+------+------+------------+

　　SELECT 查询的速度

　　总的来说，当你想要使一个较慢的SELECT ... WHERE更快，检查的第一件事情是你是否能增加一个索引。在不同表之间的所有引用通常应该用索引完成。你可以使用EXPLAIN来确定哪个索引用于一条SELECT语句。

　　一些一般的建议：

　　·为了帮助MySQL更好地优化查询，在它已经装载了相关数据后，在一个表上运行myisamchk --analyze。这为每一个更新一个值，指出有相同值地平均行数（当然，对唯一索引，这总是1。）

　　·为了根据一个索引排序一个索引和数据，使用myisamchk --sort-index --sort-records=1（如果你想要在索引1上排序）。如果你有一个唯一索引，你想要根据该索引地次序读取所有的记录，这是使它更快的一个好方法。然而注意，这个排序没有被最佳地编写，并且对一个大表将花很长时间！

　　MySQL怎样优化WHERE子句


　　where优化被放在SELECT中，因为他们最主要在那里使用里，但是同样的优化被用于DELETE和UPDATE语句。

　　也要注意，本节是不完全的。MySQL确实作了许多优化而我们没有时间全部记录他们。

　　由MySQL实施的一些优化列在下面：

　　1、删除不必要的括号：
((a AND b) AND c OR (((a AND b) AND (c AND d))))
-> (a AND b AND c) OR (a AND b AND c AND d)

　　2、常数调入： 
(a-> b>5 AND b=c AND a=5

　　3、删除常数条件(因常数调入所需)：
(B>=5 AND B=5) OR (B=6 AND 5=5) OR (B=7 AND 5=6)
-> B=5 OR B=6

　　4、索引使用的常数表达式仅计算一次。

　　5、在一个单个表上的没有一个WHERE的COUNT(*)直接从表中检索信息。当仅使用一个表时，对任何NOT NULL表达式也这样做。

　　6、无效常数表达式的早期检测。MySQL快速检测某些SELECT语句是不可能的并且不返回行。

　　7、如果你不使用GROUP BY或分组函数(COUNT()、MIN()……)，HAVING与WHERE合并。

　　8、为每个子联结(sub join)，构造一个更简单的WHERE以得到一个更快的WHERE计算并且也尽快跳过记录。

　　9、所有常数的表在查询中的任何其他表前被首先读出。一个常数的表是：

　　·一个空表或一个有1行的表。

　　·与在一个UNIQUE索引、或一个PRIMARY KEY的WHERE子句一起使用的表，这里所有的索引部分使用一个常数表达式并且索引部分被定义为NOT NULL。

　　所有下列的表用作常数表

 mysql> SELECT * FROM t WHERE primary_key=1; 
mysql> SELECT * FROM t1，t2 
WHERE t1.primary_key=1 AND t2.primary_key=t1.id;

　　10、对联结表的最好联结组合是通过尝试所有可能性来找到:(。如果所有在ORDER BY和GROUP BY的列来自同一个表，那么当廉洁时，该表首先被选中。

　　11、如果有一个ORDER BY子句和一个不同的GROUP BY子句，或如果ORDER BY或GROUP BY包含不是来自联结队列中的第一个表的其他表的列，创建一个临时表。

　　12、如果你使用SQL_SMALL_RESULT，MySQL将使用一个在内存中的表。

　　13、因为DISTINCT被变换到在所有的列上的一个GROUP BY，DISTINCT与ORDER BY结合也将在许多情况下需要一张临时表。

　　14、每个表的索引被查询并且使用跨越少于30% 的行的索引。如果这样的索引没能找到，使用一个快速的表扫描。

　　15、在一些情况下，MySQL能从索引中读出行，甚至不咨询数据文件。如果索引使用的所有列是数字的，那么只有索引树被用来解答查询。

　　16、在每个记录被输出前，那些不匹配HAVING子句的行被跳过。

　　下面是一些很快的查询例子


 mysql> SELECT COUNT(*) FROM tbl_name; 
mysql> SELECT MIN(key_part1)，MAX(key_part1) FROM tbl_name; 
mysql> SELECT MAX(key_part2) FROM tbl_name 
           WHERE key_part_1=constant; 
mysql> SELECT ... FROM tbl_name 
           ORDER BY key_part1，key_part2，... LIMIT 10; 
mysql> SELECT ... FROM tbl_name 
           ORDER BY key_part1 DESC，key_part2 DESC，... LIMIT 10;

　　下列查询仅使用索引树就可解决(假设索引列是数字的)：


 mysql> SELECT key_part1，key_part2 FROM tbl_name WHERE key_part1=val; 
mysql> SELECT COUNT(*) FROM tbl_name 
           WHERE key_part1=val1 AND key_part2=val2; 
mysql> SELECT key_part2 FROM tbl_name GROUP BY key_part1;

　　下列查询使用索引以排序顺序检索，不用一次另外的排序：

 mysql> SELECT ... FROM tbl_name ORDER BY key_part1，key_part2，... 
mysql> SELECT ... FROM tbl_name ORDER BY key_part1 DESC，key_part2 DESC，...

MySQL怎样优化LEFT JOIN

在MySQL中，A LEFT JOIN B实现如下：

1、表B被设置为依赖于表A。

2、表A被设置为依赖于所有用在LEFT JOIN条件的表(除B外)。

3、所有LEFT JOIN条件被移到WHERE子句中。

4、进行所有标准的联结优化，除了一个表总是在所有它依赖的表之后被读取。如果有一个循环依赖，MySQL将发出一个错误。

5、进行所有标准的WHERE优化。

6、如果在A中有一行匹配WHERE子句，但是在B中没有任何行匹配LEFT JOIN条件，那么在B中生成所有列设置为NULL的一行。

7、如果你使用LEFT JOIN来找出在某些表中不存在的行并且在WHERE部分你有下列测试：column_name IS NULL，这里column_name 被声明为NOT NULL的列，那么MySQL在它已经找到了匹配LEFT JOIN条件的一行后，将停止在更多的行后寻找(对一特定的键组合)。

MySQL怎样优化LIMIT

在一些情况中，当你使用LIMIT #而不使用HAVING时，MySQL将以不同方式处理查询。

1、如果你用LIMIT只选择一些行，当MySQL一般比较喜欢做完整的表扫描时，它将在一些情况下使用索引。

2、如果你使用LIMIT #与ORDER BY，MySQL一旦找到了第一个 # 行，将结束排序而不是排序整个表。

3、当结合LIMIT #和DISTINCT时，MySQL一旦找到#个唯一的行，它将停止。

4、在一些情况下，一个GROUP BY能通过顺序读取键(或在键上做排序)来解决，并然后计算摘要直到键值改变。在这种情况下，LIMIT #将不计算任何不必要的GROUP。

5、只要MySQL已经发送了第一个#行到客户，它将放弃查询。

6、LIMIT 0将总是快速返回一个空集合。这对检查查询并且得到结果列的列类型是有用的。

7、临时表的大小使用LIMIT #计算需要多少空间来解决查询。

记录转载和修改的速度

很多时候关心的是优化 SELECT 查询，因为它们是最常用的查询，而且确定怎样优化它们并不总是直截了当。相对来说，将数据装入数据库是直截了当的。然而，也存在可用来改善数据装载操作效率的策略，其基本原理如下：

·成批装载较单行装载更快，因为在装载每个记录后，不需要刷新索引高速缓存；可在成批记录装入后才刷新。

·在表无索引时装载比索引后装载更快。如果有索引，不仅必须增加记录到数据文件，而且还要修改每个索引以反映增加了的新记录。

·较短的 SQL 语句比较长的 SQL 语句要快，因为它们涉及服务器方的分析较少，而且还因为将它们通过网络从客户机发送到服务器更快。

这些因素中有一些似乎微不足道（特别是最后一个因素），但如果要装载大量的数据，即使是很小的因素也会产生很大的不同结果。

INSERT查询的速度

插入一个记录的时间由下列组成：

·连接：(3)

·发送查询给服务器：(2)

·分析查询：(2)

·插入记录：（1 x 记录大小）

·插入索引：（1 x 索引）

·关闭：(1)

这里的数字有点与总体时间成正比。这不考虑打开表的初始开销(它为每个并发运行的查询做一次)。

表的大小以N log N (B 树)的速度减慢索引的插入。

加快插入的一些方法：

·如果你同时从同一客户插入很多行，使用多个值表的INSERT语句。这比使用分开INSERT语句快(在一些情况中几倍)。

·如果你从不同客户插入很多行，你能通过使用INSERT DELAYED语句得到更高的速度。

·注意，用MyISAM，如果在表中没有删除的行，能在SELECT:s正在运行的同时插入行。

·当从一个文本文件装载一个表时，使用LOAD DATA INFILE。这通常比使用很多INSERT语句快20倍。

·当表有很多索引时，有可能多做些工作使得LOAD DATA INFILE更快些。使用下列过程：

1、有选择地用CREATE TABLE创建表。例如使用mysql或Perl-DBI。

2、执行FLUSH TABLES，或外壳命令mysqladmin flush-tables。

3、使用myisamchk --keys-used=0 -rq /path/to/db/tbl_name。这将从表中删除所有索引的使用。

4、用LOAD DATA INFILE把数据插入到表中，这将不更新任何索引，因此很快。

5、如果你有myisampack并且想要压缩表，在它上面运行myisampack。

6、用myisamchk -r -q /path/to/db/tbl_name再创建索引。这将在将它写入磁盘前在内存中创建索引树，并且它更快，因为避免大量磁盘寻道。结果索引树也被完美地平衡。

7、执行FLUSH TABLES，或外壳命令mysqladmin flush-tables。

这个过程将被构造进在MySQL的某个未来版本的LOAD DATA INFILE。

·你可以锁定你的表以加速插入


mysql> LOCK TABLES a WRITE; 
mysql> INSERT INTO a VALUES (1，23)，(2，34)，(4，33); 
mysql> INSERT INTO a VALUES (8，26)，(6，29); 
mysql> UNLOCK TABLES;

 


　　主要的速度差别是索引缓冲区仅被清洗到磁盘上一次，在所有INSERT语句完成后。一般有与有不同的INSERT语句那样夺的索引缓冲区清洗。如果你能用一个单个语句插入所有的行，锁定就不需要。锁定也将降低多连接测试的整体时间，但是对某些线程最大等待时间将上升(因为他们等待锁)。例如：

thread 1 does 1000 inserts 
thread 2， 3， and 4 does 1 insert 
thread 5 does 1000 inserts 
 


如果你不使用锁定，2、3和4将在1和5前完成。如果你使用锁定，2、3和4将可能不在1或5前完成，但是整体时间应该快大约40%。因为INSERT， UPDATE和DELETE操作在MySQL中是很快的，通过为多于大约5次连续不断地插入或更新一行的东西加锁，你将获得更好的整体性能。如果你做很多一行的插入，你可以做一个LOCK TABLES，偶尔随后做一个UNLOCK TABLES(大约每1000行)以允许另外的线程存取表。这仍然将导致获得好的性能。当然，LOAD DATA INFILE对装载数据仍然是更快的。

为了对LOAD DATA INFILE和INSERT得到一些更快的速度，扩大关键字缓冲区。

UPDATE查询的速度

更改查询被优化为有一个写开销的一个SELECT查询。写速度依赖于被更新数据大小和被更新索引的数量。

使更改更快的另一个方法是推迟更改并且然后一行一行地做很多更改。如果你锁定表，做一行一行地很多更改比一次做一个快。

注意，动态记录格式的更改一个较长总长的记录，可能切开记录。因此如果你经常这样做，时不时地OPTIMIZE TABLE是非常重要的。

DELETE查询的速度

删除一个记录的时间精确地与索引数量成正比。为了更快速地删除记录，你可以增加索引缓存的大小。

从一个表删除所有行比删除行的一大部分也要得多。

索引对有效装载数据的影响

如果表是索引的，则可利用批量插入（LOAD DATA 或多行的 INSERT 语句）来减少索引的开销。这样会最小化索引更新的影响，因为索引只需要在所有行处理过时才进行刷新，而不是在每行处理后就刷新。

·如果需要将大量数据装入一个新表，应该创建该表且在未索引时装载，装载数据后才创建索引，这样做较快。一次创建索引（而不是每行修改一次索引）较快。

·如果在装载之前删除或禁用索引，装入数据后再重新创建或启用索引可能使装载更快。
·如果想对数据装载使用删除或禁用策略，一定要做一些实验，看这样做是否值得（如果将少量数据装入一个大表中，重建和索引所花费的时间可能比装载数据的时间还要长）。

可用DROP INDEX和CREATE INDEX 来删除和重建索引。

另一种可供选择的方法是利用 myisamchk 或 isamchk 禁用和启用索引。这需要在 MySQL 服务器主机上有一个帐户，并对表文件有写入权。为了禁用表索引，可进入相应的数据库目录，执行下列命令之一：


shell>myisamchk --keys-used=0 tbl_name 
shell>isamchk --keys-used=0 tbl_name 


　　对具有 .MYI 扩展名的索引文件的 MyISAM 表使用 myisamchk，对具有 .ISM 扩展名的索引文件的 ISAM 表使用 isamchk。在向表中装入数据后，按如下激活索引：


shell>myisamchk --recover --quick --keys-used=0 tbl_name 
shell>isamchk --recover --quick --keys-used=0 tbl_name


　　n 为表具有的索引数目。可用 --description 选项调用相应的实用程序得出这个值：


shell>myisamchk --discription tbl_name 
$isamchk --discription tbl_name

 
　　如果决定使用索引禁用和激活，应该使用第13章中介绍的表修复锁定协议以阻止服务器同时更改锁（虽然此时不对表进行修复，但要对它像表修复过程一样进行修改，因此需要使用相同的锁定协议）。

上述数据装载原理也适用于与需要执行不同操作的客户机有关的固定查询。例如，一般希望避免在频繁更新的表上长时间运行 SELECT 查询。长时间运行 SELECT 查询会产生大量争用，并降低写入程序的性能。一种可能的解决方法为，如果执行写入的主要是 INSERT 操作，那么先将记录存入一个临时表，然后定期地将这些记录加入主表中。如果需要立即访问新记录，这不是一个可行的方法。但只要能在一个较短的时间内不访问它们，就可以使用这个方法。使用临时表有两个方面的好处。首先，它减少了与主表上 SELECT 查询语句的争用，因此，执行更快。其次，从临时表将记录装入主表的总时间较分别装载记录的总时间少；相应的索引高速缓存只需在每个批量装载结束时进行刷新，而不是在每行装载后刷新。

这个策略的一个应用是进入 Web 服务器的Web 页访问 MySQL 数据库。在此情形下，可能没有保证记录立即进入主表的较高权限。

如果数据并不完全是那种在系统非正常关闭事件中插入的单个记录，那么减少索引刷新的另一策略是使用 MyISAM 表的 DELAYED_KEY_WRITE 表创建选项（如果将 MySQL 用于某些数据录入工作时可能会出现这种情况）。此选项使索引高速缓存只偶尔刷新，而不是在每次插入后都要刷新。

如果希望在服务器范围内利用延迟索引刷新，只要利用 --delayed-key-write 选项启动 mysqld 即可。在此情形下，索引块写操作延迟到必须刷新块以便为其他索引值腾出空间为止，或延迟到执行了一个 flush-tables 命令后，或延迟到该索引表关闭。
