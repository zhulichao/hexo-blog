---
title: Ant Design Mobile 组件注意
layout: post
date: 2017-05-21 00:03:42
categories: Ant Design
tags: Ant Design
---

##  注意点

- Popover、Progress外面如果没有View并且给高度的话可能不显示，外层是ScrollView应该也可以显示
- Tabs最好指定activeKey否则可能有奇怪的返回第一个TabPane问题
- SwipeAction放在TouchableHighlight外，否则会报 undefined is not an object (evaluation 'this.refs.swipeoutContent.measure') 错误

## 存在问题

- PickerView 编辑不了，官方也没有给出RN上的demo
- Range 使用不了，直接红屏报错`Expected a component class,got [object Object]`
- Steps 不能水平方向
- ListView中使用SwipeAction时效果不好，左右滑动会触发上下滑动，造成ListView滚动，不容易出现删除按钮，在部分Android机型上，目前已知的是“VT5000”上，点击时触发的是SwipeAction的onOpen方法，很少会触发ListView的onPress方法
- Tabs.TabPane 在官网上写的tab属性支持 React.Element，目前经过确认是不支持的
