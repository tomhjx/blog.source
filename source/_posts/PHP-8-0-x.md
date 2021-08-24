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
  - Cryptographic Message Syntax|CMS
  - Pseudo Terminals|PTY
  - Socket Pairs
  - PHP Zip
  - PHP Tokenizer
  - Just-In-Time|JIT
  - Streaming SIMD Extensions 2|SSE2
date: 2020-11-26 15:00:00
---

# 目标及关键路径

* 提升性能
  * 基于缓存前置思想，使用CPU机器码缓存，绕过Zend VM及其过程开销来尽可能提升性能
    * JIT


# 从 PHP 7.4.x 移植到 PHP 8.0.x

[这里可以找到原文](https://www.php.net/manual/zh/migration80.php)


## 不向后兼容的变更

### PHP Core

* 字符串与数字的比较

  * ^[PHP 8.0.0](https://wiki.php.net/rfc/saner-numeric-strings)^ 数字与非数字形式的字符串之间的非严格比较现在将首先将数字转为字符串，然后比较这两个字符串。 数字与数字形式的字符串之间的比较仍然像之前那样进行。 请注意，这意味着 0 == "not-a-number" 现在将被认为是 false 。


    | Comparison | Before | After |
    | --- | --- | --- |
    | `0 == "0"` | **`true`** | **`true`** |
    | `0 == "0.0"` | **`true`** | **`true`** |
    | `0 == "foo"` | **`true`** | **`false`** |
    | `0 == ""` | **`true`** | **`false`** |
    | `42 == " 42"` | **`true`** | **`true`** |
    | `42 == "42foo"` | **`true`** | **`false`** |

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

*   The `@` operator will no longer silence fatal errors (`E_ERROR`, `E_CORE_ERROR`, `E_COMPILE_ERROR`, `E_USER_ERROR`, `E_RECOVERABLE_ERROR`, `E_PARSE`). Error handlers that expect error\_reporting to be `0` when `@` is used, should be adjusted to use a mask check instead:

    ```php
    <?php
    // Replace
    function my_error_handler($err_no, $err_msg, $filename, $linenum) {
        if (error_reporting() == 0) {
            return false; // Silenced
        }
        // ...
    }

    // With
    function my_error_handler($err_no, $err_msg, $filename, $linenum) {
        if (!(error_reporting() & $err_no)) {
            return false; // Silenced
        }
        // ...
    }
    ?>
    ```

    Additionally, care should be taken that error messages are not displayed in production environments, which can result in information leaks. Please ensure that `display_errors=Off` is used in conjunction with error logging.

*   `#[` is no longer interpreted as the start of a comment, as this syntax is now used for attributes.

*   Inheritance errors due to incompatible method signatures (LSP violations) will now always generate a fatal error. Previously a warning was generated in some cases.

*   The precedence of the concatenation operator has changed relative to bitshifts and addition as well as subtraction.

    ```php
    <?php
    echo "Sum: " . $a + $b;
    // was previously interpreted as:
    echo ("Sum: " . $a) + $b;
    // is now interpreted as:
    echo "Sum:" . ($a + $b);
    ?>
    ```

*   Arguments with a default value that resolves to `null` at runtime will no longer implicitly mark the argument type as nullable. Either an explicit nullable type, or an explicit `null` default value has to be used instead.

    ```php
    <?php
    // Replace
    function test(int $arg = CONST_RESOLVING_TO_NULL) {}
    // With
    function test(?int $arg = CONST_RESOLVING_TO_NULL) {}
    // Or
    function test(int $arg = null) {}
    ?>
    ```

*   A number of warnings have been converted into [Error](https://www.php.net/manual/zh/class.error.php) exceptions:

    *   Attempting to write to a property of a non-object. Previously this implicitly created an stdClass object for null, false and empty strings.
    *   Attempting to append an element to an array for which the PHP\_INT\_MAX key is already used.
    *   Attempting to use an invalid type (array or object) as an array key or string offset.
    *   Attempting to write to an array index of a scalar value.
    *   Attempting to unpack a non-array/Traversable.
    *   Attempting to access unqualified constants which are undefined. Previously, unqualified constant accesses resulted in a warning and were interpreted as strings.

    A number of notices have been converted into warnings:

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

*   The generated name for anonymous classes has changed. It will now include the name of the first parent or interface:

    ```php
    <?php
    new class extends ParentClass {};
    // -> ParentClass@anonymous
    new class implements FirstInterface, SecondInterface {};
    // -> FirstInterface@anonymous
    new class {};
    // -> class@anonymous
    ?>
    ```

    The name shown above is still followed by a NUL byte and a unique suffix.

*   Non-absolute trait method references in trait alias adaptations are now required to be unambiguous:

    ```php
    <?php
    class X {
        use T1, T2 {
            func as otherFunc;
        }
        function func() {}
    }
    ?>
    ```

    If both `T1::func()` and `T2::func()` exist, this code was previously silently accepted, and func was assumed to refer to `T1::func`. Now it will generate a fatal error instead, and either `T1::func` or `T2::func` needs to be written explicitly.

*   The signature of abstract methods defined in traits is now checked against the implementing class method:

    ```php
    
    <?php
    trait MyTrait {
        abstract private function neededByTrait(): string;
    }

    class MyClass {
        use MyTrait;

        // Error, because of return type mismatch.
        private function neededByTrait(): int { return 42; }
    }
    ?>
    ```

*   Disabled functions are now treated exactly like non-existent functions. Calling a disabled function will report it as unknown, and redefining a disabled function is now possible.

*   `data://` stream wrappers are no longer writable, which matches the documented behavior.

*   The arithmetic and bitwise operators `+`, `-`, `*`, `/`, `**`, `%`, `<<`, `>>`, `&`, `|`, `^`, `~`, `++`, `--` will now consistently throw a [TypeError](https://www.php.net/manual/zh/class.typeerror.php) when one of the operands is an array, [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php) or non-overloaded object. The only exception to this is the array `+` array merge operation, which remains supported.

*   Float to string casting will now always behave locale-independently.

    ```php
    <?php
    setlocale(LC_ALL, "de_DE");
    $f = 3.14;
    echo $f, "\n";
    // Previously: 3,14
    // Now:        3.14
    ?>
    ```

    See [printf()](https://www.php.net/manual/zh/function.printf.php), [number\_format()](https://www.php.net/manual/zh/function.number-format.php) and **NumberFormatter()** for ways to customize number formatting.

*   Support for deprecated curly braces for offset access has been removed.

    ```php
    <?php
    // Instead of:
    $array{0};
    $array{"key"};
    // Write:
    $array[0];
    $array["key"];
    ?>
    ```

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

    The concept of a "leading-numeric string" has been mostly dropped; the cases where this remains exist in order to ease migration. Strings which emitted an `E_NOTICE` "A non well-formed numeric value encountered" will now emit an `E_WARNING` "A non-numeric value encountered" and all strings which emitted an `E_WARNING` "A non-numeric value encountered" will now throw a [TypeError](https://www.php.net/manual/zh/class.typeerror.php). This mostly affects:

    *   Arithmetic operations
    *   Bitwise operations

    This `E_WARNING` to [TypeError](https://www.php.net/manual/zh/class.typeerror.php) change also affects the `E_WARNING` "Illegal string offset 'string'" for illegal string offsets. The behavior of explicit casts to int/float from strings has not been changed.

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


*   如果带有默认值的参数后面跟着一个必要的参数，那么默认值就会无效。这在 PHP 8.0.0 中已被废弃，通常可以通过删除默认值，不影响现有功能：

    ```php
    <?php
    function test($a = [], $b) {} // 之前
    function test($a, $b) {}      // 之后
    ?>
    ```

    这条规则的一个例外是 `Type $param = null` 形式的参数，其中 null 的默认值使得类型隐式为空。这种用法仍然是允许的，但仍建议使用显式可空类型。

    ```php
    <?php
    function test(A $a = null, $b) {} // 旧写法，仍可用
    function test(?A $a, $b) {}       // 推荐写法
    ?>
    ```

*   参数 `exclude_disabled` 不能设置为 `false` 来调用 [get\_defined\_functions()](https://www.php.net/manual/zh/function.get-defined-functions.php)，该参数已被废弃，不再起作用。 [get\_defined\_functions()](https://www.php.net/manual/zh/function.get-defined-functions.php) 绝不会再包含禁用的函数。



###  Resource to Object Migration 

Several [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php)s have been migrated to objects. Return value checks using [is\_resource()](https://www.php.net/manual/zh/function.is-resource.php) should be replaced with checks for `false`.

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


### COM and .Net (Windows)

* The ability to import case-insensitive constants from type libraries has been removed. The second argument to [com\_load\_typelib()](https://www.php.net/manual/zh/function.com-load-typelib.php) may no longer be false; [com.autoregister\_casesensitive](https://www.php.net/manual/zh/com.configuration.php#ini.com.autoregister-casesensitive) may no longer be disabled; case-insensitive markers in [com.typelib\_file](https://www.php.net/manual/zh/com.configuration.php#ini.com.typelib-file) are ignored.

### CURL

* `CURLOPT_POSTFIELDS` no longer accepts objects as arrays. To interpret an object as an array, perform an explicit `(array)` cast. The same applies to other options accepting arrays as well.

*   现在 CURL 扩展要求 libcurl 版本至少为 7.29.0。

*   移除了 [curl\_version()](https://www.php.net/manual/zh/function.curl-version.php) 废弃的参数 `version`。


### Date and Time

* [mktime()](https://www.php.net/manual/zh/function.mktime.php) and [gmmktime()](https://www.php.net/manual/zh/function.gmmktime.php) now require at least one argument. [time()](https://www.php.net/manual/zh/function.time.php) can be used to get the current timestamp.


### DOM

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

### Enchant

*   [enchant\_broker\_list\_dicts()](https://www.php.net/manual/zh/function.enchant-broker-list-dicts.php), [enchant\_broker\_describe()](https://www.php.net/manual/zh/function.enchant-broker-describe.php) and [enchant\_dict\_suggest()](https://www.php.net/manual/zh/function.enchant-dict-suggest.php) will now return an empty array instead of `null`.

*   [enchant\_broker\_set\_dict\_path()](https://www.php.net/manual/zh/function.enchant-broker-set-dict-path.php) and [enchant\_broker\_get\_dict\_path()](https://www.php.net/manual/zh/function.enchant-broker-get-dict-path.php) are deprecated, because that functionality is neither available in libenchant < 1.5 nor in libenchant-2.

*   [enchant\_dict\_add\_to\_personal()](https://www.php.net/manual/zh/function.enchant-dict-add-to-personal.php) is deprecated; use [enchant\_dict\_add()](https://www.php.net/manual/zh/function.enchant-dict-add.php) instead.

*   [enchant\_dict\_is\_in\_session()](https://www.php.net/manual/zh/function.enchant-dict-is-in-session.php) is deprecated; use [enchant\_dict\_is\_added()](https://www.php.net/manual/zh/function.enchant-dict-is-added.php) instead.

*   [enchant\_broker\_free()](https://www.php.net/manual/zh/function.enchant-broker-free.php) and [enchant\_broker\_free\_dict()](https://www.php.net/manual/zh/function.enchant-broker-free-dict.php) are deprecated; unset the object instead.

*   The `ENCHANT_MYSPELL` and `ENCHANT_ISPELL` constants are deprecated.

* 现在环境允许时，enchant 会默认使用 libenchant-2。 仍然支持 libenchant 1，但已经废弃，并将在未来移除。


### Exif

* [read\_exif\_data()](https://www.php.net/manual/zh/function.read-exif-data.php) has been removed; [exif\_read\_data()](https://www.php.net/manual/zh/function.exif-read-data.php) should be used instead.

### Filter

*   The `FILTER_FLAG_SCHEME_REQUIRED` and `FILTER_FLAG_HOST_REQUIRED` flags for the `FILTER_VALIDATE_URL` filter have been removed. The `scheme` and `host` are (and have been) always required.

*   The `INPUT_REQUEST` and `INPUT_SESSION` source for [filter\_input()](https://www.php.net/manual/zh/function.filter-input.php) etc. have been removed. These were never implemented and their use always generated a warning.


### GD

*   The deprecated functions [image2wbmp()](https://www.php.net/manual/zh/function.image2wbmp.php) has been removed.

*   The deprecated functions [png2wbmp()](https://www.php.net/manual/zh/function.png2wbmp.php) and [jpeg2wbmp()](https://www.php.net/manual/zh/function.jpeg2wbmp.php) have been removed.

*   The default `mode` parameter of [imagecropauto()](https://www.php.net/manual/zh/function.imagecropauto.php) no longer accepts `-1`. `IMG_CROP_DEFAULT` should be used instead.

*   On Windows, php\_gd2.dll has been renamed to php\_gd.dll.

### GMP

* [gmp\_random()](https://www.php.net/manual/zh/function.gmp-random.php) has been removed. One of [gmp\_random\_range()](https://www.php.net/manual/zh/function.gmp-random-range.php) or [gmp\_random\_bits()](https://www.php.net/manual/zh/function.gmp-random-bits.php) should be used instead.

### Iconv

* iconv implementations which do not properly set errno in case of errors are no longer supported.


### IMAP

*   The unused `default_host` argument of [imap\_headerinfo()](https://www.php.net/manual/zh/function.imap-headerinfo.php) has been removed.

*   The [imap\_header()](https://www.php.net/manual/zh/function.imap-header.php) function which is an alias of [imap\_headerinfo()](https://www.php.net/manual/zh/function.imap-headerinfo.php) has been removed.


### Internationalization Functions

*   The deprecated constant `INTL_IDNA_VARIANT_2003` has been removed.

*   The deprecated `Normalizer::NONE` constant has been removed.

### LDAP

*   The deprecated functions [ldap\_sort()](https://www.php.net/manual/zh/function.ldap-sort.php), [ldap\_control\_paged\_result()](https://www.php.net/manual/zh/function.ldap-control-paged-result.php) and [ldap\_control\_paged\_result\_response()](https://www.php.net/manual/zh/function.ldap-control-paged-result-response.php) have been removed.

*   The interface of [ldap\_set\_rebind\_proc()](https://www.php.net/manual/zh/function.ldap-set-rebind-proc.php) has changed; the `callback` parameter does not accept empty strings anymore; `null` should be used instead.


### MBString

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


### OCI8

*   The **OCI-Lob** class is now called [OCILob](https://www.php.net/manual/zh/class.OCI-Lob.php), and the **OCI-Collection** class is now called [OCICollection](https://www.php.net/manual/zh/class.OCI-Collection.php) for name compliance enforced by PHP 8 arginfo type annotation tooling.

*   Several alias functions have been marked as deprecated.

*   [oci\_internal\_debug()](https://www.php.net/manual/zh/function.oci-internal-debug.php) and its alias [ociinternaldebug()](https://www.php.net/manual/zh/function.ociinternaldebug.php) have been removed.

### ODBC

*   [odbc\_connect()](https://www.php.net/manual/zh/function.odbc-connect.php) no longer reuses connections.

*   The unused `flags` parameter of [odbc\_exec()](https://www.php.net/manual/zh/function.odbc-exec.php) has been removed.


### OpenSSL

  *   [openssl\_seal()](https://www.php.net/manual/zh/function.openssl-seal.php) and [openssl\_open()](https://www.php.net/manual/zh/function.openssl-open.php) now require `method` to be passed, as the previous default of `"RC4"` is considered insecure.

### Regular Expressions (Perl-Compatible)

* When passing invalid escape sequences they are no longer interpreted as literals. This behavior previously required the X modifier – which is now ignored.


### PHP Data Objects (PDO)

*   The default error handling mode has been changed from "silent" to "exceptions". See [Errors and error handling](https://www.php.net/manual/zh/pdo.error-handling.php) for details.

*   The signatures of some PDO methods have changed:

    *   `PDO::query(string $query, ?int $fetchMode = null, mixed ...$fetchModeArgs)`
    *   `PDOStatement::setFetchMode(int $mode, mixed ...$args)`


### PDO ODBC

* The php.ini directive [pdo\_odbc.db2\_instance\_name](https://www.php.net/manual/zh/ref.pdo-odbc.php#ini.pdo-odbc.db2-instance-name) has been removed.


### PDO MySQL

* [PDO::inTransaction()](https://www.php.net/manual/zh/pdo.intransaction.php) now reports the actual transaction state of the connection, rather than an approximation maintained by PDO. If a query that is subject to "implicit commit" is executed, [PDO::inTransaction()](https://www.php.net/manual/zh/pdo.intransaction.php) will subsequently return `false`, as a transaction is no longer active.


### PostgreSQL (PGSQL) / PDO PGSQL

* PGSQL 与 PDO PGSQL 扩展需要 libpq 的版本号至少为 9.1。

*   The deprecated [pg\_connect()](https://www.php.net/manual/zh/function.pg-connect.php) syntax using multiple parameters instead of a connection string is no longer supported.

*   The deprecated [pg\_lo\_import()](https://www.php.net/manual/zh/function.pg-lo-import.php) and [pg\_lo\_export()](https://www.php.net/manual/zh/function.pg-lo-export.php) signature that passes the connection as the last argument is no longer supported. The connection should be passed as first argument instead.

*   [pg\_fetch\_all()](https://www.php.net/manual/zh/function.pg-fetch-all.php) will now return an empty array instead of `false` for result sets with zero rows.


*   The constant `PGSQL_LIBPQ_VERSION_STR` now has the same value as `PGSQL_LIBPQ_VERSION`, and thus is deprecated.

*   Function aliases in the pgsql extension have been deprecated. See the following list for which functions should be used instead:

    *   **pg\_errormessage()** → [pg\_last\_error()](https://www.php.net/manual/zh/function.pg-last-error.php)
    *   **pg\_numrows()** → [pg\_num\_rows()](https://www.php.net/manual/zh/function.pg-num-rows.php)
    *   **pg\_numfields()** → [pg\_num\_fields()](https://www.php.net/manual/zh/function.pg-num-fields.php)
    *   **pg\_cmdtuples()** → [pg\_affected\_rows()](https://www.php.net/manual/zh/function.pg-affected-rows.php)
    *   **pg\_fieldname()** → [pg\_field\_name()](https://www.php.net/manual/zh/function.pg-field-name.php)
    *   **pg\_fieldsize()** → [pg\_field\_size()](https://www.php.net/manual/zh/function.pg-field-size.php)
    *   **pg\_fieldtype()** → [pg\_field\_type()](https://www.php.net/manual/zh/function.pg-field-type.php)
    *   **pg\_fieldnum()** → [pg\_field\_num()](https://www.php.net/manual/zh/function.pg-field-num.php)
    *   **pg\_result()** → [pg\_fetch\_result()](https://www.php.net/manual/zh/function.pg-fetch-result.php)
    *   **pg\_fieldprtlen()** → [pg\_field\_prtlen()](https://www.php.net/manual/zh/function.pg-field-prtlen.php)
    *   **pg\_fieldisnull()** → [pg\_field\_is\_null()](https://www.php.net/manual/zh/function.pg-field-is-null.php)
    *   **pg\_freeresult()** → [pg\_free\_result()](https://www.php.net/manual/zh/function.pg-free-result.php)
    *   **pg\_getlastoid()** → [pg\_last\_oid()](https://www.php.net/manual/zh/function.pg-last-oid.php)
    *   **pg\_locreate()** → [pg\_lo\_create()](https://www.php.net/manual/zh/function.pg-lo-create.php)
    *   **pg\_lounlink()** → [pg\_lo\_unlink()](https://www.php.net/manual/zh/function.pg-lo-unlink.php)
    *   **pg\_loopen()** → [pg\_lo\_open()](https://www.php.net/manual/zh/function.pg-lo-open.php)
    *   **pg\_loclose()** → [pg\_lo\_close()](https://www.php.net/manual/zh/function.pg-lo-close.php)
    *   **pg\_loread()** → [pg\_lo\_read()](https://www.php.net/manual/zh/function.pg-lo-read.php)
    *   **pg\_lowrite()** → [pg\_lo\_write()](https://www.php.net/manual/zh/function.pg-lo-write.php)
    *   **pg\_loreadall()** → [pg\_lo\_read\_all()](https://www.php.net/manual/zh/function.pg-lo-read-all.php)
    *   **pg\_loimport()** → [pg\_lo\_import()](https://www.php.net/manual/zh/function.pg-lo-import.php)
    *   **pg\_loexport()** → [pg\_lo\_export()](https://www.php.net/manual/zh/function.pg-lo-export.php)
    *   **pg\_setclientencoding()** → [pg\_set\_client\_encoding()](https://www.php.net/manual/zh/function.pg-set-client-encoding.php)
    *   **pg\_clientencoding()** -> [pg\_client\_encoding()](https://www.php.net/manual/zh/function.pg-client-encoding.php)



### Phar

* Metadata associated with a phar will no longer be automatically unserialized, to fix potential security vulnerabilities due to object instantiation, autoloading, etc.


### Reflection

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

*   [ReflectionFunction::isDisabled()](https://www.php.net/manual/zh/reflectionfunction.isdisabled.php) is deprecated, as it is no longer possible to create a [ReflectionFunction](https://www.php.net/manual/zh/class.reflectionfunction.php) for a disabled function. This method now always returns `false`.

*   [ReflectionParameter::getClass()](https://www.php.net/manual/zh/reflectionparameter.getclass.php), [ReflectionParameter::isArray()](https://www.php.net/manual/zh/reflectionparameter.isarray.php), and [ReflectionParameter::isCallable()](https://www.php.net/manual/zh/reflectionparameter.iscallable.php) are deprecated. [ReflectionParameter::getType()](https://www.php.net/manual/zh/reflectionparameter.gettype.php) and the [ReflectionType](https://www.php.net/manual/zh/class.reflectiontype.php) APIs should be used instead.


### Sockets

*   The deprecated `AI_IDN_ALLOW_UNASSIGNED` and `AI_IDN_USE_STD3_ASCII_RULES` `flags` for [socket\_addrinfo\_lookup()](https://www.php.net/manual/zh/function.socket-addrinfo-lookup.php) have been removed.


### Standard PHP Library (SPL)

*   [SplFileObject::fgetss()](https://www.php.net/manual/zh/splfileobject.fgetss.php) has been removed.

*   [SplFileObject::seek()](https://www.php.net/manual/zh/splfileobject.seek.php) now always seeks to the beginning of the line. Previously, positions `=1` sought to the beginning of the next line.

*   [SplHeap::compare()](https://www.php.net/manual/zh/splheap.compare.php) now specifies a method signature. Inheriting classes implementing this method will now have to use a compatible method signature.

*   [SplDoublyLinkedList::push()](https://www.php.net/manual/zh/spldoublylinkedlist.push.php), [SplDoublyLinkedList::unshift()](https://www.php.net/manual/zh/spldoublylinkedlist.unshift.php) and [SplQueue::enqueue()](https://www.php.net/manual/zh/splqueue.enqueue.php) now return void instead of `true`.

*   [spl\_autoload\_register()](https://www.php.net/manual/zh/function.spl-autoload-register.php) will now always throw a [TypeError](https://www.php.net/manual/zh/class.typeerror.php) on invalid arguments, therefore the second argument `do_throw` is ignored and a notice will be emitted if it is set to `false`.

*   [SplFixedArray](https://www.php.net/manual/zh/class.splfixedarray.php) is now an **IteratorAggregate** and not an **Iterator**. [SplFixedArray::rewind()](https://www.php.net/manual/zh/splfixedarray.rewind.php), [SplFixedArray::current()](https://www.php.net/manual/zh/splfixedarray.current.php), [SplFixedArray::key()](https://www.php.net/manual/zh/splfixedarray.key.php), [SplFixedArray::next()](https://www.php.net/manual/zh/splfixedarray.next.php), and [SplFixedArray::valid()](https://www.php.net/manual/zh/splfixedarray.valid.php) have been removed. In their place, **SplFixedArray::getIterator()** has been added. Any code which uses explicit iteration over SplFixedArray must now obtain an **Iterator** through **SplFixedArray::getIterator()**. This means that [SplFixedArray](https://www.php.net/manual/zh/class.splfixedarray.php) is now safe to use in nested loops.


### Standard Library

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

    ```php
    <?php
    $ctx = stream_context_create(['http' => ['protocol_version' => '1.0']]);
    echo file_get_contents('http://example.org', false, $ctx);
    ?>
    ```

*   Calling [crypt()](https://www.php.net/manual/zh/function.crypt.php) without an explicit salt is no longer supported. If you would like to produce a strong hash with an auto-generated salt, use [password\_hash()](https://www.php.net/manual/zh/function.password-hash.php) instead.

*   [substr()](https://www.php.net/manual/zh/function.substr.php), [mb\_substr()](https://www.php.net/manual/zh/function.mb-substr.php), [iconv\_substr()](https://www.php.net/manual/zh/function.iconv-substr.php) and [grapheme\_substr()](https://www.php.net/manual/zh/function.grapheme-substr.php) now consistently clamp out-of-bounds offsets to the string boundary. Previously, `false` was returned instead of the empty string in some cases.

*   On Windows, the program execution functions ([proc\_open()](https://www.php.net/manual/zh/function.proc-open.php), [exec()](https://www.php.net/manual/zh/function.exec.php), [popen()](https://www.php.net/manual/zh/function.popen.php) etc.) using the shell, now consistently execute **%comspec% /s /c "$commandline"**, which has the same effect as executing **$commandline** (without additional quotes).


* Sort comparison functions that return `true` or `false` will now throw a deprecation warning, and should be replaced with an implementation that returns an integer less than, equal to, or greater than zero.

  ```php
  <?php
  // Replace
  usort($array, fn($a, $b) => $a > $b);
  // With
  usort($array, fn($a, $b) => $a <=> $b);
  ?>
  ```


### Sysvsem

  *   The `auto_release` parameter of [sem\_get()](https://www.php.net/manual/zh/function.sem-get.php) was changed to accept bool values rather than int.

### Tidy

  *   The `use_include_path` parameter, which was not used internally, has been removed from [tidy\_repair\_string()](https://www.php.net/manual/zh/tidy.repairstring.php).

  *   [tidy::repairString()](https://www.php.net/manual/zh/tidy.repairstring.php) and [tidy::repairFile()](https://www.php.net/manual/zh/tidy.repairfile.php) became static methods.

### Tokenizer

  *   `T_COMMENT` tokens will no longer include a trailing newline. The newline will instead be part of a following `T_WHITESPACE` token. It should be noted that `T_COMMENT` is not always followed by whitespace, it may also be followed by `T_CLOSE_TAG` or end-of-file.

  *   Namespaced names are now represented using the `T_NAME_QUALIFIED` (`Foo\Bar`), `T_NAME_FULLY_QUALIFIED` (`\Foo\Bar`) and `T_NAME_RELATIVE` (`namespace\Foo\Bar`) tokens. `T_NS_SEPARATOR` is only used for standalone namespace separators, and only syntactially valid in conjunction with group use declarations.

### XMLReader

  * [XMLReader::open()](https://www.php.net/manual/zh/xmlreader.open.php) and [XMLReader::xml()](https://www.php.net/manual/zh/xmlreader.xml.php) are now static methods. They can still be called as instance methods, but inheriting classes need to declare them as static if they override these methods.

### XML-RPC

  * The XML-RPC extension has been moved to PECL and is no longer part of the PHP distribution.

### Zip

* `ZipArchive::OPSYS_Z_CPM` has been removed (this name was a typo). Use `ZipArchive::OPSYS_CPM` instead.

*   Using an empty file as ZipArchive is deprecated. Libzip 1.6.0 does not accept empty files as valid zip archives any longer. The existing workaround will be removed in the next version.

*   The procedural API of Zip is deprecated. Use [ZipArchive](https://www.php.net/manual/zh/class.ziparchive.php) instead. Iteration over all entries can be accomplished using [ZipArchive::statIndex()](https://www.php.net/manual/zh/ziparchive.statindex.php) and a [for](https://www.php.net/manual/zh/control-structures.for.php) loop:

    ```php
    <?php
    // iterate using the procedural API
    assert(is_resource($zip));
    while ($entry = zip_read($zip)) {
        echo zip_entry_name($entry);
    }

    // iterate using the object-oriented API
    assert($zip instanceof ZipArchive);
    for ($i = 0; $entry = $zip->statIndex($i); $i++) {
        echo $entry['name'];
    }
    ?>
    ```

### Zlib

  *   [gzgetss()](https://www.php.net/manual/zh/function.gzgetss.php) has been removed.

  *   [zlib.output\_compression](https://www.php.net/manual/zh/zlib.configuration.php#ini.zlib.output-compression) is no longer automatically disabled for `Content-Type: image/*`.

### Windows PHP Test Packs

  * The test runner has been renamed from run-test.php to run-tests.php, to match its name in php-src.


### LibXML

* [libxml\_disable\_entity\_loader()](https://www.php.net/manual/zh/function.libxml-disable-entity-loader.php) has been deprecated. As libxml 2.9.0 is now required, external entity loading is guaranteed to be disabled by default, and this function is no longer needed to protect against XXE attacks, unless the (still vulnerable). `LIBXML_NOENT` is used. In that case, it is recommended to refactor the code using [libxml\_set\_external\_entity\_loader()](https://www.php.net/manual/zh/function.libxml-set-external-entity-loader.php) to suppress loading of external entities.

### EBCDIC

不再支持 EBCDIC targets，虽然它不太可能还在当初的地方继续运行。


### SAPI

* Apache 2 Handler
  * [PHP 模块从 php7_module 重命名为 php_module。](https://php.watch/versions/8.0/mod_php-rename)



## 新特性

### PHP Core

* 新增[命名参数](https://www.php.net/manual/zh/functions.arguments.php#functions.named-arguments)的功能。

* 新增[注解](https://www.php.net/manual/zh/language.attributes.php)的功能。

* 新增[构造器属性提升](https://www.php.net/manual/zh/language.oop5.decon.php#language.oop5.decon.constructor.promotion)功能 在构造函数中声明类的属性）。

* 新增 [联合类型](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.union)。

* 新增 [`match` 表达式](https://www.php.net/manual/zh/control-structures.match.php)。

* 新增[Nullsafe 运算符](https://www.php.net/manual/zh/language.oop5.basic.php#language.oop5.basic.nullsafe)(`?->`)。

*   新增 [WeakMap](https://www.php.net/manual/zh/class.weakmap.php) 类。

*   新增 **ValueError** 类。

*   现在，只要类型兼容，任意数量的函数参数都可以用一个可变参数替换。 例如允许编写下面的代码：

    ```php
    <?php
    class A {
         public function method(int $many, string $parameters, $here) {}
    }
    class B extends A {
         public function method(...$everything) {}
    }
    ?>
    ```

*   static ("后期静态绑定"中) 可以作为返回类型：

    ```php
    <?php
    class Test {
         public function create(): static {
              return new static();
         }
    }
    ?>
    ```

*   现在可以通过 `$object::class` 获取类名，返回的结果和 `get_class($object)` 一致。

*   [`new`](https://www.php.net/manual/zh/language.oop5.basic.php#language.oop5.basic.new)、[`instanceof`](https://www.php.net/manual/zh/language.operators.type.php) 可用于任何表达式， 用法为 `new (expression)(...$args)` 和 `$obj instanceof (expression)`。

*   添加对一些变量语法一致性的修复，例如现在能够编写 `Foo::BAR::$baz`。

*   添加 [Stringable](https://www.php.net/manual/zh/class.stringable.php) interface， 当一个类定义 [\_\_toString()](https://www.php.net/manual/zh/language.oop5.magic.php#object.tostring) 方法后会自动实现该接口。

*   Trait 可以定义私有抽象方法（abstract private method）。 类必须实现 trait 定义的该方法。

*   可作为表达式使用 `throw`。 使得可以编写以下用法：

    ```php
    <?php
    $fn = fn() => throw new Exception('Exception in arrow function');
    $user = $session->user ?? throw new Exception('Must have user');
    ```

*   参数列表中的末尾逗号为可选。

    ```php
    <?php
    function functionWithLongSignature(
        Type1 $parameter1,
        Type2 $parameter2, // <-- 这个逗号也被允许了
    ) {
    }
    ```

*   现在允许 `catch (Exception)` 一个 exception 而无需捕获到变量中。

*   支持 [mixed](https://www.php.net/manual/zh/language.types.declarations.php#language.types.declarations.mixed) 类型。

*   Private methods declared on a parent class no longer enforce any inheritance rules on the methods of a child class (with the exception of final private constructors). The following example illustrates which restrictions have been removed:

    ```php
    <?php
    class ParentClass {
        private function method1() {}
        private function method2() {}
        private static function method3() {}
        // Throws a warning, as "final" no longer has an effect:
        private final function method4() {}
    }
    class ChildClass extends ParentClass {
        // All of the following are now allowed, even though the modifiers aren't
        // the same as for the private methods in the parent class.
        public abstract function method1() {}
        public static function method2() {}
        public function method3() {}
        public function method4() {}
    }
    ?>
    ```

*   [get\_resource\_id()](https://www.php.net/manual/zh/function.get-resource-id.php) has been added, which returns the same value as `(int) $resource`. It provides the same functionality under a clearer API.

*   [array\_slice()](https://www.php.net/manual/zh/function.array-slice.php) 用于没有空隙的数组时， 将不会扫描整个数组去查找开始的位移（offset）。 在 offset 较大、长度较小时，会显著减少函数的运行时间。

*   ^[{% post_link 'PHP-8-0-0' %}]^ 当本地化 `LC_CTYPE` 为 `"C"` 时（也是默认值）， [strtolower()](https://www.php.net/manual/zh/function.strtolower.php) 会使用 SIMD 的实现。
    * >  [是怎样使用SSE2 (Streaming SIMD Extensions 2) 的实现来提升strtolower性能的呢？](https://www.laruence.com/2020/06/16/5916.html)


### Date and Time

*   [DateTime::createFromInterface()](https://www.php.net/manual/zh/datetime.createfrominterface.php) and [DateTimeImmutable::createFromInterface()](https://www.php.net/manual/zh/datetimeimmutable.createfrominterface.php) have been added.

*   The DateTime format specifier `p` has been added, which is the same as `P` but returns `Z` rather than `+00:00` for UTC.


### DOM

**DOMParentNode** and **DOMChildNode** with new traversal and manipulation APIs have been added.

### Filter

`FILTER_VALIDATE_BOOL` has been added as an alias for `FILTER_VALIDATE_BOOLEAN`. The new name is preferred, as it uses the canonical type name.


### Enchant

[enchant\_dict\_add()](https://www.php.net/manual/zh/function.enchant-dict-add.php), [enchant\_dict\_is\_added()](https://www.php.net/manual/zh/function.enchant-dict-is-added.php), and `LIBENCHANT_VERSION` have been added.

### FPM

Added a new option pm.status_listen that allows getting the status from different endpoint (e.g. port or UDS file) which is useful for getting the status when all children are busy with serving long running requests.

### Hash

**HashContext** objects can now be serialized.

### Internationalization Functions

The `IntlDateFormatter::RELATIVE_FULL`, `IntlDateFormatter::RELATIVE_LONG`, `IntlDateFormatter::RELATIVE_MEDIUM`, and `IntlDateFormatter::RELATIVE_SHORT` constants have been added.

### LDAP

[ldap\_count\_references()](https://www.php.net/manual/zh/function.ldap-count-references.php) has been added, which returns the number of reference messages in a search result.

### OPcache

*  opcache 扩展新增了即时编译(JIT) 支持。
  * [PHP8的Opcache JIT要怎样用，有什么要注意，性能提升效果咋样？](https://www.laruence.com/2020/06/27/5963.html)

*  If the opcache.record\_warnings ini setting is enabled, OPcache will record compile-time warnings and replay them on the next include, even if it is served from cache.

### OpenSSL

Added [Cryptographic Message Syntax (CMS)](https://www.vocal.com/secure-communication/cryptographic-message-syntax-cms/) ([» RFC 5652](http://www.faqs.org/rfcs/rfc5652)) support composed of functions for encryption, decryption, signing, verifying and reading. The API is similar to the API for PKCS #7 functions with an addition of new encoding constants: `OPENSSL_ENCODING_DER`, `OPENSSL_ENCODING_SMIME` and `OPENSSL_ENCODING_PEM`:

*   [openssl\_cms\_encrypt()](https://www.php.net/manual/zh/function.openssl-cms-encrypt.php) encrypts the message in the file with the certificates and outputs the result to the supplied file.
*   [openssl\_cms\_decrypt()](https://www.php.net/manual/zh/function.openssl-cms-decrypt.php) that decrypts the S/MIME message in the file and outputs the results to the supplied file.
*   [openssl\_cms\_read()](https://www.php.net/manual/zh/function.openssl-cms-read.php) that exports the CMS file to an array of PEM certificates.
*   [openssl\_cms\_sign()](https://www.php.net/manual/zh/function.openssl-cms-sign.php) that signs the MIME message in the file with a cert and key and output the result to the supplied file.
*   [openssl\_cms\_verify()](https://www.php.net/manual/zh/function.openssl-cms-verify.php) that verifies that the data block is intact, the signer is who they say they are, and returns the certs of the signers.

### Regular Expressions (Perl-Compatible)

[preg\_last\_error\_msg()](https://www.php.net/manual/zh/function.preg-last-error-msg.php) has been added, which returns a human-readable message for the last PCRE error. It complements [preg\_last\_error()](https://www.php.net/manual/zh/function.preg-last-error.php), which returns an integer enum value instead.

### Reflection

*   The following methods can now return information about default values of parameters of internal functions:

    *   [ReflectionParameter::isDefaultValueAvailable()](https://www.php.net/manual/zh/reflectionparameter.isdefaultvalueavailable.php)
    *   [ReflectionParameter::getDefaultValue()](https://www.php.net/manual/zh/reflectionparameter.getdefaultvalue.php)
    *   [ReflectionParameter::isDefaultValueConstant()](https://www.php.net/manual/zh/reflectionparameter.isdefaultvalueconstant.php)
    *   [ReflectionParameter::getDefaultValueConstantName()](https://www.php.net/manual/zh/reflectionparameter.getdefaultvalueconstantname.php)

* 可通过新参数 `filter` 来过滤 [ReflectionClass::getConstants()](https://www.php.net/manual/zh/reflectionclass.getconstants.php) 和 [ReflectionClass::getReflectionConstants()](https://www.php.net/manual/zh/reflectionclass.getreflectionconstants.php) 的返回结果。 新增三个常量，搭配使用：

  *   `ReflectionClassConstant::IS_PUBLIC`
  *   `ReflectionClassConstant::IS_PROTECTED`
  *   `ReflectionClassConstant::IS_PRIVATE`


### SQLite3

[SQLite3::setAuthorizer()](https://www.php.net/manual/zh/sqlite3.setauthorizer.php) and respective class constants have been added to set a userland callback that will be used to authorize or not an action on the database.

### Standard Library

*   [str\_contains()](https://www.php.net/manual/zh/function.str-contains.php), [str\_starts\_with()](https://www.php.net/manual/zh/function.str-starts-with.php) and [str\_ends\_with()](https://www.php.net/manual/zh/function.str-ends-with.php) have been added, which check whether `haystack` contains, starts with or ends with `needle`, respectively.

*   [fdiv()](https://www.php.net/manual/zh/function.fdiv.php) has been added, which performs a floating-point division under IEEE 754 semantics. Division by zero is considered well-defined and will return one of `Inf`, `-Inf` or `NaN`.

*   [get\_debug\_type()](https://www.php.net/manual/zh/function.get-debug-type.php) has been added, which returns a type useful for error messages. Unlike [gettype()](https://www.php.net/manual/zh/function.gettype.php), it uses canonical type names, returns class names for objects, and indicates the resource type for resources.

*   [printf()](https://www.php.net/manual/zh/function.printf.php) and friends now support the `%h` and `%H` format specifiers. These are the same as `%g` and `%G`, but always use `"."` as the decimal separator, rather than determining it through the `LC_NUMERIC` locale.

*   [printf()](https://www.php.net/manual/zh/function.printf.php) and friends now support using `"*"` as width or precision, in which case the width/precision is passed as an argument to printf. This also allows using precision `-1` with `%g`, `%G`, `%h` and `%H`. For example, the following code can be used to reproduce PHP's default floating point formatting:

    ```php
    <?php
    printf("%.*H", (int) ini_get("precision"), $float);
    printf("%.*H", (int) ini_get("serialize_precision"), $float);
    ?>
    ```

*   [proc\_open()](https://www.php.net/manual/zh/function.proc-open.php) now supports [pseudo-terminal (PTY)](https://www.gnu.org/software/libc/manual/html_node/Pseudo_002dTerminals.html) descriptors. The following attaches `stdin`, `stdout` and `stderr` to the same PTY:

    ```php
    <?php
    $proc = proc_open($command, [['pty'], ['pty'], ['pty']], $pipes);
    ?>
    ```

*   [proc\_open()](https://www.php.net/manual/zh/function.proc-open.php) now supports [socket pair](https://www.gnu.org/software/libc/manual/html_node/Socket-Pairs.html) descriptors. The following attaches a distinct socket pair to `stdin`, `stdout` and `stderr`:

    ```php
    <?php
    $proc = proc_open($command, [['socket'], ['socket'], ['socket']], $pipes);
    ?>
    ```

    Unlike pipes, sockets do not suffer from blocking I/O issues on Windows. However, not all programs may work correctly with stdio sockets.

*   Sorting functions are now stable, which means that equal-comparing elements will retain their original order.

*   [array\_diff()](https://www.php.net/manual/zh/function.array-diff.php), [array\_intersect()](https://www.php.net/manual/zh/function.array-intersect.php) and their variations can now be used with a single array as argument. This means that usages like the following are now possible:

    ```php
    <?php
    // OK even if $excludes is empty:
    array_diff($array, ...$excludes);
    // OK even if $arrays only contains a single array:
    array_intersect(...$arrays);
    ?>
    ```

*   The `flag` parameter of [ob\_implicit\_flush()](https://www.php.net/manual/zh/function.ob-implicit-flush.php) was changed to accept a bool rather than an int.

### Tokenizer

[PhpToken](https://www.php.net/manual/zh/class.phptoken.php) adds an object-based interface to the tokenizer. It provides a more uniform and ergonomic representation, while being more memory efficient and faster.

### Zip

*   The Zip extension has been updated to version 1.19.1.

*   New [ZipArchive::setMtimeName()](https://www.php.net/manual/zh/ziparchive.setmtimename.php) and [ZipArchive::setMtimeIndex()](https://www.php.net/manual/zh/ziparchive.setmtimeindex.php) to set the modification time of an entry.

*   New [ZipArchive::registerProgressCallback()](https://www.php.net/manual/zh/ziparchive.registerprogresscallback.php) to provide updates during archive close.

*   New [ZipArchive::registerCancelCallback()](https://www.php.net/manual/zh/ziparchive.registercancelcallback.php) to allow cancellation during archive close.

*   New [ZipArchive::replaceFile()](https://www.php.net/manual/zh/ziparchive.replacefile.php) to replace an entry content.

*   New [ZipArchive::isCompressionMethodSupported()](https://www.php.net/manual/zh/ziparchive.iscompressionmethoddupported.php) to check optional compression features.

*   New [ZipArchive::isEncryptionMethodSupported()](https://www.php.net/manual/zh/ziparchive.isencryptionmethoddupported.php) to check optional encryption features.

*   The ZipArchive::lastId property to get the index value of the last added entry has been added.

*   Errors can now be checked after an archive has been closed using the ZipArchive::status and ZipArchive::statusSys properties, or the [ZipArchive::getStatusString()](https://www.php.net/manual/zh/ziparchive.getstatusstring.php) method.

*   The `'remove_path'` option of [ZipArchive::addGlob()](https://www.php.net/manual/zh/ziparchive.addglob.php) and [ZipArchive::addPattern()](https://www.php.net/manual/zh/ziparchive.addpattern.php) is now treated as an arbitrary string prefix (for consistency with the `'add_path'` option), whereas formerly it was treated as a directory name.

*   Optional compression / encryption features are now listed in phpinfo.

*   [ZipArchive::addGlob()](https://www.php.net/manual/zh/ziparchive.addglob.php) 和 [ZipArchive::addPattern()](https://www.php.net/manual/zh/ziparchive.addpattern.php) 方法中 `options` 数组参数可接受更多的值：

    *   `flags`
    *   `comp_method`
    *   `comp_flags`
    *   `env_method`
    *   `enc_password`

*   [ZipArchive::addEmptyDir()](https://www.php.net/manual/zh/ziparchive.addemptydir.php)、[ZipArchive::addFile()](https://www.php.net/manual/zh/ziparchive.addfile.php)、 [ZipArchive::addFromString()](https://www.php.net/manual/zh/ziparchive.addfromstring.php) 方法新增 `flags` 参数。 可用于名称编码 (`ZipArchive::FL_ENC_*`) 与条目（entry）替换 (`ZipArchive::FL_OVERWRITE`)。

*   [ZipArchive::extractTo()](https://www.php.net/manual/zh/ziparchive.extractto.php) 现在会储存文件的修改时间。

### JSON

现在无法禁用 JSON 扩展，将是任意 PHP 版本的内置功能，类似 date 扩展。

### GD

*   [imagepolygon()](https://www.php.net/manual/zh/function.imagepolygon.php)、 [imageopenpolygon()](https://www.php.net/manual/zh/function.imageopenpolygon.php)、[imagefilledpolygon()](https://www.php.net/manual/zh/function.imagefilledpolygon.php) 的参数 `num_points` 现在为可选参数。 这些函数可用三或四个参数去调用。 省略参数时，会按 `count($points)/2` 计算。

*   新增函数 [imagegetinterpolation()](https://www.php.net/manual/zh/function.imagegetinterpolation.php)，可获取当前的插值（interpolation）。

### SimpleXML

现在 [SimpleXMLElement](https://www.php.net/manual/zh/class.simplexmlelement.php) 实现（implements）了 [RecursiveIterator](https://www.php.net/manual/zh/class.recursiveiterator.php) 并吸收了 [SimpleXMLIterator](https://www.php.net/manual/zh/class.simplexmliterator.php) 的功能。 [SimpleXMLIterator](https://www.php.net/manual/zh/class.simplexmliterator.php) 是 [SimpleXMLElement](https://www.php.net/manual/zh/class.simplexmlelement.php) 的一个空扩展。


### INI 文件处理的变更

*   com.dotnet\_version 是一个新的 INI 指令，用于选择 [dotnet](https://www.php.net/manual/zh/class.dotnet.php) 对象的 .NET framework 版本。

*   zend.exception\_string\_param\_max\_len 是一个新的 INI 指令，用于设置字符串化的调用栈（stack strace）的最大字符串长度。

