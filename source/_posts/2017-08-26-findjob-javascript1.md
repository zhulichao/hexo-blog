---
title: JavaScript-基础知识
layout: post
date: 2017-08-26 14:23:17
categories: FJ
tags: JavaScript
---

- 数据类型

    6种数据类型，其中包括5个基本数据类型：String、Number、Boolean、Null、Undefined，按值访问；1个复杂数据类型：Object，按引用访问。

- html允许跨域的标签

    script、link、img、video、audio、frame、iframe、embed等有src属性的标签，以及object（data属性）、applet（code属性），css中的@font-face。

- call、applay和bind的区别

    bind通常用来重新绑定函数体中的this并放回一个具有指定this的函数，多次bind是无效的。call和apply则表示重新指定this并调用返回结果，区别在于call采用多个实参的方式传参，apply则是使用一个数组。

    共同点：第一个参数指定为this，第二个参数起为参数传递。

    不同点：bind是用来返回具有特定this的函数，call和apply都是改变上下文中的this并立即执行这个函数。

- 单页应用(SPA)和多页应用(MPA)

    单页应用将所有的活动局限于一个Web页面中，仅在该Web页面初始化时加载相应的HTML、JavaScript和CSS。一旦页面加载完成了，SPA不会因为用户的操作而进行页面的重新加载或跳转。取而代之的是利用JavaScript动态的变换HTML的内容，从而实现UI与用户的交互。由于避免了页面的重新加载，SPA可以提供较为流畅的用户体验，但不利于SEO。MVVM这类最适合做单页面应用。

    多页面一般每个页面都有一个入口页面，页面跳转用普通的`<a href=\"\"></a>`，会进行整个页面的刷新。

- 发布订阅模式

    订阅发布模式定义了一种一对多的依赖关系，让多个订阅者对象同时监听某一个主题对象。这个主题对象在自身状态变化时，会通知所有订阅者对象，使它们能够自动更新自己的状态。当一个对象的改变需要同时改变其它对象，而且它还不知道具体有多少对象需要改变时，就可以使用订阅发布模式了。

    观察者模式与发布订阅模式很像，虽然两种模式都存在订阅者和发布者（具体观察者可认为是订阅者、具体目标可认为是发布者），区别是观察者模式是由具体目标调度的，而发布订阅模式是统一由调度中心调的，所以观察者模式的订阅者与发布者之间是存在依赖的，而发布订阅模式则不会。

- 纯函数

    纯函数是这样一种函数，即相同的输入，永远会得到相同的输出，而且没有任何可观察的副作用，JavaScript中指不依赖于且不改变它作用域之外的变量状态的函数。只要是跟函数外部环境发生的交互就都是副作用，副作用可能包含但不限于：
    
    > 更改文件系统
    > 往数据库插入记录
    > 发送一个 http 请求
    > 可变数据
    > 打印/log等IO操作
    > 获取用户输入
    > DOM 查询
    > 访问系统状态
    > 访问系统时钟

- 属性特性
    
    ES5定义了一个名叫“属性描述符”的对象，用于描述属性的各种特征，只能在Object.defineProperty或Object.defineProperties中使用。属性描述符对象有：

    4个属性：

    > configurable: 可配置性，表示能否修改属性特性，能否把属性修改为访问器属性，或者能否通过delete删除属性从而重新定义属性，默认true。设置为false后，再调用Object.defineProperty修改属性特性都会报错。
    > enumerable: 可枚举性，表示能否通过for-in遍历得到属性，默认true。
    > writable: 可写性，表示能否修改属性的值，默认为true。
    > value: 数据属性，表示属性的值，默认为undefined。
    
    2个存取器属性，分别是get和set，可以代替value和writable，存取器和value、writable不能同时存在：

    > get: 在读取属性时调用的函数，只指定get则表示属性为只读属性，默认值为undefined。
    > set: 在写入属性时调用的函数，只指定set则表示属性为只写属性，默认值为undefined。

    ```
    // 修改obj的name属性特性
    Object.defineProperty(obj, 'name', {
        writable: false,
        value: 'Tom',
    )};
    // 一次修改obj的多个属性特性
    Object.defineProperties(obj, {
        _year: {
            value: 2017,
        },
        edition: {
            value: 1,
            writable: true,
        },
        year: {
            get: function() {
                return this._year;
            },
            set: function() { ... }
        }
    });
    // 读取属性特性
    Object.getOwnPrototypeDescriptor(obj, '_year');
    // 读取所有属性特性
    Object.getOwnPrototypeDescriptors(obj);
    ```

    Object.preventExtensions(obj) 禁止扩展，禁止给对象添加属性和方法，原有的属性可修改
    Object.isExtensible(obj) 检查是否可扩展
    Object.seal() 密封对象，不可扩展、不可删除属性
    Object.isSeal() 检查是否密封
    Object.freeze() 冻结对象，不可扩展、不可删除、不可修改属性
    Object.isFrozen() 检查是否冻结

