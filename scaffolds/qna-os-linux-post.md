---
title: {{ title }}
date: {{ date }}
categories:
  - 操作系统
  - Linux
tags:
  - 操作系统
  - Linux
  - Q&A
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