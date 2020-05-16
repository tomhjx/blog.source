---
title: 关于我的一些东西
comments: false
---

联系我
----

* 电子邮箱 
> tom_hejiaxi@163.com

过去
----

* 2020
    * 使用[nginx proxy cache](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache)在K8S上部署CDN节点
    * [K8S HPA](https://kubernetes.io/zh/docs/tasks/run-application/horizontal-pod-autoscale/)
    * 通过[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)组合命令完成K8S资源分配调整
    * 调研钉钉项目管理功能
    * 通过[石墨文档](https://shimo.im/sheets/PrDWgkwcGRYJdpTx/AGQY4)落地项目管理（进度跟踪，项目会议，成本统计）
    * [nginx rsyslog](https://github.com/xgoteam/docker/tree/master/openresty/1.13.6.2-rsyslog-centos7)结合[阿里云日志服务SLS](https://help.aliyun.com/document_detail/48932.html?spm=5176.10695662.1996646101.searchclickresult.49652c5a08LNAS)统一nginx日志管理
    * [基于golang与shell实现简单的网络探针](https://github.com/tomhjx/network-probe)
    * 为降成本，放弃ucloud罗马网络，改为自建vpn，打通阿里云（德国法兰克福）与ucloud（非洲拉各斯）内网
    * 降低成本，放弃阿里云rocketmq，自建rabbitmq集群
    * 分片离线计算，在低成本的背景下，为sitemap内容生成提速

* 2019
    * 参与[猫池搭建与调研](https://www.tapd.cn/55258546/documents/show/1155258546001000615?file_type=word#target:toc1)
    * 调研cloudflare Quick协议支持情况，与谷歌浏览器支持的版本不一致
    * 测试环境上k8s
    * k8s的fpm服务上[容器探针](https://kubernetes.io/zh/docs/concepts/workloads/pods/pod-lifecycle/#%E5%AE%B9%E5%99%A8%E6%8E%A2%E9%92%88)
    * 精简与统一团队git flow流程
    * 统一项目交付方案，组织整个研发团队落地实施（需求规范，需求评审，项目早会，项目排期，进度跟踪，技术方案评审）
    * 整合技术方案规范
    * jenkins+gitlab部署ci/cd
    * 通过ucloud[罗马网络](https://www.ucloud.cn/site/product/rome.html)，打通阿里云（德国法兰克福）与ucloud（非洲拉各斯）内网
    * 阿里云对象存储（德国法兰克福）[镜像回源](https://help.aliyun.com/document_detail/31865.html?spm=a2c4g.11186623.2.22.50c87222oVtN3W#concept-n34-q1z-5db)+ ucloud对象存储（非洲拉各斯）实现图片上传边缘化，提高上传网络质量
    * 接入非洲支付[Paystack](https://paystack.com/)
    * 接入海外支付[Flutterwave](https://flutterwave.com/us/)
    * 接入海外支付[PayPal](https://www.paypal.com/c2/webapps/mpp/merchant)
    * 参与海外信息分类项目（搜索、支付、分类管理、数据采集）
    * 接入[cloudflare](ttps://www.cloudflare.com)，使用cdn、https
    * 调研边缘机房，通过[路由分析工具](https://www.ipip.net/)做[非洲网络测试](https://shimo.im/sheets/xH1PswEmO9UxEmfI/esmoi)，ucloud有优势
    * Firebase没有非洲节点，链路时延过长且无法优化，通过socket io自建socket服务实现心跳、聊天、轨迹跟踪功能
    * 调研[CRM SAAS](https://www.fxiaoke.com/)
    * 对接[Firebase](https://firebase.google.com/)，实现司机心跳保活、出行轨迹跟踪，app推送
    * [基于PostgreSQL‎实现电子围栏](https://yq.aliyun.com/articles/700357)
    * 谷歌地图缺失非洲地区的详细街道，并且没有摩托路线，需要基于[openstreetmap](https://www.openstreetmap.org/#map=3/26.35/96.50)自建地图
    * 调研海外语音验证码，nexmo支持，但价格昂贵，质量不稳定
    * 调研海外虚拟拨号, nexmo支持，但价格昂贵
    * 对接非洲短信
        * 调研支持非洲短信的服务商，nexmo、paasoo、africasTalking、InfoBip、创蓝，[对比测试](https://shimo.im/docs/Gj8qdHdhPw3vdghr)
        * 非洲当地移动运营商MTN、9mobile、Glo Mobile 、Airtel
        * 非洲手机普遍开通了 [Do Not Disturb](https://support.apple.com/en-us/HT204321)，导致短信送达率较低
    * 参与海外出行项目（路线计算，轨迹跟踪，司机抢单，乘客下单，运力调度）
    * 探索[TAPD](https://www.tapd.cn/)（需求跟踪，项目生命周期管理，任务管理，人力管理）
    * 消息队列选型（阿里云rocketmq，kafka，rabbitmq）
    * 海外ota，酒店搜索技术选型，lnmp+elasticsearch+redis+mongodb
    * 参与海外ota项目（酒店采集，酒店信息清洗，酒店搜索，订房）
    * 从技术岗转型管理岗

* 2018
    * 开发发版工具
    * 设计发版方案
    * 使用k8s部署生产环境
    * 补充本地环境的docker部署环境，一键搭建开发环境
    * 通过docker自建[gitlab](https://about.gitlab.com/)
    * 接入[腾讯短视频视频鉴黄](https://cloud.tencent.com/document/product/584/15536)
    * 接入[腾讯短视频](https://cloud.tencent.com/document/product/584)
    * [自研框架，供团队使用](https://github.com/tomhjx/sphp)
    * 浅尝[laravel](https://laravel.com/)PHP框架
    * symfony+[capifony](https://everzet.github.io/capifony/)部署生产环境
    * 使用[symfony](https://symfony.com/)PHP框架
    * 使用docker部署本地环境
    * 维护[socket io](https://socket.io/)搭建的nodejs聊天系统
    * 接盘二次元社区（好友关注，聊天，短视频，发帖）