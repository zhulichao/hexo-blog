---
title: css-border-overlap
layout: post
date: 2020-11-06 13:59:43
categories: CSS
tags: CSS
---

## css 处理边框叠加

如图所示，想要做一个按钮组的功能，有 hover 效果。

{% img /2020/11/06/css-border-overlap/buttons.jpg 按钮组 %}

如果做一个 ul 列表，然后给每个 li 加上边框，相邻列表的边框就会变成 2px，解决方法是给 li 在样式中指定 `margin-right: -1px;` 这样两个边框就可以重叠在一起了。

但是在这个 li 加了 hover 后，鼠标悬停让边框变色，每个变色的只会是上下左三条框，右边框被盖住，看不出效果了，解决方法是给 li 在 hover 时提高层级，就达到了想要的效果。

```css
li {
   border: 1px solid #FF0000;
   margin-right: -1px;
}

li:hover {
   border: 1px solid #0000FF;
   position: relative;
   z-index: 2;
}
```

## css 让点击穿透

pointer-event: none; // 点击穿透
pointer-event: auto; // 恢复点击
