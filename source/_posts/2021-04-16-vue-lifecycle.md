---
title: Vue 生命周期钩子
layout: post
date: 2021-04-16 15:07:27
categories: Vue
tags: Vue
---

参考

- 官方文档 [生命周期钩子](https://cn.vuejs.org/v2/api/#%E9%80%89%E9%A1%B9-%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90)。

- [超详细vue生命周期解析(详解)](https://blog.csdn.net/weixin_42707287/article/details/111641286)

## Vue 生命周期钩子

- beforeCreate
  - 实例初始化后、创建之前调用
  - 没有实例化，不能访问数据
- created
  - 实例创建后调用
  - 能访问到数据，能修改数据且不会触发 update 阶段
  - 异步数据的获取和对实例数据的初始化操作都在这里面进行
- beforeMount
  - 编译模板已经结束，虚拟 DOM 已经存在，真实的 DOM 节点挂载到页面之前调用
  - 能访问到数据，能修改数据且不会触发 update 阶段
- mounted
  - 真实的 DOM 节点挂载到页面之后调用，可以使用 $el、$refs 拿到节点
  - 能访问到数据，能修改数据但会触发 update 阶段
- activated
  - 被 keep-alive 缓存的组件激活时（包括第一次）调用
- deactivated
  - 被 keep-alive 缓存的组件停用时调用
- beforeUpdate
  - 数据更新时调用，发生在虚拟 DOM 打补丁之前
  - 能访问到数据，能修改数据不会再次触发 update 阶段
  - 这里适合在更新之前访问现有的 DOM
- updated
  - 组件 DOM 更新之后调用
  - 能访问到数据，包括 beforeUpdate 修改后的数据，能修改数据会再次触发 update 阶段
  - 应该避免在此期间更改状态，可能会引起死循环
- beforeDestroy
  - 实例销毁之前调用，此时实例仍然完全可用
  - 能访问到数据，能修改数据不会再触发 update 阶段
  - 能访问到 $el
  - 可以清理非vue资源，防止内存泄露
- destroyed
  - 实例销毁之后调用，所有子实例也都销毁了，清除vue实例与DOM的关联
  - 能访问到数据，能修改数据不会再触发 update 阶段
  - 能访问到 $el
- errorCaptured
  - 当捕获一个来自子孙组件的错误时被调用

{% img /2021/04/16/vue-lifecycle/lifecycle1.png 生命周期执行顺序 %}

{% img /2021/04/16/vue-lifecycle/lifecycle2.png 生命周期执行顺序 %}

**注意：**

- 只有在 template 中引用的变量变化时，视图才会更新，否则无论 data 还是 props 变化，都不会触发更新

- 若只有父组件的 data 变化，只更新父组件，子组件不更新

- 执行了销毁，是清除 Vue 实例与 DOM 的关联，页面中 DOM 元素可能仍然存在，Vue Devtools 中没有对应节点了

- 如果有 watch 先进入 watch，再进入 beforeUpdate

- 如果 watch 中又对监听的属性进行了修改，会再次进入 watch，然后再进入 beforeUpdate

{% img /2021/04/16/vue-lifecycle/lifecycle3.png 生命周期执行顺序 %}

## 为什么不能用箭头函数

函数体内的 this 对象，就是定义时所在的对象，而不是使用时所在的对象。this 指向的固定化，并不是因为箭头函数内部有绑定 this 的机制，实际原因是箭头函数根本没有自己的 this，导致内部的 this 就是外层代码块的this。正是因为它没有this，所以也就不能用作构造函数。

箭头函数没有自己的 this，它的 this 是继承而来；默认指向在定义它时所处的对象(宿主对象)，而不是执行时的对象，定义它的时候，可能环境是 window；箭头函数可以方便地让我们在 setTimeout 、setInterval中方便的使用 this。

```js
const obj1 = {
  name: 'ces',
  method: function() {
    console.log(this);
  }
}

obj1.method(); // obj1

const obj2 = {
  name: 'ces',
  method: () => {
    console.log(this);
  }
}

obj2.method(); // undefined
```

类内部自身调用时 this 就是自己的实例，但是如果传给其它地方调用了，this 就变了，所以有了 bind this、箭头函数这种写法。

```js
class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  toString1() {
    console.log('(' + this.x + ', ' + this.y + ')');
  }

  toString2 = () => {
    console.log('(' + this.x + ', ' + this.y + ')');
  }
}

const point = new Point(1, 2);
point.toString1(); // (1, 2)
point.toString2(); // (1, 2)

const obj = {
  x: 3,
  y: 4,
  toString1: point.toString1,
  toString2: point.toString2,
};
obj.toString1(); // (3, 4)
obj.toString2(); // (1, 2)
```
