---
title: CSS-零散知识
layout: post
date: 2016-09-28 08:08:35
categories: CSS
tags: CSS
---

## text-indent
段落的第一行缩进

## css hack
[css hack](http://baike.baidu.com/view/1119452.htm?subLemmaId=1119452&fromenter=CSShack) 目的就是使你的CSS代码兼容不同的浏览器

## CSS border实现各个方向等腰直角三角

HTML代码：
```
<span class="border_cort"></span>
<span class="border_corb"></span>
<span class="border_corl"></span>
<span class="border_corr"></span>
```

CSS代码：
```
.border_cort, .border_corr, .border_corb, .border_corl {
    display: inline-block;
    width: 0;
    height: 0;
    border-width: 6px;
    overflow: hidden;
    background-color: red;
}
.border_cort {
    border-color: #333 transparent transparent;
    border-style: solid dotted dotted;
}
.border_corr {
    border-color: transparent #333 transparent transparent;
    border-style: dotted solid dotted dotted;
}
.border_corb {
    border-color: transparent transparent #333;
    border-style: dotted dotted solid;
}
.border_corl {
    border-color: transparent transparent transparent #333;
    border-style: dotted dotted dotted solid;
}
```
{% img https://zhulichao.github.io/2016/09/28/css-scattered/transparent.png 结果如图 %}

{% img https://zhulichao.github.io/2016/09/28/css-scattered/transparent2.png 原理如图 %}

## !important

使用!important定义的样式拥有最高的优先级，IE6不支持，会按正常优先级显示，可以解决一些浏览器的兼容性问题。

## 两个div显示在一行，分居左右

对两个div元素A、B都添加diaplay:inline-block属性，对居右元素B添加float:right属性，在B元素的后面需添加一个div并有clear:both属性用于清除float。

## min-height

由于某些原因导致相同元素不同高度，在IE浏览器下导致页面布局发生变化(有空位)，可以给这些相同元素添加min-height属性，取值大于等于这些不同高度中的最大值，即可是页面布局恢复正常。

## 必填样式

常见的必填样式都是在label前添加一个红色星号，可以在判断该项为必填项时给label添加一个class如notNull，并使用伪类
```
.notNull::before {
    color: red;
    content: "*";
}
```

## 元素居中

top: 50%;
left: 50%;
margin-top: 50px;// 居中元素的高度/2
margin-left: 50px;// 居中元素的宽度/2

img {
    display: block;
    margin: 0 auto;
}

## 文字居中

text-align: center; // 水平居中
line-height: @divHeight; // 垂直居中，属性值等于文字所在块的高度

## word-break属性

word-break属性规定自动换行的处理方法，通过使用该属性，可以让浏览器实现在任意位置的换行。

> normal，使用浏览器默认的换行规则
> break-all，允许在单词内换行
> keep-all，只能在半角空格或连字符处换行

{% img https://zhulichao.github.io/2016/09/28/css-scattered/word-break.png word-break属性 %}

## word-wrap属性

word-wrap属性允许长单词或URL地址换行到下一行。

> normal，只在允许的断字点换行（浏览器保持默认处理）
> break-word，在长单词或URL地址内部进行换行

{% img https://zhulichao.github.io/2016/09/28/css-scattered/word-wrap.png word-wrap属性 %}
