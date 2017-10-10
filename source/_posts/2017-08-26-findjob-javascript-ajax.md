---
title: JavaScript-AJAX
layout: post
date: 2017-08-26 14:30:05
categories: FJ
tags: JavaScript
---
http://www.w3school.com.cn/jquery/ajax_ajax.asp

AJAX(Asynchronous JavaScript and XML)，最大的优点是在不重新加载整个页面的情况下，可以与服务器交换数据并更新部分网页内容。编写常规的AJAX代码并不容易，因为不同的浏览器对 AJAX 的实现并不相同，不过jQuery为我们解决了这个难题。

## jQuery AJAX 使用

`$.ajax([settings])` 返回其创建的 XMLHttpRequest 对象，大多数情况下你无需直接操作该函数，除非你需要操作不常用的选项以获得更多的灵活性。参数对象settings可选，参数中的所有的选项都可以通过$.ajaxSetup() 函数来全局设置。

- global: Boolean  默认为true，表示触发全局AJAX事件

- options: Object  可选，AJAX请求设置

- async: Boolean  默认为true，表示异步请求

- cache: Boolean  默认为true，dataType为script和jsonp时默认为false，false表示不缓存此页面

- ifModified: Boolean  默认为false，true表示仅在服务器数据改变时获取新数据

- timeout: Number  设置请求超时时间（毫秒），此设置将覆盖全局设置

- traditional: Boolean  如果想要用传统的方式来序列化数据，那么就设置为true

- processData: Boolean  默认为true，true表示通过data选项传递进来的数据会被转化成一个查询字符串

- context: Object  设置AJAX相关回调函数的上下文，也就是回调函数内的this，如果不设定那么this指向调用本次AJAX请求时传递的options参数

- username: String  用于响应 HTTP 访问认证请求的用户名

- password: String  用于响应 HTTP 访问认证请求的密码

- contentType: String  默认为"application/x-www-form-urlencoded"，表示发送信息至服务器时内容编码类型

- dataType: String  预期服务器返回的数据类型，如不指定jQuery将自动根据HTTP包MIME信息来智能判断，可用值："xml"、"html"、"script"、"json"、"jsonp"、"text"

- type: String  默认为GET，可选"POST"或"GET"

- headers: Object  设置请求头

- url: String  发送请求的地址，默认为当前页地址

- data: String  发送到服务器的数据、请求参数，将自动转换为请求字符串格式，processData 选项可禁止此自动转换，GET请求中将附加在URL后

- jsonp: String  在一个jsonp请求中重写回调函数的名字，来替代在"callback"

- jsonpCallback: String  为jsonp请求指定一个回调函数名，将用来取代jQuery自动生成的随机函数名。想让浏览器缓存GET请求的时候，指定这个回调函数名

- scriptCharset: String  只有当请求时dataType为"jsonp"或"script"，并且type是"GET"才会用于强制修改 charset。通常只在本地和远程的内容编码不同时使用。

- xhr: Function  需要返回一个 XMLHttpRequest 对象，默认在 IE 下是 ActiveXObject 而其他情况下是 XMLHttpRequest 。用于重写或者提供一个增强的 XMLHttpRequest 对象。

- beforeSend: Function(XMLHttpRequest)  发送请求前可修改XMLHttpRequest对象的函数，如添加自定义HTTP头。参数为XMLHttpRequest。如果返回false可以取消本次ajax请求

- complete: Function(XMLHttpRequest, TS)  请求完成后回调函数(请求成功或失败之后均调用)，参数为XMLHttpRequest 对象和一个描述请求类型的字符串

- error: Function(XMLHttpRequest, textStatus, errorThrown)  请求失败时调用此函数，参数为XMLHttpRequest对象、错误信息、捕获的异常对象

- success: Function(responseData, TS)  请求成功后的回调函数，参数为根据dataType参数进行处理后的数据和描述状态的字符串。

- dataFilter: Function(data, type)  给Ajax返回的原始数据的进行预处理的函数，data是返回的原始数据，type是dataType参数

示例如下：
```
<html>
<head>
<script type="text/javascript" src="/jquery/jquery.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
      $("#b01").click(function(){
        // 同步
        htmlobj=$.ajax({url:"/jquery/test1.txt",async:false});
        $("#myDiv").html(htmlobj.responseText);
        // 异步
        $.ajax({
            url: "/jquery/test1.txt",
            success: function(responseData) {
                $("#myDiv").html(responseData);
            }
        });
      });
    });
</script>
</head>
<body>
<div id="myDiv"><h2>通过 AJAX 改变文本</h2></div>
<button id="b01" type="button">改变内容</button>
</body>
</html>
```

## AJAX实现

