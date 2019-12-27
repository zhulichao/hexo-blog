---
title: React-学习经验2
layout: post
date: 2016-09-13 08:44:03
categories: React
tags: React
---

## MVVM(Model-View-ViewModel)

MVC—>MVP—>MVVM  
MVVM框架的由来是MVP（Model-View-Presenter）模式与WPF（Windows Presentation Foundation）结合的应用方式时发展演变过来的一种新型架构框架。它立足于原有MVP框架并且把WPF的新特性糅合进去，以应对客户日益复杂的需求变化。  
低耦合 可重用性 独立开发 可测试

## 零散知识  

- ReactDOM.render(Component,dom) 执行后，这个dom还会存在，这个Component是在最外层。  
感觉很奇怪  
```
// 在componentDidMount方法中
ReactDOM.render(this.state.customScript.buttonAndPopoverComponents(), document.getElementById(<Button type="primary">自定义添加的按钮</Button>,'ANTD_CDP_TABLE1_ZLC-btnBar_after'));
```
{% img https://zhulichao.github.io/2016/09/13/react-experience2/renderDOM.png 结果如图 %}
 
## 解析jsx

```
return (  
  <div className="commentBox">  
    Hello, world! I am a CommentBox.  
  </div>  
); 
```

```
return (  
  React.createElement('div', {className: "commentBox"},  
    "Hello, world! I am a CommentBox."  
  )  
);  
```

Babel 设置匹配后缀，文件后缀为.jsx，就不会对<报错。Babel之所以可以按照各种要求编译JavaScript代码文件，是因为使用了各种插件和预设(预设是插件的打包封装)。

## key 的作用

今天遇到了一个奇怪的现象，下面代码是在同一个页面中，点击不同按钮时显示单选或多选树，结果出现了错误，debugger调试时看到是组件在更新时出了问题，更新时没有找到正确的组件，先显示单选树再显示多选树会在单选的树上更新的，由于没有多选的一些属性而报错。解决办法就是放开注释的key属性，这样更新时就能找到相应的组件了。这是我第一次体会到key的作用。

善于 key 值得使用，如果不同的路由进入同一个组件，但要清空原有的所有状态，相当于是一个新组件的效果，使用不同的 key 值即可达到效果。

```
...
render() {
    return (
        <div>
            {
                this.props.multi ?
                    <Tree
                        // key="tree-multi"
                        checkable
                        onCheck={this.onCheck}
                        checkedKeys={this.state.selectedKeys}
                    >
                        {loop(this.props.userData)}
                    </Tree>
                :
                    <Tree
                        // key="tree-single"
                        onSelect={this.onSelect}
                    >
                        {loop(this.props.userData)}
                    </Tree>
            }
        </div>
    );
}

```

## 引用图片

使用require静态资源，打包时会自动打入，不需要再处理静态资源。

```
<img src={require('../../resources/images/logo.png')} />
```

```
const url = `url(${require("../../resources/images/banner-home.jpg")})`;
<div style={{backgroundImage: url}} />
```
