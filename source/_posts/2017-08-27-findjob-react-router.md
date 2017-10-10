---
title: React Router-简单原理
layout: post
date: 2017-08-27 15:07:53
categories: FJ
tags: React Router
---

以下内容主要参考自
[深入理解 react-router 路由系统](http://www.cnblogs.com/wyaocn/p/5805777.html)
[react-router的实现原理](https://segmentfault.com/a/1190000004527878) 
[前端路由实现与 react-router 源码分析](http://web.jobbole.com/86407/)

- react-router怎么实现页面局部刷新和url变化的

    路由的原理并不复杂，即保证视图和URL的同步，只要URL一致，那么返回的UI界面总是相同的。从性能和用户体验的层面来比较的话，后端路由每次访问一个新页面的时候都要向服务器发送请求，然后服务器再响应请求，这个过程肯定会有延迟。而前端路由在访问一个新页面的时候仅仅是变换了一下路径而已，没有了网络延迟，对于用户体验来说会有相当大的提升。

    在HTML5的historyAPI出现之前，前端的路由都是通过hash来实现的，hash能兼容低版本的浏览器。Web服务并不会解析hash，也就是说#后的内容Web服务都会自动忽略，但是JavaScript是可以通过window.location.hash读取到的，读取到路径加以解析之后就可以响应不同路径的逻辑处理。

    history是HTML5才有的新API，可以用来操作浏览器的session history(会话历史)。基于history来实现的路由可以和最初的路径规则一样，即不带#。用户可能都察觉不到该访问地址是Web服务实现的路由还是前端实现的路由。

    react-router路由系统的核心是history对象，它的很多特性也与React保持了一致，比如声明式组件、组件嵌套、状态机特性等，毕竟它就是基于React构建并且为之所用的。路由进入时装载匹配的组件离开时卸载该组件的策略可以做到合理利用资源，不会一下把所有的组件都装载进来使内存占用飙升，也不会离开时没有卸载而时内存泄漏，每一个路由中声明的组件在渲染之前都会被传入一些props，主要包括history对象和location对象，这两个对象同时存在于路由组件的context中，还可以通过React的context API在组件的子级组件中获取到这两个对象。

    **点击Link后路由系统发生了什么？**

    Link组件最终会渲染为HTML的a标签，它的to、query、hash属性会被组合在一起并渲染为href属性。虽然Link被渲染为超链接，但在内部实现上使用脚本拦截了浏览器的默认行为，然后调用了history.pushState方法。history包中底层的pushState方法支持传入两个参数state和path，在函数体内又将这两个参数传输到createLocation方法中，返回location。系统会将这个location对象作为参数传入到TransitionTo方法中，然后调用window.location.hash或者window.history.pushState()修改了应用的URL，这取决于你创建history对象的方式。同时会触发history.listen中注册的事件监听器。

    接下来请看路由系统内部是如何修改UI的。在得到了新的location对象后，系统内部的matchRoutes方法会匹配出Route组件树中与当前location对象匹配的一个子集，并且得到了nextState。在Router组件的componentWillMount生命周期方法中调用了history.listen(listener)方法。listener会在上述matchRoutes方法执行成功后执行listener(nextState)，nextState对象里面包含location、routes、params、components属性，接下来执行this.setState(nextState)就可以实现重新渲染Router组件。

    **点击浏览器的前进和后退按钮发生了什么？**

    前进与后退的实现，是通过监听popstate以及hashchange的事件，当前进或后退url更新时，触发这两个事件的回调函数。可以简单地把web浏览器的历史记录比做成一个仅有入栈操作的栈，当用户浏览器到某一个页面时将该文档存入到栈中，点击后退或前进按钮时移动指针到history栈中对应的某一个文档。在传统的浏览器中，文档都是从服务端请求过来的。不过现代的浏览器一般都会支持两种方式用于动态的生成并载入页面。

    第一种方式

    location.hash与hashchange事件，这也是比较简单并且兼容性也比较好的一种方式，会在浏览器的URL中添加一个#号，对应history包中的createHashHistory方法，出于兼容性的考虑（ie8+），路由系统内部将这种方式作为创建history对象的默认方法。详细请看下面几点：

    > 使用hashchange事件来监听window.location.hash的变化
    > hash发生变化浏览器会更新URL，并且在history栈中产生一条记录
    > 路由系统会将所有的路由信息都保存到location.hash中
    > 在react-router内部注册了window.addEventListener('hashchange', listener, false)事件监听器
    > listener内部可以通过hash fragment获取到当前URL对应的location对象
    > 接下来的过程与点击`<Link/>`时保持一致

    当然，你会想到不仅仅在前进和后退会触发hashchange事件，应该说每次路由操作都会有hash的变化。确实如此，为了解决这个问题，路由系统内部通过判断currentLocation与nextLocation是否相等来处理该问题。不过，从它的实现原理上来看，由于路由操作hash发生变化而重复调用transitonTo(location)这一步确实无可避免。

    第二种方式

    history.pushState与popstate事件，新的HTML5规范中还提出了一个相对复杂但更加健壮的方式来解决该问题，对应history包中的createBrowserHistory方法，使用这种方式进行路由需要服务端要做一个路由的配置将所有请求重定向到入口文件位置，否则在用户刷新页面时会报404错误。详细请看下面几点：

    > 可以通过window.history.pushState(state, title, path)方法来改变浏览器的URL，实际上该方法同时在history栈中存入了state对象
    > 在浏览器前进和后退时触发popstate事件，然后注册window.addEventListener('popstate', listener, false)，并且可以在事件对象中取出对应的state对象
    > state对象可以存储一些恢复该页面所需要的简单信息，state会作为属性存储在location对象中，这样你就可以在组件中通过location.state来获取到
    > 在react-router内部将该对象存储到了sessionStorage中，也就是上图中的saveState操作
    > 接下来的操作与第一种方式一致

    实际上，上面提到的state对象不仅仅在第二种路由方式中可以使用。react-router内部做了polyfill，统一了API。在使用第一种方式创建路由时你会发现URL中多了一个类似_key=s1gvrm的query，这个_key就是为react-router内部在sessionStorage中读取state对象所提供的。

- react-router中的几类history

    > 老浏览器的history: 主要通过hash来实现，对应createHashHistory
    > 高版本浏览器: 通过html5里面的history，对应createBrowserHistory
    > node环境下: 主要存储在memeory里面，对应createMemoryHistory
    
    上面针对不同的环境提供了三个API，但是三个API有一些共性的操作，将其抽象了一个公共的文件createHistory，createHashHistory、createBrowserHistory、createMemoryHistory只是覆盖其中的某些方法而已。需要注意的是，这里的location跟浏览器原生的location是不相同的，最大的区别就在于里面多了key字段，history内部通过key来进行location的操作。

    ```
    // 内部的抽象实现
    function createHistory(options={}) {
      ...
      return {
        listenBefore, // 内部的hook机制，可以在location发生变化前执行某些行为，AOP的实现
        listen, // location发生改变时触发回调
        transitionTo, // 执行location的改变
        push, // 改变location
        replace,
        go,
        goBack,
        goForward,
        createKey, // 创建location的key，用于唯一标示该location，是随机生成的
        createPath,
        createHref,
        createLocation, // 创建location
      }
    }
    ```

    执行URL前进

    > createBrowserHistory: pushState、replaceState
    > createHashHistory: location.hash=***、location.replace()
    > createMemoryHistory: 在内存中进行历史记录的存储
    
    伪代码如下：
    ```
    // createBrowserHistory(HTML5)中的前进实现
    function finishTransition(location) {
      ...
      const historyState = { key };
      ...
      if (location.action === 'PUSH') ) {
        window.history.pushState(historyState, null, path);
      } else {
        window.history.replaceState(historyState, null, path)
      }
    }

    // createHashHistory的内部实现
    function finishTransition(location) {
      ...
      if (location.action === 'PUSH') ) {
        window.location.hash = path;
      } else {
        window.location.replace(
        window.location.pathname + window.location.search + '#' + path
      );
      }
    }

    // createMemoryHistory的内部实现
    entries = [];
    function finishTransition(location) {
      ...
      switch (location.action) {
        case 'PUSH':
          entries.push(location);
          break;
        case 'REPLACE':
          entries[current] = location;
          break;
      }
    }
    ```

    检测URL回退

    > createBrowserHistory: popstate
    > createHashHistory: hashchange
    > createMemoryHistory: 因为是在内存中操作，跟浏览器没有关系，不涉及UI层面的事情，所以可以直接进行历史信息的回退
    
    伪代码实现如下：
    ```
    // createBrowserHistory(HTML5)中的后退检测
    function startPopStateListener({ transitionTo }) {
      function popStateListener(event) {
        ...
        transitionTo( getCurrentLocation(event.state) );
      }
      addEventListener(window, 'popstate', popStateListener);
      ...
    }

    // createHashHistory的后退检测
    function startPopStateListener({ transitionTo }) {
      function hashChangeListener(event) {
        ...
        transitionTo( getCurrentLocation(event.state) );
      }
      addEventListener(window, 'hashchange', hashChangeListener);
      ...
    }

    // createMemoryHistory的内部实现
    function go(n) {
      if (n) {
        ...
        current += n;
        const currentLocation = getCurrentLocation();
        // change action to POP
        history.transitionTo({ ...currentLocation, action: POP });
      }
    }
    ```

    为了维护state的状态，将其存储在sessionStorage里面:
    ```
    // createBrowserHistory/createHashHistory中state的存储
    function saveState(key, state) {
      ...
      window.sessionStorage.setItem(createKey(key), JSON.stringify(state));
    }
    function readState(key) {
      ...
      json = window.sessionStorage.getItem(createKey(key));
      return JSON.parse(json);
    }

    // createMemoryHistory仅仅在内存中，所以操作比较简单
    const storage = createStateStorage(entries);
    function saveState(key, state) {
      storage[key] = state;
    }
    function readState(key) {
      return storage[key];
    }
    ```