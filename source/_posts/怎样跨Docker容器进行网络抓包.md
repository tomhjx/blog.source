---
title: 怎样跨Docker容器进行网络抓包
categories:
  - 运维
  - 虚拟化
  - docker
tags:
  - docker
  - Q&A
date: 2021-07-25 18:33:28
---

## Question

我把抓包工具都预安装到Docker容器里，该怎样去捕获其他Docker容器的网络包？


## Answer

```bash

docker run -it --rm --net container:<container_name> \
  nicolaka/netshoot tcpdump ...

```