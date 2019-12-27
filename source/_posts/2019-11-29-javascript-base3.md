---
title: JavaScript-基础3
layout: post
date: 2019-11-29 15:59:53
categories: JavaScript
tags: JavaScript
---

## includes VS. indexOf

- 返回值类型不同，includes 返回布尔型，indexOf 返回数值，在 if 判断时 includes 更简便
- 如果数组中有 NaN，要判断数组是否有存在 NaN，indexOf 是无法判断的，必须使用 includes
- 当数组有空值的时候，includes 会认为空的值是 undefined，而 indexOf 不会
- 如果要查找某个元素在数组中的位置，该使用 indexOf，如果要判断数组中是否存在某个元素，该使用 includes

## import VS. require

### require

- require 是 AMD 规范引入方式
- require 动态加载，是运行时调用，只能在运行时确定模块的依赖关系及输入/输出，无法进行静态优化，可以出现在任何地方，可以使用通过计算得到的地址
- require 是赋值过程，require 的结果就是对象、数字、字符串、函数等，再把结果赋值给某个变量，是普通的值拷贝传递
- 使用 exports、module.exports 导出

### import

- import 是 ES6 的一个语法标准，如果要兼容浏览器必须转化成 ES5 的语法，import 语法会被转码为 require
- import 静态加载，是编译时调用，必须放在文件开头，支持编译时静态分析，便于 JS 引入宏和类型检验，不能使用通过计算得的到地址
- import 是解构过程，使用 import 导入模块的属性或者方法是引用传递，read-only，单向传递
- 使用 export 导出
