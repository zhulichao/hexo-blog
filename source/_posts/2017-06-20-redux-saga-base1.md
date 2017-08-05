---
title: Redux-saga-基础(未完成)
layout: post
date: 2017-06-20 11:36:03
categories: Redux
tags: Redux
---
参考  
[Redux-saga 中文文档](http://leonshi.com/redux-saga-in-chinese/index.html)  
[redux-saga](https://github.com/redux-saga/redux-saga)  
[redux-saga-beginner-tutorial](https://github.com/redux-saga/redux-saga-beginner-tutorial) 有点简单  
[redux-saga-chat-example](https://github.com/kuy/redux-saga-chat-example) 有点复杂  
[redux-saga-examples](https://github.com/kuy/redux-saga-examples) 有好几个例子

## Redux-saga简介

redux-saga 是一个用于管理 Redux 应用异步操作的中间件。Sagas 是通过 Generator 函数来创建的，因为使用了 Generator，redux-saga 让你可以用同步的方式写异步代码。

Sagas 不同于 Thunks，Thunks 是在 action 被创建时调用，而 Sagas 只会在应用启动时调用（但初始启动的 Sagas 可能会动态调用其他 Sagas）。 Sagas 可以被看作是在后台运行的进程。**Sagas 监听发起的 action，然后决定基于这个 action 来做什么：是发起一个异步调用（比如一个 Ajax 请求），还是发起其他的 action 到 Store，甚至是调用其他的 Sagas。**

在 redux-saga 的世界里，所有的任务都通用 yield Effects 来完成（译注：Effect 可以看作是 redux-saga 的任务单元）。

## 基本概念

当 Saga 启动了（不管是初始启动或是稍后动态启动），middleware 会自动将它的 take / put 连接至 store。 这 2 个 Effect 可以被看作是一种 Saga 的输入/输出（Input/Output）。

**call**

call 创建了一条描述结果的信息，不立即执行异步调用，还有apply，像js的call和apply，也可以使用 call Effect 进行同步调用，call 不仅可以用来调用返回 Promise 的函数。我们也可以用它来调用其他 Generator 函数，同步的
call 和 apply 非常适合返回 Promise 结果的函数

**cps**

cps 可以用来处理 Node 风格的函数，表示的是延续传递风格

**take**

take 就像 call 和 put，它创建另一个命令对象，告诉 middleware 等待一个特定的 action，它将会暂停 Generator 直到一个匹配的 action 被发起了

**fork**

fork 任务会在后台启动，调用者也可以继续它自己的流程，而不用等待被 fork 的任务结束，异步的

**cancel**

 如果任务仍在运行，它会被中止，如果任务已完成，那什么也不会发生。一旦任务被 fork，可以使用 yield cancel(task) 来中止任务执行。取消正在运行的任务，将抛出 SagaCancellationException 错误。未被捕获的 SagaCancellationException 不会向上冒泡。yield cancel(task) 不会等待被取消的任务完成（即执行其 catch 区块）。
  /*
  const [users, repos] = yield [
    call(fetch, '/users'),
    call(fetch, '/repos')
  ];
  generator 会被阻塞直到所有的 effects 都执行完毕，或者当一个 effect 被拒绝 （就像 Promise.all 的行为）
  */
 
**race**

 race 同时启动多个任务，但又不想等待所有任务完成，只希望拿到胜利者，即第一个被 resolve（或 reject）的任务；它会自动取消那些失败的 Effects
  yield call(delay, 1000)

**put**

put 这个函数用于创建 dispatch Effect



  使用 take 组织代码有一个小问题。在 takeEvery 的情况中，被调用的任务无法控制何时被调用， 它们将在每次 action 被匹配时一遍又一遍地被调用。并且它们也无法控制何时停止监听。
而在 take 的情况中，控制恰恰相反。与 action 被 推向（pushed） 任务处理函数不同，Saga 是自己主动 拉取（pulling） action 的。 看起来就像是 Saga 在执行一个普通的函数调用 action = getNextAction()，这个函数将在 action 被发起时 resolve。

**takeEvery**

takeEvery 在每个 action 来到时派生一个新的任务

**takeLatest**

**isCancelError**


## 使用

使用redux-saga写todo
