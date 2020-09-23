---
title: webpack-entry-html
layout: post
date: 2020-07-29 15:38:54
categories: Webpack
tags: Webpack
---

项目中有多个 js 入口，要将编译生成的 js 分别插入到不同的 html 页面中。

```js
entry: {
  app: './app/main.js',
  source: './source/index.js'
},
plugins: [
  new HtmlWebpackPlugin({
    filename: 'index.html',
    template: 'index.html',
    inject: true,
    chunks: ['manifest', 'vendor', 'app'],
  }),
  new HtmlWebpackPlugin({
    filename: 'demo.html',
    template: 'demo.html',
    inject: false,
    chunks: ['manifest', 'vendor', 'source'],
  }),
],
```

demo.html 中指定插入位置

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>demo</title>
    <% for (var css in htmlWebpackPlugin.files.css) { %>
    <link href="<%=htmlWebpackPlugin.files.css[css] %>" rel="stylesheet" />
    <% } %>
  </head>
  <body>
    <div id="app"></div>
    <% for (var chunk in htmlWebpackPlugin.files.chunks) { %>
    <script type="text/javascript" src="<%=htmlWebpackPlugin.files.chunks[chunk].entry %>"></script>
    <% } %>
    <script type="text/javascript" src="./static/app/utils.js"></script>
    <script>
      // other js
    </script>
  </body>
</html>
```
