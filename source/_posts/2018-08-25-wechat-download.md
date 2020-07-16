---
title: 小程序下载文件
layout: post
date: 2018-08-25 13:02:46
categories: WeChat
tags: WeChat
---

需求为点击文件列表，可预览文件，可下载文件或以其它方式能在桌面端看文件。首先需要在小程序后台配置业务域名。经探索，需要使用 wx.downloadFile 先下载文件，再使用 wx.saveFile 将下载的临时文件保存到本地，再使用 wx.openDocument 打开保存后的文件。

在 android 手机（华为荣耀8）上，文件下载或保存后，是保存在 `本地/内部存储/Tecent/MicroMsg/wxafiles/此处为appId` 目录中，下载的文件为临时文件，文件以 temp 开头，保存的文件以 store 开头。很奇怪，使用远程调试时输出的路径都是带有后缀的路径，但在文件系统中打开文件查看详情都是没有后缀的，如图1、图2所示。

在小程序中使用 wx.openDocument 打开文件后，在 android 上点击右上角三个点发送到微信传输助手在桌面端打开时都显示为 exec 文件，没办法直接打开，如图3、图4所示，重命名添加后缀后是可以的。

{% img /2018/08/25/wechat-download/directory.png 300 文件目录 %}

{% img /2018/08/25/wechat-download/log.png 300 输出 %}

{% img /2018/08/25/wechat-download/send.jpg 300 发送 %}

{% img /2018/08/25/wechat-download/desktop.png 300 发送 %}

示例代码如下：

```js
Page({
  downloadFile() {
    // 下载文件
    wx.downloadFile({
      url: 'http://example.com/somefile.pdf',
      success: function(res) {
        const tempFilePath = res.tempFilePath;
        // 保存文件
        wx.saveFile({
          tempFilePath,
          success: function (res) {
            const savedFilePath = res.savedFilePath;
            // 打开文件
            wx.openDocument({
              filePath: savedFilePath,
              success: function (res) {
                console.log('打开文档成功')
              },
            });
          },
          fail: function (err) {
            console.log('保存失败：', err)
          }
        });
      },
      fail: function(err) {
        console.log('下载失败：', err);
      },
    });
  },
});
```