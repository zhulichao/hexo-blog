---
title: React-学习经验1
layout: post
date: 2016-09-12 14:05:21
categories: React
tags: React
---

## React基础知识

**React** 是一个声明式、高效、灵活的、创建用户界面的JavaScript库，本质是将图形界面（GUI）函数化。

**Universal渲染** 指的是一套代码可以同时在服务端和客户端渲染。

**Redux** 是一个JavaScript状态容器，提供可预测的状态管理。

**Webpack** 是当下最热门的前端资源模块化管理和打包工具。

**开发服务器**是可以为程序提供资源服务的服务器。通常情况下，在页面中引入的脚本文件等静态资源都放在硬盘中，使用了开发服务器，这些资源将被读到内存里，然后可以通过开发服务器的端口访问这些资源。webpack-dev-server就是开发服务器。

**组件** 是一个函数或类，它决定了如何把数据变为视图。ReactElement是一个普通对象，描述了组件实例或DOM节点；组件实例则是组件类的实例化对象。

**ReactElement** 就是大名鼎鼎的“虚拟DOM”，其本质是一个不可变对象，描述了一个组件的实例或一个DOM节点，包含组件的类型、属性以及子元素等信息。ReactElement不是组件的实例，不能在ReactElement中调用React组件的任何方法，它只是告诉React你想在屏幕上显示什么。JSX中的闭合标签就是ReactElement。对一个组件而言，props就是输入，ReactElement就是输出，也就是render方法的返回值。

**组件实例** 是组件类的实例化对象，同样被用来管理内部状态、处理生命周期函数。ReactDOM.render方法返回的就是组件实例，某些组件方法中的this也指向组件实例，利用组件的Refs也可以获取组件实例。无状态函数是没有实例化对象的，因此无法使用生命周期函数，也没有内部状态。

## JSX返回多个组件

JSX中返回多个组件，如果不想包面包一层父节点，可以使用数组，注意要有key属性。
```
const arr = [
    <h3 key={0}>第一个组件</h3>,
    <h2 key={1}>第二个组件</h2>,
];
```

## 组件间交互方式

我个人常用的组件间交互的方式有：
- 如果是父子关系的组件，可以通过props由父组件将属性和回调方法传递给子组件进行交互
- 如果是兄弟关系的组件，可以将需要交互的属性和方法提取到共同的父组件中，通过props传递给这两个兄弟组件进行交互
- 如果是兄弟关系的组件，如A、B，且需要在B中使用A的属性，这个属性是A特有的，不能直接提取到公共父组件中，那么可以在父组件的state中添加一个属性，如form，初始值为null，在A的可以componentDidMount方法中对父组件的form属性进行赋值，这样就可以让B使用A特有的属性
- 可以使用redux进行交互

## render方法外渲染组件

在render方法外也可以渲染组件，但需要在render方法中预留好div，如
```
// 正常渲染的组件
class CommonComponent extends Component {
	render() {
		return (
			<div>
				<Button>正常显示的组件</Button>
				<div id="specialComponent"></div>
			</div>
		);
	}
}
// 在其他地方，个人认为应该在componentDidMount方法中
componentDidMount() {
	const dom = document.getElementById('specialComponent');
	if (dom !== null) {
		ReactDOM.render(<Input placeholder="render外渲染的组件" />, dom);
	}
}
```
**注意：**
如果采用这种特殊方式渲染的组件引用到了其父组件的props或state，还需要在componentDidUpdate方法中进行同样的在操作，否则这个特殊方式渲染的组件不会刷新。
```
componentDidUpdate() {
	const dom = document.getElementById('specialComponent');
	if (dom !== null) {
		ReactDOM.render(<Input placeholder="render外渲染的组件" />, dom);
	}
}
```

## 应避免使用style属性

React可以通过给组件设置style属性，进行CSS样式控制，但是不建议这么做，最好是通过指定className来进行样式控制，方便维护。

## 使用数据结构解决问题

如果组件本身的属性无法支持某些功能，可以考虑通过定义数据结构进行解决，如对属性值进行拼接，再拆分，如菜单的key以ID%|%NAME的形式出现。

## 与redux关联的组件ref问题

