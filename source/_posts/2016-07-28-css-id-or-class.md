---
title: CSS样式命名应该用id还是用class?
layout: post
date: 2016-07-28 15:25:18
categories: Web前端
tags: css id class
---


### 常识
- id不可重名，class可以重复使用
- id定义了一个独特的元素，class定义了一批同类的元素
- id和class在优先级上是有区别的，id比class的优先级高

### 问题
在复杂的css架构中,某一个组件定义的class如果单独定义可能受同名class影响并不会起作用，而使用id就一定会起效

### 最佳实践
- 顶层布局或大组件不易重名,用id来定义元素
- 组件中的子组件或元素用父组件id+子元素class的形式来定义css

### 代码:  

```
//Bad：
#header {...}
.menu {...}

//Good:
#header {...}
#header .menu {...}
```


