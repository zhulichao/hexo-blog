---
title: React-基础知识
layout: post
date: 2017-08-26 14:22:55
categories: FJ
tags: React
---

- react的优缺点
    
    优点：
    
    > 虚拟dom加diff算法减少dom操作来提高渲染性能
    > 虚拟dom也帮助我们解决了跨浏览器问题  
    > 使用声明式语法JSX来重新定义视图开发
    > 代码更加模块化，重用代码更容易  
    > 单向数据流，灵活、可预计、可控制  
    > 将DOM操作抽象为状态的改变  
    > 只从this.props和this.state生成HTML，非常的函数式编程  
    > 能够快速上手react-native开发ios或者android项目

    缺点：

    > 本身只是View，如果是大型项目基本都需要加上React Router和Redux  
    > 大多数坑没踩出来  

- AMD(Asynchronous Module Definition)、CMD(Common Module Definition)、CommonJS

    AMD、CMD、CommonJS是JS模块化开发的标准，CommonJS是用在服务器端的，同步的，如Node.js。AMD、CMD是用在浏览器端的，异步的，如RequireJS和SeaJS。其中，AMD先提出，CMD是根据CommonJS和AMD基础上提出的。 

    CommonJS 加载模块是同步的，所以只有加载完成才能执行后面的操作。像Node.js主要用于服务器的编程，加载的模块文件一般都已经存在本地硬盘，所以加载起来比较快，不用考虑异步加载的方式，所以CommonJS规范比较适用。但如果是浏览器环境，要从服务器加载模块，这是就必须采用异步模式，所以就有了AMD和CMD解决方案。 
    
    AMD和CMD的区别有以下几点： 

   
    > **AMD推崇依赖前置，CMD推崇依赖就近。AMD和CMD最大的区别是对依赖模块的执行时机处理不同** 
    > 对于依赖的模块AMD是提前执行，CMD是延迟执行。不过RequireJS从2.0开始，也改成可以延迟执行。 
    > AMD的api默认是一个当多个用，CMD严格的区分推崇职责单一。例如：AMD里require分全局的和局部的。CMD里面没有全局的require，提供seajs.use()来实现模块系统的加载启动。CMD里每个API都简单纯粹。 
    
    UMD(Universal Module Definition 通用模块规范)，因为AMD，CommonJS规范是两种不一致的规范，虽然他们应用的场景也不太一致，但是人们仍然是期望有一种统一的规范来支持这两种规范。于是，UMD规范诞生了。

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

- webpack 打包常用

    > webpack.optimize.CommonsChunkPlugin 分离应用和第三方

    > webpack.optimize.UglifyJsPlugin 清除打包后文件中的注释和copyright

    > webpack.optimize.DedupePlugin 保证重复的代码不被打包到bundle文件

    > extract-text-webpack-plugin 独立打包样式

    > optimize-css-assets-webpack-plugin css去重 
    
    > html-webpack-plugin 根据模板创建html入口文件，为引入的外部资源如script、link动态添加每次compile后的hash，防止引用缓存的外部文件问题

    > require.ensure 代码分割，可跟react-router的getComponent配合使用

    常用loader：style-loader、css-loader、less-loader、url-loader、file-loader、babel-loader、react-hot

- redux-thunk源码

    ```
    // ES6 写法
    function createThunkMiddleware(extraArgument) {
      return ({ dispatch, getState }) => next => action => {
        if (typeof action === 'function') {
          return action(dispatch, getState, extraArgument);
        }
        return next(action);
      };
    }

    // ES5写法
    function createThunkMiddleware(extraArgument) {
      return function (_ref) {
        var dispatch = _ref.dispatch,
            getState = _ref.getState;
        return function (next) {
          return function (action) {
            if (typeof action === 'function') {
              return action(dispatch, getState, extraArgument);
            }
            return next(action);
          };
        };
      };
    }
    ```

- web端路由react-router和react-native的navigator有什么区别

    纯属个人理解：web端路由是保证url和UI一致的，进行的是局部刷新；react-native的Navigator是管理导航堆栈的，让用户清楚的知道自己当前所处的页面和返回的页面，进行的是整屏刷新。

- Vue，React，Angular

    Vue。轻量级框架，双向数据绑定，语法和原理所需要的学习成本不是很高。具有高覆盖率的文档，绝大部分操作已被记录在案。但是如果一个操作没有文档记录，能在线上找到解决方案的几率也很小，因为Vue不如Angular或React更流行。Vue也有被称为Flux架构实现的Vuex，移动端跨平台方案Weex使用Vue的语法，但是Weex并不太完善。

    React。React通过使用VirtualDOM获得高效，单向数据流，可以使用JSX语法。与框架相关的Redux是一个非常棒的类Flux架构的实现，掌握React的知识后，可以直接上手基于ReactNative的移动客户端开发。随着React将会有一个能够向后兼容的重写版React Fiber的消息放出，React的"第二春"很快就会到来。

    AngularJS。以HTML为中心，适配和扩展了传统的HTML来呈现动态内容，双向数据绑定，自定义指令，是一个比较完善的前端框架，适合大型项目。入门很容易，但框架复杂、深入后概念很多，学习中较难理解，文档例子非常少。使用脏检查，当watcher越来越多时会变得越来越慢。