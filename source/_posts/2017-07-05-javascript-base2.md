---
title: JavaScript-基础2
layout: post
date: 2017-07-05 17:52:50
categories: JavaScript
tags: JavaScript
---

最近参加了一次为时两天的JavaScript培训，回顾课程内容并进行整理，其中参考了如下两篇老师的文章。

[JavaScript编程技法入门](http://mp.weixin.qq.com/s?__biz=MzIxMjE4NzM5MA==&mid=2651782757&idx=2&sn=f7434ba3ed5f2e78eabb4f307f15f4ef&chksm=8cb3bff4bbc436e2cab4f5df12988ee01d52723b640612c6830b15b292ec2b23accc932db7ca#rd)  
[JS编程道场](http://mp.weixin.qq.com/s/suTn-IpXzPXHvw1OZQso7w)

## 简介

函数是第一等公民。
JavaScript的核心是 函数 和 对象 。
```
typeof Number // 'function'
typeof String // 'function'
typeof Function // 'function'
```

## 简化版jquery选择器实现

通过对javascript原生操作的封装，实现简化版的jquery类库。这里的代码并不复杂，个人感觉主要是要有类库的概念和实现思路，考虑将项目中使用的工具类逐步封装成类库。

```
var $ = function(selector) {
    var domObj = document.querySelector(selector);
    var result = {
        '0': domObj,
        show: function() { domObj.style.display = 'none'; },
        hide: function() { domObj.style.display = 'block'; },
        append: function(str) {
            domObj.innerHTML += str;
        },
        val: function(value) {
            if (value === undefined) {
                return domObj.value;
            } else {
                domObj.value = value;
            }
        },
        on: function(action, callback) {
            // 特定浏览器，这里是针对Chrome的写法
            if (domObj.addEventListener) {
                domObj.addEventListener(action, callback);
            }
        }
    };
    return result;
}
```

## 对象

js是解释型动态语言，可随时添加属性或方法，很灵活。
```
var obj1 = new Object();
obj1.name = 'object1';
obj1.getName = function() {
    return this.name;
};
```

推荐使用如下字面量形式的定义方式。
```
var obj2 = {
    name: 'object2',
    getName: function() {
        return this.name;
    }
};
```

遍历对象的属性和方法。
```
for(var key in obj2) {
    console.log(key + '=' + obj2[key]);
}
```

## 函数

函数的三种定义方式如下：

```
// 匿名函数，通过一个变量来指向一个匿名函数，当这个函数不再需要时，JS的运行时环境会自动收集内存垃圾
var func1 = function(name) {
    return 'hello,' + name;
};
// 具名函数，有变量提升，也就是在这段代码的前面是可以调用func2方法的
function func2 (name) {
    return 'hello,' + name;
};
// 函数对象，这也表明了函数其实是Function类型的对象
var func3 = new Function('name', 'return "hello," + name');
```

函数体的内部只有在函数被调用时才会进入，下面demo的运行结果是先后输出1、2、3、4、5。使用Chrome调试断点进入时，打开Sources注意观察Scope的变化，可以看到运行到func1()时Scope只有Globle，当进入到调用的方法时，会有Local，里面是函数内部定义的变量或方法，当函数内部用到了外面的变量时，会有Closure，里面是引用的外部变量。

```
console.log(1);
var func1 = function() {// 进来之后有Local
    console.log(3);
    var a = 0;
    function func2() { // 进来之后有Closure
        console.log(5);
        var f = a + 5;
    }
    console.log(4);
    func2();
}
console.log(2);
debugger;
func1(); // 这时只有Global
```
{% img /2017/07/05/javascript-base2/运行顺序.png 400 运行顺序 %}
{% img /2017/07/05/javascript-base2/调试.gif Chrome调试 %}

## 作用域

this取决于在哪调用，而不是在哪定义，通过“对象.”调用的，this都是这个对象，直接调用的this都是window。

```
var func = function(name) {
    this.name = name;
};
func('jobs'); // 进入func，this是window
var o = {
    setName: func
};
o.setName('jobs'); // 进入func，this是o
var method = o.setName;
method('jobs'); // 进入func，this是window
var obj = new func('jobs');// 进入func，this是obj
```

通过函数的call、apply、bind方法进行调用可改变作用域，call和apply只是传递参数的方式不同。

```
var o = {};
func.call(o, 'jobs'); // 绑定作用域为o
func.apply(o, ['jobs']);
func.bind(o)('jobs');
```

## 模拟类

函数名的第一个字母大写，表示是用来构造对象的，不是用来执行的。

用方式一模拟类，o1和o2有自己的name属性，但第三个输出结果为false，这说明o1.sayHello和o2.sayHello指向不同内存，这样存在内存的浪费。

```
// 方式一
var Person = function(name) {
    this.name = name;
    this.sayHello = function() {};
};
var o1 = {}, o2 = {};
Person.call(o1, 'jobs');
Person.call(o2, 'gates');
console.log(o1.name); // 输出jobs
console.log(o2.name); // 输出gates
console.log(o1.sayHello === o2.sayHello); // 输出false
```

用方式一模拟类，第三个输出结果为true，这时不存在内存浪费了，但破坏了封装，在外部也可以调用sayHello方法。

```
// 方式二
function sayHello() {}
var Person = function(name) {
    this.name = name;
    this.sayHello = sayHello;
};
var o1 = {}, o2 = {};
Person.call(o1, 'jobs');
Person.call(o2, 'gates');
console.log(o1.name); // 输出jobs
console.log(o2.name); // 输出gates
console.log(o1.sayHello === o2.sayHello); // 输出true
```

用方式三模拟类，通过即时函数封装作用域后，可以比较好的模拟类了。

```
// 方式三
var Person = function() {
    // private，在外部无法直接调用
    function sayHello() {}
    var Person = function(name) {
        this.name = name;
        this.sayHello = sayHello;
    };
    // public 
    return Person;
}(); // 即时函数，封装作用域
var o1 = {}, o2 = {};
Person.call(o1, 'jobs');
Person.call(o2, 'gates');
console.log(o1.sayHello === o2.sayHello); // 输出true
```

用方式四模拟类，在即时函数封装作用域的基础上，又添加了命名空间。

```
// 方式四
// 模仿命名空间，可封装类库给别人使用
var cplh = cplh || {};
// 模仿封装
(function(g) {
    // 模仿private，没有加到Person上
    function sayHello() {}
    var Person = function(name) {
        this.name = name;
        this.sayHello = sayHello;
    };
    // 模仿public 
    g.Person = Person;
})(cplh); // 加上括号来说明这是一个表达式
// 模仿初始化
var o1 = {}, o2 = {};
cplh.Person.call(o1, 'jobs');
cplh.Person.call(o2, 'gates');
console.log(o1.sayHello === o2.sayHello); // 输出true
```

## 原型

所有对象都有原型对象`__proto__`，只有函数对象有原型属性`prototype`，当这个函数被用作构造函数来创建实例时，该函数的原型属性(prototype)将被作为原型赋值给所有对象实例，也就达到了重用方法的作用，**即所有实例的原型引用的是函数的原型属性**。

```
var i = 5;
var str = 'abc';
var Person = function() {};
var person = new Person();
// 所有对象都有原型对象
i.__proto__ // 有 [Number: 0]
str.__proto__ // 有 [String: '']
Person.__proto__ // 有 [Function]
// 只有函数对象有原型属性
i.prototype // undefined
str.prototype // undefined
Person.prototype // 有 [Object]
// 所有实例的原型引用的是函数的原型属性
console.log(i.__proto__ === Number.prototype) // 输出true
console.log(str.__proto__ === String.prototype) // 输出true
console.log(person.__proto__ === Person.prototype) // 输出true
```

在执行完 `var Person = function() {};` 语句时，会分配三块内存，Person变量的内存、function函数的内存、protptype指向对象的内存，这个对象的constructor又指向Person指向的函数。

```
var Person = function() {};
console.log(Person);
console.log(Person.prototype); // 输出一个Object，有constructor属性
console.log(Person.prototype.constructor === Person); // true
```

{% img /2017/07/05/javascript-base2/内存.png 内存 %}

JavaScript是动态语言，取决于运行时，不是定义时，因此下面的代码中示例一的对象o是有sayHello方法的。通过如示例二、示例三、示例四的方式给Function、String、jquery等全局函数的prototype添加方法来实现共有的新功能。

```
// 示例一
var o = {};
o.__proto__ = Person.prototype;
console.log(o instanceof Person); // 输出 true
Person.prototype.sayHello = function() {};
console.log(o.sayHello); // 输出 function() {}
```

```
// 示例二
Function.prototype.method = function(name,fn) {
    this.prototype[name] = fn;
    return this;
};
function Person (name) {
    this.name = name;
};
Person.method('sayHello',function() {
     return 'Hello,' + this.name;
}).method('show',function() {
     return 'show';
});
var jobs = new Person('jobs');
console.log('Hello,jobs' === jobs.sayHello()); // 输出 true
console.log('show' === jobs.show()); // 输出 true
```

```
// 示例三
String.prototype.fill = function(id){
    // var sql = "select * from " + this;
    $.getJSON('/' + this, null functon(json, textStatus){
        var data = JSON.parse(json);
        $(id).append(data);
    });
};
// 给id为wellTable01的元素添加从wells表中或接口中查出的数据
"wells".fill('#wellTable01');
```

```
// 示例四
(function(){
    var myMethod = function() {
        console.log('自定义方法');
    };
    $.prototype.myMethod = myMethod;
})();
```

### 实现类

利用原型实现类，注意下面方式一到方式四的区别，方式一到方式三的o对象已经有了sayHello方法，达到了重用方法的目的，但使用了`__proto__`，理论上JavaScript中是不让用的。

```
// 方式一
// 构造函数
var Person = function(name) {
    this.name = name;
};
// 方法体
var proto = {
    sayHello: function(){}
};
// 创建对象
var o = {};
// 赋值方法
o.__proto__ = proto;
// 初始化
Person.call(o, 'jobs');
console.log(o.sayHello);
```

方式二只是将proto作为Person的属性使用的。

```
// 方式二
// 构造函数
var Person = function(name) {
    this.name = name;
};
// 方法体
Person.proto = {
    sayHello: function(){}
};
// 创建对象
var o = {};
// 赋值方法
o.__proto__ = Person.proto;
// 初始化
Person.call(o, 'jobs');
console.log(o.sayHello);
```

```
// 方式三
// 构造函数
var Person = function(name) {
    this.name = name;
};
// 方法体
Person.prototype = {
    sayHello: function(){}
};
// 创建对象
var o = {};
// 赋值方法
o.__proto__ = Person.prototype;
// 初始化
Person.call(o, 'jobs');
console.log(o.sayHello);
```

```
// 方式四
// 构造函数
var Person = function(name) {
    this.name = name;
};
// 方法体
Person.prototype = {
    sayHello: function(){}
};
var o = new Person('jobs');
console.log(Person.prototype.sayHello);
```

方式四使用new创建的对象，也就是说函数Person被用作构造函数来创建实例了，这时该函数prototype将被作为原型`__proto__`赋值给对象的实例，也就相当于如下代码。注意当函数名的第一个字母大写时，表示是用来构造对象的，不是用来执行的，该函数的prototype是给构造出来的对象用的，函数自己用不了。

```
// var o = new Person('jobs'); 等同于以下代码
// 创建对象
var o = {};
// 赋值方法
o.__proto__ = Person.prototype;
// 初始化
Person.call(o, 'jobs');
```

当定义一个当函数被用作构造函时，这个函数会默认在函数体开头和结尾添加如下代码，如果函数return的不是对象，在使用new实例化对象时这个return语句会被忽略，因为需要返回一个对象。

```
function Class() {
    // 默认添加
    var this = {};
    ...
    // 会被忽略，因为需要返回对象
    return 1;
    ...
    // 默认添加
    return this;
}
```

### 实现继承

封装自己的框架，要有类、方法、复用。

```
function Class(options) {
    var Klass = function() {
        // 如果Class有初始化
        if(typeof this.initialize === 'function'){
            this.initialize.apply(this, arguments);
        }
    };
    for(var attr in options) {
        Klass.prototype[attr] = options[attr];
    }
    Klass.extends = function(proto) {
        // 定义子类
        var Child = function() {
            Klass.apply(this, arguments);
        };

        // var f = {};
        // f.__proto__ = this.prototype;
        // // 相当于上面的，不能使用__proto__
        // var f = new Klass();

        // Child.prototype = f;

        // 继承基类
        // 不能使用 Child.prototype = this.prototype; 这样extends添加的方法会影响到基类
        var F = function() {
            /*
            这是定义F函数的原因，如果不显示定义constructor的指向，constructor将指向Object，通过constructor已经无法确定对象的类型了。
            这样显示定义constructor属性的在实例中是可枚举的。
            */
            this.constructor = Child;
        };
        F.prototype = this.prototype;// 继承
        var f = new F();
        Child.prototype = f;

        // 类的实例方法
        for(var attr2 in proto) {
            Child.prototype[attr2] = proto[attr2];
        }
        return Child;
    };
    return Klass;
};

// 方式一
var Person1 = new Class();// 函数对象可以执行
var jobs1 = new Person();
// 方式二
var Person2 = new Class({
    show: function() {}
});
var jobs2 = new Person();
// 方式三
var Person3 = new Class({
    show: function() {}
});
var Actor = Person3.extends({
    sayHello: function(){}
});
var jobs3 = new Actor();
```

{% img /2017/07/05/javascript-base2/继承.png 我对继承的理解 %}

封装商业框架，有Model和View。

```
 var Adobe = (function() {
    var Model = function() {};
    // 实例方法
    Model.prototype = {
        constructor: Model,
        get: function() {},
        set: function() {}
    }
    // 绑定作用域，在context作用域上执行func函数
    function proxy (func, context) {
        return function() {
            func.apply(context, arguments);
        };
    }

    var View = function () {
        //Hack: 绑定事件，这段代码不明白
        var events = this.events || {};
        for(var item in events){
            var func = proxy(this[events[item]], this);
            var reg = /(.+)\s+(.+)/;
            var result = reg.exec(item);
            $(result[2]).bind(result[1], func);
        }
    };

    View.extend = Model.extend = function(options) {
        var Parent = this;
        // 构造函数
        var Klass = function() {
            if(typeof this.initialize === 'function'){
                this.initialize.apply(this, arguments);
            }
            Parent.apply(this, arguments);
        };
        // 继承
        var F = function() {
            this.constructor = Klass;
        };
        F.prototype = this.prototype;
        Klass.prototype = new F();
        Klass.prototype.__super__ = this.prototype;
        // 扩展
        for(var name in options){
            Klass.prototype[name] = options[name];
        }
        return Klass;
    };
    return {
        Model: Model,
        View: View
    }
})();

// 使用代码
var Todo = Adobe.Model.extend({
    initialize: function(title) {
        if(typeof title === 'string'){
            this.set({title: title});
        }
    }
});
var todo = new Todo('Test');
console.log(typeof todo.get === 'function');
console.log(typeof todo.set === 'function');
console.log(typeof todo.initialize === 'function');
```
