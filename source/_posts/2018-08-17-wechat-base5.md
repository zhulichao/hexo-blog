---
title: 微信小程序基础3
layout: post
date: 2018-08-17 14:37:38
categories: WeChat
tags: WeChat
---

以下记录的为开发过程中遇到的零散问题及解决方案。

## 登录流程

{% img https://zhulichao.github.io/2018/08/17/wechat-base5/flow.png 小程序登录流程 %}

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

## 图片存在缓存

小程序中使用的网络图片，如果 url 没有发生变化，但后台更新了图片，使用小程序时可能会存在图片没有更新过来，把小程序从记录中删除了再打开，就可以了。也可以在使用图片的 url 后面添加查询参数 `url + '?' + Dare.parse(new Date())` 的方式不让小程序缓存图片。web-view 中打卡的网页链接也可以这么处理。