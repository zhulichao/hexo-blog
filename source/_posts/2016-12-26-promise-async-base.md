---
title: Promise-Async-基础
layout: post
date: 2016-12-26 09:02:57
categories: ES6
tags: ES6
---

## [Promise对象](http://es6.ruanyifeng.com/#docs/promise)

所谓Promise，简单说就是一个容器，里面保存着某个未来才会结束的事件（通常是一个异步操作）的结果。从语法上说，Promise是一个对象，从它可以获取异步操作的消息。

Promise的特点：

- 对象的状态不受外界影响，Pending（进行中）、Resolved（已完成，又称Fulfilled）和Rejected（已失败），任何其他操作都无法改变这个状态。**这也是Promise这个名字的由来。**
- 一旦状态改变，就不会再变，任何时候都可以得到这个结果，再对Promise对象添加回调函数，也会立即得到这个结果。

Promise的缺点：

- 无法取消Promise，**一旦新建它就会立即执行**，无法中途取消。
- 如果不设置回调函数，Promise内部抛出的错误，不会反应到外部。
- 当处于Pending状态时，无法得知目前进展到哪一个阶段。

**如果某些事件不断地反复发生，一般来说，使用stream模式是比部署Promise更好的选择。**

Promise对象是一个构造函数，用来生成Promise实例，它接受一个函数作为参数，该函数的两个参数分别是resolve和reject。它们是两个函数，由JavaScript引擎提供，不用自己部署。resolve函数的作用是，将Promise对象的状态从Pending变为Resolved，在异步操作成功时调用，并将异步操作的结果作为参数传递出去；reject函数的作用是，将Promise对象的状态从Pending变为Rejected，在异步操作失败时调用，并将异步操作报出的错误作为参数传递出去。Promise实例生成后，可以用then方法分别指定Resolved状态和Rejectded状态的回调函数。

```
var promise = new Promise(function(resolve, reject) {
  // ... some code
  if (/* 异步操作成功 */){
    resolve(value);
  } else {
    reject(error);
  }
});

promise.then(function(value) {
  // success
}, function(error) {
  // failure
});
```

then方法指定的回调函数，将在当前脚本所有同步任务执行完才会执行。
resolve函数的参数除了正常的值以外，还可能是另一个Promise实例，形式如下。这时p1的状态就会传递给p2，也就是说，p1的状态决定了p2的状态。如果p1的状态是Pending，那么p2的回调函数就会等待p1的状态改变；如果p1的状态已经是Resolved或者Rejected，那么p2的回调函数将会立刻执行。由于p2返回的是另一个Promise，所以后面的then语句都变成针对p1了。

```
var p1 = new Promise(function (resolve, reject) {
  // ...
});

var p2 = new Promise(function (resolve, reject) {
  // ...
  resolve(p1);
});

p2.then(function(value) {
  // success
}, function(error) {
  // failure
});
```

如果异步操作抛出错误，状态就会变为Rejected，就会调用catch方法指定的回调函数，处理这个错误。另外，then方法指定的回调函数，如果运行中抛出错误，也会被catch方法捕获。Promise对象的错误具有“冒泡”性质，会一直向后传递，直到被捕获为止。也就是说，错误总是会被下一个catch语句捕获。

```
promise.then(function(posts) {
  // ...
}).catch(function(error) {
  // 处理 getJSON 和 前一个回调函数运行时发生的错误
  console.log('发生错误！', error);
});
```

跟传统的try/catch代码块不同的是，如果没有使用catch方法指定错误处理的回调函数，Promise对象抛出的错误不会传递到外层代码，即不会有任何反应。
**需要注意的是，catch方法返回的还是一个Promise对象，因此后面还可以接着调用then方法。如果没有报错，则会跳过catch方法。**

Node 有一个unhandledRejection事件，专门监听未捕获的reject错误。

```
// 第一个参数是错误对象，第二个参数是报错的Promise实例
process.on('unhandledRejection', function (err, p) {
  console.error(err.stack)
});
```

