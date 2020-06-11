---
title: Rook Ceph部署
categories:
  - 存储
tags:
  - 存储
  - 云原生
date: 2020-06-11 23:21:58
---

# 版本

* rook v1.3

# 部署

## 前置

*  https://rook.io/docs/rook/v1.3/k8s-pre-reqs.html
*  添加空磁盘（不挂载）

## 部署

* https://rook.io/docs/rook/v1.3/ceph-quickstart.html


# 问题

## failed for volume pvc-... An operation with the givin Volume ID already exists

ceph 集群部署失败，需要检查部署环境是否完成前置条件
