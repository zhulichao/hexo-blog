---
title: react-学习经验2
layout: post
date: 2016-09-13 08:44:03
categories: React
tags: React
---

## 零散知识  
- ReactDOM.render(Component,dom) 执行后，这个dom还会存在，这个Component是在最外层。  
感觉很奇怪  
```
// 在componentDidMount方法中
ReactDOM.render(this.state.customScript.buttonAndPopoverComponents(), document.getElementById(<Button type="primary">自定义添加的按钮</Button>,'ANTD_CDP_TABLE1_ZLC-btnBar_after'));
```
{% img https://zhulichao.github.io/2016/09/13/react-experience2/renderDOM.png 结果如图 %}
 


