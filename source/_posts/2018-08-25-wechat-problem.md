---
title: 小程序开发遇到问题
layout: post
date: 2018-08-25 13:03:13
categories: WeChat
tags: WeChat
---

以下记录的为开发过程中遇到的零散问题及解决方案。

## 登录流程

{% img /2018/08/25/wechat-problem/flow.png 小程序登录流程 %}

## 部分用户没有 unionId

如上面登录逻辑梳理所述，进入小程序时，如果判断当前进行了用户授权，会使用 wx.getUserInfo 获取用户加密信息 encryptedData 和 iv 以及 wx.login 返回的 code 调用后台接口，后台处理会调用微信接口，通常微信接口会返回用户的 unionId，但发现有的用户就没有返回 unionId。在社区搜了一下这个问题，发现可能会存在微信接口没有返回 unionId 的情况，但通过解密 encryptedData 一定能拿到 unionId，因此改变了获取 unionId 的方式就解决了这个问题。

## 登录加载慢

小程序线上环境，有部分用户会登录加载很慢，但是我自己没有复现过这个现象，也没办法排查问题。后来发现本地使用** ngrok 进行内网穿透** 调试时，有时就会出现这个登录加载慢的问题，经过排查发现，前端在进入小程序时，先使用 wx.login 获取 code，然后调用后台 getInfo 接口拿到用户 openId 进行数据上报，同时也调用后台 login 接口进行用户登录，这两个后台接口都调用了 https://api.weixin.qq.com/sns/jscode2session 接口获取 session_key。后台本身是做了通过将 code 值存入数据库来防止重复使用 code 的兼容的，但是可能会存在同时进入后台的这两个请求，还没有完成存入数据库的操作，后台报了 code 被重复使用的错误没有继续向下执行，因此前端一直处于等待状态，导致登录加载卡死在等待中。

## iOS 上头像不显示

问题：在【我的】页面，进入时查询用户信息，如果没有用户信息，显示默认头像图片，如果有用户信息，显示指定 url 的用户头像，但在 iOS 上返回用户信息后仍然显示默认图像，image 组件的 src 属性是正确的头像链接。

解决：在 iOS 上 image 组件在 src 变化后不一定能显示更新后的图片，使用两个 image 组件，根据有没有 url 值决定显示默认头像还是用户头像，就没有问题了。

## 重复进入页面

问题：在网络条件不好时可能存在点击按钮跳转页面，可能会多次跳转同一个页面，也要点击多次返回才能返回到正确的页面。

解决：在跳转前判断要进入的页面是否在路由栈已经存在。示例代码如下

```js
Page({
    ...
    navigateToPage() {
        const pages = getCurrentPages();
        if (pages[pages.length - 1].route === 'pages/xxx/xxx') {
            return;
        }
        wx.navigateTo({
            url: '/pages/xxx/xxx',
        });
    },
    ...
});
```

## 网络图片存在缓存

小程序中使用的网络图片，如果 url 没有发生变化，但后台更新了图片，使用小程序时可能会存在图片没有更新过来，把小程序从记录中删除了再打开，就可以了。也可以在使用图片的 url 后面添加查询参数 `url + '?' + Dare.parse(new Date())` 的方式不让小程序缓存图片。web-view 中打卡的网页链接也可以这么处理。

## 一个值得思考的 bug

问题描述：A 页面 -> B 页面 -> C 页面，在 C 页面中，进行背景音频播放，并添加了背景音频播放的监听，onPlay、onPause、onTimeUpdate、onEnded、onStop，这些监听中主要是更新当前页面的 data 值，来控制页面中的显示，如显示播放/暂停按钮，显示当前播放进度等，**并更新全局的当前播放音频的信息**，在从 C 页面返回到 B 页面及 A 页面时，会显示一个悬浮播放的控件，显示正在播放的背景音频的信息及播放进度。问题是在从 C 页面返回后，如果是从背景音频点击的暂停，悬浮播放控件中显示的当前播放进度会显示从 C 页面返回时的进度，而不是当前播放进度。

分析原因：经过大概1小时的 bug 追踪，发现问题的原因是背景音频播放的监听是在 C 页面内的，在 onPause 监听中，更新全局播放音频信息的代码是如下代码中的第一段，但从 C 页面返回后，C 页面已经销毁了，这时再获取 this.data.tipRecord 是销毁页面前的数据（刚开始这么写的时候我以为会报错），也就是从 C 返回时的数据。将代码修改为第二段，主要是更新全局提示记录的处理是基于全局 store 中的数据，而不是当前页面的 data，该问题就解决了。

在 C 页面中的音频播放监听方法：
```
// 第一段，有问题的
this.backgroundAudioManager.onPause(() => {
    // 全局提示记录处理，更新 store 中的全局信息
    this.setTipRecord({
        ...this.data.tipRecord,
        show: true,
        paused: true,
    });
});

// 第二段，修正后的
this.backgroundAudioManager.onPause(() => {
    // 获取全局 store 中的音频播放信息
    const storeData = this.store.getState();
    // 全局提示记录处理，更新 store 中的全局信息
    this.setTipRecord({
        ...storeData.tipRecord,
        show: true,
        paused: true,
    });
});
```

## 微信用户可能没有头像

在开发打卡生成图片的功能时，很多都需要使用用户的头像，注意会存在没有头像的微信用户，需要处理该种情况。
