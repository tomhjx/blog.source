---
title: PHP Version 4.0 Beta 2 Published
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - 历史
  - PHP发展史
  - 技术发展史
date: 1999-08-09 15:00:00
---

# 有什么变化


## 新增了什么

* Made the IMAP module work with PHP 4.0 (Zeev)
* Added get_class($obj), get_parent_class($obj) and method_exists($obj,"name") (Andi & Zeev)
* Added function entries for strip_tags() and similar_text() (Andrei)
* Ported strtotime() function from PHP 3.0 (Andrei)
* buildconf now checks your installation (Stig)
* XML module now built dynamically with --with-xml=shared (Stig)
* Added a check for freetype.h - fixed build on RedHat 6.0 (Zeev)
* Ported all remaining date() format options from PHP 3.0 (Andrei)
* $php_errormsg now works (Andrei)
* Added locale support for Perl Compatible Regexp functions (Andrei)
* Informix module ported (Danny)
* Added patch for reverse lookup table in base64_decode (Sascha) Submitted by bfranklin@dct.com
* Added DBA module (Sascha)
* Added session id detection within REQUEST_URI (Sascha)
* Added missing E_ error level constants (Zeev, Zend Engine)
* Gave PHP 4.0's SNMP extension all the functionality of PHP 3.0.12 (SteveL)

## 移除了什么

* Remove --with-shared-apache (Sascha)




## 修改了什么

* Win32 builds now include the ODBC module built-in (Zeev)
* Updated hyperwave module, made it thread safe
* Updated pdflib module, version 0.6 of pdflib no longer supported
* Updated fdf module
* Built-in phpinfo() links are now turned off by default. They can be turned on using the allow_builtin_links INI directive (Zeev)
* Changed phpinfo() to list modules that have no info function (Zeev)
* Modified array_walk() function so that the userland callback is passed a key and possible user data in addition to the value (Andrei)
* Children now inherit their parent's constructor, if they do not supply a constructor of their own.
* Apache php_flag values only recognized 'On' (case sensitive) - changed to case insensitive (Zeev)
* Merged in gdttf stuff from PHP 3.0 (Sascha)
* Merged in PHP 3.0 version of str_replace (Sascha)
* Merged in HP-UX/ANSI compatibility switch from PHP 3.0 (Sascha)

* Improved register_shutdown_function() - you may now supply arguments that will be passed to the shutdown function (Zeev)
* Improved call_user_func() and call_user_method() - they now support passing arguments by reference (Zeev)
* Improved ISAPI module to supprt large server variables (Zeev)


## 修复了什么BUG

* Fixed a problem when sending HTTP/1.x header lines using header() (Zeev)
* Fixed SYSV-SHM interface (Thies).
* Fixed ldap_search(), ldap_read() and ldap_list() (Zeev)
* Fixed Apache information in phpinfo() (sam@breakfree.com)
* Fixed usort() and uksort() (Zeev)
* Fixed md5() in the Apache module (Thies)
* Fixed sybase_fetch_object() (Zeev)
* Fixed a problem with include()/require() of URLs (Sascha, Zeev)
* Fixed a bug in implode() that caused it to corrupt its arguments (Zeev)
* Fixed various inheritance problems (Andi & Zeev, Zend Engine)
* Fixed runtime inheritance of classes (parent methods/properties were overriding their children) (Zeev, Zend Engine)
* Fixed backwards incompatibility with the "new" operator (Andi, Zend Engine)
* Fixed bugs in uksort() and ksort() sort ordering (Andrei)
* Fixed a memory leak when using assignment-op operators with lvalue of type string (Zeev, Zend Engine)
* Fixed a problem in inheritance from classes that are defined in include()d files (Zeev, Zend Engine)
* Fixed a problem with the PHP error handler that could result in a crash on certain operating systems (Zeev)
* Fixed a memory leak with switch statement containing return statements (Andi & Zeev, Zend Engine)
* Fixed a crash problem in switch statements that had a string offset as a conditional (Andi & Zeev, Zend Engine)
* Imported PHP 3.0 fixes for problem with PHP as a dynamic module and Redhat libc2.1 in zlib module (Stefan)
* Imported PHP 3.0 fixes for rand() and mt_rand() (Rasmus)
* Fixed a bug in WDDX that would cause a crash if a number was passed in instead of a variable name (Andrei)
* Fixed array_walk() to work in PHP 4.0 (Andrei)
* Fixed rpath handling for utilitites built during Apache build (Sascha)
* Fixed a bug in sending multiple HTTP Cookies under Apache (Zeev)
* Fixed implicit connect on the MySQL, mSQL, PostgreSQL and Sybase modules (Zeev)


# 为了解决什么问题

* BUG
* 从PHP3.0过渡到PHP4.0的迭代维护

# 关键思路是什么

* 向后兼容

* 轻量化，减少更多的自启动，提供按需使用的空间

* 开放更多的可扩展性
  * 数据库驱动
  * 提供编写钩子的空间

* 优化查错体系
  * 补充并前置环境、依赖的查错
  * 规范化，完善错误日志等级
  * 补充错误信息提取手段

* 关注关键问题
  * 内存泄露
  * 线程安全