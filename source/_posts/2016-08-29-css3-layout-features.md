---
title: CSS3布局
layout: post
date: 2016-08-29 10:55:27
categories:
- Web前端
tags:
- css3
- 布局
---
发现个不错的CSS布局教程——[学习Css布局](http://zh.learnlayout.com/)  
用[codepen](http://codepen.io/collection/XpbVGg/)边学边做,练习了一下。

## 总结

### display属性
- block: 标准块级元素,新开始一行并尽可能撑满
- inline(默认): 标准行内元素,比如span包裹一些文字而不会打乱段落的布局
- none: 隐藏元素,不会保留元素本该显示的空间
- inline-block: 见下文 
- flex: 见下文

> 技巧: margin: 0 auto;  
设置块级元素的width(更好的方式是用max-width设置最大宽度)阻止它从左到右撑满容器,然后设置左右外边距为auto来使其水平居中


### 盒模型
此处省略500字,这里不是为了介绍盒模型,当各种block的内外边距影响块的实际大小时,我们需要以下技巧消除对布局造成的影响。

> 技巧: * { box-sizing:border-box; }


### 用position属性来布局
- static(默认): 不会被特殊的定位
- relative: 相对定位,再配合top、right、bottom和left属性对位置设置偏离
- fixed: 固定定位,跟relative类似可以通过top等设置偏离,区别是它将固定在位置上,不随页面滚动移动
- absolute: 绝对定位,相对于它的父元素定位,可以配合top等设置偏离

> Demo: 使用position的方式布局  
[教程](http://zh.learnlayout.com/position-example.html) [代码](https://codepen.io/nail2008/pen/JRPprW)  
菜单nav使用绝对位置,当过长时会超出容器。这种方式有些落后了。


### 用float属性来布局

> Demo: 使用float属性实现图片右对齐,文字环绕  
[教程](http://zh.learnlayout.com/float.html) [代码](https://codepen.io/nail2008/pen/RGbQYJ)  


> 技巧: 使用clear属性消除左右浮动:left、right、both,效果相当于换行  
[教程](http://zh.learnlayout.com/clear.html) [代码](https://codepen.io/nail2008/pen/pEzaQv)  
但这有个问题是当该元素比旁边的元素要长时,会冲破容器,看下面的例子:


> 技巧: 使用clearfix hack消除浮动  
[教程](http://zh.learnlayout.com/clearfix.html) [代码](https://codepen.io/nail2008/pen/JRPpQO)  
下面的代码彻底解决了这个问题
``` 
img {
  float: right;
  //....
}
.clearfix {
  overflow: auto;
  zoom: 1;  /* IE6 */
}
```

> Demo: 使用float的方式布局  
[教程1](http://zh.learnlayout.com/float-layout.html) [教程2](http://zh.learnlayout.com/percent.html) [代码](https://codepen.io/nail2008/pen/YGKazO)  
之前的主流方法之一,建议宽度使用百分比


> Demo: 使用媒体查询实现响应式布局  
[教程](http://zh.learnlayout.com/media-queries.html) [代码](https://codepen.io/nail2008/pen/ozvqXd)  


### 用inline-block来布局
[教程](http://zh.learnlayout.com/inline-block.html) [代码](https://codepen.io/nail2008/pen/yaBjZK)  
以下两种等价:  
```
.box {
  float: left;
  width: 200px;
  height: 100px;
  margin: 1em;
}
.after-box {
  clear: left;
}
```
```
.box2 {
  display: inline-block;
  width: 200px;
  height: 100px;
  margin: 1em;
  
  *display: inline; /*IE6*/
  *zoom: 1; /*IE6*/
}
```
> Demo: 使用inline-block布局  
[教程](http://zh.learnlayout.com/inline-block-layout.html) [代码](https://codepen.io/nail2008/pen/ALAaqm)  
这例子在我这有问题,宽度超过了容器,串行了

 
### 多列column (IE10+)
[教程](http://zh.learnlayout.com/column.html) [代码](https://codepen.io/nail2008/pen/ORLkxm)  
```
.three-column {
  padding: 1em;
  column-count: 3;
  column-gap: 1em;
}
```

### 用flex来布局
[教程](http://zh.learnlayout.com/flexbox.html) [代码](https://codepen.io/nail2008/pen/VKkxyZ)  

建议看下面的资料来学习,本文说的比较简单:  
[CSS3布局属性全接触@极客学院](http://www.jikexueyuan.com/course/1403.html)  
[Flexbox Playground](https://demos.scotch.io/visual-guide-to-css3-flexbox-flexbox-playground/demos/)  

> 技巧: flex布局默认所有元素高度为最高的那个元素的高度(横向)


> 技巧: 子元素占满剩余空间:设置子元素 flex:1


> 技巧: 水平、垂直都居中

```
.vertical-container {
  display: flex;
  align-items: center;
  justify-content: center;
  // ...
}
```

## 其他资料:

[CSS参考手册](http://www.css88.com/book/css/properties/layout/index.htm)
