---
title: qiankun 集成
layout: post
date: 2020-12-04 15:39:29
categories: Project Base
tags: Project Base
---

> [qiankun（乾坤）](https://qiankun.umijs.org/zh) 是一个基于 single-spa 的微前端实现库，旨在帮助大家能更简单、无痛的构建一个生产可用微前端架构系统。

开发环境下，集成 qiankun 比较简单，常规项目也没什么问题。但是我们的项目有些特殊性，主要原因是使用了已经打完包的技术平台，技术平台中有授权校验，又使用了 cesium 地图相关的功能。

生产环境部署还没测！！！

## 特殊包 mapv 的引用报错

业务平台，用户端使用了技术平台，后台端也使用了技术平台，火星科技引用的 mapv 包，在加载后会注册全局变量 window.L，内部对 L 有一些判断逻辑，进入用户端时 L 已经被注册了，再进入后台端，L 已经存在，导致 mapv 内部的判断逻辑会出错。解决方案如下，在进入后台端前卸载 L 变量。

```js
registerMicroApps(
  [
    {
      name: 'vue',
      entry: '//localhost:1024',
      container: '#container',
      activeRule: genActiveRule('/cms'),
    },
  ],
  {
    beforeLoad: () => {
      window.L = undefined;
    },
  }
);
```

## 请求静态资源报错

src/assets 下的资源，或者通过 import 加载的 static 下的静态资源，都会经过打包编译，是没有问题的。但是直接引用 static 下的资源路径，就会找不到。解决办法是在这些直接引用的静态资源前面添加 `window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__` 变量。

## cesium CESIUM_BASE_URL 变量

因为 cesium 是被技术平台引用的，经过打包后被业务平台引用的，cesium 的 CESIUM_BASE_URL 变量的定义是在技术平台中定义的，也需要定义成动态的值才能在经过 qiankun 引用时找到。

```js
'CESIUM_BASE_URL': 'window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__ + "/static/cesium"',
```