- 事件冒泡
    
    事件冒泡，从内到外；事件捕获，从外到内；DOM事件流，从外到内再从内到外回到原点。事件冒泡允许多个操作被集中处理，把事件处理器添加到一个父级元素上，避免把事件处理器添加到多个子级元素上，可以优化性能，在页面动态添加新元素后，这些新增的元素也不用再绑定事件，它还可以让你在对象层的不同级别捕获事件。

    blur、focus、load、unload不冒泡。使用addEventListener绑定事件的方法第三个参数可以控制事件触发顺序，true为事件捕获，false为事件冒泡，默认为false。使用attatchEvent绑定事件的方法不能控制事件触发顺序。

    阻止事件冒泡不能阻止对象默认行为，如submit按钮会提交表单数据。

    事件对象：
    ```
    event.keyCode // 返回keydown何keyup事件发生的时候按键的代码
    event.target // 发生事件的目标元素
    event.currentTarget // 当前处理事件的元素
    ```

    阻止冒泡：
    ```
    event.stopPropagation();
    event.stopImmediatePropagation(); // 除了该事件的冒泡行为被阻止之外，该元素绑定的后序相同类型事件的监听函数的执行也将被阻止
    window.event.cancelBubble = true; // IE下
    ```

    阻止默认行为：
    ```
    event.preventDefault();
    window.event.returnValue = false; // IE下
    ```

    在body上处理事件：
    ```
    window.onload = function() {
      document.body.addEventListener('click', function(e){
        console.log(e.target.id);
      });
    };
    ```

- cookie和session的区别与联系，怎么实现

    cookie和session都是用来跟踪浏览器用户身份的会话方式。cookie数据保存在客户端，session数据保存在服务器端。考虑到安全应当使用session，考虑到减轻服务器性能方面，应当使用cookie。

    如果web服务器端使用的是session，那么所有的数据都保存在服务器上，客户端每次请求服务器的时候会发送当前会话的sessionid，保存sessionid的方式可以采用cookie、url重写等方式，存储于浏览器内存中，服务器根据当前sessionid判断相应的用户数据标志，以确定用户是否登录或具有某种权限。由于数据是存储在服务器上面，所以你不能伪造，但是如果你能够获取某个登录用户的sessionid，用特殊的浏览器伪造该用户的请求也是能够成功的。sessionid是服务器和客户端链接时候随机分配的，一般来说是不会有重复，但如果有大量的并发请求，也不是没有重复的可能性。

    如果浏览器使用的是cookie，那么所有的数据都保存在浏览器端，比如你登录以后，服务器设置了cookie用户名，那么当你再次请求服务器的时候，浏览器会将用户名一块发送给服务器，这些变量有一定的特殊标记。如果不设置过期时间，则表示这个cookie的生命期为浏览器会话期间，关闭浏览器窗口cookie就消失。如果设置了的过期时间，浏览器会将cookie保存在客户端的硬盘上，下次再访问该网站的时候，浏览器先检查有没有cookie，如果有的话就读取该cookie，然后发送给服务器。如果直接将cookie文件拷贝到别人的浏览器目录下面，浏览器是不认的，因为它有一个index.dat文件，存储了cookie文件的建立时间，以及是否有修改，所以必须要先有该网站的cookie文件，并且要从保证时间上骗过浏览器，才能保证拷贝的cookie能生效。所以，cookie是可以伪造的，使用cookie被攻击的可能性比较大。

