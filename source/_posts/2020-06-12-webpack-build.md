---
title: Webpack 打包
layout: post
date: 2020-06-12 10:06:02
categories: Webpack
tags: Webpack
---

## 安装包后自动将文件从软件包复制到本地目录

npm 的 postinstall 脚本会在安装完包后自动执行。

```js
"scripts": {
  "postinstall": "node bin/copy.js"
},
```

## webpack 打包后可通过 import 引入、script 标签引入

- `output.libraryTarget` 打包类库的发布模式，使用 `umd` 可通过 `import` 方式引入
- `output.library` 为导出的库指定义一个全局使用的名称变量，主要用于直接引用的方式，如用 script 标签
- `output.libraryExport` 库中被导出的项，如对外暴露 default 属性，就可以直接调用 default 里的属性

配置以下内容即可实现 webpack 打包后的包可通过 import 和 script 标签引入。

```js
output: {
  path: config.buildSource.assetsRoot,
  filename: 'index.js',
  libraryTarget: 'umd',
  libraryExport: 'default',
  library: config.buildSource.name,
},
```

```js
// import 方式
import Library from 'lib';

// script 标签方式
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link rel="stylesheet" href="./lib.css"/>
    <script src="./lib.js"></script>
    <title>测试包引入</title>
  </head>
  <body>
    <div id="app"></div>
    <script>
      const viewer = new Library.App.Viewer("app");
    </script>
  </body>
</html>
```

## 添加对下载时需要的静态资源的处理，下载页面

类库提供了下载链接可直接下载使用，这就需要维护所有版本的下载压缩包，放在指定的文件夹中，在 webpack.config.js 中，通过 node 的 fs 模块读取文件夹中的文件列表，放到一个变量中，再通过 webpack.DefinePlugin 暴露成全局变量，页面中就可以取到压缩文件列表了。注意，在项目启动后修改下载列表中的文件需要重启。

```js
let files = fs.readdirSync(path.join(__dirname, '../../static/app/source/'));
files.forEach(function (fileName) {
  if (fileName.endsWith('.zip')) {
    sourceZipList.push(fileName);
  }
});
...
plugins: [
  new webpack.DefinePlugin({
    'sourceZipList': JSON.stringify(sourceZipList),
  }),
  ...
]
```
