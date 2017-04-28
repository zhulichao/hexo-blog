---
title: React Router-基础
layout: post
date: 2016-10-29 13:13:11
categories: React Router
tags: React Router
---

## React Router

参考：  
[React Router 使用教程](http://www.ruanyifeng.com/blog/2016/05/react_router.html)  
[react-router-tutorial](https://github.com/reactjs/react-router-tutorial/tree/master/lessons)  
[react-router](https://github.com/ReactTraining/react-router)  

### 基本使用

React-Router 路由库，是官方维护的路由库，事实上也是唯一可选的路由库。它通过管理 URL，实现组件的切换和状态的变化，开发复杂的应用几乎肯定会用到。

一般在src/index.jsx中定义路由，进行整个工程路由的管理。路由匹配规则是从上到下执行，一旦发现匹配，就不再走其余的规则了。
```
import { Router, Route, hashHistory } from 'react-router';

render((
    <Router history={hashHistory}>
        <Route path="/" component={App}>
            <Route path="/home" component={CommonMainPage} />
        </Route>
    </Router>
), document.getElementById('app'));
```

子路由也可以不写在Router组件里面，单独传入Router组件的routes属性。
```
let routes = <Route path="/" component={App}>
    <Route path="/home" component={CommonMainPage} />
</Route>;
<Router routes={routes} history={browserHistory}/>
```


用户访问/home时，会先加载App组件，然后在它的内部再加载CommonMainPage组件。
```
<App>
    <Repos/>
</App>
```

App组件要写成下面的样子
```
export default React.createClass({
  render() {
    return <div>
      {this.props.children}
    </div>
  }
})
```

## path属性

Route组件的path属性指定路由的匹配规则。这个属性是可以省略的，这样的话，不管路径是否匹配，总是会加载指定组件。path属性也可以使用相对路径（不以/开头），匹配时就会相对于父组件的路径。嵌套路由如果想摆脱这个规则，可以使用绝对路由。

path可以使用通配符，如：
```
<Route path="/list/:servId" component={ListPage} />
```

在ListPage组件中通过`this.props.params.servId`可获取该变量对于在url中的值。

```
<Route path="/hello/:name">
// 匹配 /hello/michael
// 匹配 /hello/ryan

<Route path="/hello(/:name)">
// 匹配 /hello
// 匹配 /hello/michael
// 匹配 /hello/ryan

<Route path="/files/*.*">
// 匹配 /files/hello.jpg
// 匹配 /files/hello.html

<Route path="/files/*">
// 匹配 /files/ 
// 匹配 /files/a
// 匹配 /files/a/b

<Route path="/**/*.jpg">
// 匹配 /files/hello.jpg
// 匹配 /files/path/to/file.jpg
```

### IndexRoute 

IndexRoute显式指定根路由的子组件，注意没有路径参数path，即指定默认情况下加载的子组件，如访问路径/，会加载该组件。
```
<Router>
  <Route path="/" component={App}>
    <IndexRoute component={Home}/>
    <Route path="accounts" component={Accounts}/>
</Router>
```

### Redirect

Redirect组件用于路由的跳转，即用户访问一个路由，会自动跳转到另一个路由。  
`＜Redirect from="/messages/:id" to="/infos/:id" />`

### IndexRedirect

IndexRedirect组件用于访问根路由的时候，将用户重定向到某个子组件。  
`＜IndexRedirect to="/welcome" />`  
用户访问根路径时，将自动重定向到子组件welcome。

### Link

Link组件用于取代`<a>`元素，生成一个链接，允许用户点击后跳转到另一个路由。它基本上就是`<a>`元素的React 版本，可以接收Router的状态。

```
// 点击About会跳转到/about路由
<Link to="/about">About</Link>

// 点击About跳转到/about是文字显示为红色
<Link to="/about" activeStyle={{color: 'red'}}>About</Link>

// 也可以指定class 
<Link to="/about" activeClassName="active">About</Link> 
```

在Router组件之外，导航到路由页面，可以使用浏览器的History API。这种方式，对于以前没有访问过的路由是不好使的。
```
import { browserHistory } from 'react-router';
browserHistory.push('/some/path');
```

或者使用context对象。注意，pathname和state名称是固定的，跳转到pathname时会带着state的信息。在跳转进入的组件中，使用`this.props.location.state`获取这个state信息。

```
// 路由跳转
this.context.router.push({
    pathname: '/card/' + this.props.servDef.SERV_ID,
    state: this.props.listQueryData
})
```

### IndexLink

如果链接到根路由/，不要使用Link组件，而要使用IndexLink组件。这是因为对于根路由来说，activeStyle和activeClassName总是生效，因为'/'会匹配任何子路由，而IndexLink组件会使用路径的精确匹配。  
`<IndexLink to="/" activeClassName="active">`  
或者使用  
`<Link to="/" activeClassName="active" onlyActiveOnIndex={true}>Home</Link>`

### histroy

Router组件的history属性，是用来监听浏览器地址栏变化的，并将URL解析成一个地址对象，供 React Router 匹配。history属性，一共可以设置三种值。  

- **createMemoryHistory：**主要用于服务器渲染，它创建一个内存中的history对象，不与浏览器URL互动，`const history = createMemoryHistory(location)`

- **hashHistory：**路由将通过URL的hash部分#切换，类似example.com/#/some/path

- **browserHistory：**不再通过Hash完成，而显示正常的路径example.com/some/path，背后调用的是浏览器的History API。这种情况需要对[服务器改造](https://github.com/ReactTraining/react-router/blob/master/docs/guides/Histories.md#configuring-your-server)，否则用户直接向服务器请求某个子路由，会显示网页找不到的404错误。
如果开发服务器使用的是webpack-dev-server，加上--history-api-fallback参数
`webpack-dev-server --inline --content-base . --history-api-fallback`，index.html中用绝对路径引入编译后的文件`<script src="/bundle.js"></script>`

### 路由的钩子

每个路由都有Enter和Leave钩子，用户进入或离开该路由时触发。  
```
<Route path="about" component={About} />  
＜Route path="inbox" component={Inbox}>  
    ＜Redirect from="messages/:id" to="/messages/:id" />
</Route>
```
如果用户离开/messages/:id，进入/about时，会依次触发以下的钩子:  
> /messages/:id的onLeave  
> /inbox的onLeave  
> /about的onEnter  

进行路由跳转
```
<Route
    path="messages/:id"
    onEnter={({params}, replace) => replace(`/messages/${params.id}`)} 
/>
```
进行登录验证
```
<Route path="/home" component={CommonMainPage} onEnter={requireAuth}>

function requireAuth(nextState, replace) {
    if (!storage.get('token')) {
        replace({
            pathname: '/login',
            state: { nextPathname: nextState.location.pathname }
        })
    }
}
```
当用户离开一个路径的时候，跳出一个提示框，要求用户确认是否离开。setRouteLeaveHook方法为Leave钩子指定routerWillLeave函数，该方法如果返回false，将阻止路由的切换，否则就返回一个字符串，提示用户决定是否要切换。
```
const Home = withRouter(
  React.createClass({
    componentDidMount() {
      this.props.router.setRouteLeaveHook(
        this.props.route, 
        this.routerWillLeave
      )
    },

    routerWillLeave(nextLocation) {
      // 返回 false 会继续停留当前页面，
      // 否则，返回一个字符串，会显示给用户，让其自己决定
      if (!this.state.isSaved)
        return '确认要离开？';
    },
  })
)
```

### 生产环境相关

**if-env 依赖：** 如果想简化开发、在任何情况运行npm start都执行正确的脚本启动，可以安装if-env依赖`npm install if-env --save`并在package.json中这样部署，再运行`NODE_ENV=production npm start`启动
```
"scripts": {
  "start": "if-env NODE_ENV=production && npm run start:prod || npm start:dev",
  "start:dev": "webpack",
  "start:prod": "start-cluster"
}
```
为了限制浏览器可访问的文件，通常创建一个浏览器可访问的文件夹，如public，将index.html、index.css放入该目录，并在server.js中指定可访问的静态资源路径
```
app.use(express.static(path.join(__dirname, 'public')))
app.get('*', function (req, res) {
  res.sendFile(path.join(__dirname, 'public', 'index.html'))
})
```
并指定webpack输入目录也为该目录
```
output: {
  path: 'public',
  // ...
}
```
最后启动命令添加参数
```
"start:dev": "webpack-dev-server --inline --content-base public --history-api-fallback",
```

**compression 依赖:** 用该中间件压缩和处理静态内容。开启gzip压缩对Web应用会产生巨大影响，当一个gzip压缩浏览器请求某些资源的时候，服务器会在响应返回给浏览器之前进行压缩。
```
var app = express();
// 必须放在第一行
app.use(compression());
...
```

**服务器端渲染:** 

需要一个服务器渲染的webpack配置`webpack.server.config.js`，原来的webpack配置webpack.config.js还是保留的
```
var fs = require('fs');
var path = require('path');
module.exports = {
  entry: path.resolve(__dirname, 'server.js'),
  output: {
    filename: 'server.bundle.js'
  },
  target: 'node',
  // keep node_module paths out of the bundle
  externals: fs.readdirSync(path.resolve(__dirname, 'node_modules')).concat([
    'react-dom/server', 'react/addons',
  ]).reduce(function (ext, mod) {
    ext[mod] = 'commonjs ' + mod
    return ext
  }, {}),
  node: {
    __filename: true,
    __dirname: true
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader?presets[]=es2015&presets[]=react' }
    ]
  }
}
```

更新`package.json`文件，用`NODE_ENV=production npm start`启动
```
"scripts": {
  "start": "if-env NODE_ENV=production && npm run start:prod || npm run start:dev",
  "start:dev": "webpack-dev-server --inline --content-base public/ --history-api-fallback",
  "start:prod": "npm run build && node server.bundle.js",
  "build:client": "webpack",
  "build:server": "webpack --config webpack.server.config.js",
  "build": "npm run build:client && npm run build:server"
},
```

把路由管理放到单独的文件中，以便客户端和服务器端都能获取它。
```js
// modules/routes.js
import React from 'react'
import { Route, IndexRoute } from 'react-router'
import App from './App'
import About from './About'
import Repos from './Repos'
import Repo from './Repo'
import Home from './Home'

module.exports = (
  <Route path="/" component={App}>
    <IndexRoute component={Home} />
    <Route path="/repos" component={Repos}>
      <Route path="/repos/:userName/:repoName" component={Repo} />
    </Route>
    <Route path="/about" component={About} />
  </Route>
)
```

```js
// index.js
import React from 'react'
import { render } from 'react-dom'
import { Router, browserHistory } from 'react-router'
// import routes and pass them into <Router/>
import routes from './modules/routes'

render(
  <Router routes={routes} history={browserHistory}/>,
  document.getElementById('app')
)
```

```js
// ...
// import some new stuff
import React from 'react'
// we'll use this to render our app to an html string
import { renderToString } from 'react-dom/server'
// and these to match the url to routes and then render
import { match, RouterContext } from 'react-router'
import routes from './modules/routes'

// ...

// send all requests to index.html so browserHistory works

app.get('*', (req, res) => {
  // match the routes to the url
  match({ routes: routes, location: req.url }, (err, redirect, props) => {
    // `RouterContext` is the what `Router` renders. `Router` keeps these
    // `props` in its state as it listens to `browserHistory`. But on the
    // server our app is stateless, so we need to use `match` to
    // get these props before rendering.
    const appHtml = renderToString(<RouterContext {...props}/>)

    // dump the HTML into a template, lots of ways to do this, but none are
    // really influenced by React Router, so we're just using a little
    // function, `renderPage`
    res.send(renderPage(appHtml))
  })
})

function renderPage(appHtml) {
  return `
    <!doctype html public="storage">
    <html>
    <meta charset=utf-8/>
    <title>My First React Router App</title>
    <link rel=stylesheet href=/index.css>
    <div id=app>${appHtml}</div>
    <script src="/bundle.js"></script>
   `
}

var PORT = process.env.PORT || 8080
app.listen(PORT, function() {
  console.log('Production Express server running at localhost:' + PORT)
})
```