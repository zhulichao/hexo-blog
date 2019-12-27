---
title: PWA
layout: post
date: 2019-12-11 15:59:48
categories: 前端知识
tags: 前端知识
---

## PWA

PWA 就是渐进式 web 应用(Progressive Web App)。早在2016年初，Google 便提出 PWA，希望提供更强大的 web 体验，引导开发者回归开放互联网。它弥补了 web 对比 Native App 急缺的几个能力，比如离线使用、后台加载、添加到主屏和消息推送等，同时它还具备了小程序标榜的“无需安装、用完即走”的特性。目的就是在移动端利用提供的标准化框架，在网页应用中实现和原生应用相近的用户体验的渐进式网页应用。虽然 PWA 技术已经被 W3C 列为标准，但是其落地情况一直以来是很让人失望的，始终受到苹果的阻碍，最重要的原因在于 PWA 绕过 Apple Store 审核，直接推给用户。

如 [Vue.js 官网](https://cn.vuejs.org/) [React 官网](https://react.docschina.org/)

### 特点

- 可靠的——即时加载，即使在不确定的网络条件下也不会受到影响
- 快速的——快速响应用，用平滑的动画和滚动快速响应用户交互
- 迷人的——感觉就像设备上的原生应用程序，具有沉浸式的用户体验

### 核心技术

- Web App Manifest
- Service Worker
- Cache API
- Push & Notification
- App Shell & App Skeleton
- Background Sync

## Web App Manifest

实现添加至主屏。Web应用程序中，可以通过 manifest.json 控制应用程序的显示方式和启动方式，指定主屏幕图标、启动应用程序时要加载的页面、屏幕方向，甚至可以指定是否显示浏览器 Chrome。[Manifest 参考文档](https://developer.mozilla.org/zh-CN/docs/Web/Manifest)

## Service Worker

实现离线缓存。由于 JavaScript 是单线程的，随着 web 业务的复杂化，开发者逐渐在 js 中做了许多耗费资源的运算过程，这使得单线程的弊端更加凹显。web worker 正是基于此被创造出来，它是脱离在主线程之外的，我们可以将复杂耗费时间的事情交给 web worker 来做。但是 web worker 作为一个独立的线程，它的功能应当不仅于此。Service Worker 便是在 web worker 的基础上增加了离线缓存的能力。当然在 Service Worker 之前也有在 HTML5 上做离线缓存的 API 叫 AppCache, 但是 AppCache 存在很多缺点。[Service Worker 参考文档](https://developer.mozilla.org/zh-CN/docs/Web/API/Service_Worker_API/Using_Service_Workers) [GoogleChrome/workbox 库](https://github.com/GoogleChrome/workbox)

Service Worker 是由事件驱动的，具有生命周期，可以拦截处理页面的所有网络请求(fetch)，可以访问 cache 和 indexDB，支持推送，并且可以让开发者自己控制管理缓存的内容以及版本，为离线弱网环境下的 web 的运行提供了可能，让 web 在体验上更加贴近 native。

### 基本特征

- 不能操作页面 DOM，但可以通过事件机制来处理
- 事件驱动型服务线程
- 必须使用 HTTPS 和 localhost
- 运行于浏览器后台，不受页面刷新的影响，可以监听和截拦作用域范围内所有页面的 HTTP 请求
- 单独的作用域范围，单独的运行环境和执行线程，与主线程独立不会被阻塞
- 完全异步，无法使用 XHR 和 localStorage
- 一旦被 install，就永远存在，除非被 uninstall 或者 dev 模式手动删除
