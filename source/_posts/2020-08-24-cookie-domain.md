---
title: Cookie 共享
layout: post
date: 2020-08-24 11:01:35
categories: JavaScript
tags: JavaScript
---

## cookie

- cookie 针对 IP，不区分端口
- 顶级域名只能设置 domain 为顶级域名，不能设置为二级域名或者三级域名等等
- 顶级域名设置的 cookie 可以共享给二级或三级域名，需要显示设置 domain 值

## 修改 host 文件

- `sudo vi /etc/hosts`

## Invalid Host Header

更改 localhost 域名为其它域名后，出现了 Invalid Host Header 错误，一通百度过后，发现是 webpack 对于 host 安全性鉴定造成的，解决方案是在 webpack.dev.conf.js 文件中的 devServer 配置对象中添加 disableHostCheck: true 这个属性，修改后就可正常访问了。
