---
title: JavaScript-Ajax基础
layout: post
date: 2017-08-17 20:59:13
categories: JavaScript
tags: JavaScript
---

# ajax 使用及原理 

```
$.ajax({
    type: 'POST',
    url: url,
    dataType: 'json',
    async: false,
    headers: { ... },
    data: JSON.stringify(this.props.form, getFieldsValue()),
    success: (responseData) => { ... },
    error: (XMLHttpRequest, textStatus, errorThrown) => { ... }  
});
```
