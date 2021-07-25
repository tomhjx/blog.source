---
title: git shallow clone是什么
categories:
  - 开发
  - 版本控制
  - GIT
tags:
  - GIT
date: 2021-07-25 00:14:48
---


随着Git仓库不断的被修改，整个仓库会变得越来越大，其中最主要的原因是历史提交特别的多，这个对于想立即阅读最新代码或者CI/CD场景下不是特别友好。

面对这种场景，可以利用git提供的浅克隆功能，只clone少部分历史到本地，这样可以极大的减少clone的仓库大小，以PHP源代码代码为例：

目前PHP源码有超过10万个提交，全部clone下来成本不小，如果只是想clone最新的N个提交，可以加上`--depth`参数：

```bash
# git clone https://github.com/php/php-src.git --depth=1 # 1可以换成任意深度，根据需要调整
Cloning into 'php-src'...
remote: Enumerating objects: 18674, done.
remote: Counting objects: 100% (18674/18674), done.
remote: Compressing objects: 100% (16621/16621), done.
remote: Total 18674 (delta 2656), reused 12214 (delta 1882), pack-reused 0
Receiving objects: 100% (18674/18674), 17.71 MiB | 1.25 MiB/s, done.
Resolving deltas: 100% (2656/2656), done.
Checking out files: 100% (18446/18446), done.

```

但是这样clone下来是没有分支信息的，如果需要看不同分支的代码：

```bash
# git remote set-branches origin PHP-7.3.8 # 如果需要全部的分支可以  git remote set-branches origin '*'
# git fetch --depth=1
remote: Enumerating objects: 13268, done.
remote: Counting objects: 100% (13266/13266), done.
remote: Compressing objects: 100% (6744/6744), done.
remote: Total 8549 (delta 5695), reused 4475 (delta 1792), pack-reused 0
Receiving objects: 100% (8549/8549), 6.49 MiB | 693.00 KiB/s, done.
Resolving deltas: 100% (5695/5695), completed with 3878 local objects.
From https://github.com/php/php-src
 * branch              master     -> FETCH_HEAD
 * [new branch]        PHP-7.3.8  -> origin/PHP-7.3.8
git remote set-branches origin 'PHP-7.3.8'
git fetch --depth=1
```

如果转换成常规克隆，需要使用`--unshallow`：

```bash
# git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
# git fetch --unshallow
remote: Enumerating objects: 800451, done.
remote: Counting objects: 100% (800446/800446), done.
remote: Compressing objects: 100% (172689/172689), done.
remote: Total 790672 (delta 630180), reused 777010 (delta 616884), pack-reused 0
Receiving objects: 100% (790672/790672), 334.08 MiB | 3.63 MiB/s, done.
Resolving deltas: 100% (630180/630180), completed with 8325 local objects.
From https://github.com/php/php-src
 * [new branch]        PEAR_1_4DEV                               -> origin/PEAR_1_4DEV
 * [new branch]        PECL                                      -> origin/PECL
 * [new branch]        PECL_4_3                                  -> origin/PECL_4_3
 * [new branch]        PECL_OPENSSL                              -> origin/PECL_OPENSSL
 * [new branch]        PHAR_1_2                                  -> origin/PHAR_1_2
 * [new branch]        PHP-4.0                                   -> origin/PHP-4.0
 * [new branch]        PHP-4.0.5                                 -> origin/PHP-4.0.5
 * [new branch]        PHP-4.0.6                                 -> origin/PHP-4.0.6
 * [new branch]        PHP-4.0.7                                 -> origin/PHP-4.0.7
 * [new branch]        PHP-4.2.0                                 -> origin/PHP-4.2.0
 * [new branch]        PHP-4.2.2                                 -> origin/PHP-4.2.2
 * [new branch]        PHP-4.3                                   -> origin/PHP-4.3
 ...
```