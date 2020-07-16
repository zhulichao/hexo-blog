---
title: CSS-border-image
layout: post
date: 2020-07-14 11:07:27
categories: CSS
tags: CSS
---

`border-image-slice` 用来分解引入进来的背景图片，使图像边界向内偏移，取值为 `number` | `percentage` 其中 number 是没有单位的，专指像素 px，`number` 或`percentage` 都可取 1~4 个值，类似于 border-width 的取值方式。如果取值上还可以加上 fill，如果使用这个关键字，图片边界的中间部分将保留下来，默认情况下是为空的。

`border-image-slice` 把通过 `border-image-source` 取到的图片切成了九份，中间一份为内容区域，其他分别对应边框的对应部分，如图 1 所示。

{% img /2020/07/14/css-border-image/slice.png 400 图1 %}

其中，1、2、3、4 区域和内容区域水平和垂直方向均被拉伸。a、b、c、d 区域根据 `border-image-repeat` 属性值展示，是否应重复（repeat）、拉伸（stretch）或铺满（round），可取两个值，分别表示水平和垂直方向。
`border-image-width` 指定图像边界的宽度，不改变元素本身大小。
`border-image-outset` 用于指定在边框外部绘制的量，向元素外显示图片边框，不影响其它元素。

示例代码如下：

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Untitled Document</title>
    <style type="text/css">
      .container {
        display: flex;
      }
      .box {
        margin: 20px;
        width: 200px;
        height: 200px;
        background-color: orange;
        border: 100px solid;
        border-image-source: url('slice.png');
      }
      .box1 {
        border-image-slice: 100;
      }
      .box2 {
        border-image-slice: 200 100 100 100;
      }
      .box3 {
        border-image-slice: 200 200 100 100;
      }
      .box4 {
        border-image-slice: 200 100 50;
      }
      .box5 {
        border-image-slice: 100;
        border-image-repeat: stretch;
      }
      .box6 {
        border-image-slice: 100;
        border-image-repeat: round;
      }
      .box7 {
        border-image-slice: 100;
        border-image-repeat: repeat;
      }
      .box8 {
        border-image-slice: 100;
        border-image-repeat: space;
      }
      .box9 {
        border-image-slice: 100;
        border-image-width: 20px;
      }
      .box10 {
        border-image-slice: 100;
        border-image-width: 20px;
        border-image-outset: 20px;
      }
    </style>
  </head>

  <body>
    <div class="container">
      <div class="box box1">内容</div>
      <div class="box box2">内容</div>
      <div class="box box3">内容</div>
      <div class="box box4">内容</div>
    </div>
    <div class="container">
      <div class="box box5">内容</div>
      <div class="box box6">内容</div>
      <div class="box box7">内容</div>
      <div class="box box8">内容</div>
    </div>
    <div class="container">
      <div class="box box9">内容</div>
      <div class="box box10">内容</div>
    </div>
  </body>
</html>
```

{% img /2020/07/14/css-border-image/border-width.png 运行结果 %}
