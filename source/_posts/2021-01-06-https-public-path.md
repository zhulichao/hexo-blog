---
title: https-public-path
layout: post
date: 2021-01-06 14:24:26
categories: Webpack
tags: Webpack
---

## 技术平台

借鉴 qiankun 的思路，如果项目中使用了 publicPath ，需要给 window 添加 `__INJECTED_PUBLIC_PATH_BY_EPIPE__` 全局变量，然后技术平台需要引用静态资源的地方都拼接上这个变量。

- 入口文件

```js
class Viewer {
  static __PUBLIC_PATH__;
  // 入口方法
  static async createDefaultViewer(id, callback = GisComponent.BaseMap.flyToChina) {
    this.__PUBLIC_PATH__ =
      window.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__ || '';
    ...
  }
}
```

- webpack 配置文件

```js
new webpack.DefinePlugin({
  ...
  'CESIUM_BASE_URL': '(window.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__ || "") + "/static/cesium"',
}),
```

## 业务平台后台端

- 添加 VUE_APP_BASE_API 环境变量，作为为静态的 publicPath
- 入口文件 main.js

```js
// 添加，判断一下有没有通过 iframe 引用后台端项目
window.__INJECTED_PUBLIC_PATH_BY_EPIPE__ = parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || process.env.VUE_APP_PUBLIC_PATH;
if (parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__) {
  // eslint-disable-next-line
  __webpack_public_path__ = parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__ + '/';
}
```

- 路由文件

```js
export default new Router({
  base: process.env.VUE_APP_PUBLIC_PATH, // 添加
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes,
});
```

- vue.config.js 配置文件

```js
publicPath: process.env.VUE_APP_PUBLIC_PATH || '/',
chainWebpack(config) {
  // 重新定义环境变量
  config.plugin('define').tap(args => {
    args[0]['process.env'].VUE_APP_PUBLIC_PATH = '(parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || "' + process.env.VUE_APP_PUBLIC_PATH + '")';
    args[0]['process.env'].VUE_APP_BASE_API = '(parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || "' + process.env.VUE_APP_PUBLIC_PATH + '") + "' + process.env.VUE_APP_BASE_API + '"';
    args[0]['process.env'].VUE_APP_MODEL_URL = '(parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || "' + process.env.VUE_APP_PUBLIC_PATH + '") + "' + process.env.VUE_APP_MODEL_URL + '"';
    args[0]['process.env'].VUE_APP_LAYER_URL = '(parent.__INJECTED_PUBLIC_PATH_BY_EPIPE__ || "' + process.env.VUE_APP_PUBLIC_PATH + '") + "' + process.env.VUE_APP_LAYER_URL + '"';
    return args;
  });
  ...
}
```

## 业务平台用户端

- 添加 VUE_APP_BASE_API 环境变量，作为为静态的 publicPath

```js
# 生产环境配置
ENV = 'production'

# 若依管理系统/生产环境
VUE_APP_PUBLIC_PATH = ''

VUE_APP_BASE_API = '${VUE_APP_PUBLIC_PATH}/prod-api'

VUE_APP_MODEL_API = '${VUE_APP_PUBLIC_PATH}/model/model/'

VUE_APP_LAYER_URL = '${VUE_APP_PUBLIC_PATH}/model/layer/'

```

- 入口文件 main.js

```js
// 添加
window.__INJECTED_PUBLIC_PATH_BY_EPIPE__ = process.env.VUE_APP_PUBLIC_PATH;
```

- 路由文件

```js
export default new Router({
  base: process.env.VUE_APP_PUBLIC_PATH, // 添加
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes,
});
```

- vue.config.js 配置文件

```js
publicPath: process.env.VUE_APP_PUBLIC_PATH || '/',
chainWebpack(config) {
  // 拷贝静态资源
  config.plugin('copy').use(CopyWebpackPlugin, [
    [
      {
        from: './static',
        to: 'static',
      },
      {
        from: 'node_modules/epipe-vp-web-cms/static/cms',
        to: 'static/cms',
        ignore: ['.*'],
      },
      {
        from: 'node_modules/epipe-vp-web-cms/static/images',
        to: 'static/images',
        ignore: ['.*'],
      },
      {
        from: 'node_modules/epipe-vp-web-cms/index.html',
        to: 'static/cms',
        ignore: ['.*'],
        transform (content, path) {
          let str = content.toString();
          // 路径替换，添加 VUE_APP_PUBLIC_PATH 环境变量
          str = str.replace(new RegExp(/(\/static\/cms)/g), process.env.VUE_APP_PUBLIC_PATH + '/static/cms');
          return str;
        }
      },
    ],
  ]);
}
```
