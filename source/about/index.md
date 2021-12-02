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

* 2010
    * 加入[新传媒集团](https://www.nmg.com.hk/)
        * 担任后端开发，负责业务迭代
* 2014
    * 加入[腾讯音乐娱乐](https://baike.baidu.com/item/%E9%85%B7%E7%8B%97%E9%9F%B3%E4%B9%90/2710730)
        * 担任后端开发，负责业务迭代

    * 业务体量渐大，须要提高系统关键模块的稳定性，实施核心资源的物理隔离
        * MySQL数据库读写分离
        * 基于业务级别对MySQL数据库实例实施粗粒度的拆分隔离
        * 基于业务级别对Redis、Memcache缓存实施粗粒度的拆分隔离

    * 业务遭遇大面积的DDOS攻击，页面、接口接入CDN

    * 为解决分布式应用日志查询问题，基于PHP、MySQL自建了一套日志中心

* 2015

    * 直播业务用户体系需要并入主系统，需要支持两个用户ID的互换
        * 每处使用到用户ID的地方，都冗余存储两个ID
        * 后期维护困难，将转换逻辑下沉为服务

    * 部分关键业务模块历史包袱太重，性能越来越差，维护迭代困难
        * 重新思考业务对一致性的要求，引入NSQ消息队列，对非强一致业务实施异步化改造，出现了对分布式事务的思考
        * 得益于消息队列，系统可从物理（部署）角度实现更小粒度的模块化拆分，实现解耦
        * 对垂直“大”逻辑实施拆分并行化，通过消息队列的广播机制，从物理（部署）角度实现隔离、解耦、可并行

    * 公司原本的灰度方案是基于nginx的配置硬编码来实现流量控制，但长期累加的规则难以维护，须要更灵活可控的手段来支持灰度发布的需求
        * 基于[Openresty](https://openresty.org/cn/)实现动态控制流量切换规则
        * 基于PHP、MySQL实现灰度规则管理系统

    * 手机端业务激涨，突发流量容易拉垮服务，并且也影响了网站端业务
        * 核心业务独立部署
        * 网关基于[Nginx模块实现限流](https://www.nginx.com/blog/rate-limiting-nginx/)


    * 业务体量渐大，单体应用难以维护迭代，须要深化治理问题（重点在于解耦、隔离），开始探索SOA服务化
        * 以数据实体划分服务，基于数据库表的相关性1比1打包服务
        * 基于Thrift RPC框架实现服务通讯
        * 基于“对数据库的调用”改为“对服务的调用”的思想，改造业务逻辑
            * 收口，下沉封装关键调用逻辑
            * 读不变，双写
            * 引入开关切换逻辑
            * 验证新旧服务的数据及逻辑一致性
            * 灰度切读
            * 弃旧写
        * 考虑对代码低侵入，基于PHP扩展接入CAT监控
        * 打通企业微信、RTX告警
        * 接入[apollo](https://github.com/apolloconfig/apollo)配置中心

    * 基于PHP实现的业务聚合层撑高并发的成本较大，探索更优的实现方案
        * 基于[Swoole](https://www.swoole.com/)实现Apollo Agent
        * 可静态化的页面类业务，采取NodeJS的服务端渲染实现
        * 广告导流类依赖服务，逻辑简单，更多的是单纯对服务的聚合，采取Openresty来实现
        * 房间本场排行榜，业务逻辑较复杂，采取Openresty、[GoLang](https://go.dev/)来分模块实现
        * 实践下来，异构的代价是团队维护成本巨大，难以招到合适的人来持续维护技术栈，后期转向统一转型为JAVA

    * 使用了CDN，但是没法防住高并发时的流量穿透，造成高负荷或服务不可用
        * 基于[nginx proxy cache](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache)实现边缘缓存、旧缓存兜底支持服务尽可能可用

* 2016

    * 原有的业务日志中心方案性能低下，且难以维护
        * 基于[syslog ng](https://www.syslog-ng.com/)简化日志中心方案，提供一台作为服务端的物理机给研发自主查日志

    * 基于linux shell的查日志方式，使用门槛高，且日志中心机存在单点风险、成本高
        * 接入[ELK](https://www.elastic.co/cn/what-is/elk-stack)

    * 广告导流业务流量巨大，开了nginx的访问日志后，磁盘IO压力引起了机器的高负载，导致服务不可用
        * nginx的日志改为不落盘，通过[syslog ng](https://www.syslog-ng.com/)异步远程记录日志，提高单机吞吐
        * 基于nginx实现限流

    * SOA服务化后，存在以下问题
        * 单一业务模块更不稳定，很大的原因在一RPC调用过多，这与业务期望不一致
        * 在单一业务模块中引入了更多的跨团队协作
        * 提供服务的人不了解业务，仅仅只是提供面向数据库的CRUD接口，没法合理地解决业务问题
        * 从设计上而言，只是增加了服务级数据访问层

    * 基于SOA服务化的落地，反思遗留的问题，开始探索面向业务的微服务化
        * 选取急迫需要治理的业务模块，面向业务领域抽象服务
        * 引入服务网关，网关基于路由转发到不同的微服务，由网关按业务模块（礼物、房间、用户等）对外提供能力

    * 消费业务在早期设计时没通过事务保证数据一致性，量上来后，数据故障频发
        * 消费业务拆分关键逻辑，下沉资产服务
        * 基于订单模型设计服务，引入对账，实现最终一致

    * 公司产品定型，业务迭代慢了下来，整体进入了高可用治理阶段
        * 接入APM用户体验监控
        * 基于[Riak](https://riak.com/)、[Elasticsearch](https://www.elastic.co/cn/)搭建高可用的NoSQL，提供给部分对高可用有要求且对数据一致性不敏感的业务使用
        * 集中治理核心业务，核心业务服务拆分隔离
        * 定义关键逻辑，落地降级方案
        * MySQL通过[MHA](https://code.google.com/archive/p/mysql-master-ha/)方案实现高可用
 
* 2017

    * 资产服务迁移，在切换过程中使用了MySQL的主主同步方案，主键冲突导致了数据故障

    * 机房割接
        * 与运维核对执行计划
        * 总结行为清单
        * 提供可复用的验收手段
        * 提供应急方案

    * 频繁的机房割接，暴露了业务的脆弱性（缺乏容错，对网络故障敏感）

    * 公司产品定型，业务迭代慢了下来，整体进入了高可用治理阶段
        * 通过[Otter](https://github.com/alibaba/otter)实现用户数据的异地机房数据同步
        * ID转换服务基于去中心优化方案
        * 送礼实现异地灾备
        * 房间榜单实现异地灾备
        * 进房实现异地灾备
        * 礼物列表实现异地双活
        * 容灾演练

* 2018
    * 加入[银时科技](https://baike.baidu.com/item/%E5%B9%BF%E5%B7%9E%E9%93%B6%E6%97%B6%E4%BF%A1%E6%81%AF%E7%A7%91%E6%8A%80%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/19962900)
        * 担任后端开发，负责业务迭代
        * 担任运维开发，负责系统日常运维
    * 参与二次元社区项目（好友关注，聊天，短视频，发帖）
        * 基于[symfony](https://symfony.com/)PHP框架开发
        * 使用[capifony](https://everzet.github.io/capifony/)部署生产环境
        * 基于[socket io](https://socket.io/)搭建的nodejs聊天系统
    * 互联网进入短视频热潮，开始引入短视频模块
        * 接入[腾讯短视频](https://cloud.tencent.com/document/product/584)
        * 接入[腾讯短视频视频鉴黄](https://cloud.tencent.com/document/product/584/15536)
    * 线下环境是传统本地安装的方式，不便于移植跟维护，因此改为了使用docker部署
    * 加入[嗨逸](https://baike.baidu.com/item/%E5%B9%BF%E5%B7%9E%E5%97%A8%E9%80%B8%E9%85%92%E5%BA%97%E7%AE%A1%E7%90%86%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8/52296392)
        * 担任后端主管，负责管理后端团队，参与业务迭代
        * 担任运维开发，负责系统日常运维
    * 从技术岗转型管理岗
    * 从0到1搭建研发体系
        * 通过docker自建[gitlab](https://about.gitlab.com/)
        * 了解[laravel](https://laravel.com/)PHP框架，借鉴核心思想 [自研框架，供团队使用](https://github.com/tomhjx/sphp)
        * 了解阿里云
        * 使用docker部署本地环境
        * 使用[Kubernetes](https://www.aliyun.com/product/kubernetes?spm=5176.19720258.J_8058803260.119.e9392c4as2Hf5O)部署生产环境
        * 开发发版工具

* 2019
    * 团队规模及项目量都在增加，效率慢了下来，需要引入项目管理工具来提效
       * 探索[TAPD](https://www.tapd.cn/)（需求跟踪，项目生命周期管理，任务管理，人力管理）
    * 参与海外ota项目（酒店采集，酒店信息清洗，酒店搜索，订房）
        * 酒店搜索技术选型，lnmp+elasticsearch+redis+mongodb
        * 消息队列选型（阿里云rocketmq，kafka，rabbitmq）
    * 加入[迈步科技](https://www.linkedin.com/company/%E8%BF%88%E6%AD%A5%E7%A7%91%E6%8A%80/)
        * 担任后端主管，负责管理后端团队，参与业务迭代
        * 担任运维主管，负责管理运维团队，参与系统日常运维
    * 从0到1搭建研发体系
    * 搭建猫池
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

* 2020
    * 通过[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)组合命令完成K8S资源分配调整
    * 调研并试用钉钉项目管理功能
    * 利用石墨文档落地项目管理（进度跟踪，项目会议，成本统计）
    * [nginx rsyslog](https://github.com/xgoteam/docker/tree/master/openresty/1.13.6.2-rsyslog-centos7)结合[阿里云日志服务SLS](https://help.aliyun.com/document_detail/48932.html?spm=5176.10695662.1996646101.searchclickresult.49652c5a08LNAS)统一nginx日志管理
    * [基于golang与shell实现简单的网络探针](https://github.com/tomhjx/network-probe)
    * 降本
        * 放弃ucloud罗马网络，改为自建vpn，打通阿里云（德国法兰克福）与ucloud（非洲拉各斯）内网
        * 放弃阿里云rocketmq，自建rabbitmq集群
    * SEO优化
        * 根据[PageSpeed Insights](https://pagespeed.web.dev/)的跑分来调优
        * 使用[nginx proxy cache](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache)在K8S上部署CDN节点，通过边缘缓存的方案来提升页面的访问速度
        * 使用[K8S HPA](https://kubernetes.io/zh/docs/tasks/run-application/horizontal-pod-autoscale/)，提升系统稳定性，提高谷歌蜘蛛的抓取频率跟规模
        * 通过离线分布式计算，在低成本的背景下，预生成sitemap内容，提供核心内容的访问速度
    * 加入[豌豆思维](https://baike.baidu.com/item/%E8%B1%8C%E8%B1%86%E6%80%9D%E7%BB%B4/23465748)
        * 担任营销平台业务小组技术负责人及架构师，负责业务后端小组的管理，参与基础建设的方案制定及执行
        * 加入公司后端专业委员会，担任职级评定评审委员，参与制定及推广执行专业线规范
    * 提高团队交付项目的效率及质量
        * 优化研发流程
        * 补充技术方案执行规范
        * 引入业务链路跟踪方案
    * 提高核心业务稳定性及可扩展性
        * 重构核心业务系统
        * 优化营销平台基建架构
* 2021
    * 腾讯云经典基础网络将下架，须要以VPC网络取代
        * 与运维对接沟通VPC网络迁移需求
        * 基于业务链路覆盖，补充优化VPC网络迁移方案
        * 配合总目标，带领团队按计划落地方案
    * 参与拓科项目
        * 辅助团队梳理业务链路，拆解核心依赖
        * 制定灰度方案
