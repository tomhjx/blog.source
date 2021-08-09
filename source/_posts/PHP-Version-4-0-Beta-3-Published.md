---
title: PHP Version 4.0 Beta 3 Published
categories:
  - 开发
  - 编程语言
  - PHP
tags:
  - PHP
  - 历史
  - PHP发展史
  - 技术发展史
date: 1999-11-16 15:00:00
---


# 有什么变化


## 新增了什么

* Added Win32 build files for Informix driver and make it compile with ZTS (danny)
* Added tmpfile() function (Stig)
* min(),max(),a[r]sort(),[r]sort(),k[r]sort() now work consistent with the language-core. (Thies)
* tempnam() now uses mkstemp() if available (Stig)
* serialize() and var_dump() now honor the precision as set in php.ini for doubles. (Thies)
* Added Microsoft SQL Server module for Win32 (Frank)
* Added support for forcing a variable number of internal function arguments by reference. (Andi & Zeev, Zend Engine)
* Implemented getprotoby{name,number} (Evan)
* Added array\_pad() function. (Andrei)
* Added new getservby{name,port} functions. (Evan)
* Added session.cookie\_path and session.cookie\_domain (Sascha)
* Continue processing PHP_INI_SYSTEM knownDirectives after extension= (Sam Ruby)
* Enable IBM DB2 support - Tested against DB2 6.1 UDB on Linux (Rasmus)
* Added new str_repeat() function. (Andrei)
* implemented OCI8 $lob->WriteToFile() function - very useful for streaming large amounts of LOB-Data without to need of a huge buffer. (Thies)
* Added session.use_cookies option (Sascha)
* Added getcwd() function. (Thies)
* added === operator support. (Andi & Thies, Zend Engine)
* Added is_resource(), is_bool() functions. (Thies)
* Thies introduced ZEND_FETCH_RESOURCE2 (Danny).
* Added Informix driver to list of maintained extensions. (Danny).
* IXF_LIBDIR environment variable specifies alternate Informix library path for configure (Danny).
* You can use resources as array-indices again (Thies, Zend Engine)
* fdf support ported; not completely tested with latest version 4.0 for glibc (Uwe)
* OCI8 connections are now kept open as long as they are referenced (Thies)
* Ported range() and shuffle() from PHP 3 to PHP 4 (Andrei)
* Added the ability to use variable references in the array() construct. For example, array("foo" => &$foo). (Andi, Zend Engine)
* Added array_reverse() function (Andrei)
* Generalized server-API build procedure on UNIX (Stig)
* Added '--disable-rpath' option (Sascha)
* Added AOLserver SAPI module (Sascha)
* Added support for the Easysoft ODBC-ODCB Bridge (martin@easysoft.com)
* Added extra metadata functions to ODBC, SQLTables etc (nick@easysoft.com)
* Implemented object serialization/deserialization in WDDX (Andrei)
* Added krsort() function (Thies)
* Added func_num_args(), func_get_arg() and func_get_args() for standard access to variable number of arguments functions (Zeev)
* Added FTP support (Andrew Skalski)
* Added optional allowable_tags arguments to strip_tags(), gzgetss() and fgetss() to allow you to specify a string of tags that are not to be stripped (Rasmus)
* Added array_count_values() function. (Thies)
* snmp, pgsql, mysql and gd modules can be built as dynamically loaded modules (Greg)
* Added user-level callbacks for session module (Sascha)
* Added support for unknown POST content types (Zeev)
* Added "wddx" serialization handler for session module (Sascha) (automatically enabled, if you compile with --with-wddx)
* PHP 4.0 now serializes Objects as 'O' (not understood by PHP 3.0), but unserializes PHP 3.0 serialized objects as expected. (Thies)
* Made serialize/unserialize work on classes. If the class is known at unserialize() time, you'll get back a fully working object! (Thies)
* Made it possible to specify external location of PCRE library (Andrei)

* OCI8 supports appending and positioning when saving LOBs (Thies)
* Added metaphone support (Thies)
* OCI8 Driver now supports LOBs like PHP 3.0. (Thies)
* var_dump now dumps the properties of an object (Thies)
* Added support for transparent session id propagation (Sascha)
* Made WDDX serialize object properties properly (Andrei)
* Added session_unset() function (Andrei)
* Added gpc_globals variable directive to php.ini. By default it is On, but if it is set to Off, GET, POST and Cookie variables will not be inserted to the global scope. Mostly makes sense when coupled with track_vars (Zeev)