```
function ajax(options) {
    options = options || {};
    options.type = (options.type || "GET").toUpperCase();
    options.dataType = options.dataType || "json";
    var params = formatParams(options.data);
    var xhr;

    //创建 - 第一步
    if (window.XMLHttpRequest) {
        xhr = new XMLHttpRequest();
    } else if(window.ActiveObject) {//IE6及以下
        xhr = new ActiveXObject('Microsoft.XMLHTTP');
    }

    //连接 和 发送 - 第二步
    if (options.type == "GET") {
        xhr.open("GET", options.url + "?" + params, true);
        xhr.send(null);
    } else if (options.type == "POST") {
        xhr.open("POST", options.url, true);
        //设置表单提交时的内容类型
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(params);
    }

    //接收 - 第三步
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            var status = xhr.status;
            if (status >= 200 && status < 300 || status == 304) {
                options.success && options.success(xhr.responseText, xhr.responseXML);
            } else {
                options.error && options.error(status);
            }
        }
    }
}

//格式化参数
function formatParams(data) {
    var arr = [];
    for (var name in data) {
        arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
    }
    arr.push(("v=" + Math.random()).replace(".", ""));
    return arr.join("&");
}
```

## GET跨域提交表单

前台代码：
```
<!doctype html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>跨域</title>
        <script src="./jquery.min.js"></script>
        <script>
        function flightHandler(data) {
            console.log('2: ',data)
        }
        window.onload = function() {
            $.ajax({
                url: "http://localhost:9432",
                type: "get", // jsonp必须是get方式，post不支持，注意
                dataType: "jsonp",
                jsonp: "callback", // 回调函数名称变量名
                jsonpCallback: "flightHandler", // 回调函数名称的值
                data: {param: '参数'},
                beforeSend: function () {
                    console.log('1');
                },
                success: function (msg) {
                    console.log('3: ',msg);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('4: ',XMLHttpRequest, textStatus, errorThrown);
                }
            });
        };
        </script>
    </head>
    <body>
    </body>
</html>
```

后台代码：
```
var http = require('http'),
    fs = require('fs'),
    url=require("url");

http.createServer(function(req, res) {
    var query = url.parse(req.url, true).query;
    var func = query.callback;
    console.log(query);
    var msg = `${func}({"txt": "success"})`;
    res.write(msg);
    res.end();  
}).listen(9432);
```

运行结果为：
```
1
2:  {txt: "success"}
3:  {txt: "success"}
```

## POST跨域提交表单

CORS（跨域资源共享，Cross-Origin Resource Sharing），定义一种跨域访问的机制，可以让AJAX实现跨域访问。CORS允许一个域上的网络应用向另一个域提交跨域AJAX请求。实现此功能非常简单，只需由服务器发送一个响应标头即可。

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Origin: http://www.test2.com");

CORS提供了一种跨域请求方案，但没有为安全访问提供足够的保障机制，如果需要信息的绝对安全，不要依赖CORS当中的权限制度，应当使用更多其它的措施来保障，比如OAuth2。CORS使用场景：

- CORS在移动终端支持的不错，可以考虑在移动端全面尝试
- jsonp是get形式，承载的信息量有限，所以信息量较大时CORS是不二选择
- 配合新的JSAPI(fileapi、xhr2等)一起使用，实现强大的新体验功能

前台代码：
```
<!doctype html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>跨域</title>
        <script src="./jquery.min.js"></script>
        <script>
        window.onload = function() {
            $.ajax({
                url: "http://localhost:9432",
                type: "post",
                dataType: "json",
                data: {param: '参数'},
                success: function (msg) {
                    console.log('3: ',msg);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('4: ',XMLHttpRequest, textStatus, errorThrown);
                }
            });
        };
        </script>
    </head>
    <body>
    </body>
</html>
```

后台代码：
```
var http = require('http'),
    fs = require('fs'),
    url=require("url");

http.createServer(function(req, res) {
    res.writeHead(200,{"Access-Control-Allow-Origin":"*"});
    // res.setHeader("Access-Control-Allow-Origin","*");

    // 设置接收数据编码格式为 UTF-8
    req.setEncoding('utf-8');
    //POST & GET ： name=zzl&email=zzl@sina.com
    var postData = "";
    // 数据块接收中
    req.addListener("data", function (postDataChunk) {
        postData += postDataChunk;
    });
    // 数据接收完毕，执行回调函数
    req.addListener("end", function () {
        console.log('数据接收完毕');
        //GET & POST  ////解释表单数据部分{name="zzl",email="zzl@sina.com"}
        var params = querystring.parse(postData);
        console.log(params);
    });
    var msg = `{"txt": "success"}`;
    res.write(msg);
    res.end();
}).listen(9432);
```
