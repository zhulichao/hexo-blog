---
title: 小程序基础 api
layout: post
date: 2018-08-25 13:01:59
categories: WeChat
tags: WeChat
---

## 登录、授权

因为调用后台的请求都需要带着 cookie，所以一定是先执行登录逻辑。在 app.ts 的 onLaunch 方法中，执行 wx.login 拿到 code 再调用后台的登录方法，登录成功后保存 cookie，查询用户信息 viewer，再进行获取用户信息授权的操作，获取用户信息后调用后台方法记录到数据库。

```
import { setCookie } from './actions/cookie';
import { LocationParam, updateLocation } from './actions/router';
import { setUserInfo } from './actions/userInfo';
import config from './config';
import configureStore from './configureStore';
import { query } from './createApolloClient';
import updateOwnerInfo from './graphql/updateOwnerInfo';
import viewer from './graphql/viewer';
import Provider from './utils/Provider';

const configuredStore = configureStore();

const appConfig: wx.AppParam = {
  getUserInfo() {
    wx.getUserInfo({
      fail: () => {
        this.globalData.authorized = false;
        wx.redirectTo({
          url: '/pages/authorize/authorize',
        });
      },
      success: res => {
        this.saveUserInfo(res.userInfo);
        // 后台保存用户信息
        query({
          query: updateOwnerInfo,
          variables: {
            input: {
              wxInfo: res.userInfo,
            },
          },
        });
      },
      withCredentials: true,
    });
  },
  saveUserInfo(userInfo: wx.UserInfo) {
    this.globalData.authorized = true;
    configuredStore.store.dispatch(setUserInfo(userInfo));
  },
  onLaunch() {
    wx.showLoading({
      title: '加载中',
      mask: true,
    });
    // 登录
    wx.login({
      success: res => {
        if (res.code) {
          wx.request({
            url: `${config.requestUrl}/api/login`,
            data: {
              code: res.code,
            },
            method: 'POST',
            success: (requestRes: any) => {
              console.log('登录成功===', requestRes);
              const cookie = requestRes.data.cookie || '';
              this.globalData.cookie = cookie;
              configuredStore.apolloClient.query({
                query: viewer,
              });
              configuredStore.store.dispatch(setCookie(cookie));
              wx.hideLoading();
              // 授权，放着这里是因为获取用户信息后需要同步到后端，需要 cookie
              this.getUserInfo();
            },
          });
        } else {
          console.log('登录失败===', res);
        }
      },
    });
    // 记录屏幕宽度
    this.globalData.windowWidth = wx.getSystemInfoSync().windowWidth;
  },
  onHide() {
    // 小程序退到后台时触发
    // configuredStore.persistStore();
  },
  onLocationChange(param: LocationParam) {
    configuredStore.store.dispatch(updateLocation(param));
  },
  globalData: {
    authorized: false,
    cookie: '',
    apolloClient: configuredStore.apolloClient,
    query,
    persistStore: configuredStore.persistStore,
    store: configuredStore.store,
  },
};

App(Provider(configuredStore.store)(appConfig));
```

但是这里存在一个问题，常见的出现时机是在分享出去的页面，虽然也会先进入 app.ts 文件，但是这里的 login 还没有返回就执行了其它 Page 页面的网络请求，这些网络请求就会报没有权限，而在 login 成功后有了 cookie，也没有办法触发重新发起网络请求。正常的思路应该是等待 app.ts 中初始化的一系列操作完成后再进入其它 Page 页面，但是目前无法达到这个效果，小程序社区中也有人提出相同的疑惑。目前只能在分享出去的页面中发起网络请求的地方进行统一的 cookie 验证，如果没有登录则先进行登录，但是可能存在进行两次 login 请求的问题。

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

{% img https://zhulichao.github.io/2018/08/25/wechat-api/system.jpeg 300 系统弹框 %}

{% img https://zhulichao.github.io/2018/08/25/wechat-api/custom.jpeg 300 自定义弹框 %}

## 分享

关于分享的逻辑参考[官方文档](https://developers.weixin.qq.com/miniprogram/dev/api/share.html#onshareappmessageoptions)就可以，经过试验结论如下：withShareTicket 参数，只有在分享到一个群时（非个人、非多个群），在 success 回调中才可以获取到 shareTickets 值，经过 wx.getShareInfo 及解密的处理可以拿到群对当前小程序的唯一 ID，wxml 中使用 `<open-data type="groupName" open-gid="xxxxxx" />` 可展示群名称。如果想进行任意的分享及打开分享时能进行关联关系的绑定，还是需要使用 path 中传入参数的形式，自己制定参数规则进行处理。

目前小程序无法直接分享到朋友圈，社区中有提供方案在后端生成小程序码，返回图片给前端，用户自己将图片保存到相册，然后自己在朋友圈转发。但是，社区中也有描述因诱导分享朋友圈审核不通过的。

## 支付

先请求后台创建订单，拿着订单 ID 获取支付参数，然后再执行 `wx.requestPayment` 发起支付。

```
// 创建订单
app.globalData.query({
    query: createOrderMutation,
    variables,
}).then((createOrderRes: any) => {
    if (createOrderRes.errors) {
        wx.showToast({
            title: '创建订单失败',
            icon: 'none',
        });
    } else {
        // 获取支付参数
        wx.request({
            url: `${config.requestUrl}/api/beecloud/forward`,
            data: {
              bill_no: createOrderRes.data.createOrder.id,
            },
            header: {
              cookie: app.globalData.cookie,
            },
            method: 'POST',
            success: (requestRes: any) => {
                // 发起支付
                wx.hideLoading();
                wx.requestPayment({
                    timeStamp: requestRes.data.timestamp,
                    nonceStr: requestRes.data.nonce_str,
                    package: requestRes.data.package,
                    signType: requestRes.data.sign_type,
                    paySign: requestRes.data.pay_sign,
                    success: () => {
                        // 支付成功后的操作
                        ...
                    },
                });
            },
        });
    }
}).catch((createOrderError: any) => {
    throw createOrderError;
});
```