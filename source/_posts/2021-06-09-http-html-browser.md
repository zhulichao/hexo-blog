---
title: Web 基础
layout: post
date: 2021-06-09 09:34:24
categories: FJ
tags: FJ
---

## click 在 ios 上有 300ms 延迟，原因及如何解决

问题：双击缩放(double tap to zoom)，是会有 300 毫秒延迟的主要原因。当用户一次点击屏幕之后，浏览器并不能立刻判断用户是要进行双击缩放，还是想要进行单击操作。因此，iOS Safari 就等待 300 毫秒，以判断用户是否再次点击了屏幕。

解决方案：

- 使用 [FastClick](https://github.com/ftlabs/fastclick) 库，FastClick 在检测到 touchend 事件的时候，会通过 DOM 自定义事件立即触发一个模拟click 事件的click事件（自定义事件），并把浏览器在 300 毫秒之后真正触发的 click 事件阻止掉。
- 禁用缩放。`<meta name="viewport" content="width=device-width,user-scalable=no">`

## 缓存

强缓存：从缓存取，状态码为 200，不发送请求到服务器。相关字段 expires、cache-control，cache-control 优先级高

协商缓存：从缓存取，状态码为 304，发送请求到服务器。相关字段 Last-Modified/If-Modified-Since，Etag/If-None-Match

[HTTP强缓存和协商缓存](https://segmentfault.com/a/1190000008956069)

## 前端优化

- 减少 HTTP 请求数量
- minify / gzip 压缩
- lazyLoad
- 预解析 DNS
- 使用 CDN
- 缓存
- 加载顺序优化
- 服务端渲染

## 输入 URL 到页面至加载显示完成，发生了什么?

- DNS 解析：浏览器缓存 -> 系统缓存 -> 路由器缓存 -> hosts 文件 -> DNS 服务器，得到服务器的 ip 地址
- TCP 连接
- 发送 HTTP 请求
- 服务器处理请求并返回 HTTP 报文
- 浏览器解析渲染页面：构建 DOM 树，在 DOM 树的构建过程中如果遇到 JS 脚本和外部 JS 连接，则会停止构建 DOM 树来执行和下载相应的代码，这会造成阻塞，这就是为什么推荐 JS 代码应该放在 html 代码的后面；构建 CSSOM 树；合并为渲染树，渲染页面；解析 DOM 过程中如果遇到图片、视频、音频等资源，会并行下载
- 连接结束

## 什么时候用 304？

如果客户端发送了一个带条件的 GET 请求且该请求已被允许，而文档的内容（自上次访问以来或者根据请求的条件）并没有改变，则服务器应当返回这个 304 状态码。

## link 标签和 import 标签的区别

- link 属于 html 标签，因此没有兼容性，而@import 是 css 提供的，只有 IE5 以上才能识别
- link 方式样式的权重高于 @import 的
- 页面被加载时，link 会同时被加载，而@import 引用的 css 会等到页面加载结束后加载
