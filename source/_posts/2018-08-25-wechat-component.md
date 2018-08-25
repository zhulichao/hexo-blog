---
title: 小程序基础组件
layout: post
date: 2018-08-25 13:02:05
categories: WeChat
tags: WeChat
---

## Swiper

使用小程序的 swiper 组件，是能达到常规的 swiper 功能的，但是原生提供的样式有限，通常为图1、图2的样式。

{% img https://zhulichao.github.io/2018/08/25/wechat-component/swiper-1.gif 300 图1 %}

{% img https://zhulichao.github.io/2018/08/25/wechat-component/swiper-2.gif 300 图2 %}

通过样式的处理可达到图3的效果。示例代码如下：

```
// wxml
<swiper indicator-dots="{{true}}" previous-margin="8px" next-margin="8px" bindchange="bindSwiperChange">
  <swiper-item wx:for="{{[1, 2, 3]}}" wx:key="{{index}}" class="swiperItem">
    <view class="ruleCard {{currentSwiperItem < index && 'hiddenLeft'}} {{currentSwiperItem > index && 'hiddenRight'}}">
      {{item}}
    </view>
  </swiper-item>
</swiper>

// js
Page({
  data: {
    currentSwiperItem: 0,
  },
  bindSwiperChange(e) {
    this.setData({
      currentSwiperItem: e.detail.current,
    });
  },
});

// wxss
swiper {
  width: 100vw;
  height: 363rpx;
}

.swiperItem {
  display: flex;
  justify-content: center;
  width: calc(100vw - 16px) !important;
}

.ruleCard {
  display: flex;
  flex-direction: column;
  justify-content: center;
  width: calc(100vw - 40px);
  height: 363rpx;
  background: skyblue;
  background-size: cover;
  border-radius: 6px;
}

.hiddenLeft {
  position: relative;
  left: -10px;
}

.hiddenRight {
  position: relative;
  right: -10px;
}
```

{% img https://zhulichao.github.io/2018/08/25/wechat-component/swiper-3.gif 300 图3 %}