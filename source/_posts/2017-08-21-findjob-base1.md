---
title: findjob-base1
layout: post
date: 2017-08-21 10:15:52
categories: JavaScript
tags: JavaScript
---

## react相关

- 为什么不能改变原有state，需要使用setState并传入修改的部分state，执行setState后怎么更新

    是否调用render进行再次渲染是由state是否变化决定的。setState本质是通过一个队列机制实现state更新的，执行setState时，会将要更新的state合并后放入状态队列，而不会立刻更新state，队列机制可以批量更新state。如果不通过setState而直接修改this.state，那么这次state的变化不会放入状态队列中，下次调用setState再进行状态队列进行合并时，会忽略之前直接直接对state修改，这样就无法合并到这次变化，实际也就没有将想要的state更新上去。setState是异步的。

    只要调用了setState，就会在合并后生成一个新的state，只要判断state指向的是否是同一个内存地址就知道state是否发生了变化，以此来决定是否进行render重新渲染。如果不用这种方式都直接操作this.state，也就是同一块内存，要侦测state是否发生变化（如angular中的deepwatch）来决定是否重新渲染会非常复杂和低效。redux的reducer中返回新的对象也是同理。react状态管理库还有redux-sagas、redux-observable、MobX等。

- 为什么组件中定义的方法要bind(this)
        
    ES5里，function内部的this默认为window，在严格模式下，this为undefined。ES5的写法React.createClass会自动绑定每个方法的this到当前组件实例，ES6的写法class XXX extends Component则不会自动为方法绑定this。

    bind()方法会创建一个新函数，当这个新函数被调用时，它的this值是传递给bind()的第一个参数，它的参数是bind()的其它参数和原本参数，这个函数不论怎么调用都有同样的this，也就是当前类的实例，否则this为undefined。绑定this的几种方式：

    ```
    // 方式一
    <div onClick={this.handleClick.bind(this)}>save</div>
    // 方式二
    constructor() {
        ...
        this.handleClick = this.handleClick.bind(this);
    }
    // 方式三
    <div onClick={() => this.handleClick()}>save</div>
    // 方式四
    handleClik = () => {}
    <div onClick={this.handleClick}>save</div>
    // 方式五
    ES6 Decorator,core-decorator.js提供了@autobind修饰器
    ```

    方式一会在每次点击时通过bind创建一个新方法，一般使用方式二、方式三或方式四，其中方式三的箭头函数总是匿名的，如果打算移除监听事件可使用方式四。方式二在构造函数里绑定this后方法是属于实例的，而定义在类里的是非静态函数，在类的`prototype`上，实例的`__proto__`原型上。方式四使用箭头函数定义的方法也是这个效果。

- 数据获取为什么一定要在componentDidMount里面调用
    
    不建议在constructor和componentWillMount里写的原因是：会阻碍组件的实例化，阻碍组件的渲染；在componentWillMount里面触发setState不会重新渲染，在componentDidMount里面会触发setState会重新渲染，有副作用的代码都会集中在componentDidMount方法里。

- webpack codesplit 代码分隔 require
- js 在rn怎么运行的
- 路由 react-router 和 navigator 的区别，react-router怎么实现的，a标签
- Vue, React, AngularJS 对比 http://36kr.com/p/5085661.html

## javascript相关

- 数据类型

    6种数据类型，其中包括5个基本数据类型：String、Number、Boolean、Null、Undefined，按值访问；1个复杂数据类型：Object，按引用访问。

- call、applay和bind的区别

    bind通常用来重新绑定函数体中的this并放回一个具有指定this的函数，多次bind是无效的。call和apply则表示重新指定this并调用返回结果，区别在于call采用多个实参的方式传参，apply则是使用一个数组。

    共同点：第一个参数指定为this，第二个参数起为参数传递。

    不同点：bind是用来返回具有特定this的函数，call和apply都是改变上下文中的this并立即执行这个函数。

- 单页应用(SPA)和多页应用(MPA)

    单页应用将所有的活动局限于一个Web页面中，仅在该Web页面初始化时加载相应的HTML、JavaScript和CSS。一旦页面加载完成了，SPA不会因为用户的操作而进行页面的重新加载或跳转。取而代之的是利用JavaScript动态的变换HTML的内容，从而实现UI与用户的交互。由于避免了页面的重新加载，SPA可以提供较为流畅的用户体验，但不利于SEO。MVVM这类最适合做单页面应用。

    多页面一般每个页面都有一个入口页面，页面跳转用普通的`<a href=\"\"></a>`，会进行整个页面的刷新。

