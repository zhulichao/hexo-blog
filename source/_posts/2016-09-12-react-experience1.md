---
title: react-学习经验1
layout: post
date: 2016-09-12 14:05:21
categories: React
tags: React
---
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