---
title: 零散知识
layout: post
date: 2016-09-21 17:53:42
categories: Other
tags: Other
---

## window.parent和window.opener区别

- window.parent能获取一个框架的父窗口或父框架。顶层窗口的parent引用的是它本身。
- window.opener引用的是window.open打开的页面的父页面。

## 解决不支持html5标签的办法

方式一：自己创建标签节点
```
<script>
    document.createElement(e[i]);
</script>
```

方式二：使用Google的html5shiv包（推荐）  
`<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>`

**不管使用以上哪种方法,都要初始化新标签的CSS**
```
article,aside,dialog,footer,header,section,footer,nav,figure,menu{
    display: block;
}
```

方式三：防弹衣技术
Bulletproof技术，防弹衣技术，建议在所有新的HTML5块级元素中增加一个内部的div元素，然后包含一个CSS class，用这个元素来替代HTML元素。
```
<section>
　　<div class="section">
　　<!-- content -->
　　</div>
</section>

.section {
   　　color: blue;
 }
```

## outerHTML、innerText、innerHTML

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/innerHTML.gif 一张图了解outerHTML和innerText、innerHTML %}

## echo

cmd中输入`echo %PATH%` 可查看path环境变量

## Chrome浏览器用户名、密码回填问题

前几天发现一个奇怪的问题，使用Chrome浏览器在登录输入用户名、密码后，点击了保存用户名密码，在其它页面发生了用户名、密码的回填。

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/login1.png 登录输入 %}

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/save.png 点击保存密码 %}

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/card.png 其它页面表单 %}

解决方案：在使用到Input的地方，都添加了autoComplete属性值为off和name属性，但是不同的name属性值，有的可能不会回填有的可能就会回填，我有点怀疑人生了。

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/card1.png 回填登录信息 %}

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/card2.png 没有回填登录信息 %}

**而且对于没有回填用户信息的情况，在点击密码框的时候，还是会有用户密码信息的提示，这个还没有找到解决方案。**

