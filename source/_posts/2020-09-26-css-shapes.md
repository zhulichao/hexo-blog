---
title: css-shapes
layout: post
date: 2020-09-26 09:34:35
categories:
tags:
---


[My Slides](https://jiongks.name/slides/five-css-features/#17)


## css shape

shape-outside 定义当前元素的形状为非矩形形状，相邻元素中的内容可沿着此元素形状的边缘进行编写

shape-margin 就是沿着 shape-outside 属性生成形状再向外扩展相应的距离，不过扩展后的形状不能超过参考盒模型的区域！
 
shape-image-threshold 这个属性是专门用来设置图片形状提取时透明通道的阈值，范围为0 ~ 1，默认值为0；阈值为n代表图片中透明通道值大于n的区域都是浮动区域。


## css exclusions

致力于解决文本环绕图片的效果，只有微软旗下 IE 和 Edge 可以用

http://www.360doc.com/content/17/0209/17/13092497_627829160.shtml
https://www.html5rocks.com/en/tutorials/regions/adobe/

wrap-flow 设置 exclusion 区域以及内容围绕的方式
wrap-margin 设置 exclusion 区与周边围绕区域的间距