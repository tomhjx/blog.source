---
title: PHP Version 7.1.0 Published
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
  - HTTP2
  - SQLite3
  - PCRE
  - CURL
date: 2016-12-01 15:06:06
---

# 目标及关键路径

* 提升性能
  *   New SSA based optimization framework (embedded into opcache)
  *   Global optimization of PHP bytecode based on type inference
  *   Highly specialized VM opcode handlers


# 从 PHP 7.0.x 移植到 PHP 7.1.x

[这里可以找到原文](https://www.php.net/manual/zh/migration71.php)

## 不向后兼容的变更

* 当传递参数过少时将抛出错误

* Dynamic calls for certain functions have been forbidden (in the form of `$func()` or `array_map('extract', ...)`, etc). These functions either inspect or modify another scope, and present with them ambiguous and unreliable behavior. The functions are as follows:

  *   [assert()](https://www.php.net/manual/zh/function.assert.php) - with a string as the first argument
  *   [compact()](https://www.php.net/manual/zh/function.compact.php)
  *   [extract()](https://www.php.net/manual/zh/function.extract.php)
  *   [func\_get\_args()](https://www.php.net/manual/zh/function.func-get-args.php)
  *   [func\_get\_arg()](https://www.php.net/manual/zh/function.func-get-arg.php)
  *   [func\_num\_args()](https://www.php.net/manual/zh/function.func-num-args.php)
  *   [get\_defined\_vars()](https://www.php.net/manual/zh/function.get-defined-vars.php)
  *   [mb\_parse\_str()](https://www.php.net/manual/zh/function.mb-parse-str.php) - with one arg
  *   [parse\_str()](https://www.php.net/manual/zh/function.parse-str.php) - with one arg

* The following names cannot be used to name classes, interfaces, or traits:
  *   void
  *   [iterable](https://www.php.net/manual/zh/language.types.iterable.php)

* Integer operations and conversions on numerical strings now respect scientific notation. This also includes the `(int)` cast operation, and the following functions: [intval()](https://www.php.net/manual/zh/function.intval.php) (where the base is 10), [settype()](https://www.php.net/manual/zh/function.settype.php), [decbin()](https://www.php.net/manual/zh/function.decbin.php), [decoct()](https://www.php.net/manual/zh/function.decoct.php), and [dechex()](https://www.php.net/manual/zh/function.dechex.php).

* [mt\_rand()](https://www.php.net/manual/zh/function.mt-rand.php) will now default to using the fixed version of the Mersenne Twister algorithm. If deterministic output from [mt\_srand()](https://www.php.net/manual/zh/function.mt-srand.php) was relied upon, then the **`MT_RAND_PHP`** with the ability to preserve the old (incorrect) implementation via an additional optional second parameter to [mt\_srand()](https://www.php.net/manual/zh/function.mt-srand.php).

* [rand()](https://www.php.net/manual/zh/function.rand.php) and [srand()](https://www.php.net/manual/zh/function.srand.php) have now been made aliases to [mt\_rand()](https://www.php.net/manual/zh/function.mt-rand.php) and [mt\_srand()](https://www.php.net/manual/zh/function.mt-srand.php), respectively. This means that the output for the following functions have changed: [rand()](https://www.php.net/manual/zh/function.rand.php), [shuffle()](https://www.php.net/manual/zh/function.shuffle.php), [str\_shuffle()](https://www.php.net/manual/zh/function.str-shuffle.php), and [array\_rand()](https://www.php.net/manual/zh/function.array-rand.php).

* The ASCII delete control character (0x7F) can no longer be used in identifiers that are not quoted.

* If the `error_log` ini setting is set to `syslog`, the PHP error levels are mapped to the syslog error levels. This brings finer differentiation in the error logs in contrary to the previous approach where all the errors are logged with the notice level only.

* 对于在执行构造方法时抛出异常的对象，现在析构方法绝不会被调用。在先前的版本中，这个行为取决于对象是否在构造方法以外的地方呗引用（例如一个错误堆栈回溯）

* call_user_func()不再支持对传址的函数的调用

* 对字符串使用一个空索引操作符（例如$str[] = $x）将会抛出一个致命错误， 而不是静默地将其转为一个数组。

* 下列ini配置项已经被移除：

  *   `session.entropy_file`
  *   `session.entropy_length`
  *   `session.hash_function`
  *   `session.hash_bits_per_character`

* The order of the elements in an array has changed when those elements have been automatically created by referencing them in a by reference assignment. 

* The internal sorting algorithm has been improved, what may result in different sort order of elements, which compare as equal, than before.

* The error message for E_RECOVERABLE errors has been changed from "Catchable fatal error" to "Recoverable fatal error".

* [DateTime](https://www.php.net/manual/zh/class.datetime.php) and [DateTimeImmutable](https://www.php.net/manual/zh/class.datetimeimmutable.php) now properly incorporate microseconds when constructed from the current time, either explicitly or with a relative string (e.g. `"first day of next month"`). This means that naive comparisons of two newly created instances will now more likely return **`false`** instead of **`true`**:

* [Fatal errors to Error exceptions conversions](https://www.php.net/manual/zh/migration71.incompatible.php#migration71.incompatible.fatal-errors-to-error-exceptions)

* Variables bound to a [closure](https://www.php.net/manual/zh/functions.anonymous.php) via the `use` construct cannot use the same name as any [superglobals](https://www.php.net/manual/zh/language.variables.predefined.php), $this, or any parameter. 

* [long2ip()](https://www.php.net/manual/zh/function.long2ip.php) now expects an int instead of a string.

* JSON encoding and decoding 

  * The `serialize_precision` ini setting now controls the serialization precision when encoding doubles.

  * Decoding an empty key now results in an empty property name, rather than _empty_ as a property name.

* Drop support for the sslv2 stream

* Return statements without argument in functions which declare a return type now trigger E_COMPILE_ERROR (unless the return type is declared as void), even if the return statement would never be reached.

------------

* mcrypt 扩展已经过时了大约10年，并且用起来很复杂。因此它被废弃并且被 OpenSSL 所取代。 从PHP 7.2起它将被从核心代码中移除并且移到PECL中。

* 对于[mb\_ereg\_replace()](https://www.php.net/manual/zh/function.mb-ereg-replace.php)和[mb\_eregi\_replace()](https://www.php.net/manual/zh/function.mb-eregi-replace.php)的 `e`模式修饰符现在已被废弃。

## 新特性

* 参数以及返回值的类型现在可以通过在类型前加上一个问号使之允许为空。 当启用这个特性时，传入的参数或者函数返回的结果要么是给定的类型，要么是 null 。

* 一个新的返回值类型void被引入。 返回值声明为 void 类型的方法要么干脆省去 return 语句，要么使用一个空的 return 语句。 对于 void 函数来说，null 不是一个合法的返回值。

* 短数组语法（`[]`）现在作为[list()](https://www.php.net/manual/zh/function.list.php)语法的一个备选项，可以用于将数组的值赋给一些变量（包括在`foreach`中）。

* 现在起支持设置类常量的可见性。

* 现在引入了一个新的被称为[iterable](https://www.php.net/manual/zh/language.types.iterable.php)的伪类 (与[callable](https://www.php.net/manual/zh/language.types.callable.php)类似)。 这可以被用在参数或者返回值类型中，它代表接受数组或者实现了**Traversable**接口的对象。 至于子类，当用作参数时，子类可以收紧父类的[iterable](https://www.php.net/manual/zh/language.types.iterable.php)类型到array 或一个实现了**Traversable**的对象。对于返回值，子类可以拓宽父类的 array或对象返回值类型到[iterable](https://www.php.net/manual/zh/language.types.iterable.php)。


* 一个catch语句块现在可以通过管道字符(|)来实现多个异常的捕获。 这对于需要同时处理来自不同类的不同异常时很有用。

* 现在[list()](https://www.php.net/manual/zh/function.list.php)和它的新的`[]`语法支持在它内部去指定键名。这意味着它可以将任意类型的数组 都赋值给一些变量（与短数组语法类似）

* 现在所有支持偏移量的[字符串操作函数](https://www.php.net/manual/zh/book.strings.php) 都支持接受负数作为偏移量，包括通过`[]`或`{}`操作[字符串下标](https://www.php.net/manual/zh/language.types.string.php#language.types.string.substr)。在这种情况下，一个负数的偏移量会被理解为一个从字符串结尾开始的偏移量。

* 通过给[openssl\_encrypt()](https://www.php.net/manual/zh/function.openssl-encrypt.php)和[openssl\_decrypt()](https://www.php.net/manual/zh/function.openssl-decrypt.php) 添加额外参数，现在支持了AEAD (模式 GCM and CCM)。

* [Closure](https://www.php.net/manual/zh/class.closure.php)新增了一个静态方法，用于将[callable](https://www.php.net/manual/zh/language.types.callable.php)快速地 转为一个[Closure](https://www.php.net/manual/zh/class.closure.php) 对象。


* 一个新的名为 [pcntl\_async\_signals()](https://www.php.net/manual/zh/function.pcntl-async-signals.php) 的方法现在被引入， 用于启用无需 ticks （这会带来很多额外的开销）的异步信号处理。


* 对服务器推送的支持现在已经被加入到 CURL 扩展中（ 需要版本 7.46 或更高）。这个可以通过 [curl\_multi\_setopt()](https://www.php.net/manual/zh/function.curl-multi-setopt.php) 函数与新的常量 **`CURLMOPT_PUSHFUNCTION`** 来进行调节。常量 **`CURL_PUST_OK`** 和 **`CURL_PUSH_DENY`** 也已经被添加进来，以便服务器推送的回调函数来表明自己会同意或拒绝处理。

* 新增 [tcp\_nodelay](https://www.php.net/manual/zh/context.socket.php#context.socket.tcp_nodelay) 选项。


# 变化

[这里可以找到原文](https://www.php.net/ChangeLog-7.php#PHP_7_1)


## Core

*   Change statement and fcall extension handlers to accept frame.
*   Number operators taking numeric strings now emit E\_NOTICEs or E\_WARNINGs when given malformed numeric strings.
*   (int), intval() where $base is 10 or unspecified, settype(), decbin(), decoct(), dechex(), integer operators and other conversions now always respect scientific notation in numeric strings.
*   Raise a compile-time warning on octal escape sequence overflow.
*   TypeError messages for arg\_info type checks will now say "must be ... or null" where the parameter or return type accepts null.
----

*   Added nullable types.
*   Added DFA optimization framework based on e-SSA form.
*   Added specialized opcode handlers (e.g. ZEND\_ADD\_LONG\_NO\_OVERFLOW).
*   Added \[\] = as alternative construct to list() =.
*   Added void return type.
*   Added support for negative string offsets in string offset syntax and various string functions.
*   Added a form of the list() construct where keys can be specified.
*   Implemented safe execution timeout handling, that prevents random crashes after "Maximum execution time exceeded" error.
*   Implemented the RFC \`Support Class Constant Visibility\`.
*   Implemented the RFC \`Catching multiple exception types\`.
*   Implemented logging to syslog with dynamic error levels.
*   Implemented FR [#72614](http://bugs.php.net/72614) (Support "nmake test" on building extensions by phpize).
*   Implemented RFC: Iterable.
*   Implemented RFC: Closure::fromCallable (Danack)
*   Implemented RFC: Replace "Missing argument" warning with "\\ArgumentCountError" exception.
*   Implemented RFC: Fix inconsistent behavior of $this variable.
*   Added new constant PHP\_FD\_SETSIZE.
*   Added optind parameter to getopt().
*   Added PHP to SAPI error severity mapping for logs.
*   Implemented RFC: RNG Fixes.
*   Implemented email validation as per RFC 6531.

----

*   Fixed bug [#73585](http://bugs.php.net/73585) (Logging of "Internal Zend error - Missing class information" missing class name).
*   Fixed memory leak(null coalescing operator with Spl hash).
*   Fixed bug [#72736](http://bugs.php.net/72736) (Slow performance when fetching large dataset with mysqli / PDO).
*   Fixed bug [#72978](http://bugs.php.net/72978) (Use After Free Vulnerability in unserialize()). (CVE-2016-9936)
*   Fixed bug [#72482](http://bugs.php.net/72482) (Ilegal write/read access caused by gdImageAALine overflow).
*   Fixed bug [#72696](http://bugs.php.net/72696) (imagefilltoborder stackoverflow on truecolor images). (CVE-2016-9933)
*   Fixed bug [#73350](http://bugs.php.net/73350) (Exception::\_\_toString() cause circular references).
*   Fixed bug [#73329](http://bugs.php.net/73329) ((Float)"Nano" == NAN).
*   Fixed bug [#73288](http://bugs.php.net/73288) (Segfault in \_\_clone > Exception.toString > \_\_get).
*   Fixed for [#73240](http://bugs.php.net/73240) (Write out of bounds at number\_format).
*   Fix pthreads detection when cross-compiling (ffontaine)
*   Fixed bug [#73337](http://bugs.php.net/73337) (try/catch not working with two exceptions inside a same operation).
*   Fixed bug [#73156](http://bugs.php.net/73156) (segfault on undefined function).
*   Fixed bug [#73163](http://bugs.php.net/73163) (PHP hangs if error handler throws while accessing undef const in default value).
*   Fixed bug [#73172](http://bugs.php.net/73172) (parse error: Invalid numeric literal).
*   Fixed bug [#73181](http://bugs.php.net/73181) (parse\_str() without a second argument leads to crash).
*   Fixed bug [#73025](http://bugs.php.net/73025) (Heap Buffer Overflow in virtual\_popen of zend\_virtual\_cwd.c).
*   Fixed bug [#73058](http://bugs.php.net/73058) (crypt broken when salt is 'too' long).
*   Fixed bug [#72944](http://bugs.php.net/72944) (Null pointer deref in zval\_delref\_p).
*   Fixed bug [#72943](http://bugs.php.net/72943) (assign\_dim on string doesn't reset hval).
*   Fixed bug [#72598](http://bugs.php.net/72598) (Reference is lost after array\_slice()).
*   Fixed bug [#72703](http://bugs.php.net/72703) (Out of bounds global memory read in BF\_crypt triggered by password\_verify).
*   Fixed bug [#72813](http://bugs.php.net/72813) (Segfault with \_\_get returned by ref).
*   Fixed bug [#72767](http://bugs.php.net/72767) (PHP Segfaults when trying to expand an infinite operator).
*   Fixed bug [#72857](http://bugs.php.net/72857) (stream\_socket\_recvfrom read access violation).
*   Fixed bug [#72663](http://bugs.php.net/72663) (Create an Unexpected Object and Don't Invoke \_\_wakeup() in Deserialization).
*   Fixed bug [#72681](http://bugs.php.net/72681) (PHP Session Data Injection Vulnerability).
*   Fixed bug [#72742](http://bugs.php.net/72742) (memory allocator fails to realloc small block to large one).
*   Fixed URL rewriter. It would not rewrite '//example.com/' URL unconditionally. URL rewrite target hosts whitelist is implemented.
*   Fixed bug [#72641](http://bugs.php.net/72641) (phpize (on Windows) ignores PHP\_PREFIX).
*   Fixed bug [#72683](http://bugs.php.net/72683) (getmxrr broken).
*   Fixed bug [#72629](http://bugs.php.net/72629) (Caught exception assignment to variables ignores references).
*   Fixed bug [#72594](http://bugs.php.net/72594) (Calling an earlier instance of an included anonymous class fatals).
*   Fixed bug [#72581](http://bugs.php.net/72581) (previous property undefined in Exception after deserialization).
*   Fixed bug [#72543](http://bugs.php.net/72543) (Different references behavior comparing to PHP 5).
*   Fixed bug [#72347](http://bugs.php.net/72347) (VERIFY\_RETURN type casts visible in finally).
*   Fixed bug [#72216](http://bugs.php.net/72216) (Return by reference with finally is not memory safe).
*   Fixed bug [#72215](http://bugs.php.net/72215) (Wrong return value if var modified in finally).
*   Fixed bug [#71818](http://bugs.php.net/71818) (Memory leak when array altered in destructor).
*   Fixed bug [#71539](http://bugs.php.net/71539) (Memory error on $arr\[$a\] =& $arr\[$b\] if RHS rehashes).
*   Fixed bug [#71911](http://bugs.php.net/71911) (Unable to set --enable-debug on building extensions by phpize on Windows).
*   Fixed bug [#29368](http://bugs.php.net/29368) (The destructor is called when an exception is thrown from the constructor).
*   Fixed bug [#72513](http://bugs.php.net/72513) (Stack-based buffer overflow vulnerability in virtual\_file\_ex).
*   Fixed bug [#72573](http://bugs.php.net/72573) (HTTP\_PROXY is improperly trusted by some PHP libraries and applications).
*   Fixed bug [#72523](http://bugs.php.net/72523) (dtrace issue with reflection (failed test)).
*   Fixed bug [#72508](http://bugs.php.net/72508) (strange references after recursive function call and "switch" statement).
*   Fixed bug [#72441](http://bugs.php.net/72441) (Segmentation fault: RFC list\_keys).
*   Fixed bug [#72395](http://bugs.php.net/72395) (list() regression).
*   Fixed bug [#72373](http://bugs.php.net/72373) (TypeError after Generator function w/declared return type finishes).
*   Fixed bug [#69489](http://bugs.php.net/69489) (tempnam() should raise notice if falling back to temp dir).
*   Fixed UTF-8 and long path support on Windows.
*   Fixed bug [#53432](http://bugs.php.net/53432) (Assignment via string index access on an empty string converts to array).
*   Fixed bug [#62210](http://bugs.php.net/62210) (Exceptions can leak temporary variables).
*   Fixed bug [#62814](http://bugs.php.net/62814) (It is possible to stiffen child class members visibility).
*   Fixed bug [#69989](http://bugs.php.net/69989) (Generators don't participate in cycle GC).
*   Fixed bug [#70228](http://bugs.php.net/70228) (Memleak if return in finally block).
*   Fixed bug [#71266](http://bugs.php.net/71266) (Missing separation of properties HT in foreach etc).
*   Fixed bug [#71604](http://bugs.php.net/71604) (Aborted Generators continue after nested finally).
*   Fixed bug [#71572](http://bugs.php.net/71572) (String offset assignment from an empty string inserts null byte).
*   Fixed bug [#71897](http://bugs.php.net/71897) (ASCII 0x7F Delete control character permitted in identifiers).
*   Fixed bug [#72188](http://bugs.php.net/72188) (Nested try/finally blocks losing return value).
*   Fixed bug [#72213](http://bugs.php.net/72213) (Finally leaks on nested exceptions).
*   Fixed bug [#47517](http://bugs.php.net/47517) (php-cgi.exe missing UAC manifest).

## Apache2handler

*   Enable per-module logging in Apache 2.4+.

##   BCmath
*   Fixed bug [#73190](http://bugs.php.net/73190) (memcpy negative parameter \_bc\_new\_num\_ex).

##   Bz2

*   Fixed bug [#72837](http://bugs.php.net/72837) (integer overflow in bzdecompress caused heap corruption).
*   Fixed bug [#72613](http://bugs.php.net/72613) (Inadequate error handling in bzread()).

##  Calendar

*   Fix integer overflows (Joshua Rogers)
*   Fixed bug [#67976](http://bugs.php.net/67976) (cal\_days\_month() fails for final month of the French calendar).
*   Fixed bug [#71894](http://bugs.php.net/71894) (AddressSanitizer: global-buffer-overflow in zif\_cal\_from\_jd).

## CLI Server

*   Fixed bug [#73360](http://bugs.php.net/73360) (Unable to work in root with unicode chars).
*   Fixed bug [#71276](http://bugs.php.net/71276) (Built-in webserver does not send Date header).

## COM

*   Fixed bug [#73126](http://bugs.php.net/73126) (Cannot pass parameter 1 by reference).
*   Fixed bug [#69579](http://bugs.php.net/69579) (Invalid free in extension trait).
*   Fixed bug [#72922](http://bugs.php.net/72922) (COM called from PHP does not return out parameters).
*   Fixed bug [#72569](http://bugs.php.net/72569) (DOTNET/COM array parameters broke in PHP7).
*   Fixed bug [#72498](http://bugs.php.net/72498) (variant\_date\_from\_timestamp null dereference).


## Curl

*   Implement support for handling [HTTP/2](https://zhuanlan.zhihu.com/p/26559480) Server Push.
*   Add curl\_multi\_errno(), curl\_share\_errno() and curl\_share\_strerror() functions.
-----

*   Fixed bug [#72674](http://bugs.php.net/72674) (Heap overflow in curl\_escape).
*   Fixed bug [#72541](http://bugs.php.net/72541) (size\_t overflow lead to heap corruption). (Stas).
*   Fixed bug [#71709](http://bugs.php.net/71709) (curl\_setopt segfault with empty CURLOPT\_HTTPHEADER).
*   Fixed bug [#71929](http://bugs.php.net/71929) (CURLINFO\_CERTINFO data parsing error).


##   Date

*   Invalid serialization data for a DateTime or DatePeriod object will now throw an instance of Error from \_\_wakeup() or \_\_set\_state() instead of resulting in a fatal error.
*   Timezone initialization failure from serialized data will now throw an instance of Error from \_\_wakeup() or \_\_set\_state() instead of resulting in a fatal error.
*   Export date\_get\_interface\_ce() for extension use.
----


*   Fixed bug [#69587](http://bugs.php.net/69587) (DateInterval properties and isset).
*   Fixed bug [#73426](http://bugs.php.net/73426) (createFromFormat with 'z' format char results in incorrect time).
*   Fixed bug [#45554](http://bugs.php.net/45554) (Inconsistent behavior of the u format char).
*   Fixed bug [#48225](http://bugs.php.net/48225) (DateTime parser doesn't set microseconds for "now").
*   Fixed bug [#52514](http://bugs.php.net/52514) (microseconds are missing in DateTime class).
*   Fixed bug [#52519](http://bugs.php.net/52519) (microseconds in DateInterval are missing).
*   Fixed bug [#60089](http://bugs.php.net/60089) (DateTime::createFromFormat() U after u nukes microtime).
*   Fixed bug [#64887](http://bugs.php.net/64887) (Allow DateTime modification with subsecond items).
*   Fixed bug [#68506](http://bugs.php.net/68506) (General DateTime improvments needed for microseconds to become useful).
*   Fixed bug [#73109](http://bugs.php.net/73109) (timelib\_meridian doesn't parse dots correctly).
*   Fixed bug [#73247](http://bugs.php.net/73247) (DateTime constructor does not initialise microseconds property).
*   Fixed bug [#73147](http://bugs.php.net/73147) (Use After Free in PHP7 unserialize()).
*   Fixed bug [#73189](http://bugs.php.net/73189) (Memcpy negative size parameter php\_resolve\_path).
*   Fixed bug [#66836](http://bugs.php.net/66836) (DateTime::createFromFormat 'U' with pre 1970 dates fails parsing).
*   Fixed bug [#63740](http://bugs.php.net/63740) (strtotime seems to use both sunday and monday as start of week).


##   Dba

*   Data modification functions (e.g.: dba\_insert()) now throw an instance of Error instead of triggering a catchable fatal error if the key is does not contain exactly two elements.
-----

*   Fixed bug [#70825](http://bugs.php.net/70825) (Cannot fetch multiple values with group in ini file).

##   DOM

*   Invalid schema or RelaxNG validation contexts will throw an instance of Error instead of resulting in a fatal error.
*   Attempting to register a node class that does not extend the appropriate base class will now throw an instance of Error instead of resulting in a fatal error.
*   Attempting to read an invalid or write to a readonly property will throw an instance of Error instead of resulting in a fatal error.
----

*   Fixed bug [#73150](http://bugs.php.net/73150) (missing NULL check in dom\_document\_save\_html).
*   Fixed bug [#66502](http://bugs.php.net/66502) (DOM document dangling reference).


##  DTrace

*   Disabled PHP call tracing by default (it makes significant overhead). This may be enabled again using envirionment variable USE\_ZEND\_DTRACE=1.

##  EXIF

*   Fixed bug [#72735](http://bugs.php.net/72735) (Samsung picture thumb not read (zero size)).
*   Fixed bug [#72627](http://bugs.php.net/72627) (Memory Leakage In exif\_process\_IFD\_in\_TIFF).
*   Fixed bug [#72603](http://bugs.php.net/72603) (Out of bound read in exif\_process\_IFD\_in\_MAKERNOTE).
*   Fixed bug [#72618](http://bugs.php.net/72618) (NULL Pointer Dereference in exif\_process\_user\_comment).


##  Filter

*   Fixed bug [#72972](http://bugs.php.net/72972) (Bad filter for the flags FILTER\_FLAG\_NO\_RES\_RANGE and FILTER\_FLAG\_NO\_PRIV\_RANGE).
*   Fixed bug [#73054](http://bugs.php.net/73054) (default option ignored when object passed to int filter).
*   Fixed bug [#71745](http://bugs.php.net/71745) (FILTER\_FLAG\_NO\_RES\_RANGE does not cover whole 127.0.0.0/8 range).


##  FPM

*   Fixed bug [#72575](http://bugs.php.net/72575) (using --allow-to-run-as-root should ignore missing user).


##   FTP

*   Implemented FR [#55651](http://bugs.php.net/55651) (Option to ignore the returned FTP PASV address).
----

*   Fixed bug [#70195](http://bugs.php.net/70195) (Cannot upload file using ftp\_put to FTPES with require\_ssl\_reuse).

##   GD

*   Fixed bug [#73213](http://bugs.php.net/73213) (Integer overflow in imageline() with antialiasing).
*   Fixed bug [#73272](http://bugs.php.net/73272) (imagescale() is not affected by, but affects imagesetinterpolation()).
*   Fixed bug [#73279](http://bugs.php.net/73279) (Integer overflow in gdImageScaleBilinearPalette()).
*   Fixed bug [#73280](http://bugs.php.net/73280) (Stack Buffer Overflow in GD dynamicGetbuf).
*   Fixed bug [#50194](http://bugs.php.net/50194) (imagettftext broken on transparent background w/o alphablending).
*   Fixed bug [#73003](http://bugs.php.net/73003) (Integer Overflow in gdImageWebpCtx of gd\_webp.c).
*   Fixed bug [#53504](http://bugs.php.net/53504) (imagettfbbox gives incorrect values for bounding box).
*   Fixed bug [#73157](http://bugs.php.net/73157) (imagegd2() ignores 3rd param if 4 are given).
*   Fixed bug [#73155](http://bugs.php.net/73155) (imagegd2() writes wrong chunk sizes on boundaries).
*   Fixed bug [#73159](http://bugs.php.net/73159) (imagegd2(): unrecognized formats may result in corrupted files).
*   Fixed bug [#73161](http://bugs.php.net/73161) (imagecreatefromgd2() may leak memory).
*   Fixed bug [#67325](http://bugs.php.net/67325) (imagetruecolortopalette: white is duplicated in palette).
*   Fixed bug [#66005](http://bugs.php.net/66005) (imagecopy does not support 1bit transparency on truecolor images).
*   Fixed bug [#72913](http://bugs.php.net/72913) (imagecopy() loses single-color transparency on palette images).
*   Fixed bug [#68716](http://bugs.php.net/68716) (possible resource leaks in \_php\_image\_convert()).
*   Fixed bug [#72709](http://bugs.php.net/72709) (imagesetstyle() causes OOB read for empty $styles).
*   Fixed bug [#72697](http://bugs.php.net/72697) (select\_colors write out-of-bounds).
*   Fixed bug [#72730](http://bugs.php.net/72730) (imagegammacorrect allows arbitrary write access).
*   Fixed bug [#72596](http://bugs.php.net/72596) (imagetypes function won't advertise WEBP support).
*   Fixed bug [#72604](http://bugs.php.net/72604) (imagearc() ignores thickness for full arcs).
*   Fixed bug [#70315](http://bugs.php.net/70315) (500 Server Error but page is fully rendered).
*   Fixed bug [#43828](http://bugs.php.net/43828) (broken transparency of imagearc for truecolor in blendingmode).
*   Fixed bug [#72512](http://bugs.php.net/72512) (gdImageTrueColorToPaletteBody allows arbitrary write/read access).
*   Fixed bug [#72519](http://bugs.php.net/72519) (imagegif/output out-of-bounds access).
*   Fixed bug [#72558](http://bugs.php.net/72558) (Integer overflow error within \_gdContributionsAlloc()).
*   Fixed bug [#72482](http://bugs.php.net/72482) (Ilegal write/read access caused by gdImageAALine overflow).
*   Fixed bug [#72494](http://bugs.php.net/72494) (imagecropauto out-of-bounds access).
*   Fixed bug [#72404](http://bugs.php.net/72404) (imagecreatefromjpeg fails on selfie).
*   Fixed bug [#43475](http://bugs.php.net/43475) (Thick styled lines have scrambled patterns).
*   Fixed bug [#53640](http://bugs.php.net/53640) (XBM images require width to be multiple of 8).
*   Fixed bug [#64641](http://bugs.php.net/64641) (imagefilledpolygon doesn't draw horizontal line).

##   Hash

*   Added SHA3 fixed mode algorithms (224, 256, 384, and 512 bit).
*   Added SHA512/256 and SHA512/224 algorithms.


##   iconv
*   Fixed bug [#72320](http://bugs.php.net/72320) (iconv\_substr returns false for empty strings).

##  IMAP
*   An email address longer than 16385 bytes will throw an instance of Error instead of resulting in a fatal error.
----
*   Fixed bug [#73418](http://bugs.php.net/73418) (Integer Overflow in "\_php\_imap\_mail" leads to crash).


##   Interbase
*   Fixed bug [#73512](http://bugs.php.net/73512) (Fails to find firebird headers as don't use fb\_config output).

##   Intl

*   Failure to call the parent constructor in a class extending Collator before invoking the parent methods will throw an instance of Error instead of resulting in a recoverable fatal error.
*   Cloning a Transliterator object may will now throw an instance of Error instead of resulting in a fatal error if cloning the internal transliterator fails.
------

*   Added IntlTimeZone::getWindowsID() and IntlTimeZone::getIDForWindowsID().
------

*   Fixed bug [#73007](http://bugs.php.net/73007) (add locale length check).
*   Fixed bug [#73218](http://bugs.php.net/73218) (add mitigation for ICU int overflow).
*   Fixed bug [#65732](http://bugs.php.net/65732) (grapheme\_\*() is not Unicode compliant on CR LF sequence).
*   Fixed bug [#73007](http://bugs.php.net/73007) (add locale length check).
*   Fixed bug [#72639](http://bugs.php.net/72639) (Segfault when instantiating class that extends IntlCalendar and adds a property).
*   Fixed bug [#72658](http://bugs.php.net/72658) (Locale::lookup() / locale\_lookup() hangs if no match found).
*   Partially fixed [#72506](http://bugs.php.net/72506) (idn\_to\_ascii for UTS #46 incorrect for long domain names).
*   Fixed bug [#72533](http://bugs.php.net/72533) (locale\_accept\_from\_http out-of-bounds access).
*   Fixed bug [#69374](http://bugs.php.net/69374) (IntlDateFormatter formatObject returns wrong utf8 value).
*   Fixed bug [#69398](http://bugs.php.net/69398) (IntlDateFormatter formatObject returns wrong value when time style is NONE).


##   JSON

*   Exported JSON parser API including json\_parser\_method that can be used for implementing custom logic when parsing JSON.
*   Escaped U+2028 and U+2029 when JSON\_UNESCAPED\_UNICODE is supplied as json\_encode options and added JSON\_UNESCAPED\_LINE\_TERMINATORS to restore the previous behaviour.
*   Implemented FR [#46600](http://bugs.php.net/46600) ("\_empty\_" key in objects).
-----

*   Implemented earlier return when json\_encode fails, fixes bugs [#68992](http://bugs.php.net/68992) (Stacking exceptions thrown by JsonSerializable) and [#70275](http://bugs.php.net/70275) (On recursion error, json\_encode can eat up all system memory).
*   Introduced encoder struct instead of global which fixes bugs [#66025](http://bugs.php.net/66025) and [#73254](http://bugs.php.net/73254) related to pretty print indentation.
*   Fixed bug [#73113](http://bugs.php.net/73113) (Segfault with throwing JsonSerializable).


##   LDAP

*   Providing an unknown modification type to ldap\_batch\_modify() will now throw an instance of Error instead of resulting in a fatal error.

##   Mbstring


*   Deprecated mb\_ereg\_replace() eval option.

-----

*   mb\_ereg() and mb\_eregi() will now throw an instance of ParseError if an invalid PHP expression is provided and the 'e' option is used.
-----

*   Fixed bug [#73532](http://bugs.php.net/73532) (Null pointer dereference in mb\_eregi).
*   Fixed bug [#66964](http://bugs.php.net/66964) (mb\_convert\_variables() cannot detect recursion).
*   Fixed bug [#72992](http://bugs.php.net/72992) (mbstring.internal\_encoding doesn't inherit default\_charset).
*   Fixed bug [#66797](http://bugs.php.net/66797) (mb\_substr only takes 32-bit signed integer).
*   Fixed bug [#72711](http://bugs.php.net/72711) (\`mb\_ereg\` does not clear the \`$regs\` parameter on failure).
*   Fixed bug [#72691](http://bugs.php.net/72691) (mb\_ereg\_search raises a warning if a match zero-width).
*   Fixed bug [#72693](http://bugs.php.net/72693) (mb\_ereg\_search increments search position when a match zero-width).
*   Fixed bug [#72694](http://bugs.php.net/72694) (mb\_ereg\_search\_setpos does not accept a string's last position).
*   Fixed bug [#72710](http://bugs.php.net/72710) (\`mb\_ereg\` causes buffer overflow on regexp compile error).
*   Fixed bug [#69151](http://bugs.php.net/69151) (mb\_ereg should reject ill-formed byte sequence).
*   Fixed bug [#72405](http://bugs.php.net/72405) (mb\_ereg\_replace - mbc\_to\_code (oniguruma) - oob read access).
*   Fixed bug [#72399](http://bugs.php.net/72399) (Use-After-Free in MBString (search\_re)).


##   Mcrypt

*   Deprecated ext/mcrypt.
----

*   mcrypt\_encrypt() and mcrypt\_decrypt() will throw an instance of Error instead of resulting in a fatal error if mcrypt cannot be initialized.
-----

*   Fixed bug [#72782](http://bugs.php.net/72782) (Heap Overflow due to integer overflows).
*   Fixed bug [#72551](http://bugs.php.net/72551), bug [#72552](http://bugs.php.net/72552) (In correct casting from size\_t to int lead to heap overflow in mdecrypt\_generic).


##   Mysqli

*   Attempting to read an invalid or write to a readonly property will throw an instance of Error instead of resulting in a fatal error.


##   Mysqlnd

*   Fixed bug [#64526](http://bugs.php.net/64526) (Add missing mysqlnd.\* parameters to php.ini-\*).
*   Fixed bug [#71863](http://bugs.php.net/71863) (Segfault when EXPLAIN with "Unknown column" error when using MariaDB).
*   Fixed bug [#72701](http://bugs.php.net/72701) (mysqli\_get\_host\_info() wrong output).

##   OCI8

*   Fixed bug [#71148](http://bugs.php.net/71148) (Bind reference overwritten on PHP 7).
*   Fixed invalid handle error with Implicit Result Sets.
*   Fixed bug [#72524](http://bugs.php.net/72524) (Binding null values triggers ORA-24816 error).

##   ODBC

*   Fixed bug [#73448](http://bugs.php.net/73448) (odbc\_errormsg returns trash, always 513 bytes).

##   Opcache

*   Fixed bug [#73583](http://bugs.php.net/73583) (Segfaults when conditionally declared class and function have the same name).
*   Fixed bug [#69090](http://bugs.php.net/69090) (check cached files permissions)
*   Fixed bug [#72982](http://bugs.php.net/72982) (Memory leak in zend\_accel\_blacklist\_update\_regexp() function).
*   Fixed bug [#72949](http://bugs.php.net/72949) (Typo in opcache error message).
*   Fixed bug [#72762](http://bugs.php.net/72762) (Infinite loop while parsing a file with opcache enabled).
*   Fixed bug [#72590](http://bugs.php.net/72590) (Opcache restart with kill\_all\_lockers does not work).


##   OpenSSL

*   Dropped support for SSL2.
-----

*   Bumped a minimal version to 1.0.1.
----

*   Implemented FR [#61204](http://bugs.php.net/61204) (Add elliptic curve support for OpenSSL).
*   Implemented FR [#67304](http://bugs.php.net/67304) (Added AEAD support \[CCM and GCM modes\] to openssl\_encrypt and openssl\_decrypt).
----

*   Fixed bug [#73478](http://bugs.php.net/73478) (openssl\_pkey\_new() generates wrong pub/priv keys with Diffie Hellman).
*   Fixed bug [#73276](http://bugs.php.net/73276) (crash in openssl\_random\_pseudo\_bytes function).
*   Fixed bug [#73072](http://bugs.php.net/73072) (Invalid path SNI\_server\_certs causes segfault).
*   Fixed bug [#72360](http://bugs.php.net/72360) (ext/openssl build failure with OpenSSL 1.1.0).
*   Implemented error storing to the global queue and cleaning up the OpenSSL error queue (resolves bugs [#68276](http://bugs.php.net/68276) and [#69882](http://bugs.php.net/69882)).


##   Pcntl

*   Implemented asynchronous signal handling without TICKS.
*   Added pcntl\_signal\_get\_handler() that returns the current signal handler for a particular signal. Addresses FR [#72409](http://bugs.php.net/72409).
*   Add siginfo to pcntl\_signal() handler args (Bishop Bettini, David Walker)


##   PCRE

*   Downgraded to PCRE 8.38.
*   Upgraded to PCRE 8.39.
-----

*   Fixed bug [#73483](http://bugs.php.net/73483) (Segmentation fault on pcre\_replace\_callback).
*   Fixed bug [#73612](http://bugs.php.net/73612) (preg\_\*() may leak memory).
*   Fixed bug [#73392](http://bugs.php.net/73392) (A use-after-free in zend allocator management).
*   Fixed bug [#73121](http://bugs.php.net/73121) (Bundled PCRE doesn't compile because JIT isn't supported on s390).
*   Fixed bug [#72688](http://bugs.php.net/72688) (preg\_match missing group names in matches).
*   Fixed bug [#72476](http://bugs.php.net/72476) (Memleak in jit\_stack).
*   Fixed bug [#72463](http://bugs.php.net/72463) (mail fails with invalid argument).


##   PDO

*   Fixed bug [#72788](http://bugs.php.net/72788) (Invalid memory access when using persistent PDO connection).
*   Fixed bug [#72791](http://bugs.php.net/72791) (Memory leak in PDO persistent connection handling).
*   Fixed bug [#60665](http://bugs.php.net/60665) (call to empty() on NULL result using PDO::FETCH\_LAZY returns false).

##   PDO\_DBlib

*   Allow \\PDO::setAttribute() to set query timeouts.
*   Handle SQLDECIMAL/SQLNUMERIC types, which are used by later TDS versions.
*   Free error and message strings when cleaning up PDO instances.
*   Ignore potentially misleading dberr values.
----

*   Add common PDO test suite.
*   Implemented stringify 'uniqueidentifier' fields.
----

*   Fixed bug [#72414](http://bugs.php.net/72414) (Never quote values as raw binary data).
*   Fixed bug [#67130](http://bugs.php.net/67130) (\\PDOStatement::nextRowset() should succeed when all rows in current rowset haven't been fetched).


##   PDO\_Firebird

*   Fixed bug [#73087](http://bugs.php.net/73087), [#61183](http://bugs.php.net/61183), [#71494](http://bugs.php.net/71494) (Memory corruption in bindParam).
*   Fixed bug [#60052](http://bugs.php.net/60052) (Integer returned as a 64bit integer on X86\_64).

##   PDO\_pgsql

*   Implemented FR [#72633](http://bugs.php.net/72633) (Postgres PDO lastInsertId() should work without specifying a sequence).
----

*   Fixed bug [#70313](http://bugs.php.net/70313) (PDO statement fails to throw exception).
*   Fixed bug [#72570](http://bugs.php.net/72570) (Segmentation fault when binding parameters on a query without placeholders).


##   Phar

*   Fixed bug [#72928](http://bugs.php.net/72928) (Out of bound when verify signature of zip phar in phar\_parse\_zipfile).
*   Fixed bug [#73035](http://bugs.php.net/73035) (Out of bound when verify signature of tar phar in phar\_parse\_tarfile).


##   phpdbg

*   Added generator command for inspection of currently alive generators.

##   Postgres
*   Implemented FR [#31021](http://bugs.php.net/31021) (pg\_last\_notice() is needed to get all notice messages).
*   Implemented FR [#48532](http://bugs.php.net/48532) (Allow pg\_fetch\_all() to index numerically).
-----

*   Fixed bug [#73498](http://bugs.php.net/73498) (Incorrect SQL generated for pg\_copy\_to()).

##   Readline

*   Fixed bug [#72538](http://bugs.php.net/72538) (readline\_redisplay crashes php).

##   Reflection

*   Undo backwards compatiblity break in ReflectionType->\_\_toString() and deprecate via documentation instead.
----

*   Failure to retrieve a reflection object or retrieve an object property will now throw an instance of Error instead of resulting in a fatal error.
----

*   Reverted prepending \\ for class names.
*   Implemented FR [#38992](http://bugs.php.net/38992) (invoke() and invokeArgs() static method calls should match). (cmb).
*   Add ReflectionNamedType::getName(). This method should be used instead of ReflectionType::\_\_toString()
*   Prepend \\ for class names and ? for nullable types returned from ReflectionType::\_\_toString().
-----

*   Fixed bug [#72661](http://bugs.php.net/72661) (ReflectionType::\_\_toString crashes with iterable).
*   Fixed bug [#72222](http://bugs.php.net/72222) (ReflectionClass::export doesn't handle array constants).
*   Fixed bug [#72209](http://bugs.php.net/72209) (ReflectionProperty::getValue() doesn't fail if object doesn't match type).


##   Session

*   Custom session handlers that do not return strings for session IDs will now throw an instance of Error instead of resulting in a fatal error when a function is called that must generate a session ID.
*   An invalid setting for session.hash\_function will throw an instance of Error instead of resulting in a fatal error when a session ID is created.
-----

*   Implemented session\_gc() (Yasuo) https://wiki.php.net/rfc/session-create-id
*   Implemented session\_create\_id() (Yasuo) https://wiki.php.net/rfc/session-gc
*   Implemented RFC: Session ID without hashing. (Yasuo) https://wiki.php.net/rfc/session-id-without-hashing
-----

*   Fixed bug [#73273](http://bugs.php.net/73273) (session\_unset() empties values from all variables in which is $\_session stored).
*   Fixed bug [#73100](http://bugs.php.net/73100) (session\_destroy null dereference in ps\_files\_path\_create).
*   Fixed bug [#68015](http://bugs.php.net/68015) (Session does not report invalid uid for files save handler).
*   Fixed bug [#72940](http://bugs.php.net/72940) (SID always return "name=ID", even if session cookie exist).
*   Fixed bug [#72531](http://bugs.php.net/72531) (ps\_files\_cleanup\_dir Buffer overflow).
*   Fixed bug [#72562](http://bugs.php.net/72562) (Use After Free in unserialize() with Unexpected Session Deserialization).
*   Improved fix for bug [#68063](http://bugs.php.net/68063) (Empty session IDs do still start sessions).
*   Fixed bug [#71038](http://bugs.php.net/71038) (session\_start() returns TRUE on failure). Session save handlers must return 'string' always for successful read. i.e. Non-existing session read must return empty string. PHP 7.0 is made not to tolerate buggy return value.
*   Fixed bug [#71394](http://bugs.php.net/71394) (session\_regenerate\_id() must close opened session on errors).

##   SimpleXML
*   Creating an unnamed or duplicate attribute will throw an instance of Error instead of resulting in a fatal error.
-----

*   Fixed bug [#73293](http://bugs.php.net/73293) (NULL pointer dereference in SimpleXMLElement::asXML()).
*   Fixed bug [#72971](http://bugs.php.net/72971) (SimpleXML isset/unset do not respect namespace).
*   Fixed bug [#72957](http://bugs.php.net/72957) (Null coalescing operator doesn't behave as expected with SimpleXMLElement).
*   Fixed bug [#72588](http://bugs.php.net/72588) (Using global var doesn't work while accessing SimpleXML element).


##   SNMP

*   Fixed bug [#72708](http://bugs.php.net/72708) (php\_snmp\_parse\_oid integer overflow in memory allocation).
*   Fixed bug [#72479](http://bugs.php.net/72479) (Use After Free Vulnerability in SNMP with GC and unserialize()).

##   Soap

*   Fixed bug [#73538](http://bugs.php.net/73538) (SoapClient::\_\_setSoapHeaders doesn't overwrite SOAP headers).
*   Fixed bug [#73452](http://bugs.php.net/73452) (Segfault (Regression for [#69152](http://bugs.php.net/69152))).
*   Fixed bug [#73037](http://bugs.php.net/73037) (SoapServer reports Bad Request when gzipped).
*   Fixed bug [#73237](http://bugs.php.net/73237) (Nested object in "any" element overwrites other fields).
*   Fixed bug [#69137](http://bugs.php.net/69137) (Peer verification fails when using a proxy with SoapClient).
*   Fixed bug [#71711](http://bugs.php.net/71711) (Soap Server Member variables reference bug).
*   Fixed bug [#71996](http://bugs.php.net/71996) (Using references in arrays doesn't work like expected).

##   SPL
*   Attempting to clone an SplDirectory object will throw an instance of Error instead of resulting in a fatal error.
*   Calling ArrayIterator::append() when iterating over an object will throw an instance of Error instead of resulting in a fatal error.
-----

*   Fixed bug [#73423](http://bugs.php.net/73423) (Reproducible crash with GDB backtrace).
*   Fixed bug [#72888](http://bugs.php.net/72888) (Segfault on clone on splFileObject).
*   Fixed bug [#73029](http://bugs.php.net/73029) (Missing type check when unserializing SplArray).
*   Fixed bug [#72646](http://bugs.php.net/72646) (SplFileObject::getCsvControl does not return the escape character).
*   Fixed bug [#72684](http://bugs.php.net/72684) (AppendIterator segfault with closed generator).
*   Fixed bug [#55701](http://bugs.php.net/55701) (GlobIterator throws LogicException).


##   SQLite3

*   Update to SQLite 3.15.1.
----

*   Implemented FR [#71159](http://bugs.php.net/71159) (Upgraded bundled SQLite lib to 3.9.2).
*   Implemented FR [#72653](http://bugs.php.net/72653) (SQLite should allow opening with empty filename).
-----

*   Fixed bug [#73530](http://bugs.php.net/73530) (Unsetting result set may reset other result set).
*   Fixed bug [#73333](http://bugs.php.net/73333) (2147483647 is fetched as string).
*   Fixed bug [#72668](http://bugs.php.net/72668) (Spurious warning when exception is thrown in user defined function).
*   Fixed bug [#70628](http://bugs.php.net/70628) (Clearing bindings on an SQLite3 statement doesn't work).

##   Standard

*   array\_multisort now uses zend\_sort instead zend\_qsort.
*   assert() will throw a ParseError when evaluating a string given as the first argument if the PHP code is invalid instead of resulting in a catchable fatal error.
*   Calling forward\_static\_call() outside of a class scope will now throw an instance of Error instead of resulting in a fatal error.
*   unpack() function accepts an additional optional argument $offset.
-----


*   Implemented RFC: More precise float values.
*   Added is\_iterable() function.
*   Implemented FR [#55716](http://bugs.php.net/55716) (Add an option to pass a custom stream context to get\_headers()).
*   Additional validation for parse\_url() for login/pass components).
*   Implemented FR [#69359](http://bugs.php.net/69359) (Provide a way to fetch the current environment variables).
*   Implemented FR [#51879](http://bugs.php.net/51879) stream context socket option tcp\_nodelay (Joe)
----

*   Fixed bug [#73297](http://bugs.php.net/73297) (HTTP stream wrapper should ignore HTTP 100 Continue).
*   Fixed bug [#73303](http://bugs.php.net/73303) (Scope not inherited by eval in assert()).
*   Fixed bug [#73192](http://bugs.php.net/73192) (parse\_url return wrong hostname).
*   Fixed bug [#73203](http://bugs.php.net/73203) (passing additional\_parameters causes mail to fail).
*   Fixed bug [#73203](http://bugs.php.net/73203) (passing additional\_parameters causes mail to fail).
*   Fixed bug [#72920](http://bugs.php.net/72920) (Accessing a private constant using constant() creates an exception AND warning).
*   Fixed bug [#65550](http://bugs.php.net/65550) (get\_browser() incorrectly parses entries with "+" sign).
*   Fixed bug [#71882](http://bugs.php.net/71882) (Negative ftruncate() on php://memory exhausts memory).
*   Fixed bug [#55451](http://bugs.php.net/55451) (substr\_compare NULL length interpreted as 0).
*   Fixed bug [#72278](http://bugs.php.net/72278) (getimagesize returning FALSE on valid jpg).
*   Fixed bug [#61967](http://bugs.php.net/61967) (unset array item in array\_walk\_recursive cause inconsistent array).
*   Fixed bug [#62607](http://bugs.php.net/62607) (array\_walk\_recursive move internal pointer).
*   Fixed bug [#69068](http://bugs.php.net/69068) (Exchanging array during array\_walk -> memory errors).
*   Fixed bug [#70713](http://bugs.php.net/70713) (Use After Free Vulnerability in array\_walk()/ array\_walk\_recursive()).
*   Fixed bug [#72622](http://bugs.php.net/72622) (array\_walk + array\_replace\_recursive create references from nothing).
*   Fixed bug [#72330](http://bugs.php.net/72330) (CSV fields incorrectly split if escape char followed by UTF chars).
*   Fixed bug [#72505](http://bugs.php.net/72505) (readfile() mangles files larger than 2G).
*   Fixed bug [#72306](http://bugs.php.net/72306) (Heap overflow through proc\_open and $env parameter).
*   Fixed bug [#71100](http://bugs.php.net/71100) (long2ip() doesn't accept integers in strict mode).



##   Streams


*   Implemented FR [#27814](http://bugs.php.net/27814) (Multiple small packets send for HTTP request).
-----

*   Fixed bug [#73586](http://bugs.php.net/73586) (php\_user\_filter::$stream is not set to the stream the filter is working on).
*   Fixed bug [#72853](http://bugs.php.net/72853) (stream\_set\_blocking doesn't work).
*   Fixed bug [#72743](http://bugs.php.net/72743) (Out-of-bound read in php\_stream\_filter\_create).
*   Fixed bug [#72764](http://bugs.php.net/72764) (ftps:// opendir wrapper data channel encryption fails with IIS FTP 7.5, 8.5).
*   Fixed bug [#72810](http://bugs.php.net/72810) (Missing SKIP\_ONLINE\_TESTS checks).
*   Fixed bug [#41021](http://bugs.php.net/41021) (Problems with the ftps wrapper).
*   Fixed bug [#54431](http://bugs.php.net/54431) (opendir() does not work with ftps:// wrapper).
*   Fixed bug [#72667](http://bugs.php.net/72667) (opendir() with ftp:// attempts to open data stream for non-existent directories).
*   Fixed bug [#72771](http://bugs.php.net/72771) (ftps:// wrapper is vulnerable to protocol downgrade attack).
*   Fixed bug [#72534](http://bugs.php.net/72534) (stream\_socket\_get\_name crashes).
*   Fixed bug [#72439](http://bugs.php.net/72439) (Stream socket with remote address leads to a segmentation fault).

##   sysvshm

*   Fixed bug [#72858](http://bugs.php.net/72858) (shm\_attach null dereference).

##   Tidy

*   Implemented support for libtidy 5.0.0 and above.
*   Creating a tidyNode manually will now throw an instance of Error instead of resulting in a fatal error.


##   Wddx

*   A circular reference when serializing will now throw an instance of Error instead of resulting in a fatal error.
-----

*   Fixed bug [#73331](http://bugs.php.net/73331) (NULL Pointer Dereference in WDDX Packet Deserialization with PDORow). (CVE-2016-9934)
*   Fixed bug [#72142](http://bugs.php.net/72142) (WDDX Packet Injection Vulnerability in wddx\_serialize\_value()).
*   Fixed bug [#72749](http://bugs.php.net/72749) (wddx\_deserialize allows illegal memory access).
*   Fixed bug [#72750](http://bugs.php.net/72750) (wddx\_deserialize null dereference).
*   Fixed bug [#72790](http://bugs.php.net/72790) (wddx\_deserialize null dereference with invalid xml).
*   Fixed bug [#72799](http://bugs.php.net/72799) (wddx\_deserialize null dereference in php\_wddx\_pop\_element).
*   Fixed bug [#72860](http://bugs.php.net/72860) (wddx\_deserialize use-after-free).
*   Fixed bug [#73065](http://bugs.php.net/73065) (Out-Of-Bounds Read in php\_wddx\_push\_element).
*   Fixed bug [#72564](http://bugs.php.net/72564) (boolean always deserialized as "true").


##   XML

*   Fixed bug [#72135](http://bugs.php.net/72135) (malformed XML causes fault).
*   Fixed bug [#72714](http://bugs.php.net/72714) (\_xml\_startElementHandler() segmentation fault).
*   Fixed bug [#72085](http://bugs.php.net/72085) (SEGV on unknown address zif\_xml\_parse).

##   XMLRPC

*   A circular reference when serializing will now throw an instance of Error instead of resulting in a fatal error.
-----

*   Fixed bug [#72647](http://bugs.php.net/72647) (xmlrpc\_encode() unexpected output after referencing array elements).
*   Fixed bug [#72606](http://bugs.php.net/72606) (heap-buffer-overflow (write) simplestring\_addn simplestring.c).


##   Zip

*   ZipArchive::addGlob() will throw an instance of Error instead of resulting in a fatal error if glob support is not available.
-----

*   Fixed bug [#68302](http://bugs.php.net/68302) (impossible to compile php with zip support).
*   Fixed bug [#72660](http://bugs.php.net/72660) (NULL Pointer dereference in zend\_virtual\_cwd).
*   Fixed bug [#72520](http://bugs.php.net/72520) (Stack-based buffer overflow vulnerability in php\_stream\_zip\_opener).