如果组件（如QueryChoose）组件，是与redux相关联的，对于使用react-redux的情况，也就是组件外调用了connect方法，需要在connect方法的mapStateToProps参数的返回对象中，添加ref属性（如ref:'innerQueryChoose'），在外层组件A引用到QueryChoose时指定ref属性（如ref:'wapperQueryChoose'），则在A中调用QueryChoose组件的方法或属性时，这样引用。
```
// A组件中
this.refs.wapperQueryChoose.refs.innerQueryChoose.someMethod();
```

## setTimeout更新state

有时使用this.setState()更新组件的状态，不会反映到页面上，具体什么时候可以反映到页面上还不清楚，目前发现会出现这种现象的地方有两处：Tabs.TabPane内部的组件、Modal内部的组件。需要使用setTimeout才能达到更新状态的效果。
```
setTimeout(() => {
	this.setState({
		newState
	});
},0);
```

## 带着信息跳转路由

跳转到新路由时，需要带有某些信息，并且不想在url中显示这些信息
```
this.context.router.push({
	pathname: 'xxxx',// 跳转的新路由
	state: {}// 信息放在这里
});
```
在路由跳转的页面中，获取这些信息
```
const urlInfo = this.props.location.state;
```

## Smart Components and Dumb Components

也有叫Container Components and Presentational components的。
  
**Smart component：**  
是连接Redux的组件(@connect)，一般不可复用，类似MVC的C层  
> 描述事物怎样工作  
> 不提供DOM标签和样式  
> 提供数据，进行数据获取  
> 发起action  
> 存放在containers目录  

**Dumb component：**  
是纯粹的组件，一般可复用，类似MVC的V层  
> 描述事物的样子  
> 不依赖应用  
> 直接收props，包括数据和回调方法  
> 很少有自己的state，有也是跟UI相关的  
> 存放在components目录  

两者的共同点是：无状态，或者说状态提取到上层，统一由 redux 的 store 来管理。redux state -> Smart component -> Dumb component -> Dumb component（通过 props 传递）。在实践中，少量 Dumb component 允许自带 UI 状态信息（组件 unmount 后，不需要保留 UI 状态）。  
值得注意的是：Smart component 是应用更新状态的最小单元。实践中，可以将 route handlers 作为 Smart component，一个 Smart component 对应一个 reducer。

