---
title: Redux-基础
layout: post
date: 2016-11-19 01:41:22
categories: React
tags: React
---

参考  
[Redux 入门教程（一）：基本用法](http://www.ruanyifeng.com/blog/2016/09/redux_tutorial_part_one_basic_usages.html)  
[Redux 入门教程（二）：中间件与异步操作](http://www.ruanyifeng.com/blog/2016/09/redux_tutorial_part_two_async_operations.html)  
[Redux 入门教程（三）：React-Redux 的用法](http://www.ruanyifeng.com/blog/2016/09/redux_tutorial_part_three_react-redux.html)  

[Redux官方文档](http://redux.js.org/)  
[前30集](https://egghead.io/courses/getting-started-with-redux)  
[后30集](https://egghead.io/courses/building-react-applications-with-idiomatic-redux)  
[action的规范](https://github.com/acdlite/flux-standard-action)  

## Redux简介

先简单说一下Flux。Flux是一种架构思想，专门解决软件的结构问题，它最大特点是数据的"单向流动"。React本身只涉及UI层，如果搭建大型应用，必须搭配一个前端框架，Facebook官方使用的是 Flux框架。[Redux](https://github.com/reactjs/redux)将Flux与函数式编程结合一起，很短时间内就成为了最热门的前端架构。

"如果你不知道是否需要 Redux，那就是不需要它。"  
"只有遇到 React 实在解决不了的问题，你才需要 Redux 。"  

适用场景  

- 用户的使用方式复杂  
- 不同身份的用户有不同的使用方式（比如普通用户和管理员）  
- 多个用户之间可以协作  
- 与服务器大量交互，或者使用了WebSocket  
- View要从多个来源获取数据  

从组件角度看，如果有以下场景，可以考虑使用 Redux

- 某个组件的状态，需要共享  
- 某个状态需要在任何地方都可以拿到  
- 一个组件需要改变全局状态  
- 一个组件需要改变另一个组件的状态  

## 设计思想

（1）Web 应用是一个状态机，视图与状态是一一对应的。  
（2）所有的状态，保存在一个对象里面。

## 工作流程

{% img /2016/11/19/redux-base/ReduxFlow.png  Redux的工作流程 %}

- 用户发出 Action，`store.dispatch(action);`
- Store 自动调用 Reducer，`let nextState = todoApp(previousState, action);`
- State 一旦有变化，Store 就会调用监听函数，监听函数可以通过store.getState()得到当前状态，可以触发重新渲染View

```
// 设置监听函数  
store.subscribe(listener);  
...  
function listerner() {  
  let newState = store.getState();  
  component.setState(newState);   
}
```

## 基本概念

**Store**

Store 就是保存数据的地方，可以把它看成一个容器，整个应用只能有一个Store，Redux提供createStore函数用来生成Store。

**State**

Store对象包含所有数据。如果想得到某个时点的数据，就要对Store生成快照。这种时点的数据集合，就叫做State。当前时刻的State，可以通过store.getState()拿到。Redux 规定， 一个 State 对应一个 View，只要 State 相同，View 就相同，反之亦然。

**Action**

State的变化必须是View导致的，Action就是View发出的通知，描述当前发生的事情，表示State应该要发生变化了。Action是一个对象，其中的type属性是必须的，表示Action的名称，其他属性可以自由设置。

**Action Creator**

 每个Action都手写会很麻烦，用来生成Action的函数就叫Action Creator。

**store.dispatch()**

store.dispatch()是View发出Action的唯一方法，通常会结合Action Creator使用。

**Reducer**

Store收到Action以后，必须给出一个新的State，这样View才会发生变化。这种State的计算过程就叫做Reducer，Reducer是一个函数，它接受Action和当前State作为参数，返回一个新的State。Reducer函数最重要的特征是，它是一个纯函数，只要是同样的输入，必定得到同样的输出。因此，Reducer 函数里面不能改变State，必须返回一个全新的对象。 

实际应用中，Reducer函数不用像上面这样手动调用，store.dispatch方法会触发Reducer 的自动执行。为此，Store需要知道Reducer函数，做法就是在生成Store的时候，将Reducer传入createStore方法，以后每当store.dispatch发送过来一个新的Action，就会自动调用Reducer，得到新的State。createStore方法还可以接受第二个参数，表示State的最初状态，这通常是服务器给出的，如果提供了这个参数，它会覆盖Reducer函数的默认初始值。    

为什么这个函数叫做Reducer呢？因为它可以作为数组的reduce方法的参数，Array.prototype.reduce(reducer, ?initialValue)，一系列Action对象按照顺序作为一个数组，对每个Action调用reducer。请看下面的例子。
```
const actions = [
  { type: 'ADD', payload: 0 },
  { type: 'ADD', payload: 1 },
  { type: 'ADD', payload: 2 }
];
const total = actions.reduce(reducer, 0); // 3
```

**Reducer拆分**

Redux提供了一个combineReducers方法，用于Reducer的拆分，只要定义各个子Reducer函数，然后将它们合成一个大的Reducer。这种拆分与React应用的结构相吻合：一个React根组件由很多子组件构成，子组件与子Reducer完全可以对应。
```
// State的属性名必须与子Reducer同名
const chatReducer = combineReducers({
  chatLog,
  statusMessage,
  userName
});
// 如果不同名，就要采用下面的写法
const reducer = combineReducers({
  a: doSomethingWithA,
  b: processB,
  c: c
});
```

**store.subscribe()**

Store 允许使用store.subscribe方法设置监听函数，一旦State发生变化，就自动执行这个函数。因此，只要把View的更新函数（对于React项目，就是组件的render方法或setState方法）放入listen，就会实现View的自动渲染。store.subscribe方法返回一个函数，调用这个函数就可以解除监听。

## 中间件

{% img /2016/11/19/redux-base/MiddleWares.png  中间件（middleware） %}

中间件就是一个函数，对store.dispatch方法进行了改造，在发出Action和执行Reducer这两步之间，添加了其他功能。
```
let next = store.dispatch;
store.dispatch = function dispatchAndLog(action) {
  console.log('dispatching', action);
  next(action);
  console.log('next state', store.getState());
};
```

**使用中间件**
```
import { applyMiddleware, createStore } from 'redux';
import createLogger from 'redux-logger';
const logger = createLogger();

const store = createStore(
  reducer,
  initial_state, // 整个应用的初始状态，没有可省略该参数
  applyMiddleware(logger) // 中间件的次序有讲究，logger一定要放在最后
);
```

**异步操作的思路**

- 操作开始时，送出一个Action，触发State更新为"正在操作"状态，View重新渲染
- 操作结束后，再送出一个Action，触发State更新为"操作结束"状态，View 再一次重新渲染

方式一：redux-thunk 

异步操作至少要送出两个Action，如何才能在操作结束时，系统自动送出第二个 Action 呢？奥妙就在 Action Creator 之中。
```
// 处理异步的 Action Creator
const fetchPosts = postTitle => (dispatch, getState) => {
  // 先发出一个Action表示操作开始
  dispatch(requestPosts(postTitle));
  // 返回了一个函数
  return fetch(`/some/API/${postTitle}.json`)
    .then(response => response.json())
    // 再发出一个 Action表示操作结束
    .then(json => dispatch(receivePosts(postTitle, json)));
  };
};

// 使用方法一
store.dispatch(fetchPosts('reactjs'));
// 使用方法二
store.dispatch(fetchPosts('reactjs')).then(() =>
  console.log(store.getState())
);
```
这样的处理，就解决了自动发送第二个Action的问题。但是，又带来了一个新的问题，Action是由store.dispatch方法发送的，而store.dispatch方法正常情况下，参数只能是对象，不能是函数。这时，就要使用中间件redux-thunk，改造store.dispatch，使得后者可以接受函数作为参数。

redux-thunk 的实现非常简单：
```
function createThunkMiddleware(extraArgument) {
  return ({ dispatch, getState }) => next => action => {
    if (typeof action === 'function') {
      return action(dispatch, getState, extraArgument);
    }

    return next(action);
  };
}

const thunk = createThunkMiddleware();
thunk.withExtraArgument = createThunkMiddleware;

export default thunk;
```

方式二：redux-promise

另一种异步操作的解决方案，就是让Action Creator返回一个Promise对象。这就需要使用redux-promise中间件，这个中间件使得store.dispatch方法可以接受Promise对象作为参数。  
```
// 写法一，返回值是一个 Promise 对象
const fetchPosts = 
  (dispatch, postTitle) => new Promise(function (resolve, reject) {
     dispatch(requestPosts(postTitle));
     return fetch(`/some/API/${postTitle}.json`)
       .then(response => {
         type: 'FETCH_POSTS',
         payload: response.json()
       });
});

// 写法二，Action 对象的payload属性是一个 Promise 对象
import { createAction } from 'redux-actions';

class AsyncApp extends Component {
  componentDidMount() {
    const { dispatch, selectedPost } = this.props
    // 发出同步 Action
    dispatch(requestPosts(selectedPost));
    // 发出异步 Action
    dispatch(createAction(
      'FETCH_POSTS', 
      fetch(`/some/API/${postTitle}.json`)
        .then(response => response.json())
    ));
  }
}
```

## React-Redux的用法

React-Redux将所有组件分成两大类：UI组件(presentational component)和容器组件(container component)。

UI 组件有以下几个特征：
> 只负责 UI 的呈现，不带有任何业务逻辑  
> 没有状态（即不使用this.state这个变量）  
> 所有数据都由参数（this.props）提供  
> 不使用任何 Redux 的 API  

容器组件有以下几个特征：
> 负责管理数据和业务逻辑，不负责 UI 的呈现  
> 带有内部状态  
> 使用 Redux 的 API

UI组件负责UI的呈现，容器组件负责管理数据和逻辑。如果一个组件既有UI又有业务逻辑，将它拆分成外面是一个容器组件，里面包了一个UI组件，前者负责与外部的通信，将数据传给后者，由后者渲染出视图。React-Redux规定，所有的UI组件都由用户提供，容器组件则是由 React-Redux 自动生成。  

**connect**

connect方法，用于从UI组件生成容器组件，connect的意思，就是将这两种组件连起来。
```
import { connect } from 'react-redux'
const VisibleTodoList = connect()(TodoList);
```
TodoList是UI组件，VisibleTodoList就是由React-Redux通过connect方法自动生成的容器组件。但是，因为没有定义业务逻辑，上面这个容器组件毫无意义，只是UI组件的一个单纯的包装层。为了定义业务逻辑，需要给出下面两方面的信息：  

（1）输入逻辑：外部的数据（即state对象）如何转换为 UI 组件的参数。   
（2）输出逻辑：用户发出的动作如何变为 Action 对象，从 UI 组件传出去。  

**mapStateToProps**

mapStateToProps是一个函数，它建立一个从外部的state对象到UI组件的props对象的映射关系。mapStateToProps会订阅 Store，每当state更新的时候，就会自动执行，重新计算 UI 组件的参数，从而触发 UI 组件的重新渲染。  

mapStateToProps的第一个参数总是state对象，还可以使用第二个参数，代表容器组件的props对象。使用ownProps作为参数后，如果容器组件的参数发生变化，也会引发UI组件重新渲染。

**mapDispatchToProps**

mapDispatchToProps用来建立UI组件的参数到store.dispatch方法的映射，它定义了哪些用户的操作应该当作Action传给Store。它可以是一个函数，也可以是一个对象。

如果mapDispatchToProps是一个函数，会得到dispatch和ownProps（容器组件的props对象）两个参数。
```
// mapDispatchToProps是函数，返回一个对象，该对象的每个键值对都是一个映射，定义了UI组件的参数怎样发出Action，如果有多个Action，可以使用Redux的bindActionCreators
const mapDispatchToProps = ( dispatch, ownProps ) => {
  return {
    onClick: () => dispatch({
      type: 'SET_VISIBILITY_FILTER',
      filter: ownProps.filter
    }),
    onChange: bindActionCreators({// 里面是Action creator
      addTodos,
      deleteTodos
    }, dispatch)
  };
}

// mapDispatchToProps是对象，它的每个键名也是对应UI组件的同名参数，键值应该是一个函数，会被当作Action creator，返回的Action会由Redux自动发出
const mapDispatchToProps = {
  onClick: (filter) => {
    type: 'SET_VISIBILITY_FILTER',
    filter: filter
  };
}
```

**Provider**

Provider组件，可以让容器组件拿到state。Provider在根组件App外面包了一层，这样一来，App的所有子组件就默认都可以拿到state了。它的原理是React组件的context属性，store放在了上下文对象context上面，子组件就可以从context拿到store了。
```
class VisibleTodoList extends Component {
  componentDidMount() {
    const { store } = this.context;
    this.unsubscribe = store.subscribe(() =>
      this.forceUpdate()
    );
  }

  render() {
    const props = this.props;
    const { store } = this.context;
    const state = store.getState();
    // ...
  }
}

VisibleTodoList.contextTypes = {
  store: React.PropTypes.object
}
```

## API的简单实现

**createStore的简单实现**

```
const createStore = (reducer) => {
  let state;
  let listeners = [];

  const getState = () => state;

  const dispatch = (action) => {
    state = reducer(state, action);
    listeners.forEach(listener => listener());
  };

  const subscribe = (listener) => {
    listeners.push(listener);
    return () => {
      listeners = listeners.filter(l => l !== listener);// 什么意思
    }
  };

  dispatch({}); // 干嘛呢

  return { getState, dispatch, subscribe };
};
```

**combineReducer的简单实现**

```
const combineReducers = reducers => {
  return (state = {}, action) => {
    return Object.keys(reducers).reduce(
      (nextState, key) => {
        nextState[key] = reducers[key](state[key], action);
        return nextState;
      },
      {} 
    );
  };
};
```

**applyMiddleware的简单实现**

```
import compose from './compose';

export default function applyMiddleware(...middlewares) {
  return (createStore) => (reducer, preloadedState, enhancer) => {
    var store = createStore(reducer, preloadedState, enhancer);
    var dispatch = store.dispatch;
    var chain = [];

    var middlewareAPI = {
      getState: store.getState,
      dispatch: (action) => dispatch(action)
    };
    chain = middlewares.map(middleware => middleware(middlewareAPI));
    dispatch = compose(...chain)(store.dispatch);

    return {...store, dispatch}
  }
}
```

**redux-promise的简单实现**

```
export default function promiseMiddleware({ dispatch }) {
  return next => action => {
    if (!isFSA(action)) {
      return isPromise(action)
        ? action.then(dispatch)
        : next(action);
    }

    return isPromise(action.payload)
      ? action.payload.then(
          result => dispatch({ ...action, payload: result }),
          error => {
            dispatch({ ...action, payload: error, error: true });
            return Promise.reject(error);
          }
        )
      : next(action);
  };
}
```

**Provider的简单实现**

```
class Provider extends Component {
  getChildContext() {
    return {
      store: this.props.store
    };
  }
  render() {
    return this.props.children;
  }
}

Provider.childContextTypes = {
  store: React.PropTypes.object
}
```
