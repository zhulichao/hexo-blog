---
title: Fetch替代Ajax
layout: post
date: 2016-10-22 21:31:18
categories: JavaScript
tags: JavaScript
---

## Fetch出现原因

[传统 Ajax 已死，Fetch 永生](https://segmentfault.com/a/1190000003810652)  传统 Ajax 指的是 XMLHttpRequest（XHR）

XMLHttpRequest 是一个设计粗糙的 API，不符合关注分离（Separation of Concerns）的原则，配置和调用方式非常混乱，而且基于事件的异步模型写起来也没有现代的 Promise，generator/yield，async/await 友好。Fetch 的出现就是为了解决 XHR 的问题，它是替代XMLHttpRequest用来发送网络请求的非常新的API。由于目前大多数浏览器原生还不支持它，建议你使用 isomorphic-fetch 库。

使用async/await对fetch的使用进行优化后，写异步代码就像写同步代码一样爽。async/await是非常新的 API，属于 ES7。

Promise，generator/yield，await/async都是现在和未来JS解决异步的标准做法，可以完美搭配使用。另外，Fetch 也很适合做现在流行的同构应用。同构(isomorphic/universal)就是使前后端运行同一套代码的意思，后端一般是指 NodeJS 环境。

Fetch 优点主要有：
> 语法简洁，更加语义化  
> 基于标准 Promise 实现，支持 async/await  
> 同构方便，使用 isomorphic-fetch  

## 支持状况及解决方案

原生支持率并不高，幸运的是，引入下面这些 polyfill 后可以完美支持 IE8+ ：

> 由于 IE8 是 ES3，需要引入 ES5 的 polyfill: es5-shim, es5-sham  
> 引入 Promise 的 polyfill: es6-promise  
> 引入 fetch 探测库：fetch-detector  
> 引入 fetch 的 polyfill: fetch-ie8 
> 可选：如果你还使用了 jsonp，引入 fetch-jsonp  
> 可选：开启 Babel 的 runtime 模式，现在就使用 async/await

JSONP(JSON with Padding)是JSON的一种"使用模式"，可用于解决主流浏览器的跨域数据访问的问题  
[jsonp详解](http://www.cnblogs.com/yuzhongwusan/archive/2012/12/11/2812849.html)