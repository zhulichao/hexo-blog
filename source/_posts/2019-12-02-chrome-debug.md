---
title: Chrome-调试
layout: post
date: 2019-12-02 16:11:52
categories: Debug
tags: Debug
---

性能调试时使用 command + shift + n 快捷键打开无痕模式，来规避 Chrome 插件对页面性能的影响。

## Sinppets

当我们想不起某个方法的具体使用时，会打开控制台随意写一些测试代码，或者想测试一下刚刚写的方法是否会出现期待的样子，但是控制台一打回车本想换行但是却执行刚写的半截代码。这时可以使用 Sources 下面的左侧的 Sinppets 代码片段，点击创建一个新的片段文件，写完测试代码后把鼠标放在新建的文件上右键 Run，再结合控制台查看相关信息。

## Performance

确保 Screenshots checkbox 被选中；点击 Capture Settings（⚙️）按钮，DevTools 会展示很多设置，来模拟各种状况，如将 CPU 选为 4x slowdown 模拟4倍低速 CPU，将 Network 选为 Slow 3G 模拟慢速 3G。参考 [全新Chrome Devtools Performance使用指南](https://segmentfault.com/a/1190000011516068)

## Memory

查看当前网页的 JavaScript 占用的内存情况。参考 [Chrome 开发工具之 Memory](https://www.cnblogs.com/ys-ys/p/11336811.html)

## Security

可以告诉你这个网站的安全性，查看有效的证书等。

## Application

会列出所有的资源，包括 Manifest、Service Workers、Local Storage、Session Storage、IndexedDB、Web SQL(已被 IndexedDB 干趴下)、Cookies、Cache Storage、Application Cache(已被 Service Workers 干趴下)、BackGround Services、Frames 等，可以对存储的内容编辑和删除。参考 [Chrome 开发工具之 Application](https://www.cnblogs.com/ys-ys/p/11444290.html)

## Audits

Audits 源于著名的开源自动化分析插件——Lighthouse，Lighthouse 不仅能够分析页面性能，还能够对 PWA、无障碍访问、SEO 等进行测试评分，可选网络环境，运行后给出优化建议。
