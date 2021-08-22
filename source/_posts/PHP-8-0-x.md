---
title: PHP 8.0.x
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - PHP8
  - 历史
  - PHP发展史
  - 技术发展史
date: 2020-11-26 15:00:00
---

# 目标及关键路径

* 提升性能
  * 基于缓存前置思想，使用CPU机器码缓存，绕过Zend VM及其过程开销来尽可能提升性能
    * JIT


# 从 PHP 7.4.x 移植到 PHP 8.0.x

[这里可以找到原文](https://www.php.net/manual/zh/migration80.php)


## 不向后兼容的变更

* 数字与非数字形式的字符串之间的非严格比较现在将首先将数字转为字符串，然后比较这两个字符串。 数字与数字形式的字符串之间的比较仍然像之前那样进行。 请注意，这意味着 0 == "not-a-number" 现在将被认为是 false 。

*   `match` 现在是一个保留字。

*   断言（Assertion）失败现在默认抛出异常。如果想要改回之前的行为，可以在 INI 设置中设置 `assert.exception=0` 。

*   与类名相同的方法名将不再被当做构造方法。应该使用[\_\_construct()](https://www.php.net/manual/zh/language.oop5.decon.php#object.construct) 来取代它。

*   不再允许通过静态调用的方式去调用非静态方法。因此[is\_callable()](https://www.php.net/manual/zh/function.is-callable.php)在检查一个类名与非静态方法 时将返回失败（应当检查一个类的实例）。

*   `(real)` 和 `(unset)` 转换已被移除。

*   The [track\_errors](https://www.php.net/manual/zh/errorfunc.configuration.php#ini.track-errors) ini directive has been removed. This means that php\_errormsg is no longer available. The [error\_get\_last()](https://www.php.net/manual/zh/function.error-get-last.php) function may be used instead.

*   The ability to define case-insensitive constants has been removed. The third argument to [define()](https://www.php.net/manual/zh/function.define.php) may no longer be `true`.

*   The ability to specify an autoloader using an [\_\_autoload()](https://www.php.net/manual/zh/function.autoload.php) function has been removed. [spl\_autoload\_register()](https://www.php.net/manual/zh/function.spl-autoload-register.php) should be used instead.

*   The `errcontext` argument will no longer be passed to custom error handlers set with [set\_error\_handler()](https://www.php.net/manual/zh/function.set-error-handler.php).

*   [create\_function()](https://www.php.net/manual/zh/function.create-function.php) has been removed. Anonymous functions may be used instead.

*   [each()](https://www.php.net/manual/zh/function.each.php) has been removed. [foreach](https://www.php.net/manual/zh/control-structures.foreach.php) or [ArrayIterator](https://www.php.net/manual/zh/class.arrayiterator.php) should be used instead.

*   The ability to unbind this from closures that were created from a method, using [Closure::fromCallable()](https://www.php.net/manual/zh/closure.fromcallable.php) or [ReflectionMethod::getClosure()](https://www.php.net/manual/zh/reflectionmethod.getclosure.php), has been removed.

*   The ability to unbind this from proper closures that contain uses of this has also been removed.

*   The ability to use [array\_key\_exists()](https://www.php.net/manual/zh/function.array-key-exists.php) with objects has been removed. [isset()](https://www.php.net/manual/zh/function.isset.php) or [property\_exists()](https://www.php.net/manual/zh/function.property-exists.php) may be used instead.

*   The behavior of [array\_key\_exists()](https://www.php.net/manual/zh/function.array-key-exists.php) regarding the type of the `key` parameter has been made consistent with [isset()](https://www.php.net/manual/zh/function.isset.php) and normal array access. All key types now use the usual coercions and array/object keys throw a [TypeError](https://www.php.net/manual/zh/class.typeerror.php).

*   Any array that has a number n as its first numeric key will use n+1 for its next implicit key, even if n is negative.

*   The default error\_reporting level is now `E_ALL`. Previously it excluded `E_NOTICE` and `E_DEPRECATED`.

*   [display\_startup\_errors](https://www.php.net/manual/zh/errorfunc.configuration.php#ini.display-startup-errors) is now enabled by default.

*   Using parent inside a class that has no parent will now result in a fatal compile-time error.

*   The `@` operator will no longer silence fatal errors (`E_ERROR`, `E_CORE_ERROR`, `E_COMPILE_ERROR`, `E_USER_ERROR`, `E_RECOVERABLE_ERROR`, `E_PARSE`). Error handlers that expect error\_reporting to be `0` when `@` is used, should be adjusted to use a mask check instead

*   `#[` is no longer interpreted as the start of a comment, as this syntax is now used for attributes.

*   Inheritance errors due to incompatible method signatures (LSP violations) will now always generate a fatal error. Previously a warning was generated in some cases.

*   The precedence of the concatenation operator has changed relative to bitshifts and addition as well as subtraction.

*   Arguments with a default value that resolves to `null` at runtime will no longer implicitly mark the argument type as nullable. Either an explicit nullable type, or an explicit `null` default value has to be used instead.


*   A number of warnings have been converted into [Error](https://www.php.net/manual/zh/class.error.php) exceptions:

    *   Attempting to write to a property of a non-object. Previously this implicitly created an stdClass object for null, false and empty strings.
    *   Attempting to append an element to an array for which the PHP\_INT\_MAX key is already used.
    *   Attempting to use an invalid type (array or object) as an array key or string offset.
    *   Attempting to write to an array index of a scalar value.
    *   Attempting to unpack a non-array/Traversable.
    *   Attempting to access unqualified constants which are undefined. Previously, unqualified constant accesses resulted in a warning and were interpreted as strings.

*  A number of notices have been converted into warnings:

    *   Attempting to read an undefined variable.
    *   Attempting to read an undefined property.
    *   Attempting to read an undefined array key.
    *   Attempting to read a property of a non-object.
    *   Attempting to access an array index of a non-array.
    *   Attempting to convert an array to string.
    *   Attempting to use a resource as an array key.
    *   Attempting to use null, a boolean, or a float as a string offset.
    *   Attempting to read an out-of-bounds string offset.
    *   Attempting to assign an empty string to a string offset.

*   Attempting to assign multiple bytes to a string offset will now emit a warning.

*   Unexpected characters in source files (such as NUL bytes outside of strings) will now result in a [ParseError](https://www.php.net/manual/zh/class.parseerror.php) exception instead of a compile warning.

*   Uncaught exceptions now go through "clean shutdown", which means that destructors will be called after an uncaught exception.

*   The compile time fatal error "Only variables can be passed by reference" has been delayed until runtime, and converted into an "Argument cannot be passed by reference" [Error](https://www.php.net/manual/zh/class.error.php) exception.

*   Some "Only variables should be passed by reference" notices have been converted to "Argument cannot be passed by reference" exception.

*   The generated name for anonymous classes has changed. It will now include the name of the first parent or interface

* Non-absolute trait method references in trait alias adaptations are now required to be unambiguous

* The signature of abstract methods defined in traits is now checked against the implementing class method

*   Disabled functions are now treated exactly like non-existent functions. Calling a disabled function will report it as unknown, and redefining a disabled function is now possible.

*   `data://` stream wrappers are no longer writable, which matches the documented behavior.

*   The arithmetic and bitwise operators `+`, `-`, `*`, `/`, `**`, `%`, `<<`, `>>`, `&`, `|`, `^`, `~`, `++`, `--` will now consistently throw a [TypeError](https://www.php.net/manual/zh/class.typeerror.php) when one of the operands is an array, [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php) or non-overloaded object. The only exception to this is the array `+` array merge operation, which remains supported.

*   Float to string casting will now always behave locale-independently.

* Support for deprecated curly braces for offset access has been removed.

*   Applying the final modifier on a private method will now produce a warning unless that method is the constructor.

*   If an object constructor [exit()](https://www.php.net/manual/zh/function.exit.php)s, the object destructor will no longer be called. This matches the behavior when the constructor throws.

*   Namespaced names can no longer contain whitespace: While `Foo\Bar` will be recognized as a namespaced name, `Foo \ Bar` will not. Conversely, reserved keywords are now permitted as namespace segments, which may also change the interpretation of code: `new\x` is now the same as `constant('new\x')`, not `new \x()`.

*   Nested ternaries now require explicit parentheses.

*   [debug\_backtrace()](https://www.php.net/manual/zh/function.debug-backtrace.php) and [Exception::getTrace()](https://www.php.net/manual/zh/exception.gettrace.php) will no longer provide references to arguments. It will not be possible to change function arguments through the backtrace.

*   Numeric string handling has been altered to be more intuitive and less error-prone. Trailing whitespace is now allowed in numeric strings for consistency with how leading whitespace is treated. This mostly affects:

    *   The [is\_numeric()](https://www.php.net/manual/zh/function.is-numeric.php) function
    *   String-to-string comparisons
    *   Type declarations
    *   Increment and decrement operations
    *   Arithmetic operations
    *   Bitwise operations

*   Magic Methods will now have their arguments and return types checked if they have them declared. The signatures should match the following list:

    *   `__call(string $name, array $arguments): mixed`
    *   `__callStatic(string $name, array $arguments): mixed`
    *   `__clone(): void`
    *   `__debugInfo(): ?array`
    *   `__get(string $name): mixed`
    *   `__invoke(mixed $arguments): mixed`
    *   `__isset(string $name): bool`
    *   `__serialize(): array`
    *   `__set(string $name, mixed $value): void`
    *   `__set_state(array $properties): object`
    *   `__sleep(): array`
    *   `__unserialize(array $data): void`
    *   `__unset(string $name): void`
    *   `__wakeup(): void`

*   [call\_user\_func\_array()](https://www.php.net/manual/zh/function.call-user-func-array.php) array keys will now be interpreted as parameter names, instead of being silently ignored.

*   Declaring a function called `assert()` inside a namespace is no longer allowed, and issues `E_COMPILE_ERROR`. The [assert()](https://www.php.net/manual/zh/function.assert.php) function is subject to special handling by the engine, which may lead to inconsistent behavior when defining a namespaced function with the same name.

* Several [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php)s have been migrated to objects. Return value checks using [is\_resource()](https://www.php.net/manual/zh/function.is-resource.php) should be replaced with checks for `false`.

  *   [curl\_init()](https://www.php.net/manual/zh/function.curl-init.php) will now return a [CurlHandle](https://www.php.net/manual/zh/class.curlhandle.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [curl\_close()](https://www.php.net/manual/zh/function.curl-close.php) function no longer has an effect, instead the [CurlHandle](https://www.php.net/manual/zh/class.curlhandle.php) instance is automatically destroyed if it is no longer referenced.

  *   [curl\_multi\_init()](https://www.php.net/manual/zh/function.curl-multi-init.php) will now return a [CurlMultiHandle](https://www.php.net/manual/zh/class.curlmultihandle.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [curl\_multi\_close()](https://www.php.net/manual/zh/function.curl-multi-close.php) function no longer has an effect, instead the [CurlMultiHandle](https://www.php.net/manual/zh/class.curlmultihandle.php) instance is automatically destroyed if it is no longer referenced.

  *   [curl\_share\_init()](https://www.php.net/manual/zh/function.curl-share-init.php) will now return a [CurlShareHandle](https://www.php.net/manual/zh/class.curlsharehandle.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [curl\_share\_close()](https://www.php.net/manual/zh/function.curl-share-close.php) function no longer has an effect, instead the [CurlShareHandle](https://www.php.net/manual/zh/class.curlsharehandle.php) instance is automatically destroyed if it is no longer referenced.

  *   [enchant\_broker\_init()](https://www.php.net/manual/zh/function.enchant-broker-init.php) will now return an [EnchantBroker](https://www.php.net/manual/zh/class.enchantbroker.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   [enchant\_broker\_request\_dict()](https://www.php.net/manual/zh/function.enchant-broker-request-dict.php) and [enchant\_broker\_request\_pwl\_dict()](https://www.php.net/manual/zh/function.enchant-broker-request-pwl-dict.php) will now return an [EnchantDictionary](https://www.php.net/manual/zh/class.enchantdictionary.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   The GD extension now uses [GdImage](https://www.php.net/manual/zh/class.gdimage.php) objects as the underlying data structure for images, rather than [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php)s. The [imagedestroy()](https://www.php.net/manual/zh/function.imagedestroy.php) function no longer has an effect; instead the [GdImage](https://www.php.net/manual/zh/class.gdimage.php) instance is automatically destroyed if it is no longer referenced.

  *   [openssl\_x509\_read()](https://www.php.net/manual/zh/function.openssl-x509-read.php) and [openssl\_csr\_sign()](https://www.php.net/manual/zh/function.openssl-csr-sign.php) will now return an [OpenSSLCertificate](https://www.php.net/manual/zh/class.opensslcertificate.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [openssl\_x509\_free()](https://www.php.net/manual/zh/function.openssl-x509-free.php) function is deprecated and no longer has an effect, instead the [OpenSSLCertificate](https://www.php.net/manual/zh/class.opensslcertificate.php) instance is automatically destroyed if it is no longer referenced.

  *   [openssl\_csr\_new()](https://www.php.net/manual/zh/function.openssl-csr-new.php) will now return an [OpenSSLCertificateSigningRequest](https://www.php.net/manual/zh/class.opensslcertificatesigningrequest.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   [openssl\_pkey\_new()](https://www.php.net/manual/zh/function.openssl-pkey-new.php) will now return an [OpenSSLAsymmetricKey](https://www.php.net/manual/zh/class.opensslasymmetrickey.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [openssl\_pkey\_free()](https://www.php.net/manual/zh/function.openssl-pkey-free.php) function is deprecated and no longer has an effect, instead the [OpenSSLAsymmetricKey](https://www.php.net/manual/zh/class.opensslasymmetrickey.php) instance is automatically destroyed if it is no longer referenced.

  *   [shmop\_open()](https://www.php.net/manual/zh/function.shmop-open.php) will now return a [Shmop](https://www.php.net/manual/zh/class.shmop.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [shmop\_close()](https://www.php.net/manual/zh/function.shmop-close.php) function no longer has an effect, and is deprecated; instead the [Shmop](https://www.php.net/manual/zh/class.shmop.php) instance is automatically destroyed if it is no longer referenced.

  *   [socket\_create()](https://www.php.net/manual/zh/function.socket-create.php), [socket\_create\_listen()](https://www.php.net/manual/zh/function.socket-create-listen.php), [socket\_accept()](https://www.php.net/manual/zh/function.socket-accept.php), [socket\_import\_stream()](https://www.php.net/manual/zh/function.socket-import-stream.php), [socket\_addrinfo\_connect()](https://www.php.net/manual/zh/function.socket-addrinfo-connect.php), [socket\_addrinfo\_bind()](https://www.php.net/manual/zh/function.socket-addrinfo-bind.php), and [socket\_wsaprotocol\_info\_import()](https://www.php.net/manual/zh/function.socket-wsaprotocol-info-import.php) will now return a [Socket](https://www.php.net/manual/zh/class.socket.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). [socket\_addrinfo\_lookup()](https://www.php.net/manual/zh/function.socket-addrinfo-lookup.php) will now return an array of [AddressInfo](https://www.php.net/manual/zh/class.addressinfo.php) objects rather than [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php)s.

  *   [msg\_get\_queue()](https://www.php.net/manual/zh/function.msg-get-queue.php) will now return an SysvMessageQueue object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   [sem\_get()](https://www.php.net/manual/zh/function.sem-get.php) will now return an SysvSemaphore object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   [shm\_attach()](https://www.php.net/manual/zh/function.shm-attach.php) will now return an SysvSharedMemory object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   [xml\_parser\_create()](https://www.php.net/manual/zh/function.xml-parser-create.php) and [xml\_parser\_create\_ns()](https://www.php.net/manual/zh/function.xml-parser-create-ns.php) will now return an [XMLParser](https://www.php.net/manual/zh/class.xmlparser.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php). The [xml\_parser\_free()](https://www.php.net/manual/zh/function.xml-parser-free.php) function no longer has an effect, instead the XmlParser instance is automatically destroyed if it is no longer referenced.

  *   The [XMLWriter](https://www.php.net/manual/zh/book.xmlwriter.php) functions now accept and return, respectively, [XMLWriter](https://www.php.net/manual/zh/class.xmlwriter.php) objects instead of [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php)s.

  *   [inflate\_init()](https://www.php.net/manual/zh/function.inflate-init.php) will now return an [InflateContext](https://www.php.net/manual/zh/class.inflatecontext.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).

  *   [deflate\_init()](https://www.php.net/manual/zh/function.deflate-init.php) will now return a [DeflateContext](https://www.php.net/manual/zh/class.deflatecontext.php) object rather than a [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php).


* The ability to import case-insensitive constants from type libraries has been removed. The second argument to [com\_load\_typelib()](https://www.php.net/manual/zh/function.com-load-typelib.php) may no longer be false; [com.autoregister\_casesensitive](https://www.php.net/manual/zh/com.configuration.php#ini.com.autoregister-casesensitive) may no longer be disabled; case-insensitive markers in [com.typelib\_file](https://www.php.net/manual/zh/com.configuration.php#ini.com.typelib-file) are ignored.


* `CURLOPT_POSTFIELDS` no longer accepts objects as arrays. To interpret an object as an array, perform an explicit `(array)` cast. The same applies to other options accepting arrays as well.

* [mktime()](https://www.php.net/manual/zh/function.mktime.php) and [gmmktime()](https://www.php.net/manual/zh/function.gmmktime.php) now require at least one argument. [time()](https://www.php.net/manual/zh/function.time.php) can be used to get the current timestamp.


* Unimplemented classes from the DOM extension that had no behavior and contained test data have been removed. These classes have also been removed in the latest version of the DOM standard:

  *   DOMNameList
  *   DomImplementationList
  *   DOMConfiguration
  *   DomError
  *   DomErrorHandler
  *   DOMImplementationSource
  *   DOMLocator
  *   DOMUserDataHandler
  *   DOMTypeInfo


*   [enchant\_broker\_list\_dicts()](https://www.php.net/manual/zh/function.enchant-broker-list-dicts.php), [enchant\_broker\_describe()](https://www.php.net/manual/zh/function.enchant-broker-describe.php) and [enchant\_dict\_suggest()](https://www.php.net/manual/zh/function.enchant-dict-suggest.php) will now return an empty array instead of `null`.

* [read\_exif\_data()](https://www.php.net/manual/zh/function.read-exif-data.php) has been removed; [exif\_read\_data()](https://www.php.net/manual/zh/function.exif-read-data.php) should be used instead.

* Filter

  *   The `FILTER_FLAG_SCHEME_REQUIRED` and `FILTER_FLAG_HOST_REQUIRED` flags for the `FILTER_VALIDATE_URL` filter have been removed. The `scheme` and `host` are (and have been) always required.

  *   The `INPUT_REQUEST` and `INPUT_SESSION` source for [filter\_input()](https://www.php.net/manual/zh/function.filter-input.php) etc. have been removed. These were never implemented and their use always generated a warning.


* GD
  *   The deprecated functions [image2wbmp()](https://www.php.net/manual/zh/function.image2wbmp.php) has been removed.

  *   The deprecated functions [png2wbmp()](https://www.php.net/manual/zh/function.png2wbmp.php) and [jpeg2wbmp()](https://www.php.net/manual/zh/function.jpeg2wbmp.php) have been removed.

  *   The default `mode` parameter of [imagecropauto()](https://www.php.net/manual/zh/function.imagecropauto.php) no longer accepts `-1`. `IMG_CROP_DEFAULT` should be used instead.

  *   On Windows, php\_gd2.dll has been renamed to php\_gd.dll.


* [gmp\_random()](https://www.php.net/manual/zh/function.gmp-random.php) has been removed. One of [gmp\_random\_range()](https://www.php.net/manual/zh/function.gmp-random-range.php) or [gmp\_random\_bits()](https://www.php.net/manual/zh/function.gmp-random-bits.php) should be used instead.

* iconv implementations which do not properly set errno in case of errors are no longer supported.


* IMAP

  *   The unused `default_host` argument of [imap\_headerinfo()](https://www.php.net/manual/zh/function.imap-headerinfo.php) has been removed.

  *   The [imap\_header()](https://www.php.net/manual/zh/function.imap-header.php) function which is an alias of [imap\_headerinfo()](https://www.php.net/manual/zh/function.imap-headerinfo.php) has been removed.


* Internationalization Functions

  *   The deprecated constant `INTL_IDNA_VARIANT_2003` has been removed.

  *   The deprecated `Normalizer::NONE` constant has been removed.

* LDAP

  *   The deprecated functions [ldap\_sort()](https://www.php.net/manual/zh/function.ldap-sort.php), [ldap\_control\_paged\_result()](https://www.php.net/manual/zh/function.ldap-control-paged-result.php) and [ldap\_control\_paged\_result\_response()](https://www.php.net/manual/zh/function.ldap-control-paged-result-response.php) have been removed.

  *   The interface of [ldap\_set\_rebind\_proc()](https://www.php.net/manual/zh/function.ldap-set-rebind-proc.php) has changed; the `callback` parameter does not accept empty strings anymore; `null` should be used instead.


* MBString

  *   The [mbstring.func\_overload](https://www.php.net/manual/zh/mbstring.configuration.php#ini.mbstring.func-overload) directive has been removed. The related `MB_OVERLOAD_MAIL`, `MB_OVERLOAD_STRING`, and `MB_OVERLOAD_REGEX` constants have also been removed. Finally, the `"func_overload"` and `"func_overload_list"` entries in [mb\_get\_info()](https://www.php.net/manual/zh/function.mb-get-info.php) have been removed.

  *   [mb\_parse\_str()](https://www.php.net/manual/zh/function.mb-parse-str.php) can no longer be used without specifying a result array.

  *   A number of deprecated mbregex aliases have been removed. See the following list for which functions should be used instead:

      *   **mbregex\_encoding()** → [mb\_regex\_encoding()](https://www.php.net/manual/zh/function.mb-regex-encoding.php)
      *   **mbereg()** → [mb\_ereg()](https://www.php.net/manual/zh/function.mb-ereg.php)
      *   **mberegi()** → [mb\_eregi()](https://www.php.net/manual/zh/function.mb-eregi.php)
      *   **mbereg\_replace()** → [mb\_ereg\_replace()](https://www.php.net/manual/zh/function.mb-ereg-replace.php)
      *   **mberegi\_replace()** → [mb\_eregi\_replace()](https://www.php.net/manual/zh/function.mb-eregi-replace.php)
      *   **mbsplit()** → [mb\_split()](https://www.php.net/manual/zh/function.mb-split.php)
      *   **mbereg\_match()** → [mb\_ereg\_match()](https://www.php.net/manual/zh/function.mb-ereg-match.php)
      *   **mbereg\_search()** → [mb\_ereg\_search()](https://www.php.net/manual/zh/function.mb-ereg-search.php)
      *   **mbereg\_search\_pos()** → [mb\_ereg\_search\_pos()](https://www.php.net/manual/zh/function.mb-ereg-search-pos.php)
      *   **mbereg\_search\_regs()** → [mb\_ereg\_search\_regs()](https://www.php.net/manual/zh/function.mb-ereg-search-regs.php)
      *   **mbereg\_search\_init()** → [mb\_ereg\_search\_init()](https://www.php.net/manual/zh/function.mb-ereg-search-init.php)
      *   **mbereg\_search\_getregs()** → [mb\_ereg\_search\_getregs()](https://www.php.net/manual/zh/function.mb-ereg-search-getregs.php)
      *   **mbereg\_search\_getpos()** → [mb\_ereg\_search\_getpos()](https://www.php.net/manual/zh/function.mb-ereg-search-getpos.php)
      *   **mbereg\_search\_setpos()** → [mb\_ereg\_search\_setpos()](https://www.php.net/manual/zh/function.mb-ereg-search-setpos.php)

  *   The `e` modifier for [mb\_ereg\_replace()](https://www.php.net/manual/zh/function.mb-ereg-replace.php) has been removed. [mb\_ereg\_replace\_callback()](https://www.php.net/manual/zh/function.mb-ereg-replace-callback.php) should be used instead.

  *   A non-string pattern argument to [mb\_ereg\_replace()](https://www.php.net/manual/zh/function.mb-ereg-replace.php) will now be interpreted as a string instead of an ASCII codepoint. The previous behavior may be restored with an explicit call to [chr()](https://www.php.net/manual/zh/function.chr.php).

  *   The `needle` argument for [mb\_strpos()](https://www.php.net/manual/zh/function.mb-strpos.php), [mb\_strrpos()](https://www.php.net/manual/zh/function.mb-strrpos.php), [mb\_stripos()](https://www.php.net/manual/zh/function.mb-stripos.php), [mb\_strripos()](https://www.php.net/manual/zh/function.mb-strripos.php), [mb\_strstr()](https://www.php.net/manual/zh/function.mb-strstr.php), [mb\_stristr()](https://www.php.net/manual/zh/function.mb-stristr.php), [mb\_strrchr()](https://www.php.net/manual/zh/function.mb-strrchr.php) and [mb\_strrichr()](https://www.php.net/manual/zh/function.mb-strrichr.php) can now be empty.

  *   The `is_hex` parameter, which was not used internally, has been removed from [mb\_decode\_numericentity()](https://www.php.net/manual/zh/function.mb-decode-numericentity.php).

  *   The legacy behavior of passing the encoding as the third argument instead of an offset for the [mb\_strrpos()](https://www.php.net/manual/zh/function.mb-strrpos.php) function has been removed; an explicit `0` offset with the encoding should be provided as the fourth argument instead.

  *   The `ISO_8859-*` character encoding aliases have been replaced by `ISO8859-*` aliases for better interoperability with the iconv extension. The mbregex ISO 8859 aliases with underscores (`ISO_8859_*` and `ISO8859_*`) have also been removed.

  *   [mb\_ereg()](https://www.php.net/manual/zh/function.mb-ereg.php) and [mb\_eregi()](https://www.php.net/manual/zh/function.mb-eregi.php) will now return boolean `true` on a successful match. Previously they returned integer `1` if `matches` was not passed, or `max(1, strlen($matches[0]))` if `matches` was passed.


* OCI8

  *   The **OCI-Lob** class is now called [OCILob](https://www.php.net/manual/zh/class.OCI-Lob.php), and the **OCI-Collection** class is now called [OCICollection](https://www.php.net/manual/zh/class.OCI-Collection.php) for name compliance enforced by PHP 8 arginfo type annotation tooling.

  *   Several alias functions have been marked as deprecated.

  *   [oci\_internal\_debug()](https://www.php.net/manual/zh/function.oci-internal-debug.php) and its alias [ociinternaldebug()](https://www.php.net/manual/zh/function.ociinternaldebug.php) have been removed.

* ODBC

  *   [odbc\_connect()](https://www.php.net/manual/zh/function.odbc-connect.php) no longer reuses connections.

  *   The unused `flags` parameter of [odbc\_exec()](https://www.php.net/manual/zh/function.odbc-exec.php) has been removed.


* OpenSSL

  *   [openssl\_seal()](https://www.php.net/manual/zh/function.openssl-seal.php) and [openssl\_open()](https://www.php.net/manual/zh/function.openssl-open.php) now require `method` to be passed, as the previous default of `"RC4"` is considered insecure.

* Regular Expressions (Perl-Compatible)

  * When passing invalid escape sequences they are no longer interpreted as literals. This behavior previously required the X modifier – which is now ignored.


* PHP Data Objects (PDO)

  *   The default error handling mode has been changed from "silent" to "exceptions". See [Errors and error handling](https://www.php.net/manual/zh/pdo.error-handling.php) for details.

  *   The signatures of some PDO methods have changed:

      *   `PDO::query(string $query, ?int $fetchMode = null, mixed ...$fetchModeArgs)`
      *   `PDOStatement::setFetchMode(int $mode, mixed ...$args)`


* PDO ODBC

  * The php.ini directive [pdo\_odbc.db2\_instance\_name](https://www.php.net/manual/zh/ref.pdo-odbc.php#ini.pdo-odbc.db2-instance-name) has been removed.


* PDO MySQL

  * [PDO::inTransaction()](https://www.php.net/manual/zh/pdo.intransaction.php) now reports the actual transaction state of the connection, rather than an approximation maintained by PDO. If a query that is subject to "implicit commit" is executed, [PDO::inTransaction()](https://www.php.net/manual/zh/pdo.intransaction.php) will subsequently return `false`, as a transaction is no longer active.


* PostgreSQL

  *   The deprecated [pg\_connect()](https://www.php.net/manual/zh/function.pg-connect.php) syntax using multiple parameters instead of a connection string is no longer supported.

  *   The deprecated [pg\_lo\_import()](https://www.php.net/manual/zh/function.pg-lo-import.php) and [pg\_lo\_export()](https://www.php.net/manual/zh/function.pg-lo-export.php) signature that passes the connection as the last argument is no longer supported. The connection should be passed as first argument instead.

  *   [pg\_fetch\_all()](https://www.php.net/manual/zh/function.pg-fetch-all.php) will now return an empty array instead of `false` for result sets with zero rows.

* Phar

  * Metadata associated with a phar will no longer be automatically unserialized, to fix potential security vulnerabilities due to object instantiation, autoloading, etc.


* Reflection

  *   The method signatures

      *   `ReflectionClass::newInstance($args)`
      *   `ReflectionFunction::invoke($args)`
      *   `ReflectionMethod::invoke($object, $args)`

      have been changed to:

      *   `ReflectionClass::newInstance(...$args)`
      *   `ReflectionFunction::invoke(...$args)`
      *   `ReflectionMethod::invoke($object, ...$args)`

      Code that must be compatible with both PHP 7 and PHP 8 can use the following signatures to be compatible with both versions:

      *   `ReflectionClass::newInstance($arg = null, ...$args)`
      *   `ReflectionFunction::invoke($arg = null, ...$args)`
      *   `ReflectionMethod::invoke($object, $arg = null, ...$args)`

  *   The [ReflectionType::\_\_toString()](https://www.php.net/manual/zh/reflectiontype.tostring.php) method will now return a complete debug representation of the type, and is no longer deprecated. In particular the result will include a nullability indicator for nullable types. The format of the return value is not stable and may change between PHP versions.

  *   Reflection export() methods have been removed. Instead reflection objects can be cast to string.

  *   [ReflectionMethod::isConstructor()](https://www.php.net/manual/zh/reflectionmethod.isconstructor.php) and [ReflectionMethod::isDestructor()](https://www.php.net/manual/zh/reflectionmethod.isdestructor.php) now also return `true` for [\_\_construct()](https://www.php.net/manual/zh/language.oop5.decon.php#object.construct) and [\_\_destruct()](https://www.php.net/manual/zh/language.oop5.decon.php#object.destruct) methods of interfaces. Previously, this would only be true for methods of classes and traits.

  *   **ReflectionType::isBuiltin()** method has been moved to **ReflectionNamedType**. **ReflectionUnionType** does not have it.

* Sockets

  *   The deprecated `AI_IDN_ALLOW_UNASSIGNED` and `AI_IDN_USE_STD3_ASCII_RULES` `flags` for [socket\_addrinfo\_lookup()](https://www.php.net/manual/zh/function.socket-addrinfo-lookup.php) have been removed.


* Standard PHP Library (SPL)

  *   [SplFileObject::fgetss()](https://www.php.net/manual/zh/splfileobject.fgetss.php) has been removed.

  *   [SplFileObject::seek()](https://www.php.net/manual/zh/splfileobject.seek.php) now always seeks to the beginning of the line. Previously, positions `=1` sought to the beginning of the next line.

  *   [SplHeap::compare()](https://www.php.net/manual/zh/splheap.compare.php) now specifies a method signature. Inheriting classes implementing this method will now have to use a compatible method signature.

  *   [SplDoublyLinkedList::push()](https://www.php.net/manual/zh/spldoublylinkedlist.push.php), [SplDoublyLinkedList::unshift()](https://www.php.net/manual/zh/spldoublylinkedlist.unshift.php) and [SplQueue::enqueue()](https://www.php.net/manual/zh/splqueue.enqueue.php) now return void instead of `true`.

  *   [spl\_autoload\_register()](https://www.php.net/manual/zh/function.spl-autoload-register.php) will now always throw a [TypeError](https://www.php.net/manual/zh/class.typeerror.php) on invalid arguments, therefore the second argument `do_throw` is ignored and a notice will be emitted if it is set to `false`.

  *   [SplFixedArray](https://www.php.net/manual/zh/class.splfixedarray.php) is now an **IteratorAggregate** and not an **Iterator**. [SplFixedArray::rewind()](https://www.php.net/manual/zh/splfixedarray.rewind.php), [SplFixedArray::current()](https://www.php.net/manual/zh/splfixedarray.current.php), [SplFixedArray::key()](https://www.php.net/manual/zh/splfixedarray.key.php), [SplFixedArray::next()](https://www.php.net/manual/zh/splfixedarray.next.php), and [SplFixedArray::valid()](https://www.php.net/manual/zh/splfixedarray.valid.php) have been removed. In their place, **SplFixedArray::getIterator()** has been added. Any code which uses explicit iteration over SplFixedArray must now obtain an **Iterator** through **SplFixedArray::getIterator()**. This means that [SplFixedArray](https://www.php.net/manual/zh/class.splfixedarray.php) is now safe to use in nested loops.


* Standard Library

  *   [assert()](https://www.php.net/manual/zh/function.assert.php) will no longer evaluate string arguments, instead they will be treated like any other argument. `assert($a == $b)` should be used instead of `assert('$a == $b')`. The [assert.quiet\_eval](https://www.php.net/manual/zh/info.configuration.php#ini.assert.quiet-eval) ini directive and the `ASSERT_QUIET_EVAL` constant have also been removed, as they would no longer have any effect.

  *   [parse\_str()](https://www.php.net/manual/zh/function.parse-str.php) can no longer be used without specifying a result array.

  *   The [string.strip\_tags](https://www.php.net/manual/zh/filters.string.strip_tags.php) filter has been removed.

  *   The `needle` argument of [strpos()](https://www.php.net/manual/zh/function.strpos.php), [strrpos()](https://www.php.net/manual/zh/function.strrpos.php), [stripos()](https://www.php.net/manual/zh/function.stripos.php), [strripos()](https://www.php.net/manual/zh/function.strripos.php), [strstr()](https://www.php.net/manual/zh/function.strstr.php), [strchr()](https://www.php.net/manual/zh/function.strchr.php), [strrchr()](https://www.php.net/manual/zh/function.strrchr.php), and [stristr()](https://www.php.net/manual/zh/function.stristr.php) will now always be interpreted as a string. Previously non-string needles were interpreted as an ASCII code point. An explicit call to [chr()](https://www.php.net/manual/zh/function.chr.php) can be used to restore the previous behavior.

  *   The `needle` argument for [strpos()](https://www.php.net/manual/zh/function.strpos.php), [strrpos()](https://www.php.net/manual/zh/function.strrpos.php), [stripos()](https://www.php.net/manual/zh/function.stripos.php), [strripos()](https://www.php.net/manual/zh/function.strripos.php), [strstr()](https://www.php.net/manual/zh/function.strstr.php), [stristr()](https://www.php.net/manual/zh/function.stristr.php) and [strrchr()](https://www.php.net/manual/zh/function.strrchr.php) can now be empty.

  *   The `length` argument for [substr()](https://www.php.net/manual/zh/function.substr.php), [substr\_count()](https://www.php.net/manual/zh/function.substr-count.php), [substr\_compare()](https://www.php.net/manual/zh/function.substr-compare.php), and [iconv\_substr()](https://www.php.net/manual/zh/function.iconv-substr.php) can now be `null`. `null` values will behave as if no length argument was provided and will therefore return the remainder of the string instead of an empty string.

  *   The `length` argument for [array\_splice()](https://www.php.net/manual/zh/function.array-splice.php) can now be `null`. `null`** values will behave identically to omitting the argument, thus removing everything from the `offset` to the end of the array.

  *   The `args` argument of [vsprintf()](https://www.php.net/manual/zh/function.vsprintf.php), [vfprintf()](https://www.php.net/manual/zh/function.vfprintf.php), and [vprintf()](https://www.php.net/manual/zh/function.vprintf.php) must now be an array. Previously any type was accepted.

  *   The `'salt'` option of [password\_hash()](https://www.php.net/manual/zh/function.password-hash.php) is no longer supported. If the `'salt'` option is used a warning is generated, the provided salt is ignored, and a generated salt is used instead.

  *   The [quotemeta()](https://www.php.net/manual/zh/function.quotemeta.php) function will now return an empty string if an empty string was passed. Previously `false` was returned.

  *   The following functions have been removed:

      *   [hebrevc()](https://www.php.net/manual/zh/function.hebrevc.php)
      *   [convert\_cyr\_string()](https://www.php.net/manual/zh/function.convert-cyr-string.php)
      *   [money\_format()](https://www.php.net/manual/zh/function.money-format.php)
      *   [ezmlm\_hash()](https://www.php.net/manual/zh/function.ezmlm-hash.php)
      *   [restore\_include\_path()](https://www.php.net/manual/zh/function.restore-include-path.php)
      *   [get\_magic\_quotes\_gpc()](https://www.php.net/manual/zh/function.get-magic-quotes-gpc.php)
      *   [get\_magic\_quotes\_runtime()](https://www.php.net/manual/zh/function.get-magic-quotes-runtime.php)
      *   [fgetss()](https://www.php.net/manual/zh/function.fgetss.php)

  *   `FILTER_SANITIZE_MAGIC_QUOTES` has been removed.

  *   Calling [implode()](https://www.php.net/manual/zh/function.implode.php) with parameters in a reverse order `($pieces, $glue)` is no longer supported.

  *   [parse\_url()](https://www.php.net/manual/zh/function.parse-url.php) will now distinguish absent and empty queries and fragments:

      *   `http://example.com/foo → query = null, fragment = null`
      *   `http://example.com/foo? → query = "", fragment = null`
      *   `http://example.com/foo# → query = null, fragment = ""`
      *   `http://example.com/foo?# → query = "", fragment = ""`

      Previously all cases resulted in query and fragment being `null`.

  *   [var\_dump()](https://www.php.net/manual/zh/function.var-dump.php) and [debug\_zval\_dump()](https://www.php.net/manual/zh/function.debug-zval-dump.php) will now print floating-point numbers using [serialize\_precision](https://www.php.net/manual/zh/ini.core.php#ini.serialize-precision) rather than [precision](https://www.php.net/manual/zh/ini.core.php#ini.precision). In a default configuration, this means that floating-point numbers are now printed with full accuracy by these debugging functions.

  *   If the array returned by [\_\_sleep()](https://www.php.net/manual/zh/language.oop5.magic.php#object.sleep) contains non-existing properties, these are now silently ignored. Previously, such properties would have been serialized as if they had the value `null`.

  *   The default locale on startup is now always `"C"`. No locales are inherited from the environment by default. Previously, `LC_ALL` was set to `"C"`, while `LC_CTYPE` was inherited from the environment. However, some functions did not respect the inherited locale without an explicit [setlocale()](https://www.php.net/manual/zh/function.setlocale.php) call. An explicit [setlocale()](https://www.php.net/manual/zh/function.setlocale.php) call is now always required if a locale component should be changed from the default.

  *   The deprecated DES fallback in [crypt()](https://www.php.net/manual/zh/function.crypt.php) has been removed. If an unknown salt format is passed to [crypt()](https://www.php.net/manual/zh/function.crypt.php), the function will fail with `*0` instead of falling back to a weak DES hash now.

  *   Specifying out of range rounds for SHA256/SHA512 [crypt()](https://www.php.net/manual/zh/function.crypt.php) will now fail with `*0` instead of clamping to the closest limit. This matches glibc behavior.

  *   The result of sorting functions may have changed, if the array contains elements that compare as equal.

  *   Any functions accepting callbacks that are not explicitly specified to accept parameters by reference will now warn if a callback with reference parameters is used. Examples include [array\_filter()](https://www.php.net/manual/zh/function.array-filter.php) and [array\_reduce()](https://www.php.net/manual/zh/function.array-reduce.php). This was already the case for most, but not all, functions previously.

  *   The HTTP stream wrapper as used by functions like [file\_get\_contents()](https://www.php.net/manual/zh/function.file-get-contents.php) now advertises HTTP/1.1 rather than HTTP/1.0 by default. This does not change the behavior of the client, but may cause servers to respond differently. To retain the old behavior, set the `'protocol_version'` stream context option, e.g.

      `<?php
      $ctx = stream_context_create(['http' => ['protocol_version' => '1.0']]);
      echo file_get_contents('http://example.org', false, $ctx);
      ?>`

  *   Calling [crypt()](https://www.php.net/manual/zh/function.crypt.php) without an explicit salt is no longer supported. If you would like to produce a strong hash with an auto-generated salt, use [password\_hash()](https://www.php.net/manual/zh/function.password-hash.php) instead.

  *   [substr()](https://www.php.net/manual/zh/function.substr.php), [mb\_substr()](https://www.php.net/manual/zh/function.mb-substr.php), [iconv\_substr()](https://www.php.net/manual/zh/function.iconv-substr.php) and [grapheme\_substr()](https://www.php.net/manual/zh/function.grapheme-substr.php) now consistently clamp out-of-bounds offsets to the string boundary. Previously, `false` was returned instead of the empty string in some cases.

  *   On Windows, the program execution functions ([proc\_open()](https://www.php.net/manual/zh/function.proc-open.php), [exec()](https://www.php.net/manual/zh/function.exec.php), [popen()](https://www.php.net/manual/zh/function.popen.php) etc.) using the shell, now consistently execute **%comspec% /s /c "$commandline"**, which has the same effect as executing **$commandline** (without additional quotes).

* Sysvsem

  *   The `auto_release` parameter of [sem\_get()](https://www.php.net/manual/zh/function.sem-get.php) was changed to accept bool values rather than int.

* Tidy

  *   The `use_include_path` parameter, which was not used internally, has been removed from [tidy\_repair\_string()](https://www.php.net/manual/zh/tidy.repairstring.php).

  *   [tidy::repairString()](https://www.php.net/manual/zh/tidy.repairstring.php) and [tidy::repairFile()](https://www.php.net/manual/zh/tidy.repairfile.php) became static methods.

* Tokenizer

  *   `T_COMMENT` tokens will no longer include a trailing newline. The newline will instead be part of a following `T_WHITESPACE` token. It should be noted that `T_COMMENT` is not always followed by whitespace, it may also be followed by `T_CLOSE_TAG` or end-of-file.

  *   Namespaced names are now represented using the `T_NAME_QUALIFIED` (`Foo\Bar`), `T_NAME_FULLY_QUALIFIED` (`\Foo\Bar`) and `T_NAME_RELATIVE` (`namespace\Foo\Bar`) tokens. `T_NS_SEPARATOR` is only used for standalone namespace separators, and only syntactially valid in conjunction with group use declarations.


## 新特性