---
title: Babel-入门
layout: post
date: 2016-10-29 12:13:35
categories: ES6
tags: ES6
---

[Babel](https://babeljs.io/)是一个广泛使用的转码器，可以将ES6代码转为ES5代码，从而在现有环境执行。

### 配置文件

Babel的配置文件是.babelrc，存放在项目的根目录下，该文件用来设置转码规则和插件。
```
{
    "presets": [], -- 设定转码规则
    "plugins": []  -- 设定支持的插件，如'antd'
}
```
ES2015转码规则  
`npm install --save-dev babel-preset-es2015`  
react转码规则  
`npm install --save-dev babel-preset-react`  
ES7不同阶段语法提案的转码规则（共有4个阶段），选装一个  
`npm install --save-dev babel-preset-stage-0`  
`npm install --save-dev babel-preset-stage-1`  
`npm install --save-dev babel-preset-stage-2`  
`npm install --save-dev babel-preset-stage-3`  

### babel-cli

`npm install --global babel-cli` 用于命令行转码的工具

```
# 转码结果输出到标准输出
$ babel example.js

# 转码结果写入一个文件
# --out-file 或 -o 参数指定输出文件
$ babel example.js --out-file compiled.js
# 或者
$ babel example.js -o compiled.js

# 整个目录转码
# --out-dir 或 -d 参数指定输出目录
$ babel src --out-dir lib
# 或者
$ babel src -d lib

# -s 参数生成source map文件
$ babel src -d lib -s
```

babel-cli工具自带一个babel-node命令，提供一个支持ES6的REPL环境。它支持Node的REPL环境的所有功能，而且可以直接运行ES6代码。

### babel-register

babel-register模块改写require命令，为它加上一个钩子。此后，每当使用require加载.js、.jsx、.es和.es6后缀名的文件，就会先用Babel进行转码。注意，它只会对require命令加载的文件转码，而不会对当前文件转码。另外，由于它是实时转码，所以只适合在开发环境使用。

### babel-core

如果某些代码需要调用Babel的API进行转码，就要使用babel-core模块，配置对象为[options](http://babeljs.io/docs/usage/options/)。
```
var babel = require('babel-core');

// 字符串转码
babel.transform('code();', options);
// => { code, map, ast }

// 文件转码（异步）
babel.transformFile('filename.js', options, function(err, result) {
  result; // => { code, map, ast }
});

// 文件转码（同步）
babel.transformFileSync('filename.js', options);
// => { code, map, ast }

// Babel AST转码
babel.transformFromAst(ast, code, options);
// => { code, map, ast }
```

### babel-polyfill

Babel默认只转换新的JavaScript句法（syntax），而不转换新的API，比如Iterator、Generator、Set、Maps、Proxy、Reflect、Symbol、Promise等全局对象，以及一些定义在全局对象上的方法（比如Object.assign）都不会转码。如果想让这些代码执行，必须使用babel-polyfill，为当前环境提供一个垫片。

### 浏览器环境

Babel也可以用于浏览器环境。可在网页中插入：
```
<script src="node_modules/babel-core/browser.js"></script>
<script type="text/babel">
```
或
```
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.4.4/babel.min.js"></script>
<script type="text/babel">
```

网页中实时将ES6代码转为ES5，对性能会有影响。生产环境需要加载已经转码完成的脚本。