---
title: RabbitMQ
categories:
  - 开发
  - 中间件
  - 消息队列
tags:
  - 消息队列
  - RabbitMQ
date: 2020-10-18 19:06:40
---

# 解决了什么问题？

## 缺乏并行化架构，单机上做并行化优化局限性大，难以扩容

* 提供构建并行化架构

## 流量突涨，系统不稳定

* 异步，前端服务资源先响应，后端服务资源可按需排队、可并行处理，削峰

## 系统耦合度高

* 通过中间件拆分隔离服务相互弱依赖的上下文

## 其他

{% post_link AMQP协议 %}


# 实践工具

* [RabbitMQ Simulator](http://tryrabbitmq.com/)