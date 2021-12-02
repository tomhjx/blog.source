---
title: TCP连接的半打开和半关闭
categories:
  - 开发
  - 网络
  - TCP
tags:
  - TCP
date: 2020-11-29 10:20:47
---

一、半开连接

        从协议定义的角度来说，TCP的半开连接是指TCP连接的一端异常崩溃，或者在未通知对端的情况下关闭连接，这种情况下不可以正常收发数据，否则会产生RST(后面内容我们在介绍RST)。比如一个常见的情况是TCP连接的一端异常断电，就会导致TCP的半开连接。如果没有数据传输，对端就不会知道本端的异常而一直处于ESTABLISHED状态(TCP有存活检测机制，后面内容我们会进行介绍)。

        另外从linux实现的角度来说，因为linux内部有个半连接队列，TCP半开连接是指发送了TCP连接请求，等待对方应答的状态，此时连接并没有完全建立起来,双方还无法进行通信交互的状态，此时就称为半连接。由于一个完整的TCP连接需要经过三次握手才能完成,这里把三次握手之前的连接都称之为半连接。

二、半关连接

TCP的半关连接是指TCP连接只有一方发送了FIN，另一方没有发出FIN包，仍然可以在一个方向上正常发送数据。这种场景并不常见，一般来说Berkeley sockets API调用shutdown()接口时候就会进入半关闭状态(调用常规的close()一般是期待完整的双向关闭这个TCP连接)，shutdown()接口相当指示程序，本端已经没有数据待发送，所以我发送一个FIN到对端，但是我仍然想要从对端接收数据，直到对端发送一个FIN指示关闭连接为止。如下图所示，在红色背景文本框标注的数据传输场景下就是TCP的半关连接

![](https://images2015.cnblogs.com/blog/740952/201611/740952-20161107133341092-1088495812.png)

三、wireshrk抓包示例

首先注意半开连接是不能正常传输数据的，而半关连接是可以在其中的一个方向上传输数据的。下面简单附一下wireshark的抓包图示，限于篇幅仅作简要介绍，详细请参考对应的wireshark抓包文件

1.TCP半开

通过单台笔记本的双无线网卡测试tcp连接的半开，步骤如下

*   server绑定网卡A的地址

*   client绑定网卡B的地址并连接server 对应截图中的No 1\-\-No 3包

*   client发送"hello"消息 对应截图中的No 4包

*   server正常接收到后"hello"消息后 拔掉网卡A

*   kill掉server进程 使server的FIN消息不能发送到client

*   插上网卡A  注意在路由器中绑定IP地址和MAC地址，使得网卡A的地址和之前是一致的,此时client和server即处于半开连接状态

*   client向server发送"world"消息   对应截图中的No 6包

*   server回复rst消息

[![](https://images2015.cnblogs.com/blog/740952/201611/740952-20161107133343795-1911242012.png)](http://images2015.cnblogs.com/blog/740952/201611/740952-20161107133343795-1911242012.png)

2.TCP半关

正常建立连接后，client首先发送"hello"消息给server，然后server发送FIN给client，关闭了server到client方向的数据传输，但是client仍然可以向server传输数据，此时client和server之间的连接即处于半关连接的状态，接下来client向server发送"world"消息，然后发送FIN给server关闭client到server方向的数据传输。

[![](https://images2015.cnblogs.com/blog/740952/201611/740952-20161107133348077-790799891.png)](http://images2015.cnblogs.com/blog/740952/201611/740952-20161107133348077-790799891.png)

补充说明：

1.目前linux最新的实现已经没有半连接队列了，连接请求的pseudo sock已经插入ehash(e代表establish，ehash即已连接hash队列)中了  详情https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/ipv4/?id=079096f103faca2dd87342cca6f23d4b34da8871&context=3&ignorews=0&dt=1