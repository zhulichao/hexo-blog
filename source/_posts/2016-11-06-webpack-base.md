---
title: Webpack-基础
layout: post
date: 2016-11-06 20:14:17
categories: Webpack
tags: Webpack
---

## [前端模块管理器简介](http://www.ruanyifeng.com/blog/2014/09/package-management.html)

浏览器本身并不提供模块管理的机制，为了调用各个模块，有时不得不在网页中，加入一大堆script标签。这样就使得网页体积臃肿，难以维护，还产生大量的HTTP请求，拖慢显示速度，影响用户体验。
为了解决这个问题，前端的模块管理器（package management）应运而生。它可以轻松管理各种JavaScript脚本的依赖关系，自动加载各个模块，使得网页结构清晰合理。不夸张地说，将来所有的前端JavaScript项目，应该都会采用这种方式开发。

## Webpack介绍

[官网](http://webpack.github.io/docs/)   
[Webpack 中文指南](http://zhaoda.net/webpack-handbook/)  
[Webpack 介绍](https://fakefish.github.io/react-webpack-cookbook/Introduction-to-Webpack.html)  
[webpack学习笔记](http://www.07net01.com/2015/08/890558.html)  
[快速上手](http://webpack.github.io/docs/tutorials/getting-started/)  
[一小时包教会](http://www.cnblogs.com/vajoy/p/4650467.html)  
[webpack-howto](https://github.com/petehunt/webpack-howto)  
[Diving into Webpack](https://web-design-weekly.com/2014/09/24/diving-webpack/)  [Webpack and React is awesome](http://www.christianalfoni.com/articles/2014_12_13_Webpack-and-react-is-awesome)  
[React Webpack cookbook](https://christianalfoni.github.io/react-webpack-cookbook/index.html)  
[webpack-demos](https://github.com/ruanyf/webpack-demos)

Webpack是近期最火的一款模块加载器兼模块打包工具，主要是用来打包在浏览器端使用的javascript，同时也能转换、捆绑、打包其它的静态资源，例如JS（含JSX）、coffee、样式（含less/sass）、图片等都作为模块来使用和处理，输出的静态文件只剩下js与png，而css、less、jade其他的文件都合并到了js中。  
Webpack主要解决如何在一个大规模的代码库中，维护各种模块资源的分割和存放，维护它们之间的依赖关系，并且无缝的将它们整合到一起生成适合浏览器端请求加载的静态资源。  
Webpack中涉及路径配置最好使用绝对路径，建议通过`path.resolve(__dirname, "app/folder")`或`path.join(__dirname, "app", "folder")`的方式来配置，以兼容 Windows 环境。   

**特点：**

- 代码拆分、Loader、智能解析、插件系统、快速运行。 
 
**优点:**  

- webpack 是以 commonJS 的形式来书写脚本的，但对 AMD/CMD 的支持也很全面  
- 直接使用 require(XXX) 的形式来引入各模块，即使它们可能需要经过编译  
- 能被模块化的不仅仅是 JS 了  
- 开发便捷，比如打包、压缩混淆、图片转base64等  
- 扩展性强，插件机制完善，特别是支持 React 热插拔（见 react-hot-loader ） 
- 可以使用别名（alias），简化require中的内容  
- 支持多入口  

## Webpack安装

全局安装：`npm install webpack -g`  
当然如果常规项目还是把依赖写入 package.json 包去更人性化：  
`npm init`  
`npm install webpack --save-dev`  

## [配置文件](http://webpack.github.io/docs/configuration.html)

示例代码如下
```
    var webpack = require('webpack');
    // 用于提取多个入口文件的公共脚本部分，然后生成一个 common.js 来方便多页面之间进行复用。
    // 注意html中引入时先引入common.js，再引入index.s
    var commonsPlugin = new webpack.optimize.CommonsChunkPlugin('common.js');
    // 定义全局变量
    var data = 'hello world';
    module.exports = {
        // 插件项
        plugins: [commonsPlugin],
        // 页面入口文件配置
        entry: {
            index : './src/js/page/index.js'
        },
        // 入口文件输出配置
        output: {
            path: 'dist/js/page',
            filename: '[name].js'
        },
        module: {
            // 加载器配置
            loaders: [
                { test: /\.css$/, loader: 'style-loader!css-loader?modules' },// 样式开启局部作用域，如果要定义全局作用域 :global(选择器) {样式}
                { test: /\.js$/, loader: 'jsx-loader?harmony' },
                { test: /\.scss$/, loader: 'style!css!sass?sourceMap'},
                { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192'},
                { test: /\.js[x]?$/, exclude: /node_modules/, loader: 'babel-loader?presets[]=es2015&presets[]=react'},
                { test: /\.jsx?$/, exclude: /node_modules/, loader: 'babel', query: { presets: ['es2015', 'react'] } }
            ]
        },
        //其它解决方案配置
        resolve: {
            // 查找module的话从这里开始查找
            root: 'E:/github/flux-example/src', // 绝对路径
            // 自动扩展文件后缀名，意味着我们require模块可以省略不写后缀名
            extensions: ['', '.js', '.json', '.scss'],
            // 模块别名定义，方便后续直接引用别名，无须多写长长的地址
            alias: {
                AppStore : 'js/stores/AppStores.js',// 后续直接 require('AppStore') 即可
                ActionType : 'js/actions/ActionType.js',
                AppAction : 'js/actions/AppAction.js'
            }
        },
        externals: {
            // 定义全局变量，index.html中需引入data.js，即可直接使用require('data')
            'data': 'data'
        }
    };
```
- context：处理entry选项时的基础路径（绝对路径），默认值为process.cmd()，即webpack.config.js文件所在路径。  
- entry：配置入口文件，值可以是字符串、数组、对象；字符串指定的模块在项目程序启动的时候加载；字符串数组指定的所有模块被当做一个模块集，在项目程序启动的时候都会加载，数组最后一个元素作为模块集输出；对象的每个属性名作为模块集的名称，属性值可以是字符串和字符串数组。这个配置可用于实现非单页的程序，程序会有多个启动入口。  
- output.filename：打包后的文件名 '[name].js'，表示name为对应entry的键。  
- output.path：打包文件存放的绝对路径。  
- output.publicPath：网站运行时的访问路径，比如publicPath为"/test"，访问localhost:8080/test/bundle.js可访问编译后的文件。  
- module.loaders：值为一个数组，数组的每一个元素是一个对象，对象里可有text、exclude、loader以“！”分隔多个loader的string、loaders是一个字符串数组；加载器配置，以处理非javascript类型的模块，都需要先安装。  
- module.noParse：值为一个数组，声明这个模块不需要parse查找依赖，忽略对已知文件的解析。告诉当webpack尝试去解析压缩文件时，这种行为是不允许的。  
- plugins：值为一个数组，new webpack.optimize.CommonsChunkPlugin('common.js')表示提取多个入口文件的公共脚本部分生成一个 common.js。注意引入时先引入common.js，再引入index.s。如压缩打包的文件(UglifyJsPlugin)、允许错误不打断程序等。  
- resolve.root：绝对路径，查找module的话从这里开始查找。添加默认搜索路径。  
- resolve.extensions：自动扩展文件后缀名，意味着我们require模块可以省略不写后缀名。  
- resolve.alias：模块别名定义，方便后续直接引用别名，无须多写长长的地址；告诉webpack，当引入react时，试图去匹配压缩过的react。  
- externals：当我们想在项目中require一些其它的类库或者API，而又不想让这些类库的源码被构建到运行时文件中，这在实际开发中很有必要。externals: {"jquery": "jQuery"}，这样我们就可以放心的在项目中使用这些API了：var jQuery = require("jquery")。如果你想将react分离，不打包到一起，可以使用externals。然后用<script>单独将react引入。  
- devtool：就是生成sourcemap的不同方式，eval不支持IE8，推荐用source-map，开发环境常用eval-source-map。  
- debug：加载器(loader)转换到调试模式。  
- catch：缓存生成的模块，watch 模式下默认就是启动的。  

[常用Loader](http://webpack.github.io/docs/list-of-loaders.html) 
[常用plugin](http://webpack.github.io/docs/list-of-plugins.html)

**常用命令:**
```
webpack    // 执行webpack.config.js文件
webpack --display-error-details //方便出错时能查阅更详尽的信息
webpack --config XXX.js   //使用另一份配置文件（比如webpack.config2.js）来打包
webpack --watch   //监听变动并自动打包
webpack -p    //压缩混淆脚本，这个非常非常重要！
webpack -d    //生成map映射文件，告知哪些模块被最终打包到哪里了
```

## webpack-dev-server

命令：`webpack-dev-server --devtool eval --progress --colors --hot --content-base dist`  
webpack-dev-server  //启动一个小的express Web服务，8080端口  
--devtool eval   //为你的代码创建源地址。当有任何报错的时候可以让你更加精确地定位到文件和行号  
--progress // 显示合并代码进度  
--colors - Yay //命令行中显示颜色！  
--content-base build // 指向设置的输出目录，这样不能访问其它路径的文件了  
--history-api-fallback // 这样在浏览器中直接输入url才不会报Cannot GET  
--inline // 自动刷新页面  
--hot // 启动热替换  

当运行 webpack-dev-server 的时候，它会监听你的文件修改。当项目重新合并之后，会通知浏览器刷新。为了能够触发这样的行为，你需要把你的 index.html 放到 build/ 文件夹下。可访问`http://localhost:8080/webpack-dev-server/bundle`或
`http://localhost:8080/webpack-dev-server/index.html`。注意，访问带webpack-dev-server的url会自动刷新，直接访问localhost:8080的可能不刷新。

## 配置webpack-dev-server代理

## 独立打包样式文件

```
var ExtractTextPlugin = require("extract-text-webpack-plugin");
plugins: [commonsPlugin, new ExtractTextPlugin("[name].css")],
loaders:[{ test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css-loader') }],
```

## 自动编译并刷新页面

index.html 放到 build/ 文件夹下  
Index.html中添加 `<script src="http://localhost:8080/webpack-dev-server.js"></script> `
```
entry: [
    'webpack/hot/dev-server',
    'webpack-dev-server/client?http://localhost:8080',
    path.resolve(__dirname, 'app/main.js')
],
```
命令：webpack-dev-server --hot  
当Webpack-dev-server在浏览器自动刷新下运行的时候，CSS也会自动更新，不过有点不同的是，当你改变了一个 CSS 文件，属于那个文件的标签会更新新的内容但不会刷新。  
注意，访问带webpack-dev-server的url会自动刷新，直接访问localhost:8080的可能不刷新。

## 分离应用和第三方

当你的应用依赖其他库尤其是像 ReactJS 这种大型库的时候，你需要考虑把这些依赖分离出去，这样就能够让用户在你更新应用之后不需要再次下载第三方文件。记住要把这些文件都加入到你的 HTML 代码中，不然你会得到一个错误。
```
entry: {
    app: path.resolve(__dirname, 'app/main.js'),
    // 当 React 作为一个 node 模块安装的时候，
    // 我们可以直接指向它，就比如 require('react')
    vendors: ['react']
},
plugins: [
    new webpack.optimize.CommonsChunkPlugin('vendors', 'vendors.js')
]
```

## 多重入口

你的应用可能有多个路径， 就是应用中有两个或者多个 URL 相应不同的页面，这里就是提供这样的解决方案。可能你有一个普通用户页和一个管理员页，他们共享了很多代码，但是不想在普通用户页中加载所有管理员页的代码，所以好方案是使用多重入口。

## 生成html、打开浏览器

```
var HtmlwebpackPlugin = require('html-webpack-plugin');
var OpenBrowserPlugin = require('open-browser-webpack-plugin');

module.exports = {
    entry: './main.js',
    output: {
        filename: 'bundle.js'
    },
    plugins: [
        new HtmlwebpackPlugin({
            title: 'Webpack-demos',
            filename: 'index.html'
        }),
        new OpenBrowserPlugin({
            url: 'http://localhost:8080'
        })
    ]
};
```

## 在开发环境使用的代码

main.js

```javascript
document.write('<h1>Hello World</h1>');

if (__DEV__) {
  document.write(new Date());
}
```

webpack.config.js

```javascript
var webpack = require('webpack');

var devFlagPlugin = new webpack.DefinePlugin({
  __DEV__: JSON.stringify(JSON.parse(process.env.DEBUG || 'false'))
});

module.exports = {
  entry: './main.js',
  output: {
    filename: 'bundle.js'
  },
  plugins: [devFlagPlugin]
};
```

```bash
# Linux & Mac
$ env DEBUG=true webpack-dev-server

# Windows
$ set DEBUG=true
$ webpack-dev-server
```

## 代码分割

方式一  
使用`require.ensure`定义一个分割点，`require.ensure`会告诉webpack被引入的文件要编译成单独的文件，与编译输出文件bundle.js分开，index.html和weback.config.js都不需要修改。从表面上也看不出有什么不同，实际上webpack把main.js和a.js编译成不同的块bundle.js和1.bundle.js，并在bundle.js需要1.bundle.js时才加载。

```javascript
// a.js
module.exports = 'Hello World';
```

```javascript
// main.js
require.ensure(['./a'], function(require) {
  var content = require('./a');
  document.open();
  document.write('<h1>' + content + '</h1>');
  document.close();
});
```

```html
// index.html
<html>
  <body>
    <script src="bundle.js"></script>
  </body>
</html>
```

```javascript
// webpack.config.js
module.exports = {
  entry: './main.js',
  output: {
    filename: 'bundle.js'
  }
};
```

方式二  
使用`bundle-loader`

```javascript
// main.js
var load = require('bundle-loader!./a.js');

// You need to async wait until a.js is available (and get the exports)
load(function(file) {
  document.open();
  document.write('<h1>' + file + '</h1>');
  document.close();
});
```

## 提取供应商模块

可以使用`CommonsChunkPlugin`提取供应商库到单独的文件中。

```javascript
// main.js
var $ = require('jquery');
$('h1').text('Hello World');
```

```html
// index.html
<html>
  <body>
    <h1></h1>
    <script src="vendor.js"></script>
    <script src="bundle.js"></script>
  </body>
</html>
```

```javascript
// webpack.config.js
var webpack = require('webpack');
module.exports = {
  entry: {
    app: './main.js',
    vendor: ['jquery'],
  },
  output: {
    filename: 'bundle.js'
  },
  plugins: [
    new webpack.optimize.CommonsChunkPlugin(/* chunkName= */'vendor', /* filename= */'vendor.js')
  ]
};
```

如果想在其它文件使用一个模块又不想使用require引入，如使用$和jQuery但是不用`require('jquery')`，就需要使用`ProvidePlugin`。

```javascript
// main.js
$('h1').text('Hello World');
```

```javascript
// webpack.config.js
var webpack = require('webpack');
module.exports = {
  entry: {
    app: './main.js'
  },
  output: {
    filename: 'bundle.js'
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    })
  ]
};
```

## 热模块替换

方式一  
启动命令添加参数  
`webpack-dev-server --hot --inline`  
方式二  
修改webpack.config.js文件，添加HotModuleReplacementPlugin插件，修改entry  
```javascript
var webpack = require('webpack');
var path = require('path');
module.exports = {
  entry: [
    'webpack/hot/dev-server',
    'webpack-dev-server/client?http://localhost:8080',
    './index.js'
  ],
  output: {
    filename: 'bundle.js',
    publicPath: '/static/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ],
  module: {
    loaders: [{
      test: /\.jsx?$/,
      exclude: /node_modules/,
      loader: 'babel-loader',
      query: {
        presets: ['es2015', 'react']
      },
      include: path.join(__dirname, '.')
    }]
  }
};
```