{% img https://zhulichao.github.io/2016/09/21/scattered-knowledge/card2.png 提示用户密码 %}

## 端口占用

netstat -aon | findstr 8088 # 查看指定端口被哪个进程占用，会返回一个进程号
tasklist | findstr 6808 # 查看指定进程号是哪个程序的
taskkill -F -IM javaw.exe # 杀死应用程序

## eclipse分配内存

右键项目 -> Run As -> -Run Configurations -> Arguments， 添加下面的信息到VM arguments中
```
-Xms256m
-Xmx512m -XX:MaxNewSize=256m -XX:MaxPermSize=512m
```

## Xshell指令更新环境

停 tomcat 重新启动
```
ps -ef|grep java            # 查进程号，12997
kill -9 12997               # 杀死进程
cd /usr/local/tomcat6/bin/  # 进入到目录
./catalina.sh start         # 启动
cd ..                       
cd logs
tail -f catalina.out        # 打日志
```

## Chrome插件生成crx文件

扩展程序->开发者模式->打包扩展程序->根据扩展程序ID，如hgmloofddffdnphfgcellkdfbfbjeloo，在C:\Users\Administrator\AppData\Local\Google\Chrome\User Data\Default\Extensions\路径下找到指定ID(hgmloofddffdnphfgcellkdfbfbjeloo)文件，双击进入，选择文件夹->打包扩展程序，即可生成crx文件。

## Thunk函数的含义

编译器的"传名调用"实现，往往是将参数放到一个临时函数之中，再将这个临时函数传入函数体。这个临时函数就叫做Thunk函数。

```
function f(m){
  return m * 2;
}
f(x + 5);

// 等同于
var thunk = function () {
  return x + 5;
};
function f(thunk){
  return thunk() * 2;
}
```

在JavaScript语言中，Thunk函数替换的不是表达式，而是多参数函数，将其替换成单参数的版本，且只接受回调函数作为参数。

```
// 正常版本的readFile（多参数版本）
fs.readFile(fileName, callback);

// Thunk版本的readFile（单参数版本）
var Thunk = function (fileName){
  return function (callback){
    return fs.readFile(fileName, callback);
  };
};
var readFileThunk = Thunk(fileName);
readFileThunk(callback);
```

## 数据库表回滚

```
# 表sy_org_user1回滚到2015-01-09 15:00:00时间
alter table sy_org_user1 enable row movement;
flashback table sy_org_user1 to timestamp to_timestamp('2015-01-09 15:00:00','yyyy-mm-dd hh24:mi:ss');
```

## Oracle数据库导入导出

```
# 导出库
exp DEV_BASE/DEV_BASE@pcmdb_192.168.100.30 file=E:\DEV_BASE.dmp owner=DEV_BASE
# 如果以前导入过，删除用户再重建
drop user DEV_BASE cascade;
create user DEV_BASE identified by DEV_BASE;
grant resource, connect, dba to DEV_BASE;
alter user DEV_BASE quota unlimited on PCMDB;
# 导入库
imp system/sys1234@orcl fromuser=DEV_BASE touser=DEV_BASE file=E:\DEV_BASE.dmp
```

## 响应式编程

响应式编程是一种面向数据流和变化传播的编程范式，这意味着可以在编程语言中很方便地表达静态或动态的数据流，而相关的计算模型会自动将变化的值通过数据流进行传播。响应式编程最初是为了简化交互式用户界面的创建和实时系统动画的绘制而提出来的一种方法，但它本质上是一种通用的编程范式。在MVC软件架构中，响应式编程允许将相关模型的变化自动反映到视图上，反之亦然。

## 检测浏览器版本

最近做的项目对浏览器的类型及版本有要求，同事写了检测浏览器版本的代码如下，我在此处进行记录，供以后参考。

```html
<!--在工程入口html文件的body标签中添加如下script内容-->
<body id="body">
<div id="react-content">
    <script>
      function cheackBowser() {
        var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
        var version = navigator.appVersion; // 浏览器版本信息
        var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器
        var isChrome = userAgent.indexOf("Chrome") > -1; //判断是否Chrome浏览器
        var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE浏览器
        var isFF = userAgent.indexOf("Firefox") > -1; //判断是否Firefox浏览器
        var isSafari = userAgent.indexOf("Safari") > -1; //判断是否Safari浏览器

        //如果是 IE 火狐 opera，提示下载qq浏览器
        if(isIE || isFF || isOpera) {
          //主页面不显示只显示弹出框，弹出弹框提示下载qq浏览器
          if(confirm("您使用的浏览器存在兼容问题，为了您更好的用户体验，建议您点击确定下载QQ浏览器")) {
              document.getElementById("react-content").style.display = "none";
              window.open("http://browser.qq.com/?adtag=SEM1", "_self");
          } else {
            //点击取消关闭此页面
            window.close();
            //如果关闭此页面被阻止则把页面清空
            if(window){
               window.location.href="about:blank";
            }
          }
        } else if(isChrome){
            var detailVersion = Number(VersionFilter(version)[0].substring(7,9));
            if(detailVersion < 45) {
              document.getElementById("react-content").style.display = "none";
              if(confirm("您使用的浏览器版本太低，为了您更好的用户体验，建议您点击确定下载QQ浏览器")) {
                window.open("https://dldir1.qq.com/invc/tt/QQBrowser_Setup_SEM1.exe","_self");
              }
            } else {
              //谷歌浏览器,版本符合要求
            }
        }
      }

      // 获取详细的chrome版本
      function VersionFilter (value) {
        var reg = /Chrome\/\d{2}\.\d+\.\d+/
         return reg.exec(value)
      }
      cheackBowser()
    </script>
</div>
</body>
```

## 打版本号

在做项目时，测试环境只要更新，最好打个版本号(tag)，这样如果这次测试的结果比较稳定，要向线上更新，直接更新指定tag的代码到线上就行了，开发人员还是正常开发提交代码。

## 元编程

简单的理解可以说成是“关于编程的编程”，或者说“与编程相关的编程”，如程序甲可以输出 A ~ Z，而程序乙可以生成程序甲，那么编写程序乙的活动就可以算作元编程。元编程更狭义的意思应该是指“编写能改变语言语法特性或者运行时特性的程序”，一种语言本来做不到的事情，通过编程来修改它，使得它可以做到了，这就是元编程。
