---
title: 微信小程序基础4
layout: post
date: 2018-07-14 11:11:10
categories: WeChat
tags: WeChat
---

## 操作相册权限

点击按钮保存图片到系统相册，默认情况下系统会弹框要求用户允许保存图片或视频到相册，当用户点击允许就是进行了“保存的相册”的授权，但是当用户点击不允许后，再点击按钮保存图片就静默失败了，没有任何反应，因此需要进行该种情况的处理。

微信社区里给出的方案是点击按钮时获取用户授权信息，如果其中有保存到相册的权限，则进行保存；否则，给出提示框引导用户进入权限设置页面。在设置页面如果授权了“保存的相册”，则关闭提示框，否则不关闭提示框，这样用户从设置页面返回后还是能看到提示框，表示并未授权。

示例代码如下：

```js
Page({
    ...
    saveClockImage(this: PageData) {
        wx.getSetting({
            success: settingRes => {
                // 注意此处判断条件，如果从没有过授权或者授权为 true 则进入，如果从没授权过 getSetting 返回是没有 writePhotosAlbum 的，直接进行下载系会弹出系统授权框，此后就都能拿到 writePhotosAlbum 的值了
                if (settingRes.authSetting['scope.writePhotosAlbum'] !== false) {
                    // 下载图片
                    wx.downloadFile({
                        url: this.data.clockImageUri,
                        success: res => {
                            if (res.statusCode === 200) {
                                // 保存到相册
                                wx.saveImageToPhotosAlbum({
                                    filePath: res.tempFilePath,
                                    success: () => {
                                        wx.showToast({
                                            title: '保存成功',
                                            icon: 'success',
                                            duration: 3000,
                                        });
                                    },
                                });
                            }
                        },
                    });
                } else {
                    // 显示自定义的弹出框
                    this.setData({
                        showDialog: true,
                    });
                }
            },
        });
    },
});
```

```html
<view wx:if="{{show}}" class="mask {{show ? 'showMask' : 'hideMask'}}" catchtap="_handleHidden">
    <view class="dialog {{show ? 'showDialog' : 'hideDialog'}}" catchtap="_stopPropagation">
        <view class="title">尚未授权</view>
        <view class="description">尚未授权使用访问你的相册，现在去设置</view>
        <view class="buttonContainer">
            <button class="cancelBtn" bindtap="_handleHidden">取消</button>
            <view class="columnDivider" />
            <!-- 注意 open-type 取值 -->
            <button class="confirmBtn" open-type="openSetting" bindopensetting="_handleConfirm">设置</button>
        </view>
    </view>
</view>
```

{% img https://zhulichao.github.io/2018/07/14/wechat-base4/system.jpeg 300 系统弹框 %}

{% img https://zhulichao.github.io/2018/07/14/wechat-base4/custom.jpeg 300 自定义弹框 %}
