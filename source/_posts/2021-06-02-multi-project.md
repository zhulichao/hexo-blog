---
title: 多项目跳转
layout: post
date: 2021-06-02 09:11:05
categories: Project Base
tags: Project Base
---


- 打包后 vue-router 多次引用
- 跳转是用 a 标签，路由可能跳不过去

注意：引用静态资源的路径可能需要处理

## 基于 qiankun

- babel-polyfill 多次引用 idempotent-babel-polyfill

### 主应用修改

- npm install qiankun
- router 删除 notFoundRouter 的重定向
- 修改 main.js

```js
import { registerMicroApps, start } from 'qiankun'
// import BabelPolyfill from 'babel-polyfill'
// Vue.use(BabelPolyfill)

// 添加
registerMicroApps(
  [
    {
      name: 'project',
      entry: '//localhost:8002',
      container: '#app',
      activeRule: '/cms'
    }
  ]
)

start()
```

### 跳转应用修改

- 修改 webpack 配置

```js
output: {
  // 把子应用打包成 umd 库格式(必须)
  library: `${packageName}-[name]`,
  libraryTarget: 'umd',
  jsonpFunction: `webpackJsonp_${packageName}`
}

devServer: {
  // ...
  headers: {
    'Access-Control-Allow-Origin': '*'
  }
}
```

- router 设置 base

```js
export default new Router({
  mode: 'history',
  base: window.__POWERED_BY_QIANKUN__ ? '/cms' : '/',
  routes: constantRouterMap
})
```

- 修改 main.js

```js
// 修改
import bootstrap2 from './core/bootstrap'

// 删除
// new Vue({
//   router,
//   store,
//   i18n,
//   created: bootstrap,
//   render: h => h(App)
// }).$mount('#app')

let instance = null

function render (props = {}) {
  const { container } = props

  instance = new Vue({
    router,
    store: store,
    i18n,
    created: bootstrap2,
    render: h => h(App)
  }).$mount(container ? container.querySelector('#app') : '#app')
}

if (window.__POWERED_BY_QIANKUN__) {
  // eslint-disable-next-line
  __webpack_public_path__ = window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__
} else {
  // 独立运行
  render()
}

/**
 * bootstrap 只会在微应用初始化的时候调用一次，下次微应用重新进入时会直接调用 mount 钩子，不会再重复触发 bootstrap。
 * 通常我们可以在这里做一些全局变量的初始化，比如不会在 unmount 阶段被销毁的应用级别的缓存等。
 */
export async function bootstrap () {
  console.log('app bootstraped')
}

/**
 * 应用每次进入都会调用 mount 方法，通常我们在这里触发应用的渲染方法
 */
export async function mount (props) {
  render(props)
}
/**
 * 应用每次 切出/卸载 会调用的方法，通常在这里我们会卸载微应用的应用实例
 */
export async function unmount (props) {
  instance.$destroy()
  instance.$el.innerHTML = ''
  instance = null
  router = null
}
```

- 线上 nginx

```sh
location /api/ {
  add_header Access-Control-Allow-Origin *;
  add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
  add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,refresh_token';
  if ($request_method = 'OPTIONS') {
      return 204;
  }
  proxy_pass http://192.168.103.219:30005/;
}

location / {
  add_header Access-Control-Allow-Origin *;
  add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
  add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
  root /usr/local/Cellar/nginx/1.19.5/pcm/dist12;
  try_files $uri $uri/ @router;
  index index.html index.htm;
  add_header Cache-Control max-age=no-cache;
}
```

## 基于 nginx 转发

- 主应用没有修改
- 跳转的应用
  - 设置 publicPath 为 '/cms'
  - router 设置 base 为 '/cms'

### 一个前端项目

```sh
location /cms/api/ {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,refresh_token';
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    proxy_pass http://192.168.103.219:30005/;
}

location /api/ {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,refresh_token';
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    proxy_pass http://192.168.103.219:30005/;
}

location /cms {
    alias /usr/local/Cellar/nginx/1.19.5/pcm/dist2/;
    try_files $uri $uri/ ../dist2/index.html break; # 注意这个 break
    index index.html index.htm;
}

location / {
    root /usr/local/Cellar/nginx/1.19.5/pcm/dist1;
    index index.html index.htm;
    try_files $uri $uri/ /index.html;
}
```

### 多个前端项目

主项目配置如下：

```sh
location /api/ {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,refresh_token';
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    proxy_pass http://192.168.103.219:30005/;
}

location /cms {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    proxy_pass http://localhost:1889;
}

location / {
    root /usr/local/Cellar/nginx/1.19.5/pcm/dist1;
    try_files $uri $uri/ @router;
    index index.html index.htm;
    add_header Cache-Control max-age=no-cache;
}
```

跳转项目配置如下：

```sh
location /cms/api/ {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,refresh_token';
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    proxy_pass http://192.168.103.219:30005/;
}

location /api/ {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,refresh_token';
    if ($request_method = 'OPTIONS') {
        return 204;
    }
    proxy_pass http://192.168.103.219:30005/;
}

location /cms {
    alias /usr/local/Cellar/nginx/1.19.5/pcm/dist2/;
    try_files $uri $uri/;
    index index.html index.htm;
}

location / {
    root /usr/local/Cellar/nginx/1.19.5/pcm/dist2;
    try_files $uri $uri/ /index.html;
    index index.html index.htm;
    add_header Cache-Control max-age=no-cache;
}
```
