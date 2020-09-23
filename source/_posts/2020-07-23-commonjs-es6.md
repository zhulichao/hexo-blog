---
title: CommonJS-ES6
layout: post
date: 2020-07-23 09:56:08
categories: JavaScript
tags: JavaScript
---

## CommonJS

CommonJS 规范的出发点：后台 JS 没有模块系统、标准库较少、缺乏包管理工具；为了让 JS 可以在任何地方运行，以达到 Java、C#、PHP 这些后台语言具备开发大型应用的能力。

CommonJS 是服务端模块的规范你，由 nodejs 推广使用。每一个文件就是一个模块，拥有自己独立的作用域、变量、以及方法等，对其它的模块都不可见。CommonJS 规范规定，每个模块内部，module 变量代表当前模块这个变量是一个对象，它的 exports 属性（即module.exports）是对外的接口。加载某个模块，其实是加载该模块的 module.exports 属性，require 方法用于加载模块。

CommonJS 规范加载模块是同步的，输入的是变量的拷贝，也就是说，一旦输出一个值，模块内部的变化就影响不到这个值了。

```js
// test1.js
var x = 5;
var addX = function (value) {
  return value + x;
};

module.exports.x = x;
module.exports.addX = addX;

// test2.js
var app =require('./test1.js');
console.log(app.addX(app.x)); // 10
```

## ES6

历史上，JavaScript 一直没有模块（module）体系，无法将一个大程序拆分成互相依赖的小文件，再用简单的方法拼装起来。其他语言都有这项功能，比如 Ruby 的 require、Python 的 import，甚至就连 CSS 都有 @import，但是 JavaScript 任何这方面的支持都没有，这对开发大型的、复杂的项目形成了巨大障碍。

在 ES6 之前，社区制定了一些模块加载方案，最主要的有 CommonJS 和 AMD 两种。前者用于服务器，后者用于浏览器。ES6 在语言标准的层面上，实现了模块功能，而且实现得相当简单，完全可以取代 CommonJS 和 AMD 规范，成为浏览器和服务器通用的模块解决方案。

ES6 模块的设计思想是尽量的静态化，使得编译时就能确定模块的依赖关系，以及输入和输出的变量。CommonJS 和 AMD 模块，都只能在运行时确定这些东西。ES6 模块输入的是只读的变量的绑定，因为它的本质是输入接口。

```js
// test1.js
export var x = 5;
export function addX(value) {
  return value + x;
}

// test2.js
import { x, addX } from './test1.js';
console.log(addX(x)); // 10
```
