---
title: React-Native-基础3
layout: post
date: 2017-06-17 12:17:23
categories: React Native
tags: React Native
---

已经用react-native开发过3个项目，经过这段时间的使用，对react-native总结如下。

## 优点

- 个人感觉react-native的主要优点还是快速构建页面，无论是使用antd-mobile的组件库还是使用react-native官方提供的组件，都能相对快速的搭建页面，但是，无论使用哪种方式也都存在着同一个问题，就是样式问题，如果要完全按照UI设计做出一套页面，还是不太容易。
- 个人感觉react-native在页面交互上还是比较方便的，可以通过组件、组件提供的方法进行事件的控制，如页面跳转、点击、关联刷新等，目前很少发现有不支持的事件。
- 个人感觉，在android上开发的react-native项目，调试出一版ios的困难并不大，如果开发中使用的第三方依赖都是兼容ios的且不考虑ios适配问题，预计一周时间是可以调出一版兼容ios的。
- 开源的第三方组件比较多，目前使用过的第三方依赖可参考[React-Native-依赖](/2017/04/02/react-native-dependencies/)，而且已经确认友盟、bugtags都可以支持react-native。

## 缺点

### 项目名称修改不方便

react-native项目名称修改不方便，个人认为目前就是不能修改项目名称。使用react-native-cli初始化的项目，android目录和ios目录中都有很多地方使用了项目名称，不是修改根目录文件夹的名称就能修改项目名称的，因此如果想使用已有的稳定项目生成新的项目，只能先初始化一个新的项目，再手动移代码，很不方便。

目前已经试验过针对android的项目名称修改的方法，参见[React-Native-基础1](/2016/11/30/react-native-base/)中“项目名称修改”部分，但针对ios的项目名称修改还没有找到解决办法，因此还不敢使用这种方法。

### 不支持web端

直接使用react-native开发的项目，可以做到兼容android和ios，但不能运行在web端。react-native-web声称能将react-native开发的项目运行在web端，个人只试验过将直接初始化的项目运行在web端，但对于已经使用了很多第三方依赖的项目运行在web端报错了，想要将react-native开发的项目运行在web端不是那么容易的。京东是自己实现了从React Native向React JS进行转换的方案。

### 开发中常见错误

开发中常见两个错误，截图如下，目前只在开发环境有，打包后的生产环境暂时还没发现。开发环境下OOM错误非常频繁，查找react-native在github上的[issues列表](https://github.com/facebook/react-native/issues/13379)建议将使用图片的ListView换成FlatList。

{% img /2017/06/17/react-native-base3/langPressIn.jpg 300 RESPONDER_ACTIVE_LONG_PRESS_IN错误 %}

{% img /2017/06/17/react-native-base3/oom.png 300 OOM错误 %}

### 多个异步请求 redux-saga

在业务逻辑比较复杂、需要多次网络请求及本地数据库操作的情况下，例如下面的业务，写出来的代码会很复杂，原因就是使用redux发起了多个异步action，除了图片上传，个人感觉应该是使用同步请求的逻辑会容易些，因为后面的处理是基于前一个请求结果进行的，但fetch没有同步请求方法，所以逻辑写起来就复杂些。目前已知的解决发起多个异步请求的方法有redux-sequence-action和redux-sage，redux-sequence-action在web端使用过，但感觉还是有些局限，redux-sage应该是比较好的解决方案，但目前还没研究过怎么使用。

“带有图片的本地数据进行web端提交后，无论提交是否成功，都需要进行本地保存；如果提交成功，根据请求返回结果删除本地业务数据、更新图片关系表，再将图片上传到web端，并根据图片上传成功的返回结果更新本地图片关系表。”

### 打包耗时

打包问题，就像react-native项目有时需要很多次启动才能启动成功（最多一次启动了6、7次），打包通常也是需要多次，几乎没有一次就能打包成功的时候，这时候代码不能修改，只能干等，后期希望引入持续集成解决这个问题，也能解决使用不同机器打的包可能不一致的问题。

### 其它问题

- 样式不好调整，如果要完全按照UI设计做出一套页面，还是不太容易，而且目前还做过屏幕适配，不知道好不好处理
- react-native版本升级有时变动较大，如0.44去掉了Navigator和BackAndroid，最主要的是许多第三方依赖对高版本rn支持的不好
- react-native或其它组件可能存在手机适配问题，目前发现的是在工程机“VT5000”上，ListView的Item如果包装了滑动删除，几乎无法触发Item的onPress事件
- 开发环境和打包后的生产环境可能不一致，具体原因还不清楚，怀疑是开发时打开浏览器调试能使用了一些浏览器的解析功能，导致离开浏览器的打包后的生产环境可能存在问题
- 数据库操作使用的[react-native-sqlite-storage](https://github.com/andpor/react-native-sqlite-storage)，个人感觉还是不太好用，多个查询的嵌套看上去很乱，写起来也不方便
- 本人没有做过原生开发，不了解更新升级，京东在GMTC会议演讲中提到更新升级需要依赖第三方框架，在我目前的项目中更新升级时本地库的处理还没有查找解决方案
- Small等插件化框架是支持原生的，目前没有看到支持react-native的文档，有没有支持react-native插件化的框架还不清楚
- 复杂场景下内存性能有瓶颈，页面跳转可能卡顿，有些偶发问题很难复现也不好定位原因，目前发现的是ListView中数据重复的问题，还没定位原因
- react-native项目运行时有时需要android studio先编译，这就需要保持开发人员android studio环境的一致，有时候我运行项目没问题，但其它人运行就有问题，需要打开android studio看一下编译信息
