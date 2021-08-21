---
title: PHP Version 7.3.0 Published
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
date: 2018-12-06 15:00:00
---

# 目标及关键路径

* 性能提升


# 从 PHP 7.2.x 移植到 PHP 7.3.x

[这里可以找到原文](https://www.php.net/manual/zh/migration73.php)

## 不向下兼容的变更

* Due to the introduction of [flexible heredoc/nowdoc syntax](https://www.php.net/manual/zh/migration73.new-features.php#migration73.new-features.core.heredoc), doc strings that contain the ending label inside their body may cause syntax errors or change in interpretation.

* Continue Targeting Switch issues Warning. `continue` statements targeting `switch` control flow structures will now generate a warning. In PHP such `continue` statements are equivalent to `break`, while they behave as `continue 2` in other languages.

* Strict Interpretation of Integer String Keys on ArrayAccess. Array accesses of type `$obj["123"]`, where `$obj` implements **ArrayAccess** and `"123"` is an integer string literal will no longer result in an implicit conversion to integer, i.e., `$obj->offsetGet("123")` will be called instead of `$obj->offsetGet(123)`. This matches existing behavior for non-literals. The behavior of arrays is not affected in any way, they continue to implicitly convert integral string keys to integers.

* In PHP, static properties are shared between inheriting classes, unless the static property is explicitly overridden in a child class. However, due to an implementation artifact it was possible to separate the static properties by assigning a reference. This loophole has been fixed.

* References returned by array and property accesses are now unwrapped as part of the access. This means that it is no longer possible to modify the reference between the access and the use of the accessed value.

* Argument unpacking stopped working with Traversables with non-integer keys. The following code worked in PHP 5.6-7.2 by accident.

* The ext_skel utility has been completely redesigned with new options and some old options removed. This is now written in PHP and has no external dependencies.

* Exceptions thrown due to automatic conversion of warnings into exceptions in `EH_THROW` mode (e.g. some [DateTime](https://www.php.net/manual/zh/class.datetime.php) exceptions) no longer populate [error\_get\_last()](https://www.php.net/manual/zh/function.error-get-last.php) state. As such, they now work the same way as manually thrown exceptions.

* [TypeError](https://www.php.net/manual/zh/class.typeerror.php) now reports wrong types as `int` and `bool` instead of `integer` and `boolean`, respectively.

* Undefined variables passed to [compact()](https://www.php.net/manual/zh/function.compact.php) will now be reported as a notice.

* [getimagesize()](https://www.php.net/manual/zh/function.getimagesize.php) and related functions now report the mime type of BMP images as `image/bmp` instead of `image/x-ms-bmp`, since the former has been registered with the IANA (see [» RFC 7903](http://www.faqs.org/rfcs/rfc7903)).

* [stream\_socket\_get\_name()](https://www.php.net/manual/zh/function.stream-socket-get-name.php) will now return IPv6 addresses wrapped in brackets. For example `"[::1]:1337"` will be returned instead of `"::1:1337"`.

* Support for BeOS has been dropped.

* BCMath Arbitrary Precision Mathematics

  * All warnings thrown by [BCMath functions](https://www.php.net/manual/zh/ref.bc.php) are now using PHP's error handling. Formerly some warnings have directly been written to stderr.

  * [bcmul()](https://www.php.net/manual/zh/function.bcmul.php) and [bcpow()](https://www.php.net/manual/zh/function.bcpow.php) now return numbers with the requested scale. Formerly, the returned numbers may have omitted trailing decimal zeroes.

* IMAP, POP3 and NNTP. **rsh**/**ssh** logins are disabled by default. Use [imap.enable\_insecure\_rsh](https://www.php.net/manual/zh/imap.configuration.php#ini.imap.enable-insecure-rsh) if you want to enable them. Note that the IMAP library does not filter mailbox names before passing them to the **rsh**/**ssh** command, thus passing untrusted data to this function with **rsh**/**ssh** enabled is insecure.

* Due to added support for named captures, `mb_ereg_*()` patterns using named captures will behave differently. In particular named captures will be part of matches and [mb\_ereg\_replace()](https://www.php.net/manual/zh/function.mb-ereg-replace.php) will interpret additional syntax. See [Named Captures](https://www.php.net/manual/zh/migration73.new-features.php#migration73.new-features.mbstring.named-captures) for more information.

* MySQL Improved Extension. Prepared statements now properly report the fractional seconds for DATETIME, TIME and TIMESTAMP columns with decimals specifier (e.g. TIMESTAMP(6) when using microseconds). Formerly, the fractional seconds part was simply omitted from the returned values.

* Prepared statements now properly report the fractional seconds for `DATETIME`, `TIME` and `TIMESTAMP` columns with decimals specifier (e.g. `TIMESTAMP(6)` when using microseconds). Formerly, the fractional seconds part was simply omitted from the returned values. Please note that this only affects the usage of [PDO\_MYSQL](https://www.php.net/manual/zh/ref.pdo-mysql.php) with emulated prepares turned off (e.g. using the native preparation functionality). Statements using connections having **`PDO::ATTR_EMULATE_PREPARES`**\=**`true`** (which is the default) were not affected by the bug fixed and have already been getting the proper fractional seconds values from the engine.

* [Reflection](https://www.php.net/manual/zh/book.reflection.php) export to string now uses `int` and `bool` instead of `integer` and `boolean`, respectively.

* If an [SPL](https://www.php.net/manual/zh/book.spl.php) autoloader throws an exception, following autoloaders will not be executed. Previously all autoloaders were executed and exceptions were chained.

* Mathematic operations involving [SimpleXML](https://www.php.net/manual/zh/book.simplexml.php) objects will now treat the text as an int or float, whichever is more appropriate. Previously values were treated as ints unconditionally.

* As of PHP 7.3.23, the names of incoming cookies are no longer url-decoded for security reasons.

--------

* 大小写不敏感的常量声明现已被废弃。将 **`true`** 作为第三个参数传递给 [define()](https://www.php.net/manual/zh/function.define.php) 将会导致一个废弃警告。大小写不敏感的使用（在读取时使用一个与声明时不同的大小写方式）也已被废弃。

* 废弃：在一个命名空间中声明一个名为 `assert()` 的函数。 [assert()](https://www.php.net/manual/zh/function.assert.php) 函数属于引擎特殊处理的情况，当在命名空间中使用相同名字去定义 函数时也许会导致不一致的行为。

* 废弃：将一个非字符串内容传递给字符串搜索函数。 在将来所有待搜索的内容都将被视为字符串，而不是 ASCII 编码值。如果需要依赖这个特性，你应该 要么显示地进行类型转换（转为字符串），或者显示地调用 [chr()](https://www.php.net/manual/zh/function.chr.php)。 以下是受到影响的方法：
  *   [strpos()](https://www.php.net/manual/zh/function.strpos.php)
  *   [strrpos()](https://www.php.net/manual/zh/function.strrpos.php)
  *   [stripos()](https://www.php.net/manual/zh/function.stripos.php)
  *   [strripos()](https://www.php.net/manual/zh/function.strripos.php)
  *   [strstr()](https://www.php.net/manual/zh/function.strstr.php)
  *   [strchr()](https://www.php.net/manual/zh/function.strchr.php)
  *   [strrchr()](https://www.php.net/manual/zh/function.strrchr.php)
  *   [stristr()](https://www.php.net/manual/zh/function.stristr.php)

* [fgetss()](https://www.php.net/manual/zh/function.fgetss.php) 函数和 [string.strip\_tags stream filter](https://www.php.net/manual/zh/filters.string.php) 已经被废弃。这同样影响了 [SplFileObject::fgetss()](https://www.php.net/manual/zh/splfileobject.fgetss.php) 方法和 [gzgetss()](https://www.php.net/manual/zh/function.gzgetss.php) 函数。


* 对于 FILTER_FLAG_SCHEME_REQUIRED 和 FILTER_FLAG_HOST_REQUIRED 常量的显示使用已被废弃。 总之，FILTER_VALIDATE_URL 已经隐含了这两者。

* [image2wbmp()](https://www.php.net/manual/zh/function.image2wbmp.php) 已被废弃。

* 如果 PHP 关联的ICU ≥ 56, 那么 Normalizer::NONE 形式的使用将会导致抛出一个废弃警告。

* 以下在文档中不存在的 `mbereg_*()` 别名已被废弃。请使用相应的 `mb_ereg_*()` 变体替代。
  *   **mbregex\_encoding()**
  *   **mbereg()**
  *   **mberegi()**
  *   **mbereg\_replace()**
  *   **mberegi\_replace()**
  *   **mbsplit()**
  *   **mbereg\_match()**
  *   **mbereg\_search()**
  *   **mbereg\_search\_pos()**
  *   **mbereg\_search\_regs()**
  *   **mbereg\_search\_init()**
  *   **mbereg\_search\_getregs()**
  *   **mbereg\_search\_getpos()**
  *   **mbereg\_search\_setpos()**

* [pdo\_odbc.db2\_instance\_name](https://www.php.net/manual/zh/ref.pdo-odbc.php#ini.pdo-odbc.db2-instance-name) ini 设置项在先前已被废弃。 它在文档中自 PHP 5.1.1 起被废弃


## 新特性

* Heredoc 和 Nowdoc 语法变的更灵活。现在支持闭合标记符的缩进，并且不再强制闭合标记符的换行。

* Array destructuring now supports reference assignments using the syntax `[&$a, [$b, &$c]] = $d`. The same is also supported for [list()](https://www.php.net/manual/zh/function.list.php).

* instanceof now allows literals as the first operand, in which case the result is always false.

* CompileError Exception instead of some Compilation Errors

* Trailing commas in function and method calls are now allowed.

* New options have been added to customize the FPM logging:
  * log_limit
  * log_buffering
  * decorate_workers_output

* [bcscale()](https://www.php.net/manual/zh/function.bcscale.php) can now also be used as getter to retrieve the current scale in use.

* Full support for LDAP Controls has been added to the [LDAP](https://www.php.net/manual/zh/book.ldap.php) querying functions and [ldap\_parse\_result()](https://www.php.net/manual/zh/function.ldap-parse-result.php)

* Multibyte String Functions 

  * Support for full case-mapping and case-folding has been added. Unlike simple case-mapping, full case-mapping may change the length of the string. 
  * Case-insensitive string operations now use case-folding instead of case- mapping during comparisons. This means that more characters will be considered (case insensitively) equal now.
  * [mb\_convert\_case()](https://www.php.net/manual/zh/function.mb-convert-case.php) with **`MB_CASE_TITLE`** now performs title-case conversion based on the Cased and CaseIgnorable derived Unicode properties. In particular this also improves handling of quotes and apostrophes.

  * The [Multibyte String](https://www.php.net/manual/zh/book.mbstring.php) data tables have been updated for Unicode 11.

  * The [Multibyte String Functions](https://www.php.net/manual/zh/ref.mbstring.php) now correctly support strings larger than 2GB.

  * Performance of the [Multibyte String](https://www.php.net/manual/zh/book.mbstring.php) extension has been significantly improved across the board. The largest improvements are in case conversion functions.

  * The mb_ereg_* functions now support named captures.

* Support for the `completion_append_character` and `completion_suppress_append` options has been added to [readline\_info()](https://www.php.net/manual/zh/function.readline-info.php). These options are only available if PHP is linked against libreadline (rather than libedit).

# 变化

[这里可以找到原文](https://www.php.net/ChangeLog-7.php#PHP_7_3)

