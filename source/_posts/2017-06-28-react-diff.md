---
title: React-Diff算法
layout: post
date: 2017-06-28 09:33:24
categories: React
tags: React
---

## Diff算法

React.js 相对于直接操作原生DOM有很大的性能优势，很大程度上都要归功于virtual DOM的batching和diff。batching把所有的DOM操作搜集起来，一次性提交给真实的DOM。diff算法时间复杂度也从标准的的Diff算法的O(n^3)降到了O(n)。React.js将标准的的Diff算法复杂度O(n^3)直接降低到O(n)基于的假设：

- 两个相同组件产生类似的DOM结构，不同的组件产生不同的DOM结构
- 对于同一层次的一组子节点，它们可以通过唯一的id进行区分

在比较两个React节点树时，React首先比较根元素，随后的行为取决于根元素类型：

- 只要根节点类型不同，React就会销毁旧节点树，创建新节点树
- 当节点类型相同时，React比较两者的属性，不改变DOM节点，只更新当前节点需要改变的属性
- 如果节点需要更新样式属性，React仅会更新当前节点需要改变的样式属性

React的Diff算法实际上只会对树进行逐层比较。在实现自己的组件时，保持稳定的DOM结构会有助于性能的提升。例如，我们有时可以通过CSS隐藏或显示某些节点，而不是真的移除或添加DOM节点。

{% img /2017/06/28/react-diff/传统算法O(n^3).png 传统Diff算法O(n^3) %}

{% img /2017/06/28/react-diff/React算法O(n).png 500 React Diff算法O(n) %}

## key属性在diff算法中的作用

使用浏览器的MutationObserver的功能，对页面上元素的改变进行监听，示例代码如下：

```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <script src="react.js"></script>
    <script src="react-dom.js"></script>
    <script src="jquery.js"></script>
    <script src="babel.min.js"></script>
  </head>
  <body>
    <div id="container"></div>
    <style>

    </style>
    <script type="text/javascript">
        var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
        var observeMutationSupport = !!MutationObserver;
        var changedNodes = [];
        if(observeMutationSupport) {
            var observer = new MutationObserver(function(mutations) {
                changedNodes = mutations;
                mutations.forEach(function(mutation){
                    console.log(mutation);
                });
            });
            var options = {
                'childList': true, // 子节点的变动
                'attributes': true, // 属性的变动
                'characterData': true, // 节点内容或节点文本的变动
                'subtree': true, // 所有后代节点的变动
                'attributeOldValue': true, // 表示观察attributes变动时，是否需要记录变动前的属性值
                'characterDataOldValue': true // 表示观察characterData变动时，是否需要记录变动前的值
            };
            observer.observe(document.body, options);
        }
    </script>
    <script type="text/babel">
        function LifeCycle(name) {
            var obj = {
                name: name
            };
            for(var n in Cycle){
                obj[n] = Cycle[n];
            }
            return obj;
        }
        var Cycle = {
            getInitialState: function() {
                console.log(this.name, 'getInitialState');
                return {};
            },
            getDefaultProps: function() {
                console.log(this.name, 'getDefaultProps');
                return {};
            },
            componentWillMount: function() {
                console.log(this.name, 'componentWillMount');
            },
            componentDidMount: function() {
                console.log(this.name, 'componentDidMount');
            },
            componentWillReceiveProps: function() {
                console.log(this.name, 'componentWillReceiveProps');
            },
            shouldComponentUpdate: function() {
                console.log(this.name, 'shouldComponentUpdate');
                return true;
            },
            componentWillUpdate: function() {
                console.log(this.name, 'componentWillUpdate');
            },
            componentDidUpdate: function() {
                console.log(this.name, 'componentDidUpdate');
            },
            componentWillUnmount: function() {
                console.log(this.name, 'componentWillUnmount');
            }
        };
        // 定义Ctrip组件
        var Ctrip = React.createClass({
            mixins: [LifeCycle('Ctrip')],
            render: function() {
                console.log('Ctrip', 'render');
                return (
                    <ul>
                        <li>ctrip</li>
                        <li>
                            <ul>
                                {this.props.children}
                            </ul>
                        </li>
                    </ul>
                );
            }
        });
        // 定义Elong组件
        var Elong = React.createClass({
            mixins: [LifeCycle('Elong')],
            render: function() {
                console.log('Elong', 'render');
                return (
                    <li>elong</li>
                );
            }
        });
        // 定义Qunar组件
        var Qunar = React.createClass({
            mixins: [LifeCycle('Qunar')],
            render: function() {
                console.log('Qunar', 'render');
                return (
                    <li>qunar</li>
                );
            }
        });
        // 定义Ly组件
        var Ly = React.createClass({
            mixins: [LifeCycle('Ly')],
            render: function () {
                console.log('Ly', 'render');
                return (
                    <li>ly</li>
                );
            }
        });

        console.log('------------first------------');
        ReactDOM.render(
            <Ctrip><Elong></Elong><Qunar></Qunar></Ctrip>,
            document.getElementById('container')
        );
        setTimeout(function() {
            console.log('------------second------------');
            ReactDOM.render(
                <Ctrip><Elong></Elong><Ly></Ly><Qunar></Qunar></Ctrip>,
                document.getElementById('container')
            );
        }, 1000);
    </script>
  </body>
</html>

```

{% img /2017/06/28/react-diff/withoutKey.png 运行结果如图 %}

常规的做法就是将Elong和Qunar组件先删除，然后一次创建和插入Elong、Ly和Qunar组件。通过运行结果可以看出，在React中，Elong组件不变，先将Qunar组件进行删除，然后在创建并插入Ly组件，最后再创建并插入Qunar组件，比常规的做法省去了对Elong组件的删除操作。下面再将主逻辑代码稍作调整，给每个组件添加key属性：

```
...
console.log('------------first------------');
ReactDOM.render(
    <Ctrip><Elong key="Elong"></Elong><Qunar key="Qunar"></Qunar></Ctrip>,
    document.getElementById('container')
);
setTimeout(function() {
    console.log('------------second------------');
    ReactDOM.render(
        <Ctrip><Elong key="Elong"></Elong><Ly key="Ly"></Ly><Qunar key="Qunar"></Qunar></Ctrip>,
        document.getElementById('container')
    );
}, 1000);
...
```

{% img /2017/06/28/react-diff/withKey.png 运行结果如图 %}

这次的Diff算法与之前有很大不同，Elong组件不变，Qunar组件不变，只是在Qunar组件之前创建并插入了Ly组件。可见使用key属性可提高渲染性能。
