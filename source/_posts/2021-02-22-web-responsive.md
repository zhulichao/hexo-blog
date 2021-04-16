---
title: WEB 自适应
layout: post
date: 2021-02-22 17:06:35
categories: 前端知识
tags: 前端知识
---

## 多媒体查询

主要针对不同的媒体类型(包括显示器、便携设备、电视机，等等)设置不同的样式规则，主要是页面布局或元素需要发生变化的情况，如从横向排列改为纵向排列，或使用不同图片等。

## Flex 布局

可针对容器宽度自行调整元素位置，如果可以不限制元素宽高，自行充满。

## 相对单位

避免使用 px，使用 vh、vw、rem 等单位。使用 rem 的方式，可以采用工具进行自动的 px 到 rem 的转换。注意 `1px` 可以不转换，有时转换为 rem 会不显示，写成 `1PX` 即可不被转换。

## rem 方式实现

### 安装 postcss-pxtorem

```js
npm install postcss-pxtorem --save-dev
```

### 配置 postcss-pxtorem

添加 .postcssrc.js 文件如下

```js
module.exports = {
  "plugins": {
    "autoprefixer": {},
    "postcss-pxtorem": {
      "rootValue": 16,
      "propList": [
        "*"
      ],
      "selectorBlackList": ["el-tooltip"],
    }
  }
};
```

### 添加自适应代码

添加 rem.js 文件如下

```js
function setRem() {
  var html = document.getElementsByTagName('html')[0];
  var width = window.innerWidth; // 获取窗口的文档显示区的宽度
  var font_Size = (16 / 1920) * width; // 设计稿以1920为准，在1920的设计稿中：16px = 1rem
  html.style.fontSize = font_Size + 'px';
  document.documentElement.style.fontSize = font_Size + 'px';
}
setRem();
window.addEventListener('resize', setRem);
```

修改 main.js 文件如下

```js
...
import './utils/rem';
...
```
