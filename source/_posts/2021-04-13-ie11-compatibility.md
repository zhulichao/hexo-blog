---
title: IE11 兼容调试
layout: post
date: 2021-04-13 16:00:01
categories: 前端知识
tags: 前端知识
---


## 调试过程

- 最困难的是看不见报错信息，开发者工具打开就崩溃
- 简化项目，删除一些文件，注释一些路由，如注释了 cesium、three、example 的路由，看到报错信息了，添加了 babel-polyfill
- 放开 example 路由，看示例程序就崩溃，把示例 html 中的内容粘贴到 index.html 中运行，看到了报错，html 中集成 babel 转码和 polyfill 兼容 IE11
- 修改了 babel-loader 处理的范围，添加了 cesium、three 包

## 注意事项

- DOM 操作的 append 方法改为 appendChild 方法
- 示例程序的 html 中尽量不写 ES6 语法
- 示例程序的 html 中不要写 async await，使用 then 回调
- 示例程序的 html 中变量要有声明
- WebGL 是实验性的，可能会有问题
