---
title: PHP Version 7.4.0 Published
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - PHP7
  - 历史
  - PHP发展史
  - 技术发展史
  - FFI C
  - CRC32C算法
date: 2019-11-28 15:00:00
---


# 目标及关键路径

* 性能提升

# 从 PHP 7.3.x 移植到 PHP 7.4.x

[这里可以找到原文](https://www.php.net/manual/zh/migration74.php)

## 不向下兼容的变更

* 尝试以数组方式访问 null，bool， int，float 或 resource （例如 $null["key"]）将会抛出 notice 通知。

* [get\_declared\_classes()](https://www.php.net/manual/zh/function.get-declared-classes.php) 函数将不再返回匿名的类，假如它们没有被实例化的话。

* fn 成为了保留关键词

* 文件尾部的 <?php 标签（不包含空行）将会被解释成一个 PHP 头标签。

* When using include/require on a stream, [streamWrapper::stream\_set\_option()](https://www.php.net/manual/zh/streamwrapper.stream-set-option.php) will be invoked with the **`STREAM_OPTION_READ_BUFFER`** option.

* 序列化类型 o 被移除。因为它不是由 PHP 生成的，这可能会影响到之前项目中手动生成的序列化字符串。

* 密码哈希算法标识符现在是可空字符串，而不再是整数。
  *   **`PASSWORD_DEFAULT`** 之前是 int 1; 现在是 **`null`**
  *   **`PASSWORD_BCRYPT`** 之前是 int 1; 现在是 string '2y'
  *   **`PASSWORD_ARGON2I`** 之前是 int 2; 现在是 string 'argon2i'
  *   **`PASSWORD_ARGON2ID`** 之前是 int 3; 现在是 string 'argon2id'

* [htmlentities()](https://www.php.net/manual/zh/function.htmlentities.php) will now raise a notice (instead of a strict standards warning) if it is used with an encoding for which only basic entity substitution is supported, in which case it is equivalent to [htmlspecialchars()](https://www.php.net/manual/zh/function.htmlspecialchars.php).

* [fread()](https://www.php.net/manual/zh/function.fread.php) 和 [fwrite()](https://www.php.net/manual/zh/function.fwrite.php) 在操作失败的时候会返回 **`false`**。

* BCMath functions will now warn if a non well-formed number is passed, such as "32foo".

* CURL
  * Attempting to serialize a [CURLFile](https://www.php.net/manual/zh/class.curlfile.php) class will now generate an exception. Previously the exception was only thrown on unserialization.
  * Using CURLPIPE_HTTP1 is deprecated, and is no longer supported as of cURL 7.62.0.
  * The `$version` parameter of [curl\_version()](https://www.php.net/manual/zh/function.curl-version.php) is deprecated. If any value not equal to the default CURLVERSION_NOW is passed, a warning is raised and the parameter is ignored.

* Date and Time

  * Calling [var\_dump()](https://www.php.net/manual/zh/function.var-dump.php) or similar on a [DateTime](https://www.php.net/manual/zh/class.datetime.php) or [DateTimeImmutable](https://www.php.net/manual/zh/class.datetimeimmutable.php) instance will no longer leave behind accessible properties on the object.

  * Comparison of [DateInterval](https://www.php.net/manual/zh/class.dateinterval.php) objects (using `==`, `<`, and so on) will now generate a warning and always return **`false`**. Previously all [DateInterval](https://www.php.net/manual/zh/class.dateinterval.php) objects were considered equal, unless they had properties.

* The default parameter value of [idn\_to\_ascii()](https://www.php.net/manual/zh/function.idn-to-ascii.php) and [idn\_to\_utf8()](https://www.php.net/manual/zh/function.idn-to-utf8.php) is now **`INTL_IDNA_VARIANT_UTS46`** instead of the deprecated **`INTL_IDNA_VARIANT_2003`**.


* MySQLi
  * The embedded server functionality has been removed. It was broken since at least PHP 7.0.
  * The undocumented `mysqli::$stat` property has been removed in favor of [mysqli::stat()](https://www.php.net/manual/zh/mysqli.stat.php).

* The [openssl\_random\_pseudo\_bytes()](https://www.php.net/manual/zh/function.openssl-random-pseudo-bytes.php) function will now throw an exception in error situations, similar to [random\_bytes()](https://www.php.net/manual/zh/function.random-bytes.php). In particular, an [Error](https://www.php.net/manual/zh/class.error.php) is thrown if the number of requested bytes is less than or equal to zero, and an [Exception](https://www.php.net/manual/zh/class.exception.php) is thrown if sufficient randomness cannot be gathered. The `$crypto_strong output` argument is guaranteed to always be **`true`** if the function does not throw, so explicitly checking it is not necessary.

* When PREG_UNMATCHED_AS_NULL mode is used, trailing unmatched capturing groups will now also be set to null (or [null, -1] if offset capture is enabled). This means that the size of the $matches will always be the same.

* Attempting to serialize a [PDO](https://www.php.net/manual/zh/class.pdo.php) or [PDOStatement](https://www.php.net/manual/zh/class.pdostatement.php) instance will now generate an [Exception](https://www.php.net/manual/zh/class.exception.php) rather than a [PDOException](https://www.php.net/manual/zh/class.pdoexception.php), consistent with other internal classes which do not support serialization.

* Reflection objects will now generate an exception if an attempt is made to serialize them. Serialization for reflection objects was never supported and resulted in corrupted reflection objects. It has been explicitly prohibited now.

* Standard PHP Library (SPL) 

  * Calling [get\_object\_vars()](https://www.php.net/manual/zh/function.get-object-vars.php) on an [ArrayObject](https://www.php.net/manual/zh/class.arrayobject.php) instance will now always return the properties of the [ArrayObject](https://www.php.net/manual/zh/class.arrayobject.php) itself (or a subclass). Other affected operations are:
    *   **ReflectionObject::getProperties()**
    *   [reset()](https://www.php.net/manual/zh/function.reset.php), [current()](https://www.php.net/manual/zh/function.current.php), etc. Use **Iterator** methods instead.
    *   Potentially others working on object properties as a list.

  * [SplPriorityQueue::setExtractFlags()](https://www.php.net/manual/zh/splpriorityqueue.setextractflags.php) will throw an exception if zero is passed. Previously this would generate a recoverable fatal error on the next extraction operation.

  * [ArrayObject](https://www.php.net/manual/zh/class.arrayobject.php), [ArrayIterator](https://www.php.net/manual/zh/class.arrayiterator.php), [SplDoublyLinkedList](https://www.php.net/manual/zh/class.spldoublylinkedlist.php) and [SplObjectStorage](https://www.php.net/manual/zh/class.splobjectstorage.php) now support the `__serialize()` and `__unserialize()` mechanism in addition to the **Serializable** interface. This means that serialization payloads created on older PHP versions can still be unserialized, but new payloads created by PHP 7.4 will not be understood by older versions.

* [token\_get\_all()](https://www.php.net/manual/zh/function.token-get-all.php) will now emit a **`T_BAD_CHARACTER`** token for unexpected characters instead of leaving behind holes in the token stream.

* 从 PHP 7.4.11 开始，为了安全考虑，接受到的 Cookie 中的 names 参数不再被 URL 编码。

-------

* 嵌套的三元操作中，必须明确使用显式括号来决定操作的顺序。

* 使用大括号访问数组及字符串索引的方式已被废弃。请使用 $var[$idx] 的语法来替代 $var{$idx}。

* `(real)` 类型已被废弃，请使用 `(float)` 来替代。

* 同时被废弃的还有 [is\_real()](https://www.php.net/manual/zh/function.is-real.php) 函数，请使用 [is\_float()](https://www.php.net/manual/zh/function.is-float.php) 来替代。

* Unbinding $this of a non-static closure that uses $this is deprecated.

* 在没有父类的类中使用 parent 关键词已被废弃，并且在将来的 PHP 版本中将会抛出一个编译错误。目前只在运行时访问父类时才会产生错误。

* 配置文件中的 [allow\_url\_include](https://www.php.net/manual/zh/filesystem.configuration.php#ini.allow-url-include) 选项被废弃。如果启用了该选项，将会产生一个弃用通知。

* 在下面这些基础转换函数中，[base\_convert()](https://www.php.net/manual/zh/function.base-convert.php), [bindec()](https://www.php.net/manual/zh/function.bindec.php), [octdec()](https://www.php.net/manual/zh/function.octdec.php) 和 [hexdec()](https://www.php.net/manual/zh/function.hexdec.php) 如果传入了非法字符，将会抛出一个弃用通知。函数会忽略掉无效字符后正常返回结果。前导空格和尾部空格，以及类型为 0x (取决于基数) 被允许传入。

* 在一个对象中使用 [array\_key\_exists()](https://www.php.net/manual/zh/function.array-key-exists.php) 已被废弃。请使用 [isset()](https://www.php.net/manual/zh/function.isset.php) 或 [property\_exists()](https://www.php.net/manual/zh/function.property-exists.php) 来替代。

* 魔术引号函数 [get\_magic\_quotes\_gpc()](https://www.php.net/manual/zh/function.get-magic-quotes-gpc.php) 和 [get\_magic\_quotes\_runtime()](https://www.php.net/manual/zh/function.get-magic-quotes-runtime.php) 已被废弃。它们将永远返回 **`false`**。

* [hebrevc()](https://www.php.net/manual/zh/function.hebrevc.php) 函数已被废弃。 可以用 `nl2br(hebrev($str))` 来替代，更好的方法是启用 Unicode RTL 来支持。

* [convert\_cyr\_string()](https://www.php.net/manual/zh/function.convert-cyr-string.php) 函数已被废弃。可以用 **mb\_convert\_string()**， [iconv()](https://www.php.net/manual/zh/function.iconv.php) 或 [UConverter](https://www.php.net/manual/zh/class.uconverter.php) 替代。

* [money\_format()](https://www.php.net/manual/zh/function.money-format.php) 函数已被废弃。 可以用更国际化的 [NumberFormatter](https://www.php.net/manual/zh/class.numberformatter.php) 功能来替代。

* [ezmlm\_hash()](https://www.php.net/manual/zh/function.ezmlm-hash.php) 函数已被废弃。

* [restore\_include\_path()](https://www.php.net/manual/zh/function.restore-include-path.php) 函数已被废弃。可以用 `ini_restore('include_path')` 替代。

* [implode()](https://www.php.net/manual/zh/function.implode.php) 允许反转参数顺序的特性已被废弃，请使用 `implode($glue, $parts)` 来替代 `implode($parts, $glue)`。

* COM, 导入类型库的大小写不敏感的常量注册已被废弃。

* FILTER_SANITIZE_MAGIC_QUOTES 已被废弃，使用 FILTER_SANITIZE_ADD_SLASHES 来替代。

* Multibyte String

  * Passing a non-string pattern to [mb\_ereg\_replace()](https://www.php.net/manual/zh/function.mb-ereg-replace.php) is deprecated. Currently, non-string patterns are interpreted as ASCII codepoints. In PHP 8, the pattern will be interpreted as a string instead.

  * Passing the encoding as 3rd parameter to [mb\_strrpos()](https://www.php.net/manual/zh/function.mb-strrpos.php) is deprecated. Instead pass a 0 offset, and encoding as 4th parameter.

* [ldap\_control\_paged\_result\_response()](https://www.php.net/manual/zh/function.ldap-control-paged-result-response.php) 和 [ldap\_control\_paged\_result()](https://www.php.net/manual/zh/function.ldap-control-paged-result.php) 函数已被废弃。控制页面操作可以使用 [ldap\_search()](https://www.php.net/manual/zh/function.ldap-search.php) 替代。

* Reflection

  * 调用 [ReflectionType::\_\_toString()](https://www.php.net/manual/zh/reflectiontype.tostring.php) 现在将会抛出一个弃用通知。 该方法从 PHP 7.1 开始，在 **ReflectionNamedType::getName()** 的文档中已经被声明废弃，但是由于技术原因，并没有抛出弃用通知。

  * The `export()` methods on all [Reflection](https://www.php.net/manual/zh/class.reflection.php) classes are deprecated.


* 常量 **`AI_IDN_ALLOW_UNASSIGNED`** 和 **`AI_IDN_USE_STD3_ASCII_RULES`** 在 [socket\_addrinfo\_lookup()](https://www.php.net/manual/zh/function.socket-addrinfo-lookup.php) 中不再可用，因为该常量在 glibc 中已被废弃。

* 这些扩展已经被转移到 PECL 中，不再是 PHP 发行版的一部分。这些扩展的 PECL 包版本将根据用户的需要来自行安装。

  *   [Firebird/Interbase](https://www.php.net/manual/zh/book.ibase.php) - access to an InterBase and/or Firebird based database is still available with the PDO Firebird driver.
  *   [Recode](https://www.php.net/manual/zh/book.recode.php)
  *   [WDDX](https://www.php.net/manual/zh/book.wddx.php)

## 新特性

* 类的属性中现在支持添加指定的类型。

* [箭头函数](https://www.php.net/manual/zh/functions.arrow.php) 提供了一种更简洁的定义函数的方法。

* 有限返回类型协变与参数类型逆变

* 空合并运算符赋值

* 数组展开操作

* 数字文字可以在数字之间包含下划线。

* Weak references allow the programmer to retain a reference to an object that does not prevent the object from being destroyed.

* 现在允许从 [\_\_toString()](https://www.php.net/manual/zh/language.oop5.magic.php#object.tostring) 抛出异常。之前的版本，将会导致一个致命错误。新版本中，之前发生致命错误的代码，已经被转换为 [Error](https://www.php.net/manual/zh/class.error.php) 异常。

* [CURLFile](https://www.php.net/manual/zh/class.curlfile.php) now supports stream wrappers in addition to plain file names, if the extension has been built against libcurl >= 7.56.0.

* The FILTER_VALIDATE_FLOAT filter now supports the min_range and max_range options, with the same semantics as FILTER_VALIDATE_INT.

* FFI is a new extension, which provides a simple way to call native functions, access native variables, and create/access data structures defined in C libraries.

* Added the IMG_FILTER_SCATTER image filter to apply a scatter filter to images.

* Added crc32c hash using Castagnoli's polynomial. This CRC32 variant is used by storage systems, such as iSCSI, SCTP, Btrfs and ext4.

* Added the [mb\_str\_split()](https://www.php.net/manual/zh/function.mb-str-split.php) function, which provides the same functionality as [str\_split()](https://www.php.net/manual/zh/function.str-split.php), but operating on code points rather than bytes.

* 新增 [缓存预加载](https://www.php.net/manual/zh/opcache.preloading.php) 特性。

* The [preg\_replace\_callback()](https://www.php.net/manual/zh/function.preg-replace-callback.php) and [preg\_replace\_callback\_array()](https://www.php.net/manual/zh/function.preg-replace-callback-array.php) functions now accept an additional `flags` argument, with support for the **`PREG_OFFSET_CAPTURE`** and **`PREG_UNMATCHED_AS_NULL`** flags. This influences the format of the matches array passed to to the callback function.

* PDO

  * The username and password can now be specified as part of the PDO DSN for the mysql, mssql, sybase, dblib, firebird and oci drivers. Previously this was only supported by the pgsql driver. If a username/password is specified both in the constructor and the DSN, the constructor takes precedence.

  * It is now possible to escape question marks in SQL queries to avoid them being interpreted as parameter placeholders. Writing ?? allows sending a single question mark to the database and e.g. use the PostgreSQL JSON key exists (?) operator.


* [PDOStatement::getColumnMeta()](https://www.php.net/manual/zh/pdostatement.getcolumnmeta.php) is now available.

* PDO_SQLite

  * PDOStatement::getAttribute(PDO::SQLITE_ATTR_READONLY_STATEMENT) allows checking whether the statement is read-only, i.e. if it doesn't modify the database.

  * PDO::setAttribute(PDO::SQLITE_ATTR_EXTENDED_RESULT_CODES, true) enables the use of SQLite3 extended result codes in PDO::errorInfo() and PDOStatement::errorInfo().

* SQLite3

  * Added **SQLite3::lastExtendedErrorCode()** to fetch the last extended result code.

  * Added `SQLite3::enableExtendedResultCodes($enable = true)`, which will make [SQLite3::lastErrorCode()](https://www.php.net/manual/zh/sqlite3.lasterrorcode.php) return extended result codes.

* Standard
  * [strip\_tags()](https://www.php.net/manual/zh/function.strip-tags.php) now also accepts an array of allowed tags: instead of `strip_tags($str, '<a><p>')` you can now write `strip_tags($str, ['a', 'p'])`.
  * A new mechanism for custom object serialization has been added, which uses two new magic methods: __serialize and __unserialize.
  * [array\_merge()](https://www.php.net/manual/zh/function.array-merge.php) and [array\_merge\_recursive()](https://www.php.net/manual/zh/function.array-merge-recursive.php) may now be called without any arguments, in which case they will return an empty array. This is useful in conjunction with the spread operator, e.g. `array_merge(...$arrays)`.
  * proc_open() function 
    * [proc\_open()](https://www.php.net/manual/zh/function.proc-open.php) now accepts an array instead of a string for the command.
    * [proc\_open()](https://www.php.net/manual/zh/function.proc-open.php) now supports `redirect` and `null` descriptors.

  * [password\_hash()](https://www.php.net/manual/zh/function.password-hash.php) now has the argon2i and argon2id implementations from the sodium extension when PHP is built without libargon.



# 变化

[这里可以找到原文](https://www.php.net/ChangeLog-7.php#PHP_7_4)