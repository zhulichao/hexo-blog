---
title: Ant Design 组件学习经验
layout: post
date: 2016-09-14 14:39:06
categories: Ant Design
tags: Ant Design
---

## Tree组件异步加载数据(待完成)

## Form组件的使用(待完成)

## Table组件单选
如果Table组件中要进行单选，需要进行如下配置：

- 将Table组件rowSelection属性的type值设置为radio，当前选中的数据由radioIndex控制
- 注意，ant-design的Table组件，对于单选类型的，无法自己管理radioIndex值，如果想要自己管理radioIndex值，需要在Table组件中添加如下代码
```
if (('radioIndex' in nextProps) && nextProps.radioIndex !== null ) {
    this.setState({
        radioIndex: nextProps.radioIndex || null
    });
}
```
