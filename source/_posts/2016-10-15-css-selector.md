---
title: css-选择器
layout: post
date: 2016-10-15 23:48:09
categories: CSS
tags: CSS
---

## 通配选择器

*{ margin:0; padding: 0; }

## 元素选择器

div { background: grey; }

## ID选择器

#id { background: grey; }

## 类选择器

.class { background: grey; }
.class1.class2 { background: grey; } // 需要同时具有指定的类才能匹配

## 群组选择器

selector1,selector2 { background: grey; } // 匹配为selector1和selector2的所有元素

## 后代选择器

E F { background: grey; } // 匹配E的元素包含的所有匹配F的元素

## 子选择器

E>F { background: grey; } // 匹配E的元素包含的匹配F的直接子元素

## 相邻兄弟选择器

E+F { background: grey; } // 匹配E的元素后紧挨着的匹配F的元素

## 通用选择器

E~F { background: grey; } // 匹配E的元素后的所有匹配F的元素

## 动态伪类选择器

:link 未被访问过的超链接  
:visited 已被访问过的超链接  
:hover 鼠标停留  
:ative 被激活，常用于锚点和按钮上  
:focus 获得焦点  

锚点伪类的设置必须遵守"link-visited-hover-active"

## 目标伪类选择器

只有存在URL指向该匹配元素时，样式效果才会生效

```
// 点击按钮时，跳到target位置，target背景为红色
<div id="target">target</div>
<a href="#target" class="btn">View project on GitHbu</a>
...
#target:target {
  background: red;
}
```

## 语言伪类选择器

需要指定html或bogy的lang属性
`<html lang="en-US">或<body lang="fr">`  
E:lang(language) 表示选择匹配E的所有元素，且匹配元素指定了lang属性，而且其值为language。

## UI元素状态伪类选择器

:checked 选中状态，适用复选或单选  
:enabled 启用状态，匹配启用的表单元素  
:disabled 不可用状态，匹配禁用的表单元素  

## 结构伪类选择器

E:first-child 作为父元素的第一个子元素的元素E，与E:nth-child(1)相同  
E:first-child 作为父元素的最后一个子元素的元素E，与E:nth-last-child(1)相同  
E:root 选择匹配元素E所在文档的根元素，在HTML文档中，根元素始终是html，此时该选择器与html类型选择器匹配的内容相同  
E F:nth-child(n) 选择父元素E的第n个子元素F，n的起始值为1  
E F:nth-last-child(n) 选择父元素E的倒数第n个子元素F  
E:nth-of-type(n) 选择父元素内具有指定类型的第n个E元素  
E:nth-last-of-type(n) 选择父元素具有指定类型的倒数第n个E元素
E:first-of-type 选择父元素内具有指定类型的第一个E元素，与E:nth-of-type(1)相同  
E:last-of-type 选择父元素内具有指定类型的最后一个E元素，与E:nth-last-of-type(1)相同 
E:only-child 选择父元素只包含一个子元素，且该子元素匹配E元素  
E:only-of-type 选择父元素只包含一个同类型的子元素，且该子元素匹配E元素
E:empty 选择没有子元素的元素，且该元素也不包含任何文本节点

## 否定伪类选择器

:not(footer){} // 选择页面中所有元素，除了"footer"元素

## 伪元素

**双冒号与单冒号在CSS3中主要用来区分伪类和伪元素**

::first-letter 用来选择文本块的第一个字母  
::first-line 用来选择文本块的第一行  
::before 和 ::after 需配合content属性，不是指存在与标记中的内容，而是可以插入额外内容的位置  
::selection 用来匹配选中的文本，紧接收background和color属性  

## 属性选择器

E[attr] 选择匹配具有属性attr的E元素  
E[attr=val] 选择匹配具有属性attr的E元素，且attr属性值为val  
E[attr|=val] 选择匹配E元素，且E元素定义了属性attr，attr属性值是一个具有val或者以val-开始的属性值  
E[attr~=val] 选择匹配E元素，且E元素定义了属性attr，attr属性值具有多个空格分隔的值，其中一个值等于val  
E[attr*=val] 选择匹配元素E，且E元素定义了属性attr，其属性值任意位置包含了val  
E[attr^=val] 选择匹配元素E，且E元素定义了属性attr，其属性值以val开头  
E[attr$=val] 选择匹配元素E，且E元素定义了属性attr，其属性值以val结尾  