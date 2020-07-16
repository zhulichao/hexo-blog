---
title: create-react-app 学习
layout: post
date: 2018-05-26 15:20:06
categories: Project Base
tags: Project Base
---

## Monorepo

先说一下 Multirepos 的管理方式，一个项目会有一个 repo 或者说一个 module 一个 repo，缺点：

- 项目或者 module 因为功能或者属性或者历史的原因不得不拆分到不同的 organization 中，这会导致后期人员交接或者自己项目管理时不知道哪里去找 repo 的境地
- issue 不知道往哪里提，导致项目管理混乱
- 版本管理带来的日常开销，如 webpack 需要变更时，需要人工同步所有的项目
- changelog 梳理又是一场灾难，需要人工同步所有变动的仓库最终列出一个 changelog

Monorepo 是一种相反的思路，可以将以上问题都解决。 Monorepo 是一种管理代码的方式，在这种方式下会摒弃原先一个 module 一个 repo 的方式，取而代之的是把所有的 modules 都放在一个 repo 内来管理，用一个项目维护所有的代码，每个子项目单独管理发布和运行，内部互相引用，但 Monorepo 也有缺陷，就是单个 repo 体积较大、如何进行权限管理。从代码结构看，一般使用 Monorepo 管理方式的项目，都会有一个 packages 目录，里面是一个个独立管理和发布的子项目。

目前诸如 Babel、React、Angular、Ember、Jest、Create-React-App 等等都采用了 Monorepo 这种方式来进行源码管理。

个人思考：
1、如果由一个 repo 管理所有项目，这个 repo 体积会越来越大，这会需要强大的构建工具，版本控制、权限管理也会变难。Monorepo 适用于什么场景呢？是否是由多个子项目共同完成一件事或者跟一件事相关，而且至少存在内部互相引用的情况，适用的边界在哪里？
2、我们的3个前端项目适用 monorepo 的管理方式吗？

## Lerna

