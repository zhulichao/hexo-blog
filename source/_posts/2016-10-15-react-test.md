---
title: React-测试
layout: post
date: 2016-10-15 23:39:35
categories: React
tags: React
---
## 前端自动化单元测试

使用**Karma + Mocha + Chai + Sinon + Enzyme**测试React + Redux的web应用，还可能用到Jsdom


---
### 工具介绍

Karma 测试过程管理工具，**最重要的是可以 webpack 预处理**

[Mocha](http://mochajs.org/) 测试框架，提供describe、it等函数

[Chai](http://chaijs.com/api/) 断言库，提供expect等函数

[Sinon](http://sinonjs.org/) 是一个mock框架，可以对任何对象进行mock

[Enzyme](http://airbnb.io/enzyme/) React测试工具，是对React官方测试工具 react-addons-test-utils 的封装

Jsdom 提供DOM环境，即window、document和navigator对象

---
### 参考教程

[前端自动化单元测试初探](http://www.jianshu.com/p/6726c0410650)-- 主要介绍Karma配置

[React 测试入门教程](http://www.ruanyifeng.com/blog/2016/02/react-testing-tutorial.html)-- 主要介绍React组件怎么测试

[React+Redux单元测试一小时入门](https://segmentfault.com/a/1190000006678143?hmsr=toutiao.io&utm_medium=toutiao.io&utm_source=toutiao.io)、[参考代码](https://github.com/cody-lettau/react-redux-starter)-- 主要介绍组件、action、reduce怎么测试

### Karma+Webpack配置

- 依赖包括

```npm install --save-dev 如下依赖

    chai
    enzyme
    isparta-instrumenter-loader
    jsdom
    karma
    karma-chai
    karma-chrome-launcher
    karma-coverage
    karma-mocha
    karma-sinon
    karma-sinon-chai
    karma-webpack
    lodash
    mocha
    null-loader
    react-addons-test-utils
    sinon
    sinon-chai
    webpack-node-externals  
```
    
- karma.conf.js 文件如下

```karma init 生成karma.conf.js修改后

    const webpackconfig = require('./webpack.config.js');
    module.exports = function(config) {
        config.set({
            basePath: '',
            frameworks: ['mocha','sinon','chai','sinon-chai'],
            files: [
              './test/*.js'
            ],
            exclude: [
            ],
            preprocessors: {
                './src/containers/*': ['coverage'],
                './test/*.js': ['webpack']
            },
            reporters: ['progress', 'coverage'],
            port: 9876,
            colors: true,
            logLevel: config.LOG_INFO,
            autoWatch: true,
            browsers: ['Chrome'],
            singleRun: false,
            concurrency: Infinity,
            webpack: webpackconfig
        })
    }
```

- webpack配置文件需要添加如下内容，否则使用enzyme报错

```cfg/test.js中

    externals: {
        'jsdom': 'window',
        'cheerio': 'window',
        'react/addons': true,
        'react/lib/ExecutionEnvironment': true,
        'react/lib/ReactContext': true
    }
```

### 测试代码样例  

```test/navPath.js中

    import React from 'react';
    import { Breadcrumb } from 'antd';
    // 测试使用模块
    import { shallow , mount, render } from 'enzyme';
    // 待测试组件
    import NavPath from '../src/components/NavPath';
    
    describe('NavPath Shallow', function () {
        it('Component Test', function () {
            const breadCrumb = [
                {key: '0qqnL2f1J42bV3I9Hzavkgg%|%请假管理', name: '请假管理'},
                {key: '0TT3DR6jt6Fogaimc3l3Rr%|%外出请假申请单', name: '外出请假申请单'},
            ];
            const context = {
                router: {},
                location: {},
            };
            const navPath = shallow(<NavPath breadCrumb={breadCrumb} />, { context });
            expect(navPath.find(Breadcrumb.Item).length).to.equal(2);
        });
    });
```

### 启动测试

```
karma start
```