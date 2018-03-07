---
title: Linux下如何查找某文件夹下最近1小时内修改过的文件
categories:
  - 系统
  - Linux
tags:
  - Linux
date: 2016-11-05 16:53:47
---

```

find /home/user -type f -cmin -60

```
