---
title: PHP Version 7.0.0 Published
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - 历史
  - PHP发展史
  - 技术发展史
  - LiteSpeed
date: 2015-12-03 15:00:00
---

# 有什么变化

## Core

*   Removed ZEND\_ACC\_FINAL\_CLASS, promoting ZEND\_ACC\_FINAL as final class modifier.
*   Removed scoped calls of non-static methods from an incompatible $this context.
*   Removed support for #-style comments in ini files.
*   Removed support for assigning the result of new by reference.
*   Removed dl() function on fpm-fcgi.
*   Removed support for hexadecimal numeric strings.
*   Removed obsolete extensions and SAPIs. See the full list in UPGRADING.

----

*   Improved zend\_qsort(using hybrid sorting algo) for better performance, and also renamed zend\_qsort to zend\_sort.
*   Improved zend\_memnchr(using sunday algo) for better performance.
*   Use "integer" and "float" instead of "long" and "double" in ZPP, type hint and conversion error messages.
*   Implemented FR [#55428](http://bugs.php.net/55428) (E\_RECOVERABLE\_ERROR when output buffering in output buffering handler).
*   Invalid octal literals in source code now produce compile errors, fixes PHPSadness #31.
*   Improved \_\_call() and \_\_callStatic() magic method handling. Now they are called in a stackless way using ZEND\_CALL\_TRAMPOLINE opcode, without additional stack frame.
*   Optimized strings concatenation.

----

*   Added NULL byte protection to exec, system and passthru.
*   Added error\_clear\_last() function.
*   is\_long() & is\_integer() is now an alias of is\_int().
*   Implemented FR [#55467](http://bugs.php.net/55467) (phpinfo: PHP Variables with $ and single quotes).
*   Added ?? operator.
*   Added <=> operator.
*   Added \\u{xxxxx} Unicode Codepoint Escape Syntax.
*   Added PHP\_INT\_MIN constant.
*   Added Closure::call() method.
*   Added options parameter for unserialize allowing to specify acceptable classes (https://wiki.php.net/rfc/secure\_unserialize).
*   Added stable sorting algo zend\_insert\_sort.
*   Implemented the RFC \`Scalar Type Decalarations v0.5\`.
*   Implemented the RFC \`Group Use Declarations\`.
*   Implemented the RFC \`Continue Output Buffering\`.
*   Implemented the RFC \`Constructor behaviour of internal classes\`.
*   Implemented the RFC \`Fix "foreach" behavior\`.
*   Implemented the RFC \`Generator Delegation\`.
*   Implemented the RFC \`Anonymous Class Support\`.
*   Implemented the RFC \`Context Sensitive Lexer\`.
*   Implemented the RFC \`Catchable "Call to a member function bar() on a non-object"\`.
-----

*   Fixed bug [#70947](http://bugs.php.net/70947) (INI parser segfault with INI\_SCANNER\_TYPED).
*   Fixed bug [#70914](http://bugs.php.net/70914) (zend\_throw\_or\_error() format string vulnerability).
*   Fixed bug [#70912](http://bugs.php.net/70912) (Null ptr dereference instantiating class with invalid array property).
*   Fixed bug [#70895](http://bugs.php.net/70895), [#70898](http://bugs.php.net/70898) (null ptr deref and segfault with crafted calable).
*   Fixed bug [#70249](http://bugs.php.net/70249) (Segmentation fault while running PHPUnit tests on phpBB 3.2-dev).
*   Fixed bug [#70805](http://bugs.php.net/70805) (Segmentation faults whilst running Drupal 8 test suite).
*   Fixed bug [#70842](http://bugs.php.net/70842) (Persistent Stream Segmentation Fault).
*   Fixed bug [#70862](http://bugs.php.net/70862) (Several functions do not check return code of php\_stream\_copy\_to\_mem()).
*   Fixed bug [#70863](http://bugs.php.net/70863) (Incorect logic to increment\_function for proxy objects).
*   Fixed bug [#70323](http://bugs.php.net/70323) (Regression in zend\_fetch\_debug\_backtrace() can cause segfaults).
*   Fixed bug [#70873](http://bugs.php.net/70873) (Regression on private static properties access).
*   Fixed bug [#70748](http://bugs.php.net/70748) (Segfault in ini\_lex () at Zend/zend\_ini\_scanner.l).
*   Fixed bug [#70689](http://bugs.php.net/70689) (Exception handler does not work as expected).
*   Fixed bug [#70430](http://bugs.php.net/70430) (Stack buffer overflow in zend\_language\_parser()).
*   Fixed bug [#70782](http://bugs.php.net/70782) (null ptr deref and segfault (zend\_get\_class\_fetch\_type)).
*   Fixed bug [#70785](http://bugs.php.net/70785) (Infinite loop due to exception during identical comparison).
*   Fixed bug [#70630](http://bugs.php.net/70630) (Closure::call/bind() crash with ReflectionFunction-> getClosure()).
*   Fixed bug [#70662](http://bugs.php.net/70662) (Duplicate array key via undefined index error handler).
*   Fixed bug [#70681](http://bugs.php.net/70681) (Segfault when binding $this of internal instance method to null).
*   Fixed bug [#70685](http://bugs.php.net/70685) (Segfault for getClosure() internal method rebind with invalid $this).
*   Added zend\_internal\_function.reserved\[\] fields.
*   Fixed bug [#70557](http://bugs.php.net/70557) (Memleak on return type verifying failed).
*   Fixed bug [#70555](http://bugs.php.net/70555) (fun\_get\_arg() on unsetted vars return UNKNOW).
*   Fixed bug [#70548](http://bugs.php.net/70548) (Redundant information printed in case of uncaught engine exception).
*   Fixed bug [#70547](http://bugs.php.net/70547) (unsetting function variables corrupts backtrace).
*   Fixed bug [#70528](http://bugs.php.net/70528) (assert() with instanceof adds apostrophes around class name).
*   Fixed bug [#70481](http://bugs.php.net/70481) (Memory leak in auto\_global\_copy\_ctor() in ZTS build).
*   Fixed bug [#70431](http://bugs.php.net/70431) (Memory leak in php\_ini.c).
*   Fixed bug [#70478](http://bugs.php.net/70478) (\*\*= does no longer work).
*   Fixed bug [#70398](http://bugs.php.net/70398) (SIGSEGV, Segmentation fault zend\_ast\_destroy\_ex).
*   Fixed bug [#70332](http://bugs.php.net/70332) (Wrong behavior while returning reference on object).
*   Fixed bug [#70300](http://bugs.php.net/70300) (Syntactical inconsistency with new group use syntax).
*   Fixed bug [#70321](http://bugs.php.net/70321) (Magic getter breaks reference to array property).
*   Fixed bug [#70187](http://bugs.php.net/70187) (Notice: unserialize(): Unexpected end of serialized data).
*   Fixed bug [#70145](http://bugs.php.net/70145) (From field incorrectly parsed from headers).
*   Fixed bug [#70370](http://bugs.php.net/70370) (Bundled libtool.m4 doesn't handle FreeBSD 10 when building extensions).
*   Fixed bug causing exception traces with anon classes to be truncated.
*   Fixed bug [#70397](http://bugs.php.net/70397) (Segmentation fault when using Closure::call and yield).
*   Fixed bug [#70299](http://bugs.php.net/70299) (Memleak while assigning object offsetGet result).
*   Fixed bug [#70288](http://bugs.php.net/70288) (Apache crash related to ZEND\_SEND\_REF).
*   Fixed bug [#70262](http://bugs.php.net/70262) (Accessing array crashes PHP 7.0beta3).
*   Fixed bug [#70258](http://bugs.php.net/70258) (Segfault if do\_resize fails to allocated memory).
*   Fixed bug [#70253](http://bugs.php.net/70253) (segfault at \_efree () in zend\_alloc.c:1389).
*   Fixed bug [#70240](http://bugs.php.net/70240) (Segfault when doing unset($var());).
*   Fixed bug [#70223](http://bugs.php.net/70223) (Incrementing value returned by magic getter).
*   Fixed bug [#70215](http://bugs.php.net/70215) (Segfault when \_\_invoke is static).
*   Fixed bug [#70207](http://bugs.php.net/70207) (Finally is broken with opcache).
*   Fixed bug [#70173](http://bugs.php.net/70173) (ZVAL\_COPY\_VALUE\_EX broken for 32bit Solaris Sparc).
*   Fixed bug [#69487](http://bugs.php.net/69487) (SAPI may truncate POST data).
*   Fixed bug [#70198](http://bugs.php.net/70198) (Checking liveness does not work as expected).
*   Fixed bug [#70241](http://bugs.php.net/70241), [#70293](http://bugs.php.net/70293) (Skipped assertions affect Generator returns).
*   Fixed bug [#70239](http://bugs.php.net/70239) (Creating a huge array doesn't result in exhausted, but segfault).
*   Fixed "finally" issues.
*   Fixed bug [#70098](http://bugs.php.net/70098) (Real memory usage doesn't decrease).
*   Fixed bug [#70159](http://bugs.php.net/70159) (\_\_CLASS\_\_ is lost in closures).
*   Fixed bug [#70156](http://bugs.php.net/70156) (Segfault in zend\_find\_alias\_name).
*   Fixed bug [#70124](http://bugs.php.net/70124) (null ptr deref / seg fault in ZEND\_HANDLE\_EXCEPTION).
*   Fixed bug [#70117](http://bugs.php.net/70117) (Unexpected return type error).
*   Fixed bug [#70106](http://bugs.php.net/70106) (Inheritance by anonymous class).
*   Fixed bug [#69674](http://bugs.php.net/69674) (SIGSEGV array.c:953).
*   Fixed bug [#70164](http://bugs.php.net/70164) (\_\_COMPILER\_HALT\_OFFSET\_\_ under namespace is not defined).
*   Fixed bug [#70108](http://bugs.php.net/70108) (sometimes empty $\_SERVER\['QUERY\_STRING'\]).
*   Fixed bug [#70179](http://bugs.php.net/70179) ($this refcount issue).
*   Fixed bug [#69896](http://bugs.php.net/69896) ('asm' operand has impossible constraints).
*   Fixed bug [#70183](http://bugs.php.net/70183) (null pointer deref (segfault) in zend\_eval\_const\_expr).
*   Fixed bug [#70182](http://bugs.php.net/70182) (Segfault in ZEND\_ASSIGN\_DIV\_SPEC\_CV\_UNUSED\_HANDLER).
*   Fixed bug [#69793](http://bugs.php.net/69793) (Remotely triggerable stack exhaustion via recursive method calls).
*   Fixed bug [#69892](http://bugs.php.net/69892) (Different arrays compare indentical due to integer key truncation).
*   Fixed bug [#70121](http://bugs.php.net/70121) (unserialize() could lead to unexpected methods execution / NULL pointer deref).
*   Fixed bug [#70089](http://bugs.php.net/70089) (segfault at ZEND\_FETCH\_DIM\_W\_SPEC\_VAR\_CONST\_HANDLER ()).
*   Fixed bug [#70057](http://bugs.php.net/70057) (Build failure on 32-bit Mac OS X 10.6.8: recursive inlining).
*   Fixed bug [#70012](http://bugs.php.net/70012) (Exception lost with nested finally block).
*   Fixed bug [#69996](http://bugs.php.net/69996) (Changing the property of a cloned object affects the original).
*   Fixed bug [#70083](http://bugs.php.net/70083) (Use after free with assign by ref to overloaded objects).
*   Fixed bug [#70006](http://bugs.php.net/70006) (cli - function with default arg = STDOUT crash output).
*   Fixed bug [#69521](http://bugs.php.net/69521) (Segfault in gc\_collect\_cycles()).
*   Improved zend\_string API.
*   Fixed bug [#69955](http://bugs.php.net/69955) (Segfault when trying to combine \[\] and assign-op on ArrayAccess object).
*   Fixed bug [#69957](http://bugs.php.net/69957) (Different ways of handling div/mod/intdiv).
*   Fixed bug [#69900](http://bugs.php.net/69900) (Too long timeout on pipes).
*   Fixed bug [#69872](http://bugs.php.net/69872) (uninitialised value in strtr with array).
*   Fixed bug [#69868](http://bugs.php.net/69868) (Invalid read of size 1 in zend\_compile\_short\_circuiting).
*   Fixed bug [#69849](http://bugs.php.net/69849) (Broken output of apache\_request\_headers).
*   Fixed bug [#69840](http://bugs.php.net/69840) (iconv\_substr() doesn't work with UTF-16BE).
*   Fixed bug [#69823](http://bugs.php.net/69823) (PHP 7.0.0alpha1 segmentation fault when exactly 33 extensions are loaded).
*   Fixed bug [#69805](http://bugs.php.net/69805) (null ptr deref and seg fault in zend\_resolve\_class\_name).
*   Fixed bug [#69802](http://bugs.php.net/69802) (Reflection on Closure::\_\_invoke borks type hint class name).
*   Fixed bug [#69761](http://bugs.php.net/69761) (Serialization of anonymous classes should be prevented).
*   Fixed bug [#69551](http://bugs.php.net/69551) (parse\_ini\_file() and parse\_ini\_string() segmentation fault).
*   Fixed bug [#69781](http://bugs.php.net/69781) (phpinfo() reports Professional Editions of Windows 7/8/8.1/10 as "Business").
*   Fixed bug [#69835](http://bugs.php.net/69835) (phpinfo() does not report many Windows SKUs).
*   Fixed bug [#69889](http://bugs.php.net/69889) (Null coalesce operator doesn't work for string offsets).
*   Fixed bug [#69891](http://bugs.php.net/69891) (Unexpected array comparison result).
*   Fixed bug [#69892](http://bugs.php.net/69892) (Different arrays compare indentical due to integer key truncation).
*   Fixed bug [#69893](http://bugs.php.net/69893) (Strict comparison between integer and empty string keys crashes).
*   Fixed bug [#69767](http://bugs.php.net/69767) (Default parameter value with wrong type segfaults).
*   Fixed bug [#69756](http://bugs.php.net/69756) (Fatal error: Nesting level too deep - recursive dependency ? with ===).
*   Fixed bug [#69758](http://bugs.php.net/69758) (Item added to array not being removed by array\_pop/shift ).
*   Fixed bug [#68475](http://bugs.php.net/68475) (Add support for $callable() sytnax with 'Class::method').
*   Fixed bug [#69485](http://bugs.php.net/69485) (Double free on zend\_list\_dtor).
*   Fixed bug [#69427](http://bugs.php.net/69427) (Segfault on magic method \_\_call of private method in superclass).
*   Fixed weird operators behavior. Division by zero now emits warning and returns +/-INF, modulo by zero and intdid() throws an exception, shifts by negative offset throw exceptions. Compile-time evaluation of division by zero is disabled.

*   Fixed bug [#69371](http://bugs.php.net/69371) (Hash table collision leads to inaccessible array keys).
*   Fixed bug [#68933](http://bugs.php.net/68933) (Invalid read of size 8 in zend\_std\_read\_property).
*   Fixed bug [#68252](http://bugs.php.net/68252) (segfault in Zend/zend\_hash.c in function \_zend\_hash\_del\_el).
*   Fixed bug [#65598](http://bugs.php.net/65598) (Closure executed via static autoload incorrectly marked as static).
*   Fixed bug [#66811](http://bugs.php.net/66811) (Cannot access static::class in lambda, writen outside of a class).
*   Fixed bug [#69568](http://bugs.php.net/69568) (call a private function in closure failed).

*   Fixed bug [#67959](http://bugs.php.net/67959) (Segfault when calling phpversion('spl')).


*   Fixed bug [#63734](http://bugs.php.net/63734) (Garbage collector can free zvals that are still referenced).

*   Fixed oversight where define() did not support arrays yet const syntax did.

*   Fixed bug [#68797](http://bugs.php.net/68797) (Number 2.2250738585072012e-308 converted incorrectly).

*   Fixed bug [#69511](http://bugs.php.net/69511) (Off-by-one buffer overflow in php\_sys\_readlink).

## CLI server

*   Added support for SEARCH WebDav method.

---

*   Refactor MIME type handling to use a hash table instead of linear search.
*   Update the MIME type list from the one shipped by Apache HTTPD.

----

*   Fixed bug [#68291](http://bugs.php.net/68291) (404 on urls with '+').
*   Fixed bug [#66606](http://bugs.php.net/66606) (Sets HTTP\_CONTENT\_TYPE but not CONTENT\_TYPE).
*   Fixed bug [#70264](http://bugs.php.net/70264) (CLI server directory traversal).
*   Fixed bug [#69655](http://bugs.php.net/69655) (php -S changes MKCALENDAR request method to MKCOL).
*   Fixed bug [#64878](http://bugs.php.net/64878) (304 responses return Content-Type header).

## COM

*   Fixed bug #69939 (Casting object to bool returns false).

## Curl

*   Removed support for unsafe file uploads.

----

*   Fixed bug [#70330](http://bugs.php.net/70330) (Segmentation Fault with multiple "curl\_copy\_handle").
*   Fixed bug [#70163](http://bugs.php.net/70163) (curl\_setopt\_array() type confusion).
*   Fixed bug [#70065](http://bugs.php.net/70065) (curl\_getinfo() returns corrupted values).
*   Fixed bug [#69831](http://bugs.php.net/69831) (Segmentation fault in curl\_getinfo).
*   Fixed bug [#68937](http://bugs.php.net/68937) (Segfault in curl\_multi\_exec).

## Date

*   Removed $is\_dst parameter from mktime() and gmmktime().
*   Removed date.timezone warning (https://wiki.php.net/rfc/date.timezone\_warning\_removal).
----

*   Added "v" DateTime format modifier to get the 3-digit version of fraction of seconds.
*   Implemented FR [#69089](http://bugs.php.net/69089) (Added DateTime::RFC3339\_EXTENDED to output in RFC3339 Extended format which includes fraction of seconds).

----

*   Fixed bug [#70245](http://bugs.php.net/70245) (strtotime does not emit warning when 2nd parameter is object or string).
*   Fixed bug [#70266](http://bugs.php.net/70266) (DateInterval::\_\_construct.interval\_spec is not supposed to be optional).
*   Fixed bug [#70277](http://bugs.php.net/70277) (new DateTimeZone($foo) is ignoring text after null byte).
*   Fixed day\_of\_week function as it could sometimes return negative values internally.


##   DBA

*   Fixed bug [#62490](http://bugs.php.net/62490) (dba\_delete returns true on missing item (inifile)).
*   Fixed bug [#68711](http://bugs.php.net/68711) (useless comparisons).

##  DOM

*   Made DOMNode::textContent writeable.
----

*   Fixed bug [#70558](http://bugs.php.net/70558) ("Couldn't fetch" error in DOMDocument::registerNodeClass()).
*   Fixed bug [#70001](http://bugs.php.net/70001) (Assigning to DOMNode::textContent does additional entity encoding).
*   Fixed bug [#69846](http://bugs.php.net/69846) (Segmenation fault (access violation) when iterating over DOMNodeList).


## EXIF
*   Fixed bug [#70385](http://bugs.php.net/70385) (Buffer over-read in exif\_read\_data with TIFF IFD tag byte value of 32 bytes).


## Fileinfo
*   Fixed bug [#66242](http://bugs.php.net/66242) (libmagic: don't assume char is signed).


## Filter

*   New FILTER\_VALIDATE\_DOMAIN and better RFC conformance for FILTER\_VALIDATE\_URL.
-----

*   Fixed bug [#67167](http://bugs.php.net/67167) (Wrong return value from FILTER\_VALIDATE\_BOOLEAN, FILTER\_NULL\_ON\_FAILURE).


##   FPM

*   Implemented FR [#67106](http://bugs.php.net/67106) (Split main fpm config).
----

*   Fixed bug [#70538](http://bugs.php.net/70538) ("php-fpm -i" crashes).
*   Fixed bug [#70279](http://bugs.php.net/70279) (HTTP Authorization Header is sometimes passed to newer reqeusts).
*   Fixed bug [#68945](http://bugs.php.net/68945) (Unknown admin values segfault pools).
*   Fixed bug [#65933](http://bugs.php.net/65933) (Cannot specify config lines longer than 1024 bytes).


## FTP

*   Fixed bug [#69082](http://bugs.php.net/69082) (FTPS support on Windows).


##   GD

*   Removed T1Lib support.
-----
*   Replace libvpx with libwebp for bundled libgd.
*   Made fontFetch's path parser thread-safe.
----

*   Fixed bug [#53156](http://bugs.php.net/53156) (imagerectangle problem with point ordering).
*   Fixed bug [#66387](http://bugs.php.net/66387) (Stack overflow with imagefilltoborder). (CVE-2015-8874)
*   Fixed bug [#70102](http://bugs.php.net/70102) (imagecreatefromwebm() shifts colors).
*   Fixed bug [#66590](http://bugs.php.net/66590) (imagewebp() doesn't pad to even length).
*   Fixed bug [#66882](http://bugs.php.net/66882) (imagerotate by -90 degrees truncates image by 1px).
*   Fixed bug [#70064](http://bugs.php.net/70064) (imagescale(..., IMG\_BICUBIC) leaks memory).
*   Fixed bug [#69024](http://bugs.php.net/69024) (imagescale segfault with palette based image).
*   Fixed bug [#53154](http://bugs.php.net/53154) (Zero-height rectangle has whiskers).
*   Fixed bug [#67447](http://bugs.php.net/67447) (imagecrop() add a black line when cropping).
*   Fixed bug [#68714](http://bugs.php.net/68714) (copy 'n paste error).
*   Fixed bug [#66339](http://bugs.php.net/66339) (PHP segfaults in imagexbm).
*   Fixed bug [#70047](http://bugs.php.net/70047) (gd\_info() doesn't report WebP support).
*   Fixed bug [#61221](http://bugs.php.net/61221) (imagegammacorrect function loses alpha channel).


##   GMP

*   Fixed bug [#70284](http://bugs.php.net/70284) (Use after free vulnerability in unserialize() with GMP).

##  hash

*   Fixed bug [#70312](http://bugs.php.net/70312) (HAVAL gives wrong hashes in specific cases).

##   IMAP

*   Fixed bug [#70158](http://bugs.php.net/70158) (Building with static imap fails).
*   Fixed bug [#69998](http://bugs.php.net/69998) (curl multi leaking memory).


##  Intl

*   Removed deprecated aliases datefmt\_set\_timezone\_id() and IntlDateFormatter::setTimeZoneID().
----

*   Fixed bug [#70453](http://bugs.php.net/70453) (IntlChar::foldCase() incorrect arguments and missing constants).
*   Fixed bug [#70454](http://bugs.php.net/70454) (IntlChar::forDigit second parameter should be optional).

## JSON

*   Replace non-free JSON parser with a parser from Jsond extension, fixes [#63520](http://bugs.php.net/63520) (JSON extension includes a problematic license statement).
----

*   Fixed bug [#62010](http://bugs.php.net/62010) (json\_decode produces invalid byte-sequences).
*   Fixed bug [#68546](http://bugs.php.net/68546) (json\_decode() Fatal error: Cannot access property started with '\\0').
*   Fixed bug [#68938](http://bugs.php.net/68938) (json\_decode() decodes empty string without error).


##   LDAP

*   Fixed bug [#47222](http://bugs.php.net/47222) (Implement LDAP\_OPT\_DIAGNOSTIC\_MESSAGE).

##   LiteSpeed

https://www.php.net/manual/zh/install.unix.litespeed.php

*   ```Updated LiteSpeed SAPI code from V5.5 to V6.6.```


##  libxml

*   Fixed handling of big lines in error messages with libxml >= 2.9.0.

##   Mcrypt

*   Removed mcrypt\_generic\_end() alias.
*   Removed mcrypt\_ecb(), mcrypt\_cbc(), mcrypt\_cfb(), mcrypt\_ofb().

-----

*   Fixed bug [#70625](http://bugs.php.net/70625) (mcrypt\_encrypt() won't return data when no IV was specified under RC4).
*   Fixed bug [#69833](http://bugs.php.net/69833) (mcrypt fd caching not working).
*   Fixed possible read after end of buffer and use after free.

##   Mysqli

*   Fixed bug [#32490](http://bugs.php.net/32490) (constructor of mysqli has wrong name).

##  Mysqlnd

*   Fixed bug [#70949](http://bugs.php.net/70949) (SQL Result Sets With NULL Can Cause Fatal Memory Errors).
*   Fixed bug [#70384](http://bugs.php.net/70384) (mysqli\_real\_query():Unknown type 245 sent by the server).
*   Fixed bug [#70456](http://bugs.php.net/70456) (mysqlnd doesn't activate TCP keep-alive when connecting to a server).
*   Fixed bug [#70572](http://bugs.php.net/70572) segfault in mysqlnd\_connect.
*   Fixed bug [#69796](http://bugs.php.net/69796) (mysqli\_stmt::fetch doesn't assign null values to bound variables).

##  OCI8

*   Corrected oci8 hash destructors to prevent segfaults, and a few other fixes.
-----

*   Fixed memory leak with LOBs.
*   Fixed bug [#68298](http://bugs.php.net/68298) (OCI int overflow).

##   ODBC

*   Fixed bug [#69975](http://bugs.php.net/69975) (PHP segfaults when accessing nvarchar(max) defined columns. (CVE-2015-8879)

##   Opcache
*   Removed opcache.load\_comments configuration directive. Now doc comments loading costs nothing and always enabled.
----

*   Added experimental (disabled by default) file based opcode cache.

----

*   Fixed bug [#70656](http://bugs.php.net/70656) (require() statement broken after opcache\_reset() or a few hours of use).
*   Fixed bug [#70843](http://bugs.php.net/70843) (Segmentation fault on MacOSX with opcache.file\_cache\_only=1).
*   Fixed bug [#70724](http://bugs.php.net/70724) (Undefined Symbols from opcache.so on Mac OS X 10.10).
*   Fixed compatibility with Windows 10 (see also bug [#70652](http://bugs.php.net/70652)).
*   Attmpt to fix "Unable to reattach to base address" problem.
*   Fixed bug [#70423](http://bugs.php.net/70423) (Warning Internal error: wrong size calculation).
*   Fixed bug [#70237](http://bugs.php.net/70237) (Empty while and do-while segmentation fault with opcode on CLI enabled).
*   Fixed bug [#70111](http://bugs.php.net/70111) (Segfault when a function uses both an explicit return type and an explicit cast).
*   Fixed bug [#70058](http://bugs.php.net/70058) (Build fails when building for i386).
*   Fixed bug [#70022](http://bugs.php.net/70022) (Crash with opcache using opcache.file\_cache\_only=1).

*   Fixed bug [#69838](http://bugs.php.net/69838) (Wrong size calculation for function table).
*   Fixed bug [#69688](http://bugs.php.net/69688) (segfault with eval and opcache fast shutdown).
*   Fixed bug with try blocks being removed when extended\_info opcode generation is turned on.
*   Fixed bug [#68644](http://bugs.php.net/68644) (strlen incorrect : mbstring + func\_overload=2 +UTF-8 + Opcache).

##   OpenSSL

*   Require at least OpenSSL version 0.9.8.
----

*   Removed "CN\_match" and "SNI\_server\_name" SSL context options. Use automatic detection or the "peer\_name" option instead.
-----

*   Added "alpn\_protocols" SSL context option allowing encrypted client/server streams to negotiate alternative protocols using the ALPN TLS extension when built against OpenSSL 1.0.2 or newer. Negotiated protocol information is accessible through stream\_get\_meta\_data() output.
*   Implemented FR [#70438](http://bugs.php.net/70438) (Add IV parameter for openssl\_seal and openssl\_open).


-----

*   Fixed bug [#68312](http://bugs.php.net/68312) (Lookup for openssl.cnf causes a message box).
*   Fixed bug [#55259](http://bugs.php.net/55259) (openssl extension does not get the DH parameters from DH key resource).
*   Fixed bug [#70395](http://bugs.php.net/70395) (Missing ARG\_INFO for openssl\_seal()).
*   Fixed bug [#60632](http://bugs.php.net/60632) (openssl\_seal fails with AES).
*   Fixed bug [#70014](http://bugs.php.net/70014) (openssl\_random\_pseudo\_bytes() is not cryptographically secure). (CVE-2015-8867)
*   Fixed bug [#69882](http://bugs.php.net/69882) (OpenSSL error "key values mismatch" after openssl\_pkcs12\_read with extra cert).


##   Pcntl

*   Implemented FR [#68505](http://bugs.php.net/68505) (Added wifcontinued and wcontinued).
*   Added rusage support to pcntl\_wait() and pcntl\_waitpid().
-----

*   Fixed bug [#70386](http://bugs.php.net/70386) (Can't compile on NetBSD because of missing WCONTINUED and WIFCONTINUED).
*   Fixed bug [#60509](http://bugs.php.net/60509) (pcntl\_signal doesn't decrease ref-count of old handler when setting SIG\_DFL).


##  PCRE

*   Removed support for the /e (PREG\_REPLACE\_EVAL) modifier.
-----

*   Fixed bug [#70232](http://bugs.php.net/70232) (Incorrect bump-along behavior with \\K and empty string match).
*   Fixed bug [#70345](http://bugs.php.net/70345) (Multiple vulnerabilities related to PCRE functions).
*   Fixed bug [#70232](http://bugs.php.net/70232) (Incorrect bump-along behavior with \\K and empty string match).
*   Fixed bug [#53823](http://bugs.php.net/53823) (preg\_replace: \* qualifier on unicode replace garbles the string).
*   Fixed bug [#69864](http://bugs.php.net/69864) (Segfault in preg\_replace\_callback).

##   PDO

*   Fixed bug [#70861](http://bugs.php.net/70861) (Segmentation fault in pdo\_parse\_params() during Drupal 8 test suite).
*   Fixed bug [#70389](http://bugs.php.net/70389) (PDO constructor changes unrelated variables).
*   Fixed bug [#70272](http://bugs.php.net/70272) (Segfault in pdo\_mysql).
*   Fixed bug [#70221](http://bugs.php.net/70221) (persistent sqlite connection + custom function segfaults).
*   Fixed bug [#59450](http://bugs.php.net/59450) (./configure fails with "Cannot find php\_pdo\_driver.h").


##   PDO\_DBlib

*   Fixed bug [#69757](http://bugs.php.net/69757) (Segmentation fault on nextRowset).

##   PDO\_mysql

*   Fixed bug [#68424](http://bugs.php.net/68424) (Add new PDO mysql connection attr to control multi statements option).

##   PDO\_OCI
*   Fixed bug [#70308](http://bugs.php.net/70308) (PDO::ATTR\_PREFETCH is ignored).

##   PDO\_pgsql
*   Removed PGSQL\_ATTR\_DISABLE\_NATIVE\_PREPARED\_STATEMENT attribute in favor of ATTR\_EMULATE\_PREPARES).
----

*   Fixed bug [#69752](http://bugs.php.net/69752) (PDOStatement::execute() leaks memory with DML Statements when closeCuror() is u).

##   Phar

*   Fixed bug [#69720](http://bugs.php.net/69720) (Null pointer dereference in phar\_get\_fp\_offset()).
*   Fixed bug [#70433](http://bugs.php.net/70433) (Uninitialized pointer in phar\_make\_dirstream when zip entry filename is "/").
*   Improved fix for bug [#69441](http://bugs.php.net/69441).
*   Fixed bug [#70019](http://bugs.php.net/70019) (Files extracted from archive may be placed outside of destination directory).

##   Phpdbg

*   Fixed bug [#70614](http://bugs.php.net/70614) (incorrect exit code in -rr mode with Exceptions).
*   Fixed bug [#70532](http://bugs.php.net/70532) (phpdbg must respect set\_exception\_handler).
*   Fixed bug [#70531](http://bugs.php.net/70531) (Run and quit mode (-qrr) should not fallback to interactive mode).
*   Fixed bug [#70533](http://bugs.php.net/70533) (Help overview (-h) does not rpint anything under Windows).
*   Fixed bug [#70449](http://bugs.php.net/70449) (PHP won't compile on 10.4 and 10.5 because of missing constants).
*   Fixed bug [#70214](http://bugs.php.net/70214) (FASYNC not defined, needs sys/file.h include).
*   Fixed bug [#70138](http://bugs.php.net/70138) (Segfault when displaying memory leaks).


##  Reflection

*   Added ReflectionGenerator class.
*   Added reflection support for return types and type declarations.
-----

*   Fixed bug [#70650](http://bugs.php.net/70650) (Wrong docblock assignment).
*   Fixed bug [#70674](http://bugs.php.net/70674) (ReflectionFunction::getClosure() leaks memory when used for internal functions).
*   Fixed bug causing bogus traces for ReflectionGenerator::getTrace().
*   Fixed inheritance chain of Reflector interface.

##   Session
*   Fixed bug [#70876](http://bugs.php.net/70876) (Segmentation fault when regenerating session id with strict mode).
*   Fixed bug [#70529](http://bugs.php.net/70529) (Session read causes "String is not zero-terminated" error).
*   Fixed bug [#70013](http://bugs.php.net/70013) (Reference to $\_SESSION is lost after a call to session\_regenerate\_id()).
*   Fixed bug [#69952](http://bugs.php.net/69952) (Data integrity issues accessing superglobals by reference).
*   Fixed bug [#67694](http://bugs.php.net/67694) (Regression in session\_regenerate\_id()).
*   Fixed bug [#68941](http://bugs.php.net/68941) (mod\_files.sh is a bash-script).

##   SOAP

*   Fixed bug [#70940](http://bugs.php.net/70940) (Segfault in soap / type\_to\_string).
*   Fixed bug [#70900](http://bugs.php.net/70900) (SoapClient systematic out of memory error).
*   Fixed bug [#70875](http://bugs.php.net/70875) (Segmentation fault if wsdl has no targetNamespace attribute).
*   Fixed bug [#70715](http://bugs.php.net/70715) (Segmentation fault inside soap client).
*   Fixed bug [#70709](http://bugs.php.net/70709) (SOAP Client generates Segfault).
*   Fixed bug [#70388](http://bugs.php.net/70388) (SOAP serialize\_function\_call() type confusion / RCE).
*   Fixed bug [#70081](http://bugs.php.net/70081) (SoapClient info leak / null pointer dereference via multiple type confusions).
*   Fixed bug [#70079](http://bugs.php.net/70079) (Segmentation fault after more than 100 SoapClient calls).
*   Fixed bug [#70032](http://bugs.php.net/70032) (make\_http\_soap\_request calls zend\_hash\_get\_current\_key\_ex(,,,NULL).
*   Fixed bug [#68361](http://bugs.php.net/68361) (Segmentation fault on SoapClient::\_\_getTypes).


##   SPL

*   Changed ArrayIterator implementation using zend\_hash\_iterator\_... API. Allowed modification of iterated ArrayObject using the same behavior as proposed in \`Fix "foreach" behavior\`. Removed "Array was modified outside object and internal position is no longer valid" hack.

----

*   Implemented FR [#67886](http://bugs.php.net/67886) (SplPriorityQueue/SplHeap doesn't expose extractFlags nor curruption state).

----
*   Fixed bug [#70959](http://bugs.php.net/70959) (ArrayObject unserialize does not restore protected fields).
*   Fixed bug [#70853](http://bugs.php.net/70853) (SplFixedArray throws exception when using ref variable as index).
*   Fixed bug [#70868](http://bugs.php.net/70868) (PCRE JIT and pattern reuse segfault).
*   Fixed bug [#70730](http://bugs.php.net/70730) (Incorrect ArrayObject serialization if unset is called in serialize()).
*   Fixed bug [#70573](http://bugs.php.net/70573) (Cloning SplPriorityQueue leads to memory leaks).
*   Fixed bug [#70303](http://bugs.php.net/70303) (Incorrect constructor reflection for ArrayObject).
*   Fixed bug [#70068](http://bugs.php.net/70068) (Dangling pointer in the unserialization of ArrayObject items).
*   Fixed bug [#70166](http://bugs.php.net/70166) (Use After Free Vulnerability in unserialize() with SPLArrayObject).
*   Fixed bug [#70168](http://bugs.php.net/70168) (Use After Free Vulnerability in unserialize() with SplObjectStorage).
*   Fixed bug [#70169](http://bugs.php.net/70169) (Use After Free Vulnerability in unserialize() with SplDoublyLinkedList).
*   Fixed bug [#70053](http://bugs.php.net/70053) (MutlitpleIterator array-keys incompatible change in PHP 7).
*   Fixed bug [#69970](http://bugs.php.net/69970) (Use-after-free vulnerability in spl\_recursive\_it\_move\_forward\_ex()).
*   Fixed bug [#69845](http://bugs.php.net/69845) (ArrayObject with ARRAY\_AS\_PROPS broken).
*   Fixed bug [#66405](http://bugs.php.net/66405) (RecursiveDirectoryIterator::CURRENT\_AS\_PATHNAME breaks the RecursiveIterator).

##  SQLite3
*   Fixed bug [#70571](http://bugs.php.net/70571) (Memory leak in sqlite3\_do\_callback).
*   Fixed bug [#69972](http://bugs.php.net/69972) (Use-after-free vulnerability in sqlite3SafetyCheckSickOrOk()).
*   Fixed bug [#69897](http://bugs.php.net/69897) (segfault when manually constructing SQLite3Result).
*   Fixed bug [#68260](http://bugs.php.net/68260) (SQLite3Result::fetchArray declares wrong required\_num\_args).

##  Standard

*   Deprecated salt option to password\_hash.
*   Removed call\_user\_method() and call\_user\_method\_array() functions.
*   Remove string category support in setlocale().
*   Remove set\_magic\_quotes\_runtime() and its alias magic\_quotes\_runtime().
*   Removed hardcoded limit on number of pipes in proc\_open().

-----

*   Improved precision of log() function for base 2 and 10.
-----

*   Added Windows support for getrusage().
*   Added preg\_replace\_callback\_array function.
*   Added intdiv() function.
*   Implemented FR [#70112](http://bugs.php.net/70112) (Allow "dirname" to go up various times).
*   Implemented the RFC \`Random Functions Throwing Exceptions in PHP 7\`.
----


*   Fixed count on symbol tables.
*   Fixed bug [#70963](http://bugs.php.net/70963) (Unserialize shows UNKNOWN in result).
*   Fixed bug [#70910](http://bugs.php.net/70910) (extract() breaks variable references).
*   Fixed bug [#70808](http://bugs.php.net/70808) (array\_merge\_recursive corrupts memory of unset items).
*   Fixed bug [#70667](http://bugs.php.net/70667) (strtr() causes invalid writes and a crashes).
*   Fixed bug [#70668](http://bugs.php.net/70668) (array\_keys() doesn't respect references when $strict is true).
*   Fixed bug [#70487](http://bugs.php.net/70487) (pack('x') produces an error).
*   Fixed bug [#70342](http://bugs.php.net/70342) (changing configuration with ignore\_user\_abort(true) isn't working).
*   Fixed bug [#70295](http://bugs.php.net/70295) (Segmentation fault with setrawcookie).
*   Fixed bug [#67131](http://bugs.php.net/67131) (setcookie() conditional for empty values not met).
*   Fixed bug [#70365](http://bugs.php.net/70365) (Use-after-free vulnerability in unserialize() with SplObjectStorage).
*   Fixed bug [#70366](http://bugs.php.net/70366) (Use-after-free vulnerability in unserialize() with SplDoublyLinkedList).
*   Fixed bug [#70250](http://bugs.php.net/70250) (extract() turns array elements to references).
*   Fixed bug [#70211](http://bugs.php.net/70211) (php 7 ZEND\_HASH\_IF\_FULL\_DO\_RESIZE use after free).
*   Fixed bug [#70208](http://bugs.php.net/70208) (Assert breaking access on objects).
*   Fixed bug [#70140](http://bugs.php.net/70140) (str\_ireplace/php\_string\_tolower - Arbitrary Code Execution).
*   Fixed bug [#36365](http://bugs.php.net/36365) (scandir duplicates file name at every 65535th file).
*   Fixed bug [#70096](http://bugs.php.net/70096) (Repeated iptcembed() adds superfluous FF bytes).
*   Fixed bug [#70018](http://bugs.php.net/70018) (exec does not strip all whitespace).
*   Fixed bug [#69983](http://bugs.php.net/69983) (get\_browser fails with user agent of null).
*   Fixed bug [#69976](http://bugs.php.net/69976) (Unable to parse "all" urls with colon char).
*   Fixed bug [#69768](http://bugs.php.net/69768) (escapeshell\*() doesn't cater to !).
*   Fixed bug [#62922](http://bugs.php.net/62922) (Truncating entire string should result in string).
*   Fixed bug [#69723](http://bugs.php.net/69723) (Passing parameters by reference and array\_column).
*   Fixed bug [#69523](http://bugs.php.net/69523) (Cookie name cannot be empty).
*   Fixed bug [#69325](http://bugs.php.net/69325) (php\_copy\_file\_ex does not pass the argument).
*   Fixed bug [#69299](http://bugs.php.net/69299) (Regression in array\_filter's $flag argument in PHP 7).
*   Fixed user session handlers (See rfc:session.user.return-value).
*   Fixed bug [#65272](http://bugs.php.net/65272) (flock() out parameter not set correctly in windows).
*   Fixed bug [#69686](http://bugs.php.net/69686) (password\_verify reports back error on PHP7 will null string).

##   Streams

*   Removed set\_socket\_blocking() in favor of its alias stream\_set\_blocking().
-----

*   Fixed bug [#70361](http://bugs.php.net/70361) (HTTP stream wrapper doesn't close keep-alive connections).
*   Fixed bug [#68532](http://bugs.php.net/68532) (convert.base64-encode omits padding bytes).


##   Tokenizer

*   Fixed bug [#69430](http://bugs.php.net/69430) (token\_get\_all has new irrecoverable errors).

##   XMLReader
*   Fixed bug [#70309](http://bugs.php.net/70309) (XmlReader read generates extra output).

##   XMLRPC
*   Fixed bug [#70526](http://bugs.php.net/70526) (xmlrpc\_set\_type returns false on success).

##   XSL
*   Removed xsl.security\_prefs ini option.
----
*   Fixed bug [#70678](http://bugs.php.net/70678) (PHP7 returns true when false is expected).
*   Fixed bug [#70535](http://bugs.php.net/70535) (XSLT: free(): invalid pointer).
*   Fixed bug [#69782](http://bugs.php.net/69782) (NULL pointer dereference).
*   Fixed bug [#64776](http://bugs.php.net/64776) (The XSLT extension is not thread safe).

##   Zlib
*   Added deflate\_init(), deflate\_add(), inflate\_init(), inflate\_add() functions allowing incremental/streaming compression/decompression.

##   Zip

*   Update bundled libzip to 1.0.1.
-----

*   Added ZipArchive::setCompressionName and ZipArchive::setCompressionIndex methods.
----

*   Fixed bug [#70322](http://bugs.php.net/70322) (ZipArchive::close() doesn't indicate errors).
*   Fixed bug [#70350](http://bugs.php.net/70350) (ZipArchive::extractTo allows for directory traversal when creating directories). (CVE-2014-9767)
*   Fixed bug [#67161](http://bugs.php.net/67161) (ZipArchive::getStream() returns NULL for certain file).
