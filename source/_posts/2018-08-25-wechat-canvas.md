---
title: 小程序 canvas 使用
layout: post
date: 2018-08-25 13:02:51
categories: WeChat
tags: WeChat
---

我们的小程序中有一个功能，会根据用户信息生成图片，并可以保存到相册。第一次是使用前端发起请求，后端生成图片上传到阿里云后给前端返回图片地址，但是上线后发现图片出来的很慢，平均要6~7秒。第二次是使用小程序的 canvas api 在前端绘制图片，可达到平局在3秒左右，但这个过程也遇到了一些问题，描述如下。

### 多屏幕适配问题

设计稿是基于 375 * 667 尺寸的，如果是用 image 显示图片，我们可以通过计算或使用适配的单位来进行多屏适配。但是 canvas 中不能使用适配的单位，但是可以获取到屏幕的宽度，自己计算每一个尺寸应该有多大，比较麻烦。更好的做法是在绘制前使用 canvasContext.scale api 进行缩放，后面直接使用设计稿中固定的尺寸绘制即可。

### 绘制圆形用户微信头像

canvas 中绘制图片时，需要先使用 wx.downloadFile api 下载文件到本地，再使用返回的临时路径绘制图片。注意下载的图片的域名需要添加在 downloadFile 合法域名中，否则 iOS 不显示图片。之后使用 canvasContext.clip api 将图片切成圆形。

### 居中显示不同样式的文字

图片的中间需要显示“第 xxx 天”，整行文字需要居中显示，但数字的字体比较大，因此无法直接使用 canvasContext.setTextAlign api 进行文字居中设置。可使用 canvasContext.measureText
 api 先计算出数字显示需要的宽度，然后将 “第 ” 和 “ 天” 放在计算后的位置居右和距左对齐。

### Modal 形式的图片被 canvas 覆盖

canvas 属于原生组件，层级是最高的，页面中如果有需要弹出 Modal 的地方，是无法显示在 canvas 上面的。经试验，如果使用两个 canvas，是可以达到一个 canvas 在另一个 canvas 上面的，但是因为我们的项目中弹出的 Modal 有一个按钮，因此无法使用这种方式。我们采用了在屏幕的外面绘制图片，绝对定位，top 为负值，然后下载到本地，用 image 标签引用本地路径来显示图片。

### 完整示例代码

```js
// 图片宽度为 330，该值为图片水平居中的位置
const midpoint = 330 / 2;

Page({
  ...
  onLoad(this: PageData, options: Options) {
    const canvasContext = wx.createCanvasContext('clockImage');
    this.canvasContext = canvasContext;
    // 多屏幕适配问题
    canvasContext.scale(
      app.globalData.windowWidth / 375,
      app.globalData.windowWidth / 375,
    );

    canvasContext.drawImage(`../../images/clock_bg.png`, 0, 0, 330, 400);
    canvasContext.setTextAlign('center');
    canvasContext.setFillStyle('white');
    canvasContext.setFontSize(16);
    canvasContext.fillText(`我在这里学习`, midpoint, 124);
    canvasContext.fillText(`坚持学习《占位占位占位占位》`, midpoint, 150);
    canvasContext.setFillStyle('rgba(255, 255, 255, 0.15)');
    canvasContext.fillRect(15, 258, 300, 50);
    canvasContext.setFillStyle('#8FADFF');
    canvasContext.setFontSize(14);
    canvasContext.setTextAlign('left');
    canvasContext.setFillStyle('#fff');
    canvasContext.fillText('The truth is that there is the pinnacle of', 22, 278);
    canvasContext.fillText('justice in practice is to use the truth.', 22, 298);
    canvasContext.setTextAlign('center');

    canvasContext.draw();
    // 用户头像
    this.drawAvatar(wxInfo);
    // 二维码
    this.drawQrcode();
    // 天数
    this.drawDays();
  },
  drawAvatar(this: PageData, wxInfo: WxInfo) {
    const canvasContext = this.canvasContext;
    wx.downloadFile({
      url: 'path to avatar',
      success: res => {
        // 绘制圆形用户微信头像
        canvasContext.beginPath();
        canvasContext.arc(midpoint, 40, 24, 0, 2 * Math.PI);
        canvasContext.clip();
        canvasContext.drawImage(res.tempFilePath, midpoint - 24, 16, 48, 48);
        canvasContext.setFontSize(12);
        canvasContext.draw(true, () => {
          this.setData(
            {
              showAvatar: true,
              canSave: this.data.showDays && this.data.showQrcode,
            },
            () => {
              this.saveTempImage();
            },
          );
        });
      },
      fail: () => {
        this.drawAvatar();
      },
    });
  },
  drawQrcode(this: PageData) {
    const canvasContext = this.canvasContext;
    wx.downloadFile({
      url: 'https://res.wx.qq.com/mpres/htmledition/images/mp_qrcode3a7b38.gif',
      success: res => {
        canvasContext.drawImage(res.tempFilePath, 68, 328, 56, 56);
        canvasContext.draw(true, () => {
          this.setData(
            {
              showQrcode: true,
              canSave: this.data.showAvatar && this.data.showDays,
            },
            () => {
              this.saveTempImage();
            },
          );
        });
      },
      fail: () => {
        this.drawQrcode();
      },
    });
  },
  drawDays(this: PageData) {
    const canvasContext = this.canvasContext;
    // 居中显示不同样式的文字
    canvasContext.setFontSize(48);
    const days = '99';
    const dayWidth = canvasContext.measureText(days).width / 2;

    canvasContext.setFillStyle('#8FADFF');
    canvasContext.setFontSize(16);
    canvasContext.setTextAlign('right');
    canvasContext.fillText('第 ', midpoint - dayWidth, 210);
    canvasContext.setFillStyle('#FF9F65');
    canvasContext.setFontSize(48);
    canvasContext.setTextAlign('center');
    canvasContext.fillText(days, midpoint, 210);
    canvasContext.setFillStyle('#8FADFF');
    canvasContext.setFontSize(16);
    canvasContext.setTextAlign('left');
    canvasContext.fillText(' 天', midpoint + dayWidth, 210);
    canvasContext.draw(true, () => {
      this.setData(
        {
          showDays: true,
          canSave: this.data.showAvatar && this.data.showQrcode,
        },
        () => {
          this.saveTempImage();
        },
      );
    });
  },
  saveTempImage(this: PageData) {
    // 下载图片
    if (this.data.canSave && !this.data.saving) {
      this.setData({
        saving: true,
      });
      wx.canvasToTempFilePath({
        canvasId: 'clockImage',
        success: res => {
          // image 组件的 src 值为 clockImagePath
          this.setData({
            clockImagePath: res.tempFilePath,
          });
          this.setData({
            saving: false,
          });
        },
        fail: () => {
          this.setData({
            saving: false,
          });
        },
      });
    }
  },
});
```

{% img /2018/08/25/wechat-canvas/1.jpeg 300 canvas 绘制的图片 %}

{% img /2018/08/25/wechat-canvas/2.jpeg 300 点击 Modal 效果 %}