Promise.all方法用于将多个Promise实例，包装成一个新的Promise实例。p1、p2、p3都是Promise对象的实例，如果不是，就会先调用Promise.resolve方法将参数转为Promise实例。
```
var p = Promise.all([p1, p2, p3]);
```

p的状态由p1、p2、p3决定：

- 只有p1、p2、p3的状态都变成resolved，p的状态才会变成resolved，此时p1、p2、p3的返回值组成一个数组，传递给p的回调函数。
- 只要p1、p2、p3之中有一个被rejected，p的状态就变成rejected，此时第一个被reject的实例的返回值，会传递给p的回调函数。

Promise.race方法同样是将多个Promise实例，包装成一个新的Promise实例。该方法与Promise.all类似，区别是只要p1、p2、p3之中有一个实例率先改变状态，p的状态就跟着改变，那个率先改变的 Promise 实例的返回值，就传递给p的回调函数。
```
var p = Promise.race([p1, p2, p3]);
```

Promise.resolve方法将现有对象转为Promise对象：

- 如果参数是Promise实例，那么Promise.resolve将不做任何修改、原封不动地返回这个实例。
- 如果参数是一个thenable对象（thenable对象指的是具有then方法的对象），那么Promise.resolve将这个对象转为Promise对象，然后就立即执行thenable对象的then方法。
- 如果参数是一个原始值，或者是一个不具有then方法的对象，则Promise.resolve方法返回一个新的Promise对象，状态为Resolved。
- 如果不带任何参数，直接返回一个Resolved状态的Promise对象。

**注意，立即resolve的Promise对象，是在本轮“事件循环”的结束时执行，setTimeout(fn, 0)在下一轮“事件循环”开始时执行。**

Promise.reject(reason)方法也会返回一个新的Promise实例，该实例的状态为rejected。它的参数用法与Promise.resolve方法完全一致。

Promise对象的回调链，不管以then方法或catch方法结尾，要是最后一个方法抛出错误，都有可能无法捕捉到。因此，可以提供一个done方法，总是处于回调链的尾端，保证抛出任何可能出现的错误。

```
Promise.prototype.done = function (onFulfilled, onRejected) {
  this.then(onFulfilled, onRejected)
    .catch(function (reason) {
      // 抛出一个全局错误
      setTimeout(() => { throw reason }, 0);
    });
};
```

finally方法用于指定不管Promise对象最后状态如何，都会执行的操作。它与done方法的最大区别，它接受一个普通的回调函数作为参数，该函数不管怎样都必须执行。

```
Promise.prototype.finally = function (callback) {
  let P = this.constructor;
  return this.then(
    value  => P.resolve(callback()).then(() => value),
    reason => P.resolve(callback()).then(() => { throw reason })
  );
};
```

如果不知道或者不想区分函数f是同步函数还是异步操作，但是想用 Promise 来处理它，像下面这样，会有一个缺点
```
Promise.resolve().then(f)
```
上面的写法有一个缺点，就是如果f是同步函数，那么它会在本轮事件循环的末尾执行。

让同步函数同步执行，异步函数异步执行，并且让它们具有统一的 API，有两种方式：

- 用async函数，但是`async () => f()`会吃掉f()抛出的错误，需要使用promise.catch方法。
- 使用new Promise()。

但是Promise.try为所有操作提供了统一的处理机制，所以如果想用then方法管理流程，最好都用Promise.try包装一下。

## [异步操作和Async函数](http://es6.ruanyifeng.com/#docs/async)

### 异步操作

异步编程的四种方式：回调函数、事件监听、发布/订阅、Promise。

为什么Node约定，回调函数的第一个参数，必须是错误对象err（如果没有错误，该参数就是null）？原因是执行分成两段，第一段执行完以后，任务所在的上下文环境就已经结束了，在这以后抛出的错误，原来的上下文环境已经无法捕捉，只能当作参数，传入第二段。

回调函数在多个回调函数嵌套时，代码不是纵向发展，而是横向发展，很快就会乱成一团，无法管理，称为"回调函数地狱"。Promise对象就是为了解决这个问题而提出的，将回调函数的嵌套，改成链式调用。