- Web Storage包括哪几种方式，区别是什么，没出现之前怎么做的

    HTML5中的Web Storage包括了两种存储方式：sessionStorage和localStorage。在没有Web Storage之前，是通过Cookie来在客户端存储数据的。

    sessionStorage用于本地存储一个会话（session）中的数据，这些数据只有在同一个会话中的页面才能访问，刷新页面数据依旧存在，但是当会话结束也就是页面关闭后数据也随之销毁。因此sessionStorage不是一种持久化的本地存储，仅仅是会话级别的存储。

    localStorage用于持久化的本地存储，可用于所有同源窗口或标签页（相同的域名、协议和端口），除非主动删除数据，否则数据是永远不会过期的。

|Cookie|Web Storage|
|:-----|:-----|
|4KB左右|5MB左右|
|自己封装setCookie、getCookie|提供setItem、getItem等api|
|可设置失效时间|localStorage永久保存、sessionStorage会话级别|
|HTTP规范的一部分，同源的请求都带Cookie|仅在客户端保存数据，不参与和服务器的通信|

- 正则表达式中test、exec、match

    **test**查找对应的字符串中是否存在模式，返回Boolean。当一个具有g标志的正则表达式调用test方法时，它的行为和exec相同，会从上个匹配的位置(index + 当前匹配项的长度)开始查找，这样我们就可以使用方法test来遍历字符串了。

    ```
    var str = "1a1b1c";
    var reg = new RegExp("1.", "g");
    console.log(reg.test(str)); // true
    console.log(reg.test(str)); // true
    console.log(reg.test(str)); // true
    console.log(reg.test(str)); // false
    ```

    **exec**查找并返回当前的匹配结果，并以数组的形式返回，如果不存在模式则返回null，否则总是返回一个长度为1的数组，其值就是当前匹配项，还有两个属性：index为当前匹配项的位置；input就是参数字符串。exec方法受参数g的影响。若指定了g，则下次调用exec时，会从上个匹配的位置(index+当前匹配项的长度)开始查找。

    ```
    var str = "1a1b1c";
    var reg = new RegExp("1.", "g");
    console.log(reg.exec(str)); // ["1a", index: 0, input: "1a1b1c"]
    console.log(reg.exec(str)); // ["1b", index: 2, input: "1a1b1c"]
    ```

    **match**是String对象的一个方法。match这个方法有点像exec，但exec是RegExp对象的方法。二者有一个不同点，就是对参数g的解释。如果指定了参数g，那么match一次返回所有的结果组成的数组，没有匹配则返回null。

    ```
    var str = "1a1b1c";
    var reg = new RegExp("1.", "g");
    console.log(str.match(reg)); // ["1a", "1b", "1c"]
    ```

- dom ready 的实现

    window.onload事件是等到页面上的所有资源被加载才激活，包括页面上的许多图片、音乐或falsh等资源。如果要做绑定事件、DOM操作某节点等事情，使用window.onload有点太“迟”了，比较影响用户体验。为了解决这个问题，Firefox为DOM纳入一个全新事件DOMContentLoaded，也就是后来所说的DOMReady，是在DOM树构建完毕执行，无需等待其它资源的加载，因此是在onload前加载的。

    ```
    // DOM已加载，比window.onload快，可以有多个，按序执行
    jQuery(document).ready(function() {
        ...
    });
    // 也是在页面所有元素加载完毕后执行的，但是可加载多个函数，并且可以做到js和html完全分离
    $(window).load(function() {
        ...
    });
    $(window).load(function() {
        ...
    });
    // 页面关闭时引发
    $(window).unload(function() {
        ...
    });

    // IE浏览器没有添加DOMContentLoaded事件，以下是jQuery对该事件的兼容性实现
    function domReady() {
        if (readyBound) return;
        readyBound = true;
        if (document.addEventListener) {// 对于非IE的处理
            document.addEventListener("DOMContentLoaded", function() {
                document.removeEventListener("DOMContentLoaded", arguments.callee, false);
                jQuery.ready();
            }, false);
        } else if (document.attachEvent) {// 对于IE的处理
            // 如果是在iframe中，通过document的onReadyStateChange实现
            document.attachEvent("onReadyStateChange", function() {
                if (document.readyState === "complete") {
                    document.detachEvent("onReadyStateChange", arguments.callee);
                    jQuery.ready();
                }
            });
            // 如果页面不在iframe中，通过setTimeout不断调用documentElement的doScroll方法直到调用成功
            if (document.documentElement.doScroll && typeof window.frameElement === "undefined") {
                (function() {
                    if (jQuery.isReady) return;
                    try {
                        document.documentElement.doScroll("left");
                    } catch(error) {
                        setTimeout(arguments.callee, 0);
                        return;
                    }
                    jQuery.ready();
                })();
            }
        }
        jQuery.event.add(window, "load", jQuery.ready);
    }
    ```

