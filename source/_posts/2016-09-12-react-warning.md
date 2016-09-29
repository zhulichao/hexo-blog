---
title: react-警告
layout: post
date: 2016-09-12 14:52:43
categories:
tags:
---

## 请求数据放在componentDidMount方法中的警告
需要请求数据的，或者使用redux触发action请求数据，最终会更新组件的state时，这种操作最好放在componentDidMount中，我以前总认为这种准备工作要放在constructor方法中，会报下面的警告。
```
Warning: setState(...): Cannot update during an existing state transition (such as within `render` or another component's constructor). Render methods should be a pure function of props and state; constructor side-effects are an anti-pattern, but can be moved to `componentWillMount`.
```

## 类似数组的组件没有key属性的警告
类似数组的组件，如Col、li等，有多个值时需要加key属性，否则会报如下警告。
```
Warning: Each child in an array or iterator should have a unique "key" prop. Check the render method of `AdvSearch`.
```