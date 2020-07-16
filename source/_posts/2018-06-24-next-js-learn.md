---
title: Next.js 学习
layout: post
date: 2018-06-24 11:56:27
categories: Project Base
tags: Project Base
---

## 介绍

[Next.js](https://nextjs.org/) 是一个轻量级的 React 服务端渲染应用框架，是 [Create-React-App](https://github.com/facebook/create-react-app) 的升级版。当使用 React 开发时，常常需要配置很多繁琐的参数，如 Webpack 配置、Router 配置和服务器配置等。如果需要做 SEO，要考虑的事情就更多了，怎么让服务端渲染和客户端渲染保持一致是一件很麻烦的事情，需要引入很多第三方库。针对这些问题，Next.js 提供了一个很好的解决方案，使开发人员可以将精力放在业务上，从繁琐的配置中解放出来。

## 优点

- **服务端渲染（SSR）**
- 基于文件系统的页面路由
- 自动按页面拆分代码
- 静态页面导出
- 使用 styled-jsx
- 零配置，基于 Webpack 的开发环境，支持热模块替换
- 支持 Babel 和 Webpack 的配置项定制，可定制服务端、路由 和 next 插件

## 缺点

- 注意 window、document 等只能在浏览器端使用的变量
- 区分服务端还是客户端
- 图片等静态文件只能放在 static 目录下，不能通过 require 来引入，也就是没办法通过 webpack 来进行模块化管理，如果各个组件有自身依赖的图片，也只能一股脑放 static 里，也很难实现版本管理控制浏览器缓存

简单地说，很适合快速搭建简单站点，但自由度不高，且带样式或图片的 React 组件无法直接使用，个人看法是一个用自由度和通用性来换取易用性的框架

## Next.js vs create-react-app

Next.js：优化首屏加载速度，有SEO，如着陆页项目
create-react-app：适用于 SPA，不需SEO、SSR的项目，如后台项目

## 使用

### Command

next dev  开发模式，编译完后只是搭建基础模块，访问到哪些页面再进行编译，提升开发效率
next build 构建打包生产环境代码
next start 发布模式编译后本地运行 server
next export 导出静态页面，使用 next.config.js

### Pages

Next.js 项目有两个特殊目录，pages 和 public。public 目录存放静态文件和 robots.txt 文件。pages 目录下的文件可以是页面路由或 api 路由，可通过文件名直接访问，pages/api 目录下的文件都是 api 路由，可通过 /api/* 访问，其它为页面路由。pages 目录下文件名由 [] 包裹的会产生动态路由，文件的名称会作为query参数传入页面，Link 中需要使用 as 属性。

### Router and Link

useRouter() 可以获取 router 对象，withRouter() 可以将 router 对象传入组件。页面跳转不要使用 `<a>`，它不会执行客户端导航，而是浏览器发起请求到服务器页面，会刷新整个页面，使用 `<Link>` 是客户端导航，并且使用了 `location.history`。`Link` 只是一个接受 href 和类似属性的包装组件，如果想给链接标签添加属性，需要添加到它的子组件上，href 属性是到 pages 下的路径，as 属性是浏览器地址栏显示的地址。

### Style

使用 `<style jsx>` 内联样式，只作用在本组件内，可以通过 global 属性定义全局样式，也可以使用引用 css 文件的方式。可以通过 `[name].module.css` 命名方式使用 css module。可以继承 styled-components 来支持服务端渲染。

### Data Fetching

Next.js 有两种预渲染方式，Static Generation 和 Server-side Rendering。有3个方法可以用于预渲染获取数据：

- getStaticProps (Static Generation): 在打包构建生产环境时获取数据，因此无法获取 query 参数或 headers 等再请求发生时才有的信息，只在服务端执行，然后把获取到的数据用 props 传入页面
- getStaticPaths (Static Generation): 根据数据指定动态路由进行预渲染，如果一个动态路由页面使用了 getStaticProps 方法，那它也必须使用 getStaticPaths 方法
- getServerSideProps (Server-side Rendering): 每次请求时获取数据，只在服务端执行，

除此之外，还可使用 getInitialProps API 获取数据，getInitialProps 适合通用数据抓取和服务器端渲染，有利于 SEO。这些方法只能在 page 页面导出。
