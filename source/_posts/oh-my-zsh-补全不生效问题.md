---
title: oh my zsh 补全不生效问题
categories:
  - 操作系统
  - Linux
tags:
  - 操作系统
  - Linux
  - Q&A
date: 2020-04-04 15:15:27
---

## Question

安装了以下插件，但是自动补全没生效

~/.zshrc

```

plugins=(
  zsh-completions
  kubectl
  docker
  docker-compose
)

```

## Answer

```bash

rm -rf ~/.zcompdump*

```