- img标签的图片怎么占高
    
    img外层要有div，如果已知图片宽高可直接指定div的宽高，然后将img的width样式设成100%。也可以使用预览图占位。
    
    获取图片原始尺寸：
    ```
    // js获取
    var img = document.getElementsByTagName('img')[0];
    function getImgNaturalDimensions(img, callback) {
        var nWidth, nHeight
        if (img.naturalWidth) { // 现代浏览器
            nWidth = img.naturalWidth
            nHeight = img.naturalHeight
        } else { // IE6/7/8
            // js创建一个Image
            var imgae = new Image();
            image.src = img.src;
            image.onload = function() {
                callback(image.width, image.height);
            }
            // jQuery创建img
            $("<img/>").attr("src", $(img).attr("src")).load(function() {
                callback(image.width, image.height);
            });
        }
        return [nWidth, nHeight];
    }
    ```

- js跨域的解决办法

    浏览器都有一个同源策略，其限制之一是不能通过ajax的方法去请求不同源中的文档；第二是限制浏览器中不同域的框架之间是不能进行js的交互操作的。但是不同的框架之间（父子或同辈），是能够获取到彼此的window对象的，但却不能使用获取到的window对象的属性和方法，**postMessage方法除外，**可以当做是只能获取到一个几乎无用的window对象。只要协议、域名、端口有任何一个不同，都被当作是不同的域。要解决跨域的问题，我们可以使用以下几种方法：

    **方式一、通过jsonp跨域**

    jsonp是利用`<script>`标签可以引入不同域上的js脚本文件来实现的，通过script标签引入一个js文件，这个js文件载入成功后会执行我们在url参数中指定的函数，并且会把我们需要的json数据作为参数传入。所以jsonp是需要服务器端的页面进行相应的配合的。

    ```
    /*
    js原生写法，通过http://example.com/data.php?callback=dosomething得到的js文件，就是我们之前定义的dosomething函数,并且它的参数就是我们需要的json数据，这样就跨域获得了我们需要的数据。
    */
    <script>
        function dosomething(jsondata) {
            // 相应操作
        }
    </script>
    <script src="http://example.com/data.php?callback=dosomething"></script>
    
    /*
    jQuery写法，jQuery会自动生成一个全局函数来替换callback=?中的问号，之后获取到数据后又会自动销毁。$.getJSON方法会自动判断是否跨域，不跨域就调用普通的ajax方法，跨域会以异步加载js文件的形式来调用jsonp的回调函数。
    */
    <script>
        $.getJSON('http://example.com/data.php?callback=?', function(jsondata){
            // 相应操作
        });
    </script>
    ```
    <br />
    
    **方式二、通过修改document.domain来跨子域**

    针对不同域的框架这种情况，是无法通过在页面中书写js代码来获取iframe中的东西的，这个时候可以使用document.domain，把这两个页面的document.domain都设成相同的域名就可以了。但要注意，只能把document.domain设置成自身或更高一级的父域，且主域必须相同，如果当前文档的domain就是要设置的域名，还是必须显示的设置
    document.domain。这样我们就可以通过js访问到iframe中的各种属性和对象了。

    `http://www.example.com/a.html`中：
    ```
    <iframe src="http://example.com/b.html" id="iframe" onLoad="test()"></iframe>
    <script>
        document.domain = 'example.com'; // 设置成主域
        function test() {
            alert(document.getElementById('iframe').contentWindow);
        }
    </script>
    ```
    `http://example.com/b.html`中：
    ```
    <script>
        // 在iframe载入的这个页面也设置document.domain，使之与主页面的document.domain相同
    </script>
    ```

    但是如果想在a.html页面中通过ajax直接请求b.html页面，即使设置了相同的document.domain也还是不行的，修改document.domain的方法只适用于不同子域的框架间的交互。如果想通过ajax的方法去与不同子域的页面交互，除了使用jsonp的方法外，还可以用一个隐藏的iframe来做一个代理。原理就是让这个iframe载入一个与你想要通过ajax获取数据的目标页面处在相同域的页面，这个iframe中的页面是可以正常使用ajax去获取你要的数据的，然后通过修改document.domain的方法，通过js完全控制这个iframe，这样就可以让iframe去发送ajax请求，然后收到的数据我们也可以获取到。

    **方式三、使用window.name来进行跨域**

    window.name属性有个特征，即在一个窗口(window)的生命周期内，窗口载入的所有的页面都是共享一个window.name的，即使这些页面是不同域的或url发生变化，每个页面对window.name都有读写的权限，window.name是持久存在一个窗口载入过的所有页面中的，不会因新页面的载入而进行重置。window.name的值只能是字符串的形式，最大能允许2M左右甚至更大的一个容量，具体取决于不同的浏览器，但一般是够用了。例如`www.example.com/a.html`页面里的js需要获取另一个位于不同域的页面`www.cnblogs.com/data.html`里的数据，示例代码如下：

    `www.cnblogs.com/data.html`中：
    ```
    <script>
        window.name = '我就是页面a.html想要的数据，所有可以转化成字符串来传递的数据都可以在这里使用！！！';
    </script>
    ```
    `www.example.com/a.html`中：
    ```
    <!doctype html>
    <html>
        <head>
            <meta charset="utf-8" />
            <title>window.name跨域</title>
            <script>
                function getData() {
                    var iframe = document.getElementById('proxy');
                    // 这个时候a.html与iframe已经是同源了，可以互相访问
                    iframe.onload = function() {
                        // 获取iframe里的window.name，也就是data.html页面给它设置的数据
                        var data = iframe.contentWindow.name;
                        alert(data);
                    };
                    // 这里的b.html为随便的一个页面，只要与a.html同源的就行
                    iframe.src = 'b.html';
                }
            </script>
        </head>
        <body>
            <iframe id="proxy" src="http://www.cnblogs.com/data.html" style="display:none" onload="getData()" />
        </body>
    </html>
    ```

    **方式四、使用HTML5中新引进的window.postMessage方法来跨域传送数据**

    `window.postMessage(message, targetOrigin)`方法是html5新引进的特性，不支持IE6、7旧浏览器，可以向其它的window对象发送消息，无论这个window对象是属于同源或不同源，该方法的第一个参数message为要发送的消息，类型只能为字符串；第二个参数targetOrigin用来限定接收消息的那个window对象所在的域，如果不想限定域，可以使用通配符 * 。接收消息的window对象，通过监听自身的message事件来获取传过来的消息，消息内容储存在该事件对象的data属性中。

    `test.com/a.html`中：
    ```
    <script>
        function onLoad() {
            var iframe = document.getElementById("iframe");
            var win = iframe.contentWindow;
            // 向不同域发送消息
            win.postMessage('我是来自页面a的消息！', '*');
        }
    </script>
    <iframe id="iframe" src="http://www.test.com/b.html" onload="onLoad()" />
    ```
    `www.test.com/b.html`中：
    ```
    <script>
        window.onmessage = function(e) {
            e = e || event;
            alert(e.data);
        }
    </script>
    ```

