---
title: 解决 Mac 升级为 Big Sur 系统后 Homebrew 命令失效的问题
categories:
  - 运维
  - 操作系统
  - Mac
tags:
  - 操作系统
  - Mac
  - Q&A
date: 2021-07-24 22:53:20
---
## Question

现象：

```
$ brew list

Traceback (most recent call last):
	11: from /usr/local/Homebrew/Library/Homebrew/brew.rb:23:in `<main>'
	10: from /usr/local/Homebrew/Library/Homebrew/brew.rb:23:in `require_relative'
	 9: from /usr/local/Homebrew/Library/Homebrew/global.rb:37:in `<top (required)>'
	 8: from /usr/local/Homebrew/Library/Homebrew/vendor/portable-ruby/2.6.3/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
	 7: from /usr/local/Homebrew/Library/Homebrew/vendor/portable-ruby/2.6.3/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
	 6: from /usr/local/Homebrew/Library/Homebrew/os.rb:3:in `<top (required)>'
	 5: from /usr/local/Homebrew/Library/Homebrew/os.rb:21:in `<module:OS>'
	 4: from /usr/local/Homebrew/Library/Homebrew/os/mac.rb:58:in `prerelease?'
	 3: from /usr/local/Homebrew/Library/Homebrew/os/mac.rb:24:in `version'
	 2: from /usr/local/Homebrew/Library/Homebrew/os/mac.rb:24:in `new'
	 1: from /usr/local/Homebrew/Library/Homebrew/os/mac/version.rb:26:in `initialize'
/usr/local/Homebrew/Library/Homebrew/version.rb:368:in `initialize': Version value must be a string; got a NilClass () (TypeError)

```


## Answer

```
brew update-reset

```