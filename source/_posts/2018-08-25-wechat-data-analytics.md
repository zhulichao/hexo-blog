---
title: 小程序数据分析
layout: post
date: 2018-08-25 13:45:13
categories: WeChat
tags: WeChat
---

由于微信自己的机制，无论是用微信公众平台，还是用第三方的数据分析平台，都有可能存在数据不准确的情况。我们的小程序由于能够统计每天的收入情况，对比发现过微信公众平台和诸葛io都存在购买数据的偏差。

## 基于[微信公众平台](https://mp.weixin.qq.com)

微信公众平台中，也就是小程序管理后台，本身提供了基础的数据分析的功能，无需上报数据也能分析一部分数据。也可通过小程序开发文档中提供的自定义数据上报接口 `wx.reportAnalytics` 在代码中上报需要的数据，使用前，需要在小程序管理后台自定义分析中新建事件，配置好事件名与字段。使用小程序管理后台很简单，不用做用户标识，因为微信自己是能通过 openId 区分用户的，无需自己处理，也不用上报场景值和用户画像等基本信息。缺点是，小程序管理后台：

- 不能自定义面板
- 对自定义分析的查询日期跨度不能超过31天
- 不能添加自定义的用户属性，不能创建用户分群
- 不能查看原始数据，更不能下载了
- 没有渠道分析，当然这个可以自己做

## 基于[诸葛io](https://zhugeio.com/)

为了解决小程序管理后台数据分析存在的问题，我们对比了很多支持小程序的数据分析产品，列表如下，最后选择了诸葛io。

- [腾讯移动分析](http://mta.qq.com/mta/ctr_index/opd)
- [阿拉丁小程序统计平台](https://www.aldwx.com/)
- [神策数据](https://www.sensorsdata.cn/manual/mp_sdk.html)
- [TalkingData](https://www.talkingdata.com/)
- [及策](https://jice.io/)
- [易观方舟](https://ark.analysys.cn/)
- [GrowingIO](https://www.growingio.com/)
- [诸葛io](https://zhugeio.com/)

总体来说，诸葛io解决了上述小程序后台存在的所有问题，而且提供了下载原始数据的方式，集成简单，调试也快，后台也可以添加多个用户并授予不同权限。后台创建用户分群、创建面板方式比较简单，不需要工程师去创建，业务人员可以自己创建。缺点就是付费😂，上面也说过了，数据会有些偏差，但是很有可能没办法避免。

## 基于[Google Analytics](https://analytics.google.com/)

小程序中集成 [wxapp-google-analytics](https://github.com/rchunping/wxapp-google-analytics) 后，**按照文档进行操作**，可上报数据到 Google Analytics，经试验以下功能都可正常使用：

- 可上报页面访问，支持自定义维度和指标
- 可上报事件，若要上报自定义维度和指标，需修改 ga.js 文件

```
EventBuilder.prototype.build = function() {
  // 去除无效字段字段
  hit_delete_if(this, 'ev', 0);
  hit_delete_if(this, 'el', '');

  // 添加--处理自定义维度和指标
  var cd_arr = this.custom_dimensions;
  var cm_arr = this.custom_metrics;
  var i;

  for (i = 0; i < cd_arr.length; i++) {
    var cd = cd_arr[i];
    this.hit['cd' + cd[0]] = cd[1];
  }

  for (i = 0; i < cm_arr.length; i++) {
    var cm = cm_arr[i];
    this.hit['cm' + cm[0]] = cm[1];
  }
  // 添加--结束

  return HitBuilder.prototype.build.apply(this, arguments);
};
```

- 渠道分析
- 跟踪场景值
- 跟踪二维码参数
- 可标识用户，清除 storage/_ga_cid 后，将产生一个新用户，这也意味着用户删除小程序后再次进入将作为一个新用户

Google Analytics 中受众群体下的报告反映都很慢，想看到用户数据上报情况很可能第二天才能看到，有时第二天也没看到数据，还需要重新测，很担心线上环境也会出现这种情况。