- 有分号和没分号的区别
    
    [JavaScript 语句后应该加分号么？](https://www.zhihu.com/question/20298345)

    通常情况下，解释器会自动添加分号，但有些时候不加分号还是容易引起解析错误，特别是在代码压缩的情况下，所以出于严谨考虑，还是推荐在语句结束时添加分号。还有不要把分号单单认为只是用来结束某段代码，它还可以用来隔离某段代码和别人划清界限。

    如果遇到无法解析下去则javascript解析器会尝试给其添加一个分号，如果还是解析不了则报错。javascript解析器会尽可能多的去匹配，但也有几个例外，它们是retrun、break、continue，当javascript解析器解析到这几个关键字时，它不会把换行后的内容当成是自身的，而是直接在换行之前添加分号。

    JavaScript自动加分号规则，有3条：
    > 当有换行符（包括含有换行符的多行注释），并且下一个token没法跟前面的语法匹配时，会自动补分号。
    > 当有`}`时，如果缺少分号，会补分号。
    > 当程序源代码结束时，如果缺少分号，会补分号。

    真正会导致上下行解析出问题的 token 有5个：括号，方括号，正则开头的斜杠，加号，减号。实际代码中几乎没有用正则、加号、减号作为行首的情况，所以一行开头是括号或者方括号的时候加上分号就可以了，其它时候全部不需要。

    > 在return、break、continue、后自增、后自减五种语句中，换行符可以完全替代分号的作用。
    > var if do while for continue break return with switch throw try debugger几种关键字开头的语句，以及空语句，上一行加不加分号影响不大。
    > 凡表达式语句和函数表达式语句，后面不加分号非常危险，情况极其复杂。
    > 凡`(`和`[`开头的语句，前面不加分号极度危险。

    ```
    // 例子1
    var a = 10;
    var b = 5;
    var c = a + b
    (a + b).toString() // b is not a function，同 var c = a + b(a + b).toString();

    // 例子2
    function test(){
      return 
      123;
    }
    console.log(test()); // undefined，同 return;
    ```

- 变量提升基础

    注意js运行时先执行变量提升，然后在从上往下执行。

    ```
    /*
    相当于：
    var a;
    function a() {}
    a = 1;
    */
    var a = 1;
    function a() {}
    console.log(a); // 输出 1
    ```

    ```
    /*
    相当于：
    var a;
    a = {
        x: 'x',
        a: a, // 此时a是undefined
    };
    */
    var a = {
        x: 'x',
        a: a,
    };
    console.log(a); // 输出 {x: "x", a: undefined}
    ```

    ```
    var a = {x:'x'};
    a.a = a;
    console.log(a); // 输出 {x: "x", a: {…}} a可以无限展开
    ```

- prototype基础
    
    任何对象都有`__proto__`，只有函数对象才有`prototype`，prototype.constructor指回自己，函数被当作构造函数创建实例时它的prototype将作为实例的`__proto__`。在定义prototype是显示的将constructor指向函数自己，否则constructor将指向Object，通过constructor已经无法确定对象的类型了。还有显示定义了constructor后在对象实例中是可枚举的。
    ```
    function feed() {
        this.a = 'hello';
    }
    feed.a = 'word';
    var f = new feed();
    console.log(f.a); // 输出 'hello'
    console.log(f.__proto__.a); // 输出 undefined
    console.log(f.__proto__.constructor.a); // 输出 'word'
    ```

    ```
    function feed() {
        this.a = 'hello';
    }
    feed.prototype = {
        b: 'www',
    };
    console.log(feed.prototype.constructor); // 输出 ƒunction Object() { [native code] }
    feed.prototype = {
        constructor: feed,
        b: 'www',
    };
    console.log(feed.prototype.constructor); // 输出 ƒunction feed() { this.a = 'hello'; }
    var f = new feed();
    for(var key in f) {
        console.log(key); // 依次输出 a、constructor、b
    }
    ```

- 左值和右值
    
    按字面意思，通俗地说，以赋值符号=为界，=左边的就是左值，=右边就是右值。更深一层，可以将L-value的L，理解成Location，表示定位、地址。将R-value的R理解成 Read，表示读取数据。现在的计算机数据放在内存。内存有两个很基本的属性：内存地址和内存里面放的数据。想象完全一样的箱子。每个箱子有个编号，用来区分到底是哪个箱子，箱子里面可以放东西。内存地址相当于箱子的编号，内存的数据，相当于箱子里面放的东西。变量名编译之后，会映射成内存地址。操作a=b的含义，其实就是将"b地址内存里面的数据"，放到"a地址内存"中。

    可以放在赋值符号左边的变量，即具有对应的可以由用户访问的存储单元，并且能够由用户去改变其值的量。左值表示存储在计算机内存的对象，而不是常量或计算的结果。或者说左值是代表一个内存地址值，并且通过这个内存地址，就可以对内存进行读并且写（主要是能写）操作；这也就是为什么左值可以被赋值的原因了。相对应的还有右值：当一个符号或者常量放在操作符右边的时候，计算机就读取他们的“右值”，也就是其代表的真实值。简单来说就是，左值相当于地址值，右值相当于数据值。右值指的是引用了一个存储在某个内存地址里的数据。

    ```
    1 = 2; // Uncaught ReferenceError: Invalid left-hand side in assignment
    const a; // Uncaught SyntaxError: Missing initializer in const declaration
    const b = 1;
    b = 2; // Uncaught TypeError: Assignment to constant variable
    ```

- undefined

    undefined 表示一个未声明的变量，或已声明但没有赋值的变量，或一个并不存在的对象属性，函数没有返回值时，默认返回undefined。这是undefined的几种典型用法，而判断一个变量是不是undefined，用typeof函数，typeof函数主要是返回的是字符串，主要有："number"、"string"、"boolean"、"object"、"function"、"undefined"。注意对于未声明的变量，typeof 也会返回undefined。

    null 是一个空的对象引用，undefined是声明但没有被赋值的变量，利用这两个就可以区分空对象指针和未经初始化的变量。

    ```
    console.log(null == undefined); // true
    console.log(null === undefined); // false
    ```

- 实现super

    ```
    Object.prototype.mysuper = function(){
        // 返回一个对函数的引用，该函数调用了当前函数，不能使用arguments.callee.name，arguments.callee.name的值为mysuper
        var caller = arguments.callee.caller;
        var name;
        for(var key in this){
            if(this[key] === caller){
                name = key;
                break;
            }
        }
        __proto = this.__proto__ || this.constructor.prototype;
        return __proto[name]();
    }
    function Class(){
        this.name = "class";
        this.setName = function(name){
            this.name = name;
        }
        this.getName = function(){
            return this.name;
        }
        this.method = function() {
            console.log("父类方法");
        };
    }
    function Test(){
        this.getName = function(){
            return 'sub-' +  this.mysuper();
        }
        this.method = function() {
            this.mysuper();
        }
    }
    // 实现继承
    Test.prototype = new Class();
    Test.prototype.constructor = Test;
    
    var a = new Test();
    console.log(a.getName()); // sub-class
    a.method(); // 父类方法
    ```

- 如何使用CSS实现如图效果，其中矩形：width=200px height=100px，三角形：底为40px 高为50px，并垂直居中于矩形右侧。
{% img /2017/08/26/findjob-other/css1.png 效果图 %}

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Document</title>
        <style>
            * {
                margin: 0;
                padding: 0;
            }
            .rec {
                width: 200px;
                height: 100px;
                background-color: #000;
            }
            /* 第一个 */
            .main1 {
                position: relative;
            }
            #triangle-right1 {
                width: 0;
                height: 0;
                border-top: 20px solid transparent;
                border-left: 50px solid red;
                border-bottom: 20px solid transparent;
                position: absolute;
                top: 50%;
                left: 200px;
                margin-top: -20px;
            }
            /* 第二个 */
            .main2 {
                margin-top: 10px;
                display: -webkit-flex; 
                display: -o-flex;   // 欧鹏浏览器
                display: -ms-flex;  // ie
                display: -moz-flex; //火狐
                display: flex;
                align-items: center; // 侧轴，垂直方向
            }
            #triangle-right2 {
                width: 0;
                height: 0;
                border-top: 20px solid transparent;
                border-left: 50px solid red;
                border-bottom: 20px solid transparent;
            }
        </style>
    </head>
    <body>
        <div class="main1">
            <div class="rec"></div>
            <div id="triangle-right1"></div>
        </div>  
        <div class="main2">
            <div class="rec"></div>
            <div id="triangle-right2"></div>
        </div>
    </body>
    </html>
    ```
