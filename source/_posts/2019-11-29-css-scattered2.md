---
title: CSS-零散知识2
layout: post
date: 2019-11-29 10:14:21
categories: CSS
tags: CSS
---

## last-child 与 last-of-type

:last-child 表示其父元素的最后一个子元素，且这个元素是 css 指定的元素，才可以生效，否则无法生效，first-child 同理。:last-of-type 表示其父元素下的最后一个指定类型的元素。

{% img https://zhulichao.github.io/2019/11/29/css-scattered2/last-child.png last-child 与 last-of-type %}

## 锚点定位偏移

在 `<section>` 前面再加一个 `<a class="target-fix">` 作为暗锚，将这个锚点进行偏移：

```js
.target-fix {
    position: relative;
    top: -60px; // 偏移为nav被fixed元素的高度
    display: block;
    height: 0; // 高度为0
    overflow: hidden;
}
```

## 选择器的优先级

!important > 内联样式（1000）> ID选择器（100）> 类选择器（10）= 属性选择器（10）= 伪类选择器（10）> 元素选择器（1）= 伪元素选择器（1) > 通配符选择器（0）= 关系选择器（0）= 否定伪类（0）> 继承

当选择器出于同一种特殊性的时候，位于css文件下部的样式会覆盖上面的样式。

## Canvas 、SVG、WebGL

### Canvas

- Canvas 通过 JavaScript 来绘制 2D 图形
- 逐像素进行渲染，依赖分辨率
- 一旦图形被绘制完成就不会继续得到浏览器的关注，如果其位置发生变化，整个场景也需要重新绘制，包括任何可能已被图形覆盖的对象
- 不支持事件处理器
- 弱的文本渲染能力
- 能够以 .png 或 .jpg 格式保存结果图像
- 最适合图像密集型的游戏，其中的许多对象会被频繁重绘

### SVG

- SVG 是一种使用 XML 描述 2D 图形的语言
- 矢量图，不依赖分辨率，难以表现色彩丰富的逼真图像效果
- 每个被绘制的图形均被视为对象，如果对象的属性发生变化，浏览器能够自动重现图形
- 支持事件处理器
- 最适合带有大型渲染区域的应用程序（比如谷歌地图）
- 复杂度高会减慢渲染速度（任何过度使用 DOM 的应用都不快）
- 不适合游戏应用

### WebGL

- 基于 Canvas 的 3D 框架，主要用来做 3D 展示、动画、游戏

## CSS Modules

CSS 模块化的解决方案有很多，但主要有三类：

- 命名约定，代表 BEM、OOCSS、AMCSS、SMACSS
- CSS in JS，代表 styled-components
- 使用JS 来管理样式模块，代表是 CSS Modules

CSS Modules 是所有的 class 的名称和动画的名称默认属于本地作用域的 CSS 文件。所以 CSS Modules 不是一个官方的规范，也不是浏览器的一种机制，它是一种构建步骤中的一个进程，通过构建工具的帮助，可以将 class 的名字或者选择器的名字作用域化。有了 CSS Modules，就可以确保所有的样式能够服务于单个组件：集中在一个地方；只应用于那个组件，其他组件不适用。这样设计的目的在于解决 CSS 中的全局作用域问题。

Webpack 自带的 css-loader 组件，自带了 CSS Modules，通过简单的配置即可使用。

```javascript
module: {
  rules: [
    {
      test: /\.css$/,
      use: [
        'style-loader',
        {
          loader: 'css-loader',
          options: {
            modules: true,
          }
        }
      ]
      }
  ],
  ...
}
```

## BFC 块级格式化上下文

BFC(Block Formatting Context) 块级格式化上下文，是 Web 页面中盒模型布局的 CSS 渲染模式，指一个独立的渲染区域或者说是一个隔离的独立容器。可以用来解决两相邻元素间距发生重叠、清除浮动等问题。

### 形成 BFC 的条件

- 浮动元素，float 除 none 以外的值
- 定位元素，position 为 absolute 或 fixed
- 非块盒的块容器，display 为 inline-block 或 table-cell 或 table-caption
- overflow 除 visible 以外的值（hidden，auto，scroll)

### BFC 的特性

- 内部的 Box 会在垂直方向上一个接一个的放置
- BFC 就是页面上的一个独立容器，容器里面的子元素不会影响外面元素
- 垂直方向的距离由 margin 决定，属于同一个 BFC 的相邻 Box 的 margin 会发生重叠
- 元素的 margin box 的左边与包含块 border box 的左边相接触，存在浮动也是如此
- BFC 的区域不会与 float 的元素区域重叠
- 计算 BFC 的高度时，浮动元素也参与计算
