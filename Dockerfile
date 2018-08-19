FROM centos:7
MAINTAINER "Tom" <tom_hejiaxi@163.com>

RUN yum install -y wget; \
    cd /etc/yum.repos.d/; \
    mv CentOS-Base.repo CentOS-Base.repo.backup; \
    wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo; \
    yum clean all && yum check-update; \
    yum makecache;

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN yum install -y \
    git-core

RUN curl -sL https://raw.github.com/creationix/nvm/master/install.sh | sh
ENV NVM_DIR="/root/.nvm"
ENV BLOG_DIR="/var/blog"
ENV NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/mirrors/node"
RUN \. $NVM_DIR/nvm.sh; \
    nvm install stable; \
    npm install -g hexo-cli; \
    hexo init ${BLOG_DIR}; \
    cd ${BLOG_DIR}; \
    npm install; \
    npm install hexo-server --save; \
    mkdir -p /usr/local/node; \
    ln -s ${NVM_BIN} /usr/local/node/bin

ENV PATH=$PATH:/usr/local/node/bin

WORKDIR $BLOG_DIR
CMD ["hexo", "server"]