* Added versioning support for shared library (Sascha) This allows concurrent use of PHP 3.0 and PHP 4.0 as Apache modules. See the end of the INSTALL file for more information.

* Added second parameter to array_keys which specifies search value for which the key should be returned (Andrei)

* Make set_time_limit() work on Unix (Rasmus)
* Added connection handling support (Rasmus)
* Added shared memory module for session data storage (Sascha)
* Ported newest GetImageSize (Thies)
* Added session compile support in Win32 (Andi)
* Added -d switch to the CGI binary that allows overriding php.ini values from the command line (Zeev)
* Added output_buffering directive to php.ini, to enable output buffering for all PHP scripts - default is off (Zeev).

* Added session.extern_referer_chk which checks whether session ids were referred to by an external site and eliminates them (Sascha)

* Introduced general combined linear congruential generator (Sascha)
* Made ldap_close back into an alias for ldap_unbind (Andrei)





## 移除了什么

* Cleaned up File-Module (Thies)
* Cleaned up Directory-Module (Thies)



## 修改了什么

* ucfirst()/ucwords() no longer modify arg1 (Thies)
* Upgraded regex library to alpha3.8 (Sascha)
* Output-Buffering system is now Thread-Safe. (Thies)
* XML_Parse_Into_Struct no longer eats data. (Thies)
* unserialize() now gives a notice when passed invalid data. (Thies)
* Improved the Win32 COM module to support [out] parameters (Boris Wedl)
* setlocale doesn't anymore screw up things if you forgot to change it back to the original settings. (Jouni)
* Switched to new system where ChangeLog is automagically updated from commit messages. NEWS file is now the place for public announcements. (Andrei)
* Improved UNIX build system. Now utilizes libtool (Sascha)
* Updated Zend garbage collection with a much more thorough method. (Andi, Zend Engine)
* Some more XML fixes/cleanups (Thies)
* Updated preg_replace() so that if any argument passed in is an array it will make a copy of each entry before converting it to string so that the original is intact. If the subject is an array then it will preserve the keys in the output as well (Andrei)
* Configure speedup (Stig)
* Upgrade some more internal functions to use new Zend function API. (Thies, Zend Engine)
* Informix driver : Changed ifx.ec to use the new high-performance ZEND API. (Danny)
* Upgraded math-funtions to use new Zend function API (Thies)
* Upgraded a lot internal functions to use new Zend function API (Thies)
* Updated OCI8 to use the new high-performance Zend function API. (Thies)
* Updated ODBC to use the new high-performance Zend function API (kara)
* Updated zlib to use the new high-performance Zend function API. (Stefan)
* Updated preg_split() to allow returning only non-empty pieces (Andrei)
* Updated PCRE to use the new high-performance Zend function API (Andrei)
8 Updated session, dba, mhash, mcrypt, sysvshm, sysvsem, gettext modules to use the new high-performance Zend function API (Sascha)
* Updated WDDX to use the new high-performance Zend function API (Andrei)
* Updated XML to use the new high-performance Zend function API. (Thies)
* Updated Oracle to use the new high-performance Zend function API. (Thies)
* Improved the performance of the MySQL module significantly by using the new high-performance Zend function API. (Zeev)
* Extended var_dump to handle resource type somewhat (Andrei)
* Resourcified Oracle (Thies)
* Upgraded var_dump() to take multiple arguments (Andrei)
* Reworked preg_* functions according to the new PCRE API, which also made them behave much more like Perl ones (Andrei)
* Updated bundled PCRE library to version 2.08 (Andrei)
* count()/is_array/is_object... speedups. (Thies)
* OCI8 doesn't use define callbacks any longer. (Thies)
* Rewrote the GET/POST/Cookie data reader to support multi-dimensional arrays! (Zeev)
* Renamed allow_builtin_links to expose_php (defaults to On). This directive tells PHP whether it may expose its existence to the outside world, e.g. by adding itself to the Web server header (Zeev)

* Resourcified Informix driver (Danny)
* New resource handling for odbc, renamed to php\_odbc.\[ch\]

