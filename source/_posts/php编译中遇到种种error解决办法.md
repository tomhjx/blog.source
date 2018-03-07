---
title: php编译中遇到种种error解决办法
categories:
  - 编程语言
  - PHP
tags:
  - PHP
date: 2016-05-09 00:31:41
---

1) Configure: error: xml2-config not found. Please check your libxml2 installation.
Solutions :
Quote:
```
#yum install libxml2 libxml2-devel (For Redhat & Fedora)
# aptitude install libxml2-dev      (For ubuntu)

```
2) Checking for pkg-config… /usr/bin/pkg-config 
configure: error: Cannot find OpenSSL’s <evp.h>
Solutions :
Quote:

```
#yum install openssl openssl-devel
```

3) Configure: error: Please reinstall the BZip2 distribution
Solutions :
Quote:

```
# yum install bzip2 bzip2-devel
```

4) Configure: error: Please reinstall the libcurl distribution - 
easy.h should be in <curl-dir>/include/curl/
Solutions :
Quote:

```
# yum install curl curl-devel   (For Redhat & Fedora)
# install libcurl4-gnutls-dev    (For Ubuntu) 
```

5) Configure: error: libjpeg.(also) not found.
Solutions :
Quote:

```
# yum install libjpeg libjpeg-devel
```

6) Configure: error: libpng.(also) not found.
Solutions :
Quote:

```
# yum install libpng libpng-devel
```

7) Configure: error: freetype.h not found. 
Solutions :
Quote:

```
#yum install freetype-devel
```

8) Configure: error: Unable to locate gmp.h
Solutions :
Quote:

```
# yum install gmp-devel
```


9) Configure: error: Cannot find MySQL header files under /usr. 
Note that the MySQL client library is not bundled anymore!
Solutions :
Quote:

```
# yum install mysql-devel            (For Redhat & Fedora)
# apt-get install libmysql++-dev      (For Ubuntu) 
```


10) Configure: error: Please reinstall the ncurses distribution
Solutions :
Quote:

```
# yum install ncurses ncurses-devel
```

11) Checking for unixODBC support… configure: error: ODBC header file ‘/usr/include/sqlext.h’ not found!
Solutions :
Quote:

```
# yum install unixODBC-devel
```

12) Configure: error: Cannot find pspell
Solutions :
Quote:

```
# yum install pspell-devel
```

13) configure: error: mcrypt.h not found. Please reinstall libmcrypt.
Solutions :
Quote:

```
wget https://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz/download
mv download libmcrypt-2.5.8.tar.gz
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/usr/local/mcrypt
make
make install

```

14) Configure: error: snmp.h not found. Check your SNMP installation.
Solutions :
Quote:

```
# yum install net-snmp net-snmp-devel
```

15)configure: error: Please reinstall libmhash – I cannot find mhash.h

```
#yum install mhash-devel
```