[Lerna](https://lernajs.io/) 是基于 Monorepo 理念在工具端的实现，优化使用 git 和 npm 管理多包代码库的工作流程，可以在主项目下管理多个子项目，从而解决多个包互相依赖，且发布时需要手动维护多个包的问题，根据 git 提交记录自动生成 CHANGELOG。

```
yarn global add lerna
git init monorepo-example
cd monorepo-example
lerna init
```
此时目录结构为：
```
.
|-- packages/     存放之后所有的官方维护的 module
|-- lerna.json
|-- package.json
```
```
cd packages
mkdir module-a && cd module-a && yarn init
mkdir module-b && cd module-b && yarn init
```
此时目录结构为：
```
.
|-- packages
|       |-- module-a
|               |-- package.json
|       |-- module-b
|               |-- package.json
|-- lerna.json
|-- package.json
```

在 module-a 的 package.json 的 dependencies 中添加 module-b，执行 lerna bootstrap，引导packages安装各自的依赖。如果想把 package 发布到 npm 上，可以执行 lerna publish 命令。

## 如何学习

CONTRIBUTION.md 看项目结构，怎么更改和维护。React-boilerplate 样板 ，最佳实践，弄成项目样板，在此基础上写业务代码。

- 读代码
- 看 commit 记录

## packages

把配置和开发调试依赖的东西分成独立项目了，使用者只关注业务代码。

babel-preset-react-app：react-scripts 使用的 babel 预设，将 ES6 以上的语法转义。
eslint-config-react-app：eslint 语法检查配置。
react-dev-utils：开发调试模式用到的一些脚本和方法，如编译时的错误提示？
create-react-app：全局 CLI 命令行工具，不应该经常变换，需适配多版本的 node，委托所有的配置给了 react-scripts。
react-scripts：项目核心，项目基础配置，包括开发服务的脚本和设置，如 webpack、babel、eslint 配置，构建生产模式等。

### create-react-app

create-react-app 由于是全局安装的，不会经常升级，因此要保持简单，少变更。它只负责做好一件事，初始化仓库，把其他版本的包下载到本地配置好，应适配多版本的 node。

create-react-app 好的思路：

- index.js 中 ： 生成一个新项目到本地，加载依赖项。检查 node 版本，过低给出警告。这样很安全。
- 使用 commander 项目，解决控制台如何使用指令。
- react-script 中执行 init，把 package.json 填充好，把 template 目录中的模板文件拷贝到项目中。
- 配置相关的安装包都以特定的方式预配置到项目中，如果需要更高程度的自定义，使用 eject 命令。

`npx` 需要全局安装的包，用了一次或两次就不用了。全局安装包 + 执行命令 + 删除全局包。
`npx create-react-app my-app` ===
`npm install -g create-react-app && create-react-app my-app && npm uninstall -g create-react-app`

通过 create-react-app + 自定义 react-scripts 的方式，fork create-react-app 项目，做了：

- 将使用 js 改为 ts
- 添加了 fork-ts-checker-webpack-plugin 负责语法检查，添加了使用 ts-lint 的配置
- 添加了 cache
- 增加了 ts-jest 的配置
- 修改了 template 下的模板文件
- 增加了对 graphql 文件类型的处理 graphql-tag/loader
- 加载文件预处理的耗时多的操作，都用了 thread-loader
- 原来使用 webpack 的 uglyjs 的 plugin ，但是效率低，改为使用社区开源的 uglyjsplugin
- 使用 module.css 思路，以 .module.css 使用 css module 的处理，增加了对 scss sass 的处理
- webpack 由3升级到4

使用我们自定义的安装包
`npx create-react-app@next --scripts-version=@canway/react-scripts my-app`

性能优化：Typescript，会运行 tsc，src/complier/tsc.ts，使用 server-client 的设计思路模式。对于 typescript 其实是一个编译器，把 ts 文件转成 js 文件，把一个文件怎么编译和转换当做一个基础的服务放到 server，client 在个个地方怎么调用这些服务，tsc 是去调用提供的服务，所以 tsc 不在 server 下。ts 的服务一共两大部分：语法检查和转义。好处是，vscode 等 ide 中只要语法检查部分。直接使用 tsc 进行语法检查和转义，效率低，webpack 打包的时候只进行转义，独立的使用 fork-ts-checker-webpack-plugin 做语法检查，ts-loader 添加选项 happyPackMode: true 只进行转义，配合了 thread-loader 利用电脑多核使用多线程，使用 cache-loader 缓存转义（babel-loader本身是有缓存机制的，ts-loader 没有）。用独立的线程进行语法检查 fork-ts-checker-webpack-plugin。

---
我的问题：

- node_modules 没有包括所有 package.json 中的 dependencies 下的包
- 执行 yarn install 后没有 yarn.lock 文件
- createReactApp.js 中执行过安装 react、react-dom了，在 react-scripts/init.js 中再次执行
- tasks 目录
- yarn e2e:docker

## 项目中如何修改

- yarn add @private/react-scripts --exact
- 删除编译相关的包、scripts
	```
	graphql-tag
	isomorphic-loader
	serialize-javascript
	whatwg-fetch
	@babel/*
	jest 相关
	webpack 相关
	postcss 相关
	ts 相关
	ali-oss
	async-retry
	autoprefixer
	chalk
	chokidar
	front-matter
	fs-extra
	glob
	identify-obj-proxy
	markdown-it
	mkdirp
	object-assign
	prettier-error
	promise
	react-deep-force-update
	react-dev-utils
	react-error-overlay
	rimraf
	source-map-support
	```
	更新 scripts 只留 precommit、start、build、test、eject
	更新 browerslist
- 删除 config 、scripts、test 目录，babel、docker、jest、nginx 配置文件
- 拷贝 tsconfig、tslint
- 修改入口文件为 src/index.tsx
- 添加 serviceWorker.ts 文件
- 添加 node-sass 安装包
- 可能存在 react、react-dom 类型文件版本冲突，redux、apollo 也可能有问题，可能需要手动修改 yarn.lock 文件
- webpack 4 “export does not found” 问题，修改 webpack 配置中 `strictExportPresence: false`
- 更新环境变量为 REACT_APP_ 开头

## PostCss 改为 SCSS

- 删除 css.d.ts 声明文件
- css 文件改为 module.scss，修改文件引入
- 变量的定义及使用、多媒体查询、@next 替换为 @at-root
- 图标样式文件 Icon.module.scss 中变量需定义为字符串
- antd 样式没有生效，原因是 webpack 配置中使用了 thread-loader
- 修正 stylelint 配置文件，支持 scss 中的 @include 等使用
	```
	module.exports = {
    plugins: [
      ...
      'stylelint-scss', // 需安装
    ],
    ...
    rules: {
      ...
      'at-rule-no-unknow': null,
      'scss/at-rule-no-unknow': true,
    }
	};
	```