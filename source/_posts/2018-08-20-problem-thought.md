---
title: 解决问题的思路
layout: post
date: 2018-08-20 09:44:57
categories: Ideas
tags: Ideas
---

## 项目重构后 Modal 组件样式不正确

我们的项目基于 create-react-app 重构后，运行一段时间突然发现 Modal 组件样式有问题了。现象是：通常的 Modal 样式是正确的，在一个固定地方点击的 Modal 样式不正确，而且一旦出现不对的样式后其它的 Modal 样式也不正确了。经过与正确的 Modal 对比样式，发现样式没有问题。无意中点击了编译后的 css 文件，发现 keyframes 不是 modules 命名的，而是命名为 a、b、c 等，被其它文件中同名的 keyframes 覆盖了。这也解释了为什么其它地方的 Modal 是正确的，而某个地方的 Modal 出现不正确样式后其它 Modal 都被影响了的问题。我的第一反应就是代码里面命名重复了，但查看代码发现没有问题。再仔细一看发现其它样式都是 modules 形式的，如类名为 .Modal_content__14s1u，只有 keyframes 不是，都是 a、b、c 这种形式的。

之后就开始查 webpack 相关编译的问题，没有解决方案。后来想起来，项目基于 create-react-app 后，webpack 配置相关的都是在 react-scripts 中配置的，也就是 create-react-app，去查了 issuse 列表，找到有人问相同的问题了，解决方式如下。

事后回想一下，我已经定位到时编译问题后，首先想到的就应该是 create-react-app 的问题，不应该盲目的乱查 webpack 配置相关的东西。**切记遇到问题还需仔细思考，理清思路，准确定位，不应乱查。**

```js
// create-react-app/packages/react-scripts/config/webpack.config.prod.js
...
module.exports = {
  ...
  optimization: {
    minimizer: [
      ...,
      new OptimizeCSSAssetsPlugin({ cssProcessorOptions: { safe: true } }),
    ],
  },
};
```

## 奇怪问题

如果自己确认代码没有问题，但效果有奇怪的问题，尤其是移植过来的代码，跟原代码运行时效果不一样，首先考虑是否有包的版本有问题，将相关包的版本处理成一样的，再试试是否还存在问题。
