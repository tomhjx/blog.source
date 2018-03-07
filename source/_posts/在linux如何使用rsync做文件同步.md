---
title: 在linux如何使用rsync做文件同步
categories:
  - 系统
  - Linux
tags:
  - Linux
date: 2016-10-16 13:02:33
---


###配置

http://blog.csdn.net/chen978616649/article/details/42581843

###使用


远程将10.1.0.37上的文件同步到本地

```
rsync -aq --max-size=100m  10.1.0.37::logs/server/livelocation/2016-10-12.log /home/www/livelocation_10.1.0.37/2016-10-12.log

```



###参考资料

http://man.linuxde.net/rsync