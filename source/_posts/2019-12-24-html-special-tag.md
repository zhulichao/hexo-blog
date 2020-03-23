---
title: HTML-特殊标签
layout: post
date: 2019-12-24 14:59:42
categories: HTML
tags: HTML
---

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HTML特殊标签</title>
</head>
<body>
    <!-- 带有一定样式，不提倡使用的标签，目前HTML5仍然保留 -->
    <b>b加粗</b>
    <i>i斜体</i>
    <tt>tt打字机字体</tt>
    <small>small小一些的字体</small>
    <br>
    <!-- 带有明确语义的标签 -->
    <del>del删除</del>
    <ins>ins添加</ins>
    <s>s过时废弃</s>
    <sup>sup上标</sup>
    <sub>sub下标</sub>
    <mark>mark特别强调</mark>
    <em>em强调</em>
    <strong>strong着重</strong>
    <dfn>definition定义</dfn>
    <code>code代码</code>
    <samp>samp例子代码</samp>
    <kbd>kbd用户输入</kbd>
    <var>variable变量</var>
    <cite>cite引用</cite>
    <br>
    <!-- 英文单词过长时，根据浏览器宽度指定单词换行时机裁切换行 -->
    <p>To learn AJAX, you must be familiar with the XMLHttpRequest Object.To learn AJAX, you must be familiar with the XMLHttp<wbr>Request Object.</p>
    <!-- 既表达语义又带有一定样式的标签 -->
    <address>address地址</address>
    <blockquote>blockquote缩进</blockquote>
    <q>q小引用</q>
    <pre>pre预格式化标签</pre>
    <abbr title="中华人民共和国">abbr简写</abbr>
    <br>
    <bdo dir="rtl">bdo反向</bdo>
</body>
</html>
```

{% img /2019/12/24/html-special-tag/tag.png 效果图 %}
