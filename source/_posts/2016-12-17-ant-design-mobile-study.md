---
title: Ant Design Mobile 组件学习经验
layout: post
date: 2016-12-17 15:32:10
categories: Ant Design
tags: Ant Design
---

## 使用过的组件

TabBar、Toast、ActivityIndicator、Button、SegmentedControl、Tabs、WingBlank、Icon

## 自定义组件样式

参见[有情怀的程序猿](http://www.jianshu.com/p/70b46e305914)

## TabBar组件

使用TabBar组件需注意：

- TabBar.Item必须多余1个否则报错  
- TabBar.Item中包裹的组件要有背景色，否则会重合显示  

## InputItem组件

使用该组件时在Android上无法输入，所以直接使用的React Native的TextInput组件。

## SegmentedControl组件

其实是一个标签的效果，通过在SegmentedControl标签内，根据selectedIndex不同包裹不同的子组件，可以实现内容切换的效果。**但是这种方式每次点击显示的内容都是重新加载的，不像Tabs有缓存的功能。**

## Icon组件

详见[Icon 如何使用-(RN-版)](https://mobile.ant.design/components/icon/#如何使用-(RN-版))，在android上这样配置没问题，在ios上还要参考[issues-1027](https://github.com/ant-design/ant-design-mobile/issues/1027#issuecomment-289643922)。

## RN兼容性及Android兼容性

个人感觉 Ant Design Mobile 当前不太稳定，RN兼容性及Android兼容性都有些问题，如果没有特殊要求且RN中存在满足需求的组件，建议还是使用RN的。

[关于 antd-mobile 对应的 RN 版本使用说明](https://github.com/ant-design/ant-design-mobile/issues/634)  
[组件 RN 版本兼容性测试记录](https://github.com/ant-design/ant-design-mobile/issues/589)  
[SwipeAction在安卓上无效](https://github.com/ant-design/ant-design-mobile/issues/381)  
