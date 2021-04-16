---
title: 使用 Lottie 加载动画
layout: post
date: 2020-11-10 11:29:09
categories: JavaScript
tags: JavaScript
---

基于 lottie ，将 After Effects 导出的 json 文件渲染成 svg/canvas/html 动画效果。我使用的是 [lottie-web](https://github.com/airbnb/lottie-web)。

## 安装

`npm install lottie-web --save`

## 使用

```vue
<template>
  <div id="lottie_box" class="login-form-container" />
</template>

<script>
import lottie from 'lottie-web';
import * as animationData from '@/assets/image/login-data.json';

export default {
  mounted() {
    lottie.loadAnimation({
      container: document.getElementById('lottie_box'),
      renderer: 'svg',
      loop: true,
      autoplay: true,
      animationData: animationData.default,
    });
  },
};
</script>
```
