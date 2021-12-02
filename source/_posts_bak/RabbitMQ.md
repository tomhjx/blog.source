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

## 消费的收发可靠性没有保障

[Consumer Acknowledgements and Publisher Confirms](https://www.rabbitmq.com/confirms.html)

## 其他

{% post_link AMQP协议 %}


# 存在什么问题？

## 消息有丢失的可能

A RabbitMQ node can lose persistent messages if it fails before said messages are written to disk. For instance, consider this scenario:

1.  a client publishes a persistent message to a durable queue
2.  a client consumes the message from the queue (noting that the message is persistent and the queue durable), but confirms are not active,
3.  the broker node fails and is restarted, and
4.  the client reconnects and starts consuming messages

At this point, the client could reasonably assume that the message will be delivered again. This is not the case: the restart has caused the broker to lose the message. In order to guarantee persistence, a client should use confirms. If the publisher's channel had been in confirm mode, the publisher would *not* have received an ack for the lost message (since the message hadn't been written to disk yet).



# 实践工具

* [RabbitMQ Simulator](http://tryrabbitmq.com/)