- 发布订阅模式

    订阅发布模式定义了一种一对多的依赖关系，让多个订阅者对象同时监听某一个主题对象。这个主题对象在自身状态变化时，会通知所有订阅者对象，使它们能够自动更新自己的状态。当一个对象的改变需要同时改变其它对象，而且它还不知道具体有多少对象需要改变时，就可以使用订阅发布模式了。

    观察者模式与发布订阅模式很像，虽然两种模式都存在订阅者和发布者（具体观察者可认为是订阅者、具体目标可认为是发布者），区别是观察者模式是由具体目标调度的，而发布订阅模式是统一由调度中心调的，所以观察者模式的订阅者与发布者之间是存在依赖的，而发布订阅模式则不会。

- 属性特性
    
    ES5定义了一个名叫“属性描述符”的对象，用于描述属性的各种特征，只能在Object.defineProperty或Object.defineProperties中使用。属性描述符对象有：

    4个属性：

    > configurable: 可配置性，表示能否修改属性特性，能否把属性修改为访问器属性，或者能否通过delete删除属性从而重新定义属性，默认true。设置为false后，再调用Object.defineProperty修改属性特性都会报错。
    > enumerable: 可枚举性，表示能否通过for-in遍历得到属性，默认true。
    > writable: 可写性，表示能否修改属性的值，默认为true。
    > value: 数据属性，表示属性的值，默认为undefined。
    
    2个存取器属性，分别是get和set，可以代替value和writable，存取器和value、writable不能同时存在：

    > get: 在读取属性时调用的函数，只指定get则表示属性为只读属性，默认值为undefined。
    > set: 在写入属性时调用的函数，只指定set则表示属性为只写属性，默认值为undefined。

    ```
    // 修改obj的name属性特性
    Object.defineProperty(obj, 'name', {
        writable: false,
        value: 'Tom',
    )};
    // 一次修改obj的多个属性特性
    Object.defineProperties(obj, {
        _year: {
            value: 2017,
        },
        edition: {
            value: 1,
            writable: true,
        },
        year: {
            get: function() {
                return this._year;
            },
            set: function() { ... }
        }
    });
    // 读取属性特性
    Object.getOwnPrototypeDescriptor(obj, '_year');
    // 读取所有属性特性
    Object.getOwnPrototypeDescriptors(obj);
    ```

    Object.preventExtensions(obj) 禁止扩展，禁止给对象添加属性和方法，原有的属性可修改
    Object.isExtensible(obj) 检查是否可扩展
    Object.seal() 密封对象，不可扩展、不可删除属性
    Object.isSeal() 检查是否密封
    Object.freeze() 冻结对象，不可扩展、不可删除、不可修改属性
    Object.isFrozen() 检查是否冻结

- 事件冒泡
    
    事件冒泡，从内到外；事件捕获，从外到内；DOM事件流，从外到内再从内到外回到原点。事件冒泡允许多个操作被集中处理，把事件处理器添加到一个父级元素上，避免把事件处理器添加到多个子级元素上，可以优化性能，在页面动态添加新元素后，这些新增的元素也不用再绑定事件，它还可以让你在对象层的不同级别捕获事件。

    blur、focus、load、unload不冒泡。使用addEventListener绑定事件的方法第三个参数可以控制事件触发顺序，true为事件捕获，false为事件冒泡，默认为false。使用attatchEvent绑定事件的方法不能控制事件触发顺序。

    阻止事件冒泡不能阻止对象默认行为，如submit按钮会提交表单数据。

    事件对象：
    ```
    event.keyCode // 返回keydown何keyup事件发生的时候按键的代码
    event.target // 发生事件的目标元素
    event.currentTarget // 当前处理事件的元素
    ```

    阻止冒泡：
    ```
    event.stopPropagation();
    event.stopImmediatePropagation(); // 除了该事件的冒泡行为被阻止之外，该元素绑定的后序相同类型事件的监听函数的执行也将被阻止
    window.event.cancelBubblt = true; // IE下
    ```

    阻止默认行为：
    ```
    event.preventDefault();
    window.event.returnValue = false; // IE下
    ```

