---
title: React-警告
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

## react组件销毁后渲染其它组件报警告

可以将react组件销毁后渲染其它组件报警告
```
const dom = document.getElementById('item_code');
if (dom !== null) {
    ReactDOM.unmountComponentAtNode(dom);
    ReactDOM.render(<Input placeholder="这是新渲染的组件"/>, dom);
}
```

{% img /2016/09/12/react-warning/unmountWarning.png 结果如图 %}

## IE11下报的render中Object类型错误

```
Unhandled promise rejection Invariant Violation: Objects are not valid as a React child (found: [object Generator]). If you meant to render a collection of children, use an array instead or wrap the object using createFragment(object) from the React add-ons. Check the render method of `QueryChoose`.
```

原因是jsx中调用generator函数返回的结果没有进行解构。将
```
this.state.customScript['customRender']()
```
改为
```
[...this.state.customScript['customRender']()]
```

## IE11下报的deprecated错误

```
Warning: isMounted(...) is deprecated in plain JavaScript React classes. Instead, make sure to clean up subscriptions and pending requests in componentWillUnmount to prevent memory leaks.
Warning: replaceState(...) is deprecated in plain JavaScript React classes. Refactor your code to use setState instead (see https://github.com/facebook/react/issues/3236).
```

这个很奇怪，是发现在根组件App的render方法中有`console.log(this);`导致的警告，不明白为什么。