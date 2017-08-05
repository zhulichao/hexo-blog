---
title: Emmet-基础
layout: post
date: 2017-07-10 10:11:32
categories: HTML
tags: HTML
---

前两天参加JavaScript培训，老师在写HTML的时候提到Zen Coding，我之前没有听到过这个东西，但写起来感觉跟Emmet一样，回来特意查了一下。

## 简介

Zen Coding 改名为 [Emmet](https://www.emmet.io/)，是一种快速编写HTML/CSS代码的方法。输入缩写代码，光标移到末尾，按扩展键（Tab键），即可得到代码片段。

### HTML基本用法

! ---- 生成html页面结构如下。
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    
</body>
</html>
```

元素名如div ---- 生成元素
```
<div></div>
```

`#`如div#section1 ---- 指定元素id
```
<div id="section1"></div>
```

`.`如div.className1 ---- 元素类名
```
<div class="className1"></div>
```

`[]`如a[alt title=name] ---- 指定元素属性，用空格分隔多个属性，属性值用=赋值
```
<a href="" alt="" title="name"></a>
```

`{}`如a{click me} ---- 文本
```
<a href="">click me</a>
```

`$`如 ---- 自增符号，@-表示倒序，@指定开始序号
```
<!-- ul>li.item$*3 -->
<ul>
    <li class="item1"></li>
    <li class="item2"></li>
    <li class="item3"></li>
</ul>
<!-- ul>li.item$@3*3 -->
<ul>
    <li class="item3"></li>
    <li class="item4"></li>
    <li class="item5"></li>
</ul>
<!-- ul>li.item$@-*3 -->
<ul>
    <li class="item3"></li>
    <li class="item2"></li>
    <li class="item1"></li>
</ul>
<!-- ul>li.item$@-3*3 -->
<ul>
    <li class="item5"></li>
    <li class="item4"></li>
    <li class="item3"></li>
</ul>
```

`>`如ul>li --- 子元素
```
<ul>
    <li></li>
</ul>
```

`*`如li*3 ---- 指定个数的元素
```
<li></li>
<li></li>
<li></li>
```

`+`如div+div ---- 兄弟元素
```
<div></div>
<div></div>
```

`^`如div+div>p>span+em^bq ---- 上级元素，多个表示向上几级
```
<div></div>
<div>
    <p><span></span><em></em></p>
    <blockquote></blockquote>
</div>
```

`()`如div>(header>ul>li*3)+section+footer ---- 群组
```
<div>
    <header>
        <ul>
            <li></li>
            <li></li>
            <li></li>
        </ul>
    </header>
    <section></section>
    <footer></footer>
</div>
```

### CSS基本用法



```
div {
    <!-- m:20 -->
    margin: 20px;
    <!-- mt:20 mb、ml、mr同理 -->
    margin-top: 20px;
    <!-- m:20-30 -->
    margin: 20px 30px;
    <!-- pos:a -->
    position: absolute;
    <!-- fl:l -->
    float: left;
    <!-- bd+ -->
    border: 1px solid #000;
    <!-- bdrs:3 -->
    border-radius: 3px;
    <!-- -wmso-bdrs:3 -->
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    -ms-border-radius: 3px;
    -o-border-radius: 3px;
    border-radius: 3px;
}
```



