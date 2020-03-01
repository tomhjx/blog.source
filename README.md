
### 启动环境

[hexo 环境docker镜像](https://github.com/tomhjx/docker/tree/master/hexo/4.2.0.13-centos7)


```bash

docker-compose up -d

```

### 监听，即时预览效果

http://127.0.0.1:4000


### 创建新文章

docker-compose exec blog hexo new [layout] <title>

e.g

docker-compose exec blog hexo new memoir-post 定时器重启爱奇艺客户端

### 发布至git blog

```bash

docker-compose exec blog hexo generate -d

```

http://tomhjx.github.io/





### TODO

[ ] 谷歌浏览器工具，支持在网页上复制内容，选择或者新建标签、分类,一键生成blog文并发布，新增转载标签
[ ] 订阅热点文章，归档并发布blog文
[ ] 支持搜索
[ ] 开放评论

