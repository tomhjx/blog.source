---
title: macos 升级 10.15.4 导致 git 无法拉取代码问题
categories:
  - 版本管理
  - GIT
tags:
  - GIT
date: 2020-03-29 23:51:44
---

今天发现 macos 推送了最新版本 10.15.4

逐马上更新了系统，但是更新系统以后发现一个玄学问题。

公司自建的 git 仓库无法拉取代码，执行 git pull 一直在等待毫无反应。

由于我的 git 一直使用的是 ssh 协议拉取，尝试过更新 Iterm2,git 均未解决。

开始是怀疑由于我本机是否有一些全局代理导致的问题，但是尝试过其他 github，gitee 等公有仓库均可以正常拉取代码。

后来看到 V2ex 上一片帖子也有人遇到跟我一样的问题

是我本机的 V2ray 开启了 pac 模式，导致了这一问题出现。

解决方案，执行以下命令：

```
brew install openssh
```