Promise的写法只是回调函数的改进，使用then方法以后，异步任务的两段执行看得更清楚了，除此以外，并无新意。Promise的最大问题是代码冗余，不管什么操作，一眼看去都是一堆then，原来的语义变得很不清楚。

Generator函数可以暂停执行和恢复执行，这是它能封装异步任务的根本原因。除此之外，它还有两个特性，使它可以作为异步编程的完整解决方案：函数体内外的数据交换和错误处理机制。

使用Generator函数，执行一个异步任务。

```
var fetch = require('node-fetch');

function* gen(){
  var url = 'https://api.github.com/users/github';
  var result = yield fetch(url);
  console.log(result.bio);
}
/*
 * 执行Generator函数，获取遍历器对象，然后用next方法执行异步任务的第一阶段。
 * 由于Fetch模块返回的是一个Promise对象，因此要用then方法调用下一个next方法。
 */
var g = gen();
var result = g.next();
result.value.then(function(data){
  return data.json();
}).then(function(data){
  g.next(data);
});
```

Thunk函数现在可以用于Generator函数的自动流程管理。下面就是一个基于Thunk函数的Generator执行器。

```
function run(fn) {
  var gen = fn();
  // next函数是Thunk的回调函数
  function next(err, data) {
    var result = gen.next(data);
    if (result.done) return;
    result.value(next);
  }
  next();
}

function* g() {
  // ...
}
run(g);
```

### Async函数

从语法上看，async函数就是将Generator函数的星号（*）替换成async，将yield替换成await。async函数返回一个Promise对象，可以使用then方法添加回调函数。当函数执行的时候，一旦遇到await就会先返回，等到触发的异步操作完成，再接着执行函数体内后面的语句。

async函数对 Generator 函数的改进，体现在以下四点：

- 内置执行器。Generator函数的执行必须靠执行器，所以才有了co模块，而async函数自带执行器。
- 更好的语义。async表示函数里有异步操作，await表示紧跟在后面的表达式需要等待结果。
- 更广的适用性。co模块约定，yield命令后面只能是Thunk函数或Promise对象，而async函数的await命令后面，可以是Promise对象和原始类型的值。
- 返回值是 Promise。async函数的返回值是 Promise 对象，这比 Generator 函数的返回值是 Iterator 对象方便多了。

async函数的语法规则总体上比较简单，难点是错误处理机制：

- async函数返回一个Promise对象。async函数内部return语句返回的值，会成为then方法回调函数的参数。async函数内部抛出错误，会导致返回的Promise对象变为reject状态，抛出的错误对象会被catch方法回调函数接收到。
- async函数返回的Promise对象，必须等到内部所有await命令的Promise对象执行完，才会发生状态改变，除非遇到return语句或者抛出错误。也就是说，只有async函数内部的异步操作执行完，才会执行then方法指定的回调函数。
- 正常情况下，await命令后面是一个Promise对象。如果不是，会被转成一个立即resolve的Promise对象。await命令后面的Promise对象如果变为reject状态，则reject的参数会被catch方法的回调函数接收到。
- 只要一个await语句后面的Promise变为reject，那么整个async函数都会中断执行。为了避免这个问题，可以将await放在try...catch结构里面，这样后面的await就会执行；另一种方法是await后面的Promise对象再跟一个catch方法，处理前面可能出现的错误。

async函数的实现：

```
async function fn(args){
  // ...
}

// 等同于
function fn(args){
  return spawn(function*() {
    // ...
  });
}
function spawn(genF) {
  return new Promise(function(resolve, reject) {
    var gen = genF();
    function step(nextF) {
      try {
        var next = nextF();
      } catch(e) {
        return reject(e);
      }
      if(next.done) {
        return resolve(next.value);
      }
      Promise.resolve(next.value).then(function(v) {
        step(function() { return gen.next(v); });
      }, function(e) {
        step(function() { return gen.throw(e); });
      });
    }
    step(function() { return gen.next(undefined); });
  });
}
```

async 函数的用法：


---

如果某些事件不断地反复发生，一般来说，使用stream模式是比部署Promise更好的选择。