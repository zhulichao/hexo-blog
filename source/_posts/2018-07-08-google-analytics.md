---
title: 集成谷歌分析
layout: post
date: 2018-07-08 12:53:24
categories: 数据分析
tags: 数据分析
---

## 网站跟踪

登录 [Google Analytics](https://analytics.google.com/) 后，根据项目情况创建媒体资源并集成到项目中，通常包括以下步骤：

- 初始化跟踪实例
- 上报页面访问事件，集成 Google Analytics 后会自动上报页面访问事件，但现在的应用通常是单页应用，需要特殊处理一下，在路由发生变化时上报页面信息
- 标识用户
  - Google 后台，管理 -> 媒体资源/.js 跟踪信息 -> User-ID，启用 User-ID 功能，可查看示例代码
  - 代码中再获取到用户信息时进行上报，如 `gtag('set', {'user_id': 'USER_ID'});`
  - 清除 cookie 后，将产生一个新用户，即使设置了相同的 user_id
  - 在报告 -> 受众群体 -> 行为 -> User ID 覆盖率中，可查看被标识用户的比例
- 跟踪流量来源
  - 在页面 url 中带有的 `utm_` 系列参数会自动上报，utm_source 是必须的，否则无法收集其它数据
  - 也可通过代码手动上报
  - utm_source，广告系列来源，用于确定具体的搜索引擎、简报或其他来源，如 google 或 weixin
  - utm_medium，广告系列媒介，用于确定电子邮件或采用每次点击费用的广告等媒介，如 cpc 或 appmessage 或 timeline
  - utm_campaign，广告系列名称，用于关键字分析，以标识具体的产品推广活动或战略广告系列，如 spring_sale 或 sharePlan
  - utm_term，广告系列字词，用于付费搜索，为广告提供关键字，如 running + shoes
  - utm_content，广告系列内容，用于 A/B 测试和内容定位广告，以区分指向相同网址的不同广告或链接，如 logolink 或 textlink
- 上报事件，可上报自定义指标和维度
  - 事件类别，如购买
  - 事件操作，如购买成功、购买失败
  - 事件标签，如单品1、单品2

  ```
  gtag('config', config.gaTrackingId, {
    custom_map: {
      dimension1: 'viewerId',
      dimension2: 'activityName',
    },
  });

  gtag('event', '事件操作', {
    event_category: '事件类别',
    event_label: '事件标签',
    viewerId: '维度1',
    activityName: '维度2',
  });
  ```