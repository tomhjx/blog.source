---
title: 在linux上为什么内存使用率过高?
categories:
  - 系统
  - Linux
tags:
  - Linux
  - 内存
  - 排障
date: 2020-07-04 17:39:16
---

## 常用排障命令

* 使用ps命令找出占用内存资源最多的20个进程（数量可以任意设置）

```bash
ps aux | head -1;ps aux |grep -v PID |sort -rn -k +4 | head -20

```


* 使用 top , 按命令分组，查找内存消耗最大的前20[在这里可以了解到top的输出方式](https://www.2daygeek.com/understanding-linux-top-command-output-usage/)

```bash

top -b -n 1|tail -n +8| awk '{ sum[$12]+=($6-$7) } END { for(i in sum) {print i,sum[i]/1024}}'|sort -rn -k +2|head -20

```

## 参考资料

* [查看 Linux 系统中进程和用户的内存使用情况](https://juejin.im/post/5e3c13dbf265da576f52f706)
* [linux下查询进程占用的内存方法总结](https://segmentfault.com/a/1190000004147558)