* Improved the Sybase-CT module to make use of resources (Zeev)
* Improved the mSQL module to make use of resources (Zeev)
* Changed mysql_query() and mysql_db_query() to return false in case of saving the result set data fails (Zeev)
* Improved the resource mechanism - resources were not getting freed as soon as they could (Zeev)
* Improved session id generation (Sascha)
* Improved speed of uniqid() by using the combined LCG and removing the extra usleep() (Sascha)

* OciFetchInto now resets the returned array in all cases (Thies)
* Oracle is now ZTS-Safe (Thies)
* OCI8 is now ZTS-Safe (Thies)
* Imported PHP 3.0 diskfreespace() function (Thies)






## 修复了什么BUG

* Fixed strtr() not to modify arg1 (Thies)
* Fixed selecting nested-tables in OCI8. (Thies)
* RFC-854 fix for internal FTP-Code. Commands have to end in "\r\n" (Thies)
* Fixed OpenLink ODBC support (Stig)
* Fixed garbage returned at the end of certain Sybase-Columns (Thies) Patch submitted by: neal@wanlink.com
* Fixed parse_url('-') crash. (Thies)
* Fixed shuffle() so that it no longer breaks on Solaris. (Andrei)
* Fixed zombie problem in shell\_exec() and $a = \`some\_command\` constructs. (Thies)
* Fixed gmmktime() so that the following should always be true: gmmktime([args]) == mktime([args]) + date('Z', mktime([args])) (Jouni)
* Fixed refcount problem in XML module. (Thies)
* Fixed crash in HTTP_RAW_POST_DATA handling (Thies)
* Fixed pg_fetch_array() with three arguments (Sascha) Patch submitted by: brian@soda.berkeley.edu
* Small fix in Ora_Close (Thies)
* Fixed header("HTTP/..."); behaviour (Sascha)
* Fixed backwards incompatibility with ereg() (Thies)
* Fixed LOB/Persistent-Connection related OCI8-Crash (Thies)
* Fixed XML Callbacks. (Thies)
* Fixed bug in odbc_setoption, getParameter call incorrect (martin@easysoft.com)
* Fixed NULL-Column problem in Oracle-Driver (Thies)
* Fixed SEGV in mcal make_event_object() and typo in mcal_list_alarms() (Andrew Skalski)
* Fixed Ora_PLogon (Thies)
* Fixed a memory leak in the Apache per-directory directives handler (Zeev)
* OCI8 fix for fetching empty LOBs (Thies)
* Fixed unserializing objects (Thies)

* Fixed WDDX mem leak when undefined variable is passed in for serialization (Andrei)
* Fixed double session globals shutdown crash (Andrei)
* Fixed crash related to ignore_user_abort ini entry (Andrei)

* Fixed session.auto_start (Sascha)
* Fixed several problems with output buffering and HEAD requests (Zeev)
* Fixed HTTP Status code issue with ISAPI module (Zeev)
* Fixed a problem that prevented $GLOBALS from working properly (Zeev, Zend library)

* Fixed a crash that would occur if wddx_deserialize did not receive a valid packet (Andrei)
* Fixed a bugglet when redefining a class at run-time (Andi, Zend Engine)
* Fixed sem_get() on AIX (Sascha)
* Fixed fopen() to work with URL's in Win32 (Andi & Zeev)
* Fixed include_path for Win32 (Andi, Zend Engine)
* Fixed bug in ISAPI header sending function (Charles)
* Fixed memory leak when using undefined values (Andi & Zeev, Zend Engine)
* Fixed some more class inheritance issues (Zeev, Zend Engine)
* Fixed Apache build wrt to shared modules on FreeBSD/Linux (Sascha)

* Fixed mysql_errno() to work with recent versions of MySQL (Zeev)
* Fixed a problem with define() and boolean values (Zeev)
* Fixed inclusion of gd/freetype functions (Sascha)
* Fixed persistency of MHASH_* constants (Sascha)
* Fixed flushing of cached information to disk in DBA's DB2 module (Sascha)
* Fixed is_writeable/is_writable problem; they are both defined now (Andrei)
* Fixed thread-safety issues in the MySQL module (Zeev)
* Fixed thread-safe support for dynamic modules (Zeev)
* Fixed Sybase CT build process (Zeev)



# 为了解决什么问题

* BUG
* 从PHP3.0过渡到PHP4.0的迭代维护

# 关键思路是什么

* 可扩展
  * 支持更多的数据库
* 可移植
  * 支持更多的操作系统 
* 关注关键问题
  * 内存泄露
  * 多线程安全