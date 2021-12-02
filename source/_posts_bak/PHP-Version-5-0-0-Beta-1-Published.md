---
title: PHP Version 5.0.0 Beta 1 Published
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - 历史
  - PHP发展史
  - 技术发展史
date: 2003-06-29 15:00:00
---

# 有什么变化

它的核心是 Zend 引擎 2 代，引入了新的对象模型和大量新功能。

http://people.apache.org/~jim/ApacheCons/ApacheCon2002/pdf/suraski-php-02.pdf

## 新增了什么

*   New php.ini options:
    *   "session.hash\_function" and "session.hash\_bits\_per\_character". (Sascha)
    *   "mail.force\_extra\_paramaters". (Derick)
    *   "register\_long\_arrays". (Zeev)

*   Added new iconv functions. (Moriyoshi)
    *   iconv\_strlen()
    *   iconv\_substr()
    *   iconv\_strpos()
    *   iconv\_strrpos()
    *   iconv\_mime\_decode()
    *   iconv\_mime\_encode()
*   Added misc. new functions:
    *   ldap\_sasl\_bind(). (peter\_c60@hotmail.com, Jani)
    *   imap\_getacl(). (Dan, Holger Burbach)
    *   file\_put\_contents(). (Sterling)
    *   proc\_nice() - Changes priority of the current process. (Ilia)
    *   pcntl\_getpriority() and pcntl\_setpriority(). (Ilia)
    *   idate(), date\_sunrise() and date\_sunset(). (Moshe Doron)
    *   strpbrk() - Searches a string for a list of characters. (Ilia)
    *   get\_headers() - Returns headers sent by the server of the specified URL. (Ilia)
    *   str\_split() - Breaks down a string into an array of elements based on length. (Ilia)
    *   array\_walk\_recursive(). (Ilia)
    *   array\_combine(). (Andrey)
*   Added optional parameter to get\_browser() to make it return an array. (Jay)
*   Added optional parameter to openssl\_sign() to specify the hashing algorithm.(scott@planetscott.ca, Derick)
*   Added optional parameter to sha1(), sha1\_file(), md5() and md5\_file() which makes them return the digest as binary data. (Michael Bretterklieber, Derick)
*   Added optional parameter to mkdir() to make directory creation recursive. (Ilia)
*   Added optional parameter to file() which makes the result array not contain the line endings and to skip empty lines. (Ilia)
*   Added new range() functionality:
    *   Support for float modifier. (Ilia)
    *   Detection of numeric values inside strings passed as high & low. (Ilia)
    *   Proper handle the situations where high == low. (Ilia)
    *   Added an optional step parameter. (Jon)
*   Added encoding detection feature for expat XML parser. (Adam Dickmeiss, Moriyoshi)
*   Added missing multibyte (unicode) support and numeric entity support to html\_entity\_decode(). (Moriyoshi)
*   Added IPv6 support to ext/sockets. (Sara)
*   Added input filter support. See README.input\_filter for more info. (Rasmus)
*   Added a replace count for str\_\[i\]replace(), see [#8218](http://bugs.php.net/8218). (Sara)

## 移除了什么
*   Removed the bundled MySQL client library. (Sterling)


## 修改了什么

*   Switch to using Zend Engine 2, which includes numerous engine level improvements. A full overview may be downloaded from [http://www.zend.com/engine2/ZendEngine-2.0.pdf](http://www.zend.com/engine2/ZendEngine-2.0.pdf) (PDF).

*   The SQLite ([http://www.hwaci.com/sw/sqlite/](http://www.hwaci.com/sw/sqlite/)) extension is now bundled and enabled by default. (Wez, Marcus, Tal)

*   Improved the speed of internal functions that use callbacks by 40% due to a new internal fast\_call\_user\_function() function. (Sterling)

*   Completely Overhauled XML support (Rob, Sterling, Chregu, Marcus)
    *   Brand new Simplexml extension
    *   New DOM extension
    *   New XSL extension
    *   Moved the old DOM-XML and XSLT extensions to PECL
    *   ext/xml can now use both libxml2 and expat to parse XML
    *   Removed bundled expat


*   Improved the streams support: (Wez, Sara, Ilia)
    *   Improved performance of readfile(), fpassthru() and some internal streams operations under Win32.
    *   stream\_socket\_client() - similar to fsockopen(), but more powerful.
    *   stream\_socket\_server() - Creates a server socket.
    *   stream\_socket\_accept() - Accept a client connection.
    *   stream\_socket\_get\_name() - Get local or remote name of socket.
    *   stream\_copy\_to\_stream()
    *   stream\_get\_line() - Reads either the specified number of bytes or until the ending string is found.
    *   Added context property to userspace streams object.
    *   Added generic crypto interface for streams (supports dynamic loading of OpenSSL)
    *   Added lightweight streaming input abstraction to the Zend Engine scanners to provide uniform support for include()'ing data from PHP streams across all platforms.
    *   Added 'string.base64' stream filter.
    *   Renamed stream\_register\_wrapper() to stream\_wrapper\_register().
    *   Added "ftp://" wrapper support to opendir(), stat() and unlink().
    *   Added context options 'method', 'header' and 'content' for "http://" fopen wrapper.


*   Improved the GD extension: (Pierre-Alain Joye, Ilia)
    *   imagefilter() - Apply different filters to image. (Only available with bundled GD library)
    *   Antialiased drawing support:
        *   imageantialias() - (de)active antialias
        *   imageline() and imagepolygon() antialias support

*   Changed the length parameter in fgetss() to be optional. (Moriyoshi)
*   Changed ini parser to allow for handling of quoted multi-line values. (Ilia)
*   Changed get\_extension\_funcs() to return list of the built-in Zend Engine functions if "zend" is specified as the module name. (Ilia)
*   Changed array\_search() to accept also objects as a needle. (Moriyoshi)
*   Changed ext/mcrypt to require libmcrypt version 2.5.6 or greater. (Derick)
*   Changed uniqid() parameters to be optional and allow any prefix length. (Marcus)


## 修复了什么BUG

*   Fixed is\_executable() to be available also on Windows. (Shane)
*   Fixed dirname() and strip\_tags() to be binary-safe. (Moriyoshi)
*   Fixed bug [#24098](http://bugs.php.net/24098) (crash in pathinfo()). (Ilia)
*   Fixed bug [#21985](http://bugs.php.net/21985) and [#22064](http://bugs.php.net/22064) (various mb\_send\_mail() issues). (Moriyoshi)
*   Fixed bug [#21600](http://bugs.php.net/21600) (Assign by reference function call changes variable contents). (Zeev)

# 为了解决什么问题

* BUG
* XML被广泛使用，支持能力需要提升
* 支持IPv6
* 在面向对象的设计支持不足

# 关键思路是什么

* 借鉴优秀的设计思路，如JAVA，补充更多的面向对象设计特性


# 演进思路是什么