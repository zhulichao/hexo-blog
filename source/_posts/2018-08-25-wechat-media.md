---
title: 小程序多媒体相关
layout: post
date: 2018-08-25 13:02:30
categories: WeChat
tags: WeChat
---

## 音频（待优化）

音频播放是自己封装了 Component，传入参数进行展示，如是否播放中、当前播放进度、总时长，主要是样式的封装，在播放音频的地方调用[背景音频播放管理 api](https://developers.weixin.qq.com/miniprogram/dev/api/getBackgroundAudioManager.html) 进行播放，在各种回调的方法中更新参数。需要注意的是 title 参数必须设置，否则 ios 会报错。

```
Page({
    onLoad() {
        this.backgroundAudioManager = wx.getBackgroundAudioManager();
        this.backgroundAudioManager.onPlay(() => {...});
        this.backgroundAudioManager.onPause(() => {...});
        this.backgroundAudioManager.onEnded(() => {...});
        this.backgroundAudioManager.onStop(() => {...});
        this.backgroundAudioManager.onTimeUpdate(() => {...});
    },
    handleVoicePlay(this: PageData, e: PageCustomEvent) {
        // title 必须设置，否则 ios 会报错
        this.backgroundAudioManager.title = '标题';
        this.backgroundAudioManager.coverImgUrl = '图片 url';
        this.backgroundAudioManager.src = e.target.dataset.src;
        this.backgroundAudioManager.startTime = 0;
    },
    handleVoicePause(this: PageData) {
        this.backgroundAudioManager.stop();
    },
    handleVoiceSeek(this: PageData, e: PageCustomEvent) {
        this.backgroundAudioManager.seek(e.detail.value);
    },
})
```

## 视频

视频播放如无特殊要求，使用官方提供的 video 组件即可。但是注意“请勿在 scroll-view、swiper、picker-view、movable-view 中使用 video 组件”，这些情况下样式会有较严重的问题。也可以在这些情况下使用一张预览图占位显示视频，点击后跳转到一个新页面使用 video 播放视频。