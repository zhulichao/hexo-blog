---
title: JavaScript-练习题
layout: post
date: 2019-12-10 15:47:29
categories: JavaScript
tags: JavaScript
---

```javascript
var a = 100;
function testResult() {
  var b = 2 * a;
  var a = 200; // 这里的 a 会覆盖外面的 a
  var c = a / 2;
  console.log(b, c); // NaN 100
}
testResult();
```

```javascript
function createFunctions() {
  var result = new Array();
  for(var i = 0; i < 10; i++) {
    var j = i;
    result[i] = function() {
      return j; // j 存在变量提升，循环结束后 j 为 9
    }
  }
  return result;
}
createFunctions().forEach(item => console.log(item())) // 10 个 9
```

```javascript
var myObject = {
  foo: 'bar',
  func: function() {
    var self = this;
    console.log('outer func:this.foo = ', this.foo); // bar
    console.log('outer func:self.foo = ', self.foo); // bar
    (function(){// 立即执行函数，没有 this
      console.log('inner func:this.foo = ', this.foo); // undefined, this 指向 window
      console.log('inner func:self.foo = ', self.foo); // bar
    }());
  }
};
myObject.func();
```
