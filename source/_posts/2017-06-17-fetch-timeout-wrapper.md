---
title: Fetch-Timeout-Wrapper
layout: post
date: 2017-06-17 09:52:18
categories: ES6
tags: ES6
---

在使用react-native进行开发时，用到网络请求的地方，如果服务端未启动或存在网络问题，会弹出Network request failed，想自己设置客户端超时时间及超时提示信息，在react-native问题列表和网上查找后，已确认react-native用的fetch没有直接提供timeout设置的。

在网上查到了使用ES6的promise封装fetch的方式，自己修改成如下timeout_fetch.js工具类，经过验证可以解决使用fetch时timeout的设置问题，将项目所有使用fetch的地方替换成使用timeout_fetch即可。

```
/*
config中配置了系统默认的请求超时时间，方便后期统一修改
*/
import { default as config } from '../config/base';

/**
 * @param {Promise} fetch_promise fetch请求返回的Promise
 * @param {number} timeout 超时时间，单位为毫秒
 * @return 返回Promise
 */
function promise_fetch(fetch_promise, timeout) {
  let timeout_fn = null;
  // 这是一个可以被reject的promise
  let timeout_promise = new Promise((resolve, reject) => {
    timeout_fn = () => {
      const error = new Error('网络请求超时');
      reject(error);
    };
  });
  /*
  这里使用Promise.race，以先返回的 resolve 或 reject 的结果来传入后续绑定的回调。
  timeout不是请求连接超时的含义，它表示请求的response时间，fetch的timeout即使超时发生了，本次请求也不会被abort丢弃掉，它在后台仍然会发送到服务器端，只是本次请求的响应内容被丢弃而已。
  */
  const abortable_promise = Promise.race([
    fetch_promise,
    timeout_promise
  ]);
  setTimeout(function() {
    timeout_fn();
  }, timeout);
  return abortable_promise;
}

/**
 * @param {string} url 请求地址
 * @param {object} params 请求参数，其中timeout是超时设置，如果没有取全局配置的默认值
 * @return 返回Promise
 */
export function timeout_fetch(url, params) {
  return new Promise((resolve, reject) => {
    promise_fetch(fetch(url, params), params.timeout ? params.timeout : config.clientTimeout * 1000)
      .then((responseData) => {
          resolve(responseData);
      })
      .catch((err) => {
          reject(err);
      });
  });
}
```

