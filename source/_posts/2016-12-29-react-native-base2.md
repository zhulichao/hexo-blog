---
title: React-Native-基础2
layout: post
date: 2016-12-29 07:51:49
categories: React Native
tags: React Native
---

## View组件

View组件还有三个没有在官方文档中公布的回调函数：onTouchStart、onTouchMove、onTouchEnd。这三个回调函数都有一个特殊的性质，就是在React Native开发中，通常是在最上层的组建中(render函数靠后渲染的组件)处理触摸事件的；但这三个回调函数总能收到事件，而不管用户当前触摸区域是空白的，还是有其它组件已经处理了触摸事件。

## pointEvents属性

在React Native中，触摸事件总是被传送给最上层的组件。当很多组件被布局在手机屏幕上时，有的组件可能会遮盖住它下方的其它组件。对于某些应用逻辑，被遮盖住的组件需要处理触摸事件，这时就可以使用pointerEvents属性。

- 取值none，表示发生在本组件与本组件的子组件上的触摸事件都会交给本组件的父组件处理；
- 取值box-none，表示发生在本组件显示范围内（但非本组件的子组件显示范围内）的事件将交由本组件的父组件处理，发生在本组件的子组件显示范围内的触摸事件由子组件处理；
- 取值box-only，表示发生在本组件显示范围内的触摸事件将全部有本组件处理（即使触摸事件发生在本组件的子组件显示范围内）；
- 取值auto会视组件的不同而不同。

## 设备放置状态、onLayout回调函数

使项目在两个平台行都能自动调整应用的显示方式来适应设备当前的放置状态，需要：

- 在应用启动时能检测到设备是横置的还是竖置的；
- 当设备从横置变为竖置或从竖置变为横置时，应用要能监测到这个事件。

检测设备当前是竖置还是横置的一个方法是取当前设备屏幕的宽与高，正常的设备在竖置时宽小于高，在横置时宽大于高。Demensions API 可以获取屏幕的宽和高。

通常，React Native 开发的应用有一个或多个根View，根View的特点是它没有父组件。onLayout回调函数在组件被加载或者布局被改变时会被调用，通过指定这个根View组件的onLayout回调函数可以很方便地得到初始设备的放置状态，检测设备放置状态的改变并得到改变后新的屏幕高度与宽度。为了实现这些功能，不能指定根View的宽和高，并需要设定根View组件的样式flex值为1。**注意，模拟器显示方式被改变时不会触发Layout事件。**

```
'user strick';
var React = require('react-native');
var { AppRegister, StyleSheet, Text, View, Dimensions } = React;
var Project19 = React.createClass({
    _onLayout: function (event) {
        console.log('屏幕的宽度：', Dimensions.get('window').width);
        console.log('屏幕的高度：', Dimensions.get('window').height);
        let { x, y, width, height } = event.nativeEvent.layout;
        console.log('View的宽度：', width);
        console.log('View的高度：', height);
        console.log('View的左上顶点横坐标：', x);
        console.log('View的左上顶点纵坐标：', y);
    },
    _onLayoutText: function(event) {
        let { x, y, width, height } = event.nativeEvent.layout;
        console.log('Text的宽度：', width);
        console.log('Text的高度：', height);
        console.log('Text的左上顶点横坐标：', x);
        console.log('Text的左上顶点纵坐标：', y);
    },
    render: function() {
        return (
            <View style={styles.container} onLayout={this._onLayout}>
                <Text style={styles.welcom} onLayout={this._onLayoutText}>
                    Welcom to React Native!
                </Text>
            </View>
        );
    }
});
var styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItem: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcom: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    }
});

AppRegister.registerComponent('Project19', () => Project19);
```

## setNativeProps成员函数

每个React Native组件都有一个公开的成员函数setNativeProps，使用它可以增加或修改组件的属性，但不建议使用该函数，它是一个“简单、粗暴”的方法，可以直接操作任何层面组件的属性，而不是使用React Native组件的状态机变量，这样会使代码逻辑混乱。

在不得不频繁刷新而又遇到性能瓶颈时，比如创建连续的动画，同时要避免渲染组件结构和同步太多的视图变化所带来的大量开销时，才考虑使用setNativeProps函数。

```
let Project19 = React.createClass({
    getInitialState: function() {
        return {
            textInputValue: ''
        };
    },
    buttonPressed: function() {
        let textInputValue = 'new value';
        this.setState({ textInputValue });
        this.refs.textInputRefer.setNativeProps({
            editable: false
        });
        this.refs.text2.setNativeProps({
            style: {
                color: 'blue',
                fontSize: 30
            }
        });
    },
    render: function() {
        return (
            <View style={styles.container}>
                <Text style={styles.buttonStyle} onPress={this.buttonPressed}>
                    Press me genterly
                </Text>
                <Text style={styles.textPromptStyle} ref="text2"
                    文字提示
                </Text>
                <View>
                    <TextInput
                        style={styles.textInputStyle}
                        ref="textInputRefer"
                        value={this.state.textInputValue}
                        onChangeText={(textInputValue)=>this.setState({textInputValue})}
                    />
                </View>
            </View>
        );
    },
});
```

## measure成员函数

每一个React Native组件都有一个measure成员函数，调用它可以得到组件当前的宽、高与位置信息。使用View组件的onLayout回调函数是获取组件的宽、高与位置信息的好办法，但对某些代码生成的组件，使用组件的measure成员函数是唯一的方法。**Ant Design Mobile组件无法使用measure方法。**

```
...
// 在componentDidMount执行完后才可以获取位置信息
componentDidMount: function() {
    var aref = this.tempfunc;
    window.setTimeout(aref, 1);
},
tempfunc: function() {
    this.refs.aTextInputRef.measure( this.getTextInputPosition);
},
getTextInputPosition: function(fx, fy, width, height, px, py) {
    console.log('getTextInputPosition方法');  
    console.log('Component width: ' + width);
    console.log('Component height: ' + height);
    console.log('X offset to frame: ' + fx); // 这个值无用
    console.log('Y offset to frame: ' + fy);
    console.log('X offset to page: ' + px);
    console.log('Y offset to page: ' + py);
},
...
```

{% img /2016/12/29/react-native-base2/measure.png 结果如图 %}

## AsyncStorage

React Native框架不支持调用JavaScript的fs包进行文件读写操作，**但提供了AsyncStorage API将“字符串键值对”存储在手机存储空间中**。AsyncStorage不提供索引、排序等数据库中经常使用的功能，每个AsyncStorage API提供的方法都会返回一个JavaScript的Promise对象。

使用AsyncStorage的静态函数时，如果参数类型提供错误，try...catch机制将无法捕捉到这个错误。使用Promise机制的rejection状态处理函数中或者利用Promise机制发生错误时的回调函数可以捕捉到错误。但这三种机制中的任何一种都不能阻止手机屏幕的红屏错误。