{% img https://zhulichao.github.io/2016/09/12/react-experience1/smart-dumb-components.png 结果如图 %}

## ref回调函数

今天无意看到了ref可以使用回调函数的用法，这个回调函数在组件安装后立即执行，被引用的组件作为一个参数传递，且回调函数可以立即使用这个组件，或保存供以后使用(或实现这两种行为)。
```
<TextInput ref={(node) => (this._input = node)} />
```

## 将函数传递到父组件的state中

```
+---------------------------------------------------------+
| +---------+                                             |
| |C        |                                           A |
| +---------+                                             |
+---------------------------------------------------------+
|                                                         |
|                        Dashboard                        |
|                                                         |
|                                                         |
|   +---------------------+    +----------------------+   |
|   |    B                |    |                      |   |
|   | +              +    |    +--------->            |   |
|   | |              |    |    |                      |   |
|   | |   +          |    |    +------------->        |   |
|   | |   |    +     |    |    |                      |   |
|   | |   |    |     |    |    |                      |   |
|   +-+---+----+-----+----+    +----------------------+   |
|                                                         |
+---------------------------------------------------------+
```
A组件是B、C组件的公共祖先组件，C组件需要用到B组件的方法method，首先想到的是把method放到A中定义，然后传入B和C。但是如果不使用ref在A中定义无法获取B私有的状态和其它信息，而且实际中C是A的第一层子组件，B是A的第。我想到的解决方法是：A定义一个方法update接收参数更新自己的state，将update方法传入B中，B将method作为参数调用update方法，这样就将method定义为了A的state的一个属性，再传入C中，即可实现C中调用B中定义的方法。

## 修改state的问题

特别注意，当state中的属性是一个对象是，获取该对象进行属性值的修改后，页面当前不会按新状态显示，从react调试工具看该组件的状态时是修改后的值，可能操作几下页面会按新状态显示。原因是react不能直接修改state，如果是属性值是对象，需要进行深拷贝，修改值后在setState就没问题了。

## 依赖更新的问题

我和同事是同一套代码，没有任何不同，由于他npm install太慢，我把我的node_modules打成压缩包发给他，他的项目启动后会报一些奇怪的警告，我的就没有。执行完npm update就好了，很不明白这是为什么。

还有一个奇怪的问题，更新了antd依赖后，使用Tabs组件直接使用<Tabs.TabPane>定义的内容可以显示，而调用一个方法返回<Tabs.TabPane>会正常显示切换标签，切换后内容是空的，不报任何错误或警告。将整个node_modules删除后，重新安装依赖就正常了。

## Controller View Pattern

[The ReactJS Controller View Pattern](http://blog.andrewray.me/the-reactjs-controller-view-pattern/)

## refs取不到组件的方法

refs如果能取到组件的state和props，但是取不到组件定义的方法，可能是因为这些方法没有在构造函数中bind(this)。

## 关于setState

- 如果setState函数的新状态没有改变当前状态，也会重新执行render方法
- setState第二个参数可以是个回调函数，如果有些操作要求在界面重新渲染完成后进行，可以放在回调函数中
```
class CompB extends React.Component {
    render(){
		console.log("触发了CompB重新render")
          	return (
	            <div>
	              	<h1>{this.props.value}</h1>
	            </div>
          	);
	}
}
class CompA extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 'Hello, world!',
        }
        this.onClick = this.onClick.bind(this);
    }
    onClick() {
        this.setState({
            value: '你好！'
        }, () => console.log("CompA的setState回调！"));
    }
    render(){
        console.log("触发了CompA重新render")
        return (
            <div>
              	<h1>{this.state.value}</h1>
              	<button onClick={this.onClick}>点击</button>
             	 <hr/>
              	<CompB value={this.state.value} />
            </div>
        );
    }
}
```

{% img https://zhulichao.github.io/2016/09/12/react-experience1/setState1.png 运行结果如图 %}

## forceUpdate函数

- 会导致组件本身及其包含的所有级别的子组件重新读取、计算与渲染，与其同级的无关组件不会重新渲染
- 所有UI组件的生命周期函数都会按生命周期规则来执行，如先进入componentWillUpdate再进入render
- 不会调用shouldComponentUpdate来检查是否允许重新渲染
- 可以提供一个回调函数，这个回调函数将在所有组件渲染完成后被调用
```
class CompB extends React.Component {
    componentWillUpdate(){
        console.log("触发了CompB的componentWillUpdate：",this.props.value)
    }
    render(){
        console.log("触发了CompB重新render：",this.props.value)
        return (
            <div>
            	<h1>{this.props.value}</h1>
            </div>
        );
    }
}
class CompA extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            value: 'Hello, world!',
        }
        this.onClick = this.onClick.bind(this);
    }
    shouldComponentUpdate() {
        console.log("进入shouldComponentUpdate");
    }
    onClick() {
        this.forceUpdate(() => console.log("渲染完成!!!"));
    }
    render(){
        console.log("触发了CompA重新render")
        return (
            <div>
              	<h1>{this.state.value}</h1>
              	<button onClick={this.onClick}>点击</button>
              	<hr/>
              	<CompB value="CompA的子组件" />
            </div>
        );
    }
}
ReactDOM.render(
    <div><CompA /><CompB value="与CompA无关的组件"/></div>,
    document.getElementById('example')
);
```

{% img https://zhulichao.github.io/2016/09/12/react-experience1/forceUpdate1.png 运行结果如图 %}

## 关于render函数

可以在自己的代码中调用这个函数以重新刷新组件，注意只刷新了组件本身，不会刷新子组件，但这不是一个好办法。如在点击按钮的onClick方法中可直接调用this.render()方法。
```
class CompB extends React.Component {
	render(){
		console.log("触发了CompB重新render")
		return (
			<div>
				<h1>{this.props.value}</h1>
			</div>
		);
	}
}
class CompA extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			value: 'Hello, world!',
		}
		this.onClick = this.onClick.bind(this);
	}
	onClick() {
		this.render();
	}
	render(){
		console.log("触发了CompA重新render")
		return (
			<div>
				<h1>{this.state.value}</h1>
				<button onClick={this.onClick}>点击</button>
				<hr/>
				<CompB value={this.state.value} />
			</div>
		);
	}
}
```

{% img https://zhulichao.github.io/2016/09/12/react-experience1/render1.png 运行结果如图 %}

## 组件定义外的代码

在React和React Native都发现，在每次系统刷新时（刷新浏览器或重新打开App程序），个人感觉会执行一遍所有文件（在几类文件中都输出了日志），就像此时是对所有的组件进行一遍声明一样，后面用到的地方才是正式的引用。**这里需要注意的是，所有的文件都会在系统刷新时执行一遍，如果在组件定义外部进行了一些操作，如获取数据，那这个时候获取对不对，如果获取数据需要用户登录信息，这是很可能没有登录信息，有没有做处理。**

## children属性

如果使用了`{this.props.children}`显示子组件，想给子组件传递一些属性，可以使用

```
{React.cloneElement(this.props.children, {changeOpenState: this.changeOpenState})}
```

注意此时`this.props.children`是Object，如果`this.props.children`是数组，则需要遍历每个元素执行上面的cloneElement。

## 监听浏览器窗口大小变化

```
handleResize() {
    console.log("输出")
}
componentDidMount() {
    window.addEventListener('resize', this.handleResize);
}
componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize);
}
```

## 巧用setTimeout

项目中遇到一个问题，点击按钮执行了一个更新值的操作，然后调用保存方法，发现保存方法中获取的值并不是更新后的值，感觉是更新后的值没有执行完页面刷新呢，就进入了保存方法。由于setTimeout是在下一轮开始时进行，所以使用setTimeout可使更新在本轮刷新完成后在执行保存操作，达到保存更新后的效果。
```
export function callSaveClickHandler() {
    const newData = {
        'COL1': '改变一个字段值',
    };
    this.props.cardActions.modifyCardChangedData(this.state.servDef.servDef.SERV_ID, newData, true, this.props.servType);
    // 这样做的目的是样保存操作在下一轮开始时执行，这样才能获取到页面更新的内容
    setTimeout(()=>this.refs.btnBar.saveClickHandler(), 0);
}
```

## 巧用路由

/list路由对应的是List组件，该组件主体是一个Tabs组件，默认选中的是第一个Tab。在什么都不处理的情况下，选中不同的Tab不会改变路由，当进入下一个页面并想返回时，总是返回到同一个路由，并且每次选中的只能是第一个Tab，这样的用户体验不好，用户想要的是在进入其它页面前选中的是哪个Tab，返回到上一页面也应该选中哪个Tab。

我的解决方法是，在点击不同Tab时添加回调函数，在里面根据当前选中哪个Tab更新一次路由（this.context.router.replace），也就是路由为/list/tab1、/list/tab2、...这种形式，这样无论是哪种方式进入到相应的路由，只要从路由中取出第二个斜杠后的值，就可以知道当前页面应该选中哪个Tab了。这样相比两个独立页面的好处：非 tab 部分都是公用的，无需重新渲染；点击 tab 切换后滚动条不会回到顶部。

## 阻止默认事件

项目中遇到的问题是，在使用Table组件时，定义了行点击事件，这时行首部的复选框、行中带连接的文字、输入框等，点击的时候都会触发行点击事件。解决方式是在Table行上的组件外包一层div，并添加如下点击事件。

```
function stopPropagation(e) {
  e.stopPropagation();
  e.nativeEvent.stopImmediatePropagation();
}
```

## Context

使用props可以进行上下层组件间属性的传递，使用context可以实现跨层组件间属性的传递。适合使用context的场景包括床底登录信息、当前语言以及主题信息等。而且，react-redux的Provider组件就使用了context来传递store。

```
class Level2 extends React.Component {
    render() {
        return (
            <div id="parent2">
                <p>{this.context.name}</p>
            </div>
        );
    }
};
Level2.contextTypes = {
    name: React.PropTypes.string.isRequired,
};

class Level1 extends React.Component {
    render() {
        return (
            <div id="parent1">
                <Level2 />
            </div>
        );
    }
};

class Root extends React.Component {
    // 注意如果name的属性值为null，会报警告，如下图所示
    getChildContext() {
        return {name: '顶层属性'};
    }
    render() {
        return (
            <div id="parent">
                <Level1 />
            </div>
        );
    }
};
Root.childContextTypes = {
    name: React.PropTypes.string.isRequired,
};

ReactDOM.render(
    <Root />,
    document.getElementById('example')
);
```

{% img https://zhulichao.github.io/2016/09/12/react-experience1/null.png getChildContext返回name为null %}

在使用中发现了一个问题，在一个组件提供的context值改变时，使用这个值的子节点并没有接受到context的改变，没有达到要跨级共享数据的效果。网上说可以在这个提供context组件值改变时执行setState这样就会更新了，但通常使用context都是在组件顶层，这样进行整个重新渲染感觉不太好。