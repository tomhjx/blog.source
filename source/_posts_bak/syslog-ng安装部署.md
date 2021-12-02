---
title: syslog-ng安装部署
categories:
  - 日志工具
  - syslog-ng
tags:
  - syslog-ng
date: 2016-10-22 11:35:08
---


环境
===

> 日志客户端机

ip   : 192.168.1.120

系统 : CentOS Linux release 7.1.1503 (Core)

> 日志服务端机

ip   : 192.168.1.121

系统 : CentOS Linux release 7.1.1503 (Core)


安装
===

> 参考资料

https://syslog-ng.gitbooks.io/getting-started/content/

http://www.sa-log.com/101.html


> 执行安装

```

wget http://www.balabit.com/downloads/files/syslog-ng/sources/3.2.4/source/eventlog_0.2.12.tar.gz

tar xvf eventlog_0.2.12.tar.gz

cd eventlog-0.2.12

./configure --prefix=/usr/local/eventlog && make && make install

```


syslog-ng的包可以在这找到

https://github.com/balabit/syslog-ng/releases/


```

yum -y install glib2-devel json-c-devel

wget https://github.com/balabit/syslog-ng/releases/download/syslog-ng-3.8.1/syslog-ng-3.8.1.tar.gz

tar xvf syslog-ng-3.8.1.tar.gz

cd syslog-ng-3.8.1

export PKG_CONFIG_PATH=/usr/local/eventlog/lib/pkgconfig

./configure --prefix=/usr/local/syslog-ng --enable-json && make&& make install


cp ./contrib/rhel-packaging/syslog-ng.init /etc/init.d/syslog-ng

chmod +x /etc/init.d/syslog-ng



```


> 启动


```
/etc/init.d/syslog-ng start

```

或


```
/usr/local/syslog-ng/sbin/syslog-ng

```



安装遇到的问题
===

> 安装syslog-ng时，编译报错：configure: error: Package requirements (glib-2.0 >= 2.10.1 gmodule-2.0 gthread-2.0) were not met



```
yum -y install glib2-devel

```

> 启动syslog-ng失败，报错：template: $(format-json)


```
yum -y install json-c-devel


cd syslog-ng-3.8.1

export PKG_CONFIG_PATH=/usr/local/eventlog/lib/pkgconfig

./configure --prefix=/usr/local/syslog-ng --enable-json && make&& make install

```

> 启动syslog-ng报错：Error opening plugin module; module='mod-java', error='libjvm.so: cannot open shared object file: No such file or directory'



```

find /usr -name libjvm.so

```

找到该文件

```
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.65-2.b17.el7_1.x86_64/jre/lib/amd64/server/libjvm.so

```

做软链，目的要让libjvm.so可以访问到

```

export LD_LIBRARY_PATH=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.65-2.b17.el7_1.x86_64/jre/lib/amd64/server:$LD_LIBRARY_PATH

```







配置
===

> 在192.168.1.121上构建日志中心，192.168.1.120落地本地日志并上报到日志中心

```
ssh -p22 root@192.168.1.120

```


```

vi /usr/local/syslog-ng/etc/syslog-ng.conf

```


```
@version: 3.8
@include "scl.conf"

options {
        log_msg_size(16384);
        flush_lines(1);
        log_fifo_size(1000000);
        time_reopen(10);
        use_dns(no);
        dns_cache(yes);
        use_fqdn(yes);
        keep_hostname(yes);
        chain_hostnames(no);
        check_hostname(yes);
        create_dirs(yes);
        dir_perm(0755);
        perm(0644);
        stats_freq(1800);
    threaded(yes);
};

source s_local {
    #standard Linux log source (this is the default place for the syslog()
# function to send logs to)
    unix-stream("/dev/log" max-connections(10240) log_iw_size(1024000));
# messages from the kernel
    file("/proc/kmsg" program_override("kernel"));
};

## project logs

destination d_remote_local6 {tcp('192.168.1.121' port(5124));};
destination d_remote_back_all {file("/var/log/projlogs/$PROGRAM/$YEAR$MONTH/$DAY/$HOUR" perm(0644) dir_perm(0755) create_dirs(yes) );};
filter f_remote_log_all { facility(local6) and match("/" value("PROGRAM"));};

log {
    source(s_local);
    filter(f_remote_log_all);
    destination(d_remote_back_all);
    destination(d_remote_local6);
};


```


```
ssh -p22 root@192.168.1.121

```

```

vi /usr/local/syslog-ng/etc/syslog-ng.conf

```

```

@version: 3.8
@include "scl.conf"

options {
        flush_lines (0);
        time_reopen (10);
        log_fifo_size (1000);
        chain_hostnames (off);
        use_dns (no);
        use_fqdn (no);
        create_dirs (yes);
        keep_hostname (no);
};


source src_projlog {
    tcp(ip("192.168.1.121") port(5124));
};
                                                         
                                                        
filter f_remote_log_all {facility(local6) and match("/" value("PROGRAM"));}; 
                                                         
destination dst_projlog {
    file("/var/log/center_projlogs/$PROGRAM/$YEAR$MONTH/$DAY/$HOUR" perm(0644) dir_perm(0755) create_dirs(yes));
};
                                                         
                                                         
log {
    source(src_projlog);
    filter(f_remote_log_all);
    destination(dst_projlog);
};


```




> 在192.168.1.121上构建日志中心，192.168.1.120不落地本地日志，只上报到日志中心

```
ssh -p22 root@192.168.1.120

```


```

vi /usr/local/syslog-ng/etc/syslog-ng.conf

```


```
@version: 3.8
@include "scl.conf"

options {
        log_msg_size(16384);
        flush_lines(1);
        log_fifo_size(1000000);
        time_reopen(10);
        use_dns(no);
        dns_cache(yes);
        use_fqdn(yes);
        keep_hostname(yes);
        chain_hostnames(no);
        check_hostname(yes);
        create_dirs(yes);
        dir_perm(0755);
        perm(0644);
        stats_freq(1800);
    threaded(yes);
};

source s_local {
    #standard Linux log source (this is the default place for the syslog()
# function to send logs to)
    unix-stream("/dev/log" max-connections(10240) log_iw_size(1024000));
# messages from the kernel
    file("/proc/kmsg" program_override("kernel"));
};

## project logs

destination d_remote_local6 {tcp('192.168.1.121' port(5124));};
filter f_remote_log_all { facility(local6) and match("/" value("PROGRAM"));};

log {
    source(s_local);
    filter(f_remote_log_all);
    destination(d_remote_local6);
};


```


```
ssh -p22 root@192.168.1.121

```

```

vi /usr/local/syslog-ng/etc/syslog-ng.conf

```

```

@version: 3.8
@include "scl.conf"

options {
        flush_lines (0);
        time_reopen (10);
        log_fifo_size (1000);
        chain_hostnames (off);
        use_dns (no);
        use_fqdn (no);
        create_dirs (yes);
        keep_hostname (no);
};


source src_projlog {
    tcp(ip("192.168.1.121") port(5124));
};
                                                         
                                                        
filter f_remote_log_all {facility(local6) and match("/" value("PROGRAM"));}; 
                                                         
destination dst_projlog {
    file("/var/log/center_projlogs/$PROGRAM/$YEAR$MONTH/$DAY/$HOUR" perm(0644) dir_perm(0755) create_dirs(yes));
};
                                                         
                                                         
log {
    source(src_projlog);
    filter(f_remote_log_all);
    destination(dst_projlog);
};


```



