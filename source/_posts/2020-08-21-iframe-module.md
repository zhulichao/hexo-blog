---
title: 使用 iframe 引用 NPM 包
layout: post
date: 2020-08-21 09:40:42
categories: NPM
tags: NPM
---

问题描述：想创建一个基于 vue 的业务平台，分为前台和后台，前台写业务相关的代码，后台是依赖[若依](https://ruoyi.vip/)的管理系统，将后台项目打包后发布到私有 npm 仓库，前台安装这个包直接使用，项目运行起来后是一个整体。这样用户可以下载前台的项目直接运行整个项目，可以修改代码进行个性化定制，但是后台的部分职能只用，不能修改。

依赖若依的后台项目，打包后是一个完整的项目，有自己的 index.html 入口文件，如果想让后台项目打包后与前台项目融合为一体，因为 vue 的入口在前台，前台就需要使用后台项目的所有路由、store，这样的可行性不高，即使可行代价也比较大，所以采用了前台通过 iframe 嵌入后台的入口文件的方式，前台和后台保持相同的登录退出逻辑，能让前台和后台同步登录和退出的状态。

### 后台项目

- 基于 [RuoYi-Vue/ruoyi-ui](https://gitee.com/y_project/RuoYi-Vue) 初始化项目
- src/router/index.js 文件中添加，让前台通过 iframe 嵌入的地址重定向到主页

```js
{
  path: '/static/cms/index.html',
  redirect: 'index',
},
```

- src/layout/components/Navbar.vue 文件中修改，让后台点击退出时进入前台页面的主页

```js
this.$store.dispatch('LogOut').then(() => {
  location.replace('/index');
  window.parent.location.replace('/');
});
```

- vue.config.js 中修改打包静态资源的路径

```js
assetsDir: 'static/cms';
```

### 前台项目

- vue init webpack 初始化项目
- 移植若依登录、401、404 页面相关代码
- build/webpack.base.conf.js 文件中添加对 sass 和 svg 的处理

```js
{
  test: /\.sass$/,
  loader: ['style', 'css', 'sass']
},
{
  test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
  loader: 'url-loader',
  exclude: [resolve('src/assets/icons')],
  options: {
    limit: 10000,
    name: utils.assetsPath('img/[name].[hash:7].[ext]')
  }
},
{
  test: /\.svg$/,
  loader: 'svg-sprite-loader',
  include: [resolve('src/assets/icons')],
  options: {
    symbolId: 'icon-[name]'
  }
},
```

- 集成后台项目，因为 iframe 只能访问静态资源，不能直接访问 node_modules 下的资源，因此需要将 node_modules 下打包后的后台项目资源拷贝到前台项目 static 目录下，webpack 添加如下配置

```js
new CopyWebpackPlugin([
  ...
  {
    from: 'node_modules/后台项目名/index.html',
    to: path.join(config.dev.assetsSubDirectory, 'cms'),
    ignore: ['.*'],
  },
  {
    from: 'node_modules/后台项目名/static/cms',
    to: path.join(config.dev.assetsSubDirectory, 'cms'),
    ignore: ['.*'],
  },
]);
```

- 使用 iframe 引用后台入口

```vue
<template>
  <iframe id="cms" class="content" src="/static/cms/index.html"></iframe>
</template>

<style scoped>
.content {
  position: absolute;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  border: none;
}
</style>
```
