---
title: Redux-学习经验
layout: post
date: 2016-11-25 08:47:18
categories: Redux
tags: Redux
---

## 进行网络请求

发起网络请求的操作通常放在组件的componentDidMount方法中，使用redux进行网络请求就是发起一个action，但这个action比较特殊，它的内部还会发起其它action，形式如下：

* 需要使用redux需要使用[redux-thunk](https://github.com/gaearon/redux-thunk)中间件
```
import { createStore, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';
const store = createStore(reducer, initialState, compose(
    applyMiddleware(..., thunk),
    window.devToolsExtension ? window.devToolsExtension() : f => f // 可使用浏览器的Redux DevTools插件进行redux调试
));

```

* action文件主要内容
```
function xxxRequest() {
  return {
    type: REQUEST,
  }
}
function xxxSuccess(data) {
  return {
    type: SUCCESS,
    data: data,
  }
}
function xxxFailure(error) {
  return {
    type: FAILURE,
    error: error,
  }
}
export function xxx(url, objParam) {
  return (dispatch, getState) => {
    dispatch(xxxRequest());
    return fetch(url, {
        method: 'post',
        headers: {
            ...
        },
        body: JSON.stringify(objParam)
    }).then(data => dispatch(xxxSuccess(data)))
      .catch(errors => dispatch(xxxFailure(error)));
  };
}
```

## 保证请求按序进行

使用[redux-sequence-action](https://github.com/jasonslyvia/redux-sequence-action)中间件

这里说的按序请求，不是指上面的发起一个网络请求时发起的多个action的情况，而是指按序发起多个网络请求、每个网络请求是在上个网络请求完成再执行的情况，比如点击保存先调用save网络请求，再调用refresh网络请求。至于为什么不能直接用dispatch(save)，再dispatch(refresh)，是因为进行网络请求是异步的，可能在save请求还没完成，就进行了refresh请求并返回了结果，这时的结果是未更新的结果。

* 安装依赖
```
npm install --save redux-sequence-action
```
* createStore.js中
```
import sequenceAction from 'redux-sequence-action';
...
const store = createStore(reducer, initialState, compose(
    applyMiddleware(invariant(), thunk, sequenceAction),
    window.devToolsExtension ? window.devToolsExtension() : f => f
));
...
```
* containers/下引用的组件中
```

...
class MyComponent extends Component {
    ...
    componentDidMount() {
        // 发起actionA
        this.props.allActions.actionA('a','b');
        // 发起actionC
        this.props.allActions.actionC('c');
    }
    ...
}

function mapStateToProps(state) {
  return state;
}
function mapDispatchToProps(dispatch) {
  return {
    allActions: {
        ...bindActionCreators({
            actionA,
            actionB,
        }, dispatch),
        // actionC中先发起actionB，actionB结束后再发起actionC
        actionC: (arg1, arg2, arg3) => dispatch([actionA(arg1, arg2), actionB(arg3)]),
    },
  };
}
export default connect(mapStateToProps, mapDispatchToProps)(MyComponent);
```
 