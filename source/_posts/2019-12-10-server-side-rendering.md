---
title: React-SSR
layout: post
date: 2019-12-10 10:25:14
categories: React
tags: React
---

[How to implement server-side rendering in your React app in three simple steps](https://www.freecodecamp.org/news/server-side-rendering-your-react-app-in-three-simple-steps-7a82b95db82e/)
[React 服务端渲染从入门到精通](https://segmentfault.com/a/1190000018672269)

## 什么是服务端渲染

当用户或爬虫程序访问页面 URL 时，将组件或页面通过服务器生成 HTML 字符串，再发送到浏览器，最后将静态标记"混合"为客户端上完全交互的应用程序。服务端渲染只发生在首屏，在客户端处理后面的请求。

## 服务端渲染和客户端渲染的区别

- 客户端渲染时，浏览器下载一个最小的 HTML 页面，渲染 JavaScript 并填充进去
- 服务端渲染时，在服务端渲染 React 组件，输出 HTML 内容

可以组合使用这 2 种方式创建同构应用

## 如何在页面中快速判断是否为服务端渲染

- 鼠标右键查看源代码，在页面中看到的内容在源代码中也可以查看到，则是服务端渲染得到的
- 鼠标右键查看源代码，页面中看到的内容在源代码中不可以查看到，则是客户端渲染得到的

## 在服务端渲染 React 的后果

- 如果应用很小，服务端渲染可以改善性能，但是如果应用很大会降低性能
- 增大了响应时间，如果服务器很忙会更糟糕
- 增大了响应大小，这意味着需要更长的时间来加载页面
- 增大了应用的复杂度
- 在服务端渲染时只会执行到 componentDidMount 之前的生命周期钩子，一些常用的浏览器的 api 可能无法正常使用

## 什么时候应该使用服务端渲染

- SEO，目前搜索引擎爬虫还不能解析 JavaScript，这是使用服务端渲染最主要的原因，特别是对于着陆页
- 改善性能，在服务端渲染时，应用的性能依赖服务器的资源和用户的网速，这使服务端渲染对于内容密集型网站非常有用；另一个改善是首次用户交互时间，减少白屏等待时间

## 如何工作

- 首次访问页面时创建一个新的 Redux Store
- 选择性的 dispatch action，服务端渲染时客户端不需要初始化 state 的 action
- 从 Store 中拿到 state 执行 SSR
- 将上一步获取到的 state 一起返回，用这个 state 在客户端初始化 state

```javascript
// server rendered home page
app.get('/', (req, res) => {
  const { preloadedState, content } = ssr(initialState);
  const response = template('Server Rendered Page', preloadedState, content);
  res.setHeader('Cache-Control', 'assets, max-age=604800');
  res.send(response);
});
```

```javascript
function ssr(initialState) {
  // Configure the store with the initial state provided
  const store = configureStore(initialState);

  // render the App store static markup ins content variable
  let content = renderToString(
    <Provider store={store}>
      <App />
    </Provider>
  );

  // Get a copy of store data to create the same store on client side
  const preloadedState = store.getState();

  return { content, preloadedState };
}
```

```javascript
function template(title, initialState = {}, content = '') {
  // Dynamically ship scripts based on render type
  let scripts = '';
  if (content) {
    // 服务端渲染
    scripts = ` <script>
                   window.__STATE__ = ${JSON.stringify(initialState)}
                </script>
                <script src="assets/client.js"></script>
                `;
  } else {
    // 客户端渲染
    scripts = ` <script src="assets/bundle.js"> </script> `;
  }
  let page = `<!DOCTYPE html>
              <html lang="en">
              <head>
                <meta charset="utf-8">
                <title> ${title} </title>
                <link href="assets/style.css" rel="stylesheet">
              </head>
              <body>
                <div class="content">
                   <div id="app" class="wrap-inner">
                      <!--- magic happens here -->  ${content}
                   </div>
                </div>

                  ${scripts}
              </body>
              `;

  return page;
}
```

```javascript
// client.js
import React from 'react';
import { hydrate } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './redux/configureStore';
import App from './components/app';

// Read the state sent with markup
const state = window.__STATE__;

// delete the state from global window object
delete window.__STATE__;

// reproduce the store used to render the page on server
const store = configureStore(state);

/**
 * hydrate the page to make sure both server and client
 * side pages are identical. This includes markup checking,
 * react comments to identify elements and more.
 */

hydrate(
  <Provider store={store}>
    <App />
  </Provider>,
  document.querySelector('#app')
);
```
