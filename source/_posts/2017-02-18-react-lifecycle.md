---
title: React-生命周期
layout: post
date: 2017-02-18 11:11:56
categories: React
tags: React
---

学了React快一年了，现在用的已经比较顺手了，单个组件的生命周期执行过程已经很清楚了，但是关于多个组件之间怎么进入生命周期方法的还是不确定，现在好好学习一下。

## 单个组件的生命周期过程

组件的生命周期函数按如下顺序执行，每个方法的说明如下：

- constructor

    构造函数，对组件的state进行初始化，对函数进行this绑定。

- componentWillMount

    初始渲染前进入，只执行一次，如果这个函数里调用setState，不会执行渲染操作，而是等这个函数执行完成后再执行初始渲染。如果组件需要从本地存储中读取数据，一般放在这里执行。

- render

    返回值为页面要显示的组件，组件的重新渲染后触发所有子组件的重新渲染。

- componentDidMount

    初始渲染完成后进入，只执行一次。如果组件需要从网络侧读取数据，一般放在这里执行。

- componentWillReceiveProps(nextProps, nextContext)

    组件在初始渲染完成后，当接收到新的props时进入，state发生变化时不会进入，而无论props的内容是否发生变化都会进入。如果在这个函数中调用setState，不会执行渲染操作，而是等该方法执行完成一起渲染。

- shouldComponentUpdate(nextProps, nextState, nextContext)

    当组件接收到新的state或props时，这个函数将被调用，如果返回false可以阻止组件的重新渲染，也就不会进入本组件的componentWillUpdate、componentDidUpdate方法了。通过这个函数来阻止无必要的重新渲染可以提高程序的性能。

- componentWillUpdate(nextProps, nextState, nextContext)

    组件在重新渲染前进入，**切记不能在这个函数中通过setState更新状态，** 如果需要改变，则在componentWillReceiveProps函数中进行改变，否则会导致死循环。

- componentDidUpdate(prevProps, prevState, prevContext)

    组件在重新渲染完成时进入。

- componentWillUnmount()

    组件在卸载前进入，如果组件申请了某些资源或订阅了某些消息，需要要在这个函数中释放资源或取消订阅，常见的是在这里清除定时器。

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/life.gif 单个组件的生命周期过程 %}

## 多个组件的生命周期过程

父组件每次执行过setState更新了state后，无论state内容是否发生变化，都会进行所有子孙组件的重新渲染。

先进入父组件的componentWillUnmount，再进入子组件的componentWillUnmount，就像先进入父组件的componentWillUpdate，再进入子组件的componentWillUpdate一样，只是React没有componentDidUnmount方法，看不到是先卸载子组件完成，再卸载父组件完成的。

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/mount.png 初始化 %}

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/update.png 更新 %}

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/unmount.png 卸载 %}

## forceUpdate函数

forceUpdate函数不是组件的生命周期函数，组件通过调用`this.forceUpdate()`可以强制进行组件的重新渲染，并且会连带所有子组件都重新渲染。通过这种方式的重新渲染，不会进入本组件shouldComponentUpdate方法，会进入子组件的shouldComponentUpdate和componentWillReceiveProps方法及其它生命周期方法。

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/forceUpdate.png forceUpdate操作 %}

## HOC（High Order Component ）高阶组件

参考[初识React中的High Order Component](http://www.tuicool.com/articles/RFJJniN)  
HOC是一个抽象和公用代码的方案，它接受一个包含共用逻辑或者是状态的ReactComponent，并返回一个包含特定逻辑或者是状态的新ReactComponent，相当于对原组件做了一层包装，react-redux中的connect就算是HOC。组件的生命周期执行顺序与父子组件类型的执行顺序一样。

```
class App extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        value: '',
      };
    }
    render() {
      return (
        <input ref="app" value={this.state.value} onChange={this.onChange}/>
      );
    }
};
const connect = (mapStateFromStore) => (WrappedComponent) => {
    class InnerComponent extends React.Component {
      constructor(props) {
        super(props);
      }
      render () {console.log(this)
        return (
          <WrappedComponent ref="middle" />
        );
      }
    }
    // 将新组件返回
    return InnerComponent;
}
const HOC = connect(() => ({}))(App);

class Root extends React.Component {
    render() {console.log(this)
      return (
        <div>
          <HOC ref="hoc"/>
        </div>
      );
    }
}

ReactDOM.render(
    <Root />,
    document.getElementById('example')
);
```

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/hoc.png HOC的ref结构 %}

{% img https://zhulichao.github.io/2017/02/18/react-lifecycle/hocHtml.png HOC渲染出的DOM结构 %}