- Event on多个事件，off一次全部取消，emit发出事件

    当同一个对象使用.onclick的写法触发多个方法的时候，后一个方法会把前一个方法覆盖掉。而用addEventListener事件监听则不会有覆盖的现象，每个绑定的事件都会被执行。

    ```
    // onclick绑定事件
    window.onload = function() {
        var btn = document.getElementById("yuanEvent");
        btn.onclick = function() {
            alert("第一个事件");
        };
        btn.onclick = function() {
            alert("第二个事件");
        }
    };
    // addEventListener绑定事件
    var eventOne = function() {
        alert("第一个监听事件");
    }
    function eventTwo() {
        alert("第二个监听事件");
    }
    window.onload = function() {
        var btn = document.getElementById("yuanEvent");
        // addEventListener：绑定函数
        btn.addEventListener("click", eventOne); 
        btn.addEventListener("click", eventTwo);
        // removeEventListener：取消绑定
        btn.removeEventListener("click",eventOne); 
    }
    ```

    解决onClick的写法触发后一个方法会把前一个方法覆盖的问题。
    ```
    //统计添加事件监听的个数，0作为预留位
    var eventHandlesCounter = 1;
    function addEvent(obj, evt, fn) {
        if(!fn.__EventID) {
            fn.__EventID = eventHandlesCounter++;
        }
        if(!obj.__EventHandles) {
            obj.__EventHandles = [];
        }
        if(!obj.__EventHandles[evt]) {
            obj.__EventHandles[evt] = [];
            if(obj["on"+evt] instanceof Function) {
                obj.__EventHandles[evt][0] = obj["on"+evt];
                obj["on"+evt] = handleEvents;
            }
        }
        obj.__EventHandles[evt][fn.__EventID] = fn;
      
        function handleEvents() {
            var fns = obj.__EventHandles[evt];
            for (var i=0; i < fns.length; i++) {
                fns[i].call(this);
            }
        }
    }

    function delEvent(obj, evt, fn) {
        if(!obj.__EventHandles || !obj.__EventHandles[evt] || !fn.__EventID){
            return false;
        }
        if(obj.__EventHandles[evt][fn.__EventID] == fn){
           delete obj.__EventHandles[evt][fn.__EventID];
        }
    }
    ```

- session 和 cookie 区别，怎么实现
- localStorage 和 sessionStorage 的区别，没出现之前怎么做的
- 权限用技术怎么实现，用什么技术
- AsyncStorage 做数据库，react-native-store 就是
- CSS盒模型
- js 原型、继承
- dom ready 怎么实现

    window.onload太慢，firefox为DOM纳入一个全新事件 DOMContentLoaded，也就是后来所说的DOMReady，是在DOM树构建完毕执行，ready在onload前加载。
    ```
    // DOM已加载，比onload快，可以有多个，按序执行
    jQuery(document).ready(function() { ... });
    // 没有window.onload的弊端
    $(window).load(function() { ... });
    // 页面关闭时引发
    $(window).unload(function() { ... });

    if (document.addEventListener) {
        document.addEventListener("DOMContentLoaded", fun, false);
    } else if (document.attachEvent) {
        document.attachEvent("onReadyStateChange", fun);
    }
    ```

- Array、String api

## ES6相关

- let、const与var相比

    > 使用未声明的变量，直接报错
    > 重复声明同一个变量，直接报错
    > 是块级作用域
    > 必须声明 'use strict' 后才能使用let声明变量

- 数组的解构赋值，是值的拷贝，不是深拷贝
- 对象的解构赋值，是值的拷贝，不是深拷贝，let {a: { b }} = {a: { b: 1 }} 给b赋值，此时a是未定义的
- 箭头函数
    
    （1）函数体内的this对象，就是定义时所在的对象，而不是使用时所在的对象。
    （2）不可以当作构造函数，也就是不可以使用new命令，否则会抛出错误。
    （3）不可以使用arguments对象，该对象在函数体内不存在，如果要用，可以使用rest参数代替。
    （4）不可以使用yield命令，因为箭头函数不能用作Generator函数。

- Promise 使用及原理
- Promise 和 async await 的关系
- 装饰器 Decorator

## 其它

- 概率的常见面试题
