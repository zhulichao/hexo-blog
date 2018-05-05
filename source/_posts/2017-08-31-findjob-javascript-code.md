---
title: JavaScript-小代码
layout: post
date: 2017-08-31 17:50:00
categories: FJ
tags: JavaScript
---

- 实现Array的map
```
Array.prototype.map = function(callback, thisArg) {  
    if (this == null) {
        throw new TypeError("this is null or not defined");
    }  
    if (Object.prototype.toString.call(callback) != "[object Function]") {
        throw new TypeError(callback + " is not a function");
    }
    // 将O赋值为调用map方法的数组. 防止callback方法中修改原数组.
    var originArr = Object(this);
    // 将len赋值为数组O的长度. 如果length未定义就取0.
    var len = originArr.length >>> 0;
    var copyArg;
    if (thisArg) {
        copyArg = thisArg;
    }
    var result = new Array(len);
    var k = 0;
    while(k < len) {
        var kValue, mappedValue;
        // 遍历O,k为原数组索引
        if (k in originArr) {
            // kValue为索引k对应的值.
            kValue = originArr[k];
            // 执行callback,this指向copyArg.
            // originArr.map((kValue, k, originArr) => {});
            mappedValue = callback.call(copyArg, kValue, k, originArr);
            // 返回值添加到新数组A中.
            result[k] = mappedValue;
        }
        k++;
    }
    return result;
};
```

- js 实现快排
```
function quickSort(arr){
    // 如果数组<=1,则直接返回
    if(arr.length <= 1){
        return arr;
    }
    var pivotIndex = Math.floor(arr.length/2);
    // 找基准，并把基准从原数组删除
    var pivot = arr.splice(pivotIndex, 1)[0];
    // 定义左右数组
    var left = [];
    var right = [];
    // 比基准小的放在left，比基准大的放在right
    for(var i = 0; i < arr.length; i++){
        if(arr[i] <= pivot){
            left.push(arr[i]);
        }
        else{
            right.push(arr[i]);
        }
    }
    // 递归
    return quickSort(left).concat([pivot], quickSort(right));
}
```

- 随机选取10–100之间的10个且不重复的数字，存入一个数组并排序
```
function randomRange(start, end, count) {
    // 升序排序
    function sortFunc(a, b) {
        return a - b;
    }
    const randoms=[];
    // 跳出while循环时 randoms数组有count个元素
    while (randoms.length < count)
    {
        // 获取一个10–100范围的数
        var random = Math.floor(Math.random()*(end - start + 1) + start);
        // 判断当前随机数是否已经存在
        if (!randoms.includes(random)) {
            randoms.push(random);
        }
    }
    randoms.sort(sortFunc);
    return randoms;
}
randomRange(10, 100, 10);
```

- 获取url后面的查询参数
```
// 获取url后面指定名称的查询参数
function getUrlQueryString(name) {
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    // window.location.search 从?开始的部分，包括?
    var r = window.location.search.substr(1).match(reg);
    if (r) {
        return unescape(r[2]);// 对通过escape()编码的字符串进行解码
    }
    return null;
}
// 获取url的查询参数组成的对象
function getUrlQueryObj() { 
    //获取url中"?"符后的字串 
    var url = location.search;
    var queryObj = {}; 
    if (url.indexOf("?") > -1) { 
        var str = url.substr(1); 
        strs = str.split("&");
        strs.forEach((item) => {
            queryObj[item.split("=")[0]] = unescape(item.split("=")[1]);
        });
    }
    return queryObj; 
} 
```

- 找字符串中出现最多的字符
```
function getMost(str){
    var maxNum = 0;
    // 存放出现字数最多的字符数组，因为出现最多的字符可能有多个
    var maxCharArr = [];    
    while(str){
        var char = str.charAt(0);
        var arr = str.split(char);
        // char 字符出现的个数
        var n = str.length - arr.join('').length;
        // str 中去掉全部 char 字符
        str = arr.join('');
        if(n > maxNum){
            maxNum = n;
            maxCharArr = [char];    // 放置数组元素
        }else if( n === maxNum){
            maxCharArr.push(char);    //出现次数相同的字符 存入数组里
        }
    }
    return {'maxNum': maxNum, 'maxCharArr': maxCharArr};
}
```

- a 和 b 不使用临时变量进行交换
```
// 方式一 通过计算
function swape(a, b) {
    console.log("进入：", a, '    ', b);
    if (a === b) {
        // 不用交换
    }
    if (a < b) {
        a = b + (b - a);
        b = b - (a - b);
        a = b + (a - b)/2;
    } else {
        b = a + (a - b);
        a = a - (b - a);
        b = a + (b - a)/2;
    }
    console.log("离开：", a, '    ', b);
}

// 方式二 es5
a = [b, b = a][0];

// 方式三 es6
[a, b] = [b, a];
```

- 字符串的字节长度
```
// 方式一 将双字节字符替换为2个单字节字母
str.replace(/[\u0931-\uFFE5]/g, 'aa').length;

// 方式二 把中文替换成两个a
str.replace(/[^\x00-\xff]/g, 'aa'); 

// 方式三 循环遍历
function getStrLength (str) {
    // 获得字符串实际长度，中文2，英文1
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128)
            realLength += 1;
        else {
            realLength += 2;
        }
    }
    return realLength;
};
```

- 字符串反转
```
str.split('').reverse().join('');
```

- 数组去重
```
// 方式一 使用es6的set
arr = Array.from(new Set(arr));

// 方式二 使用indexOf和lastIndexOf判断
function uniqueArray(arr) {
    for(let i = 0; i < arr.length; i++) {
        let start = arr.indexOf(arr[i]);
        let end = arr.lastIndexOf(arr[i]);
        while(start !== end) {
            arr.splice(end, 1);
            end = arr.lastIndexOf(arr[i]);
        }
    }
}
```

- 数组扁平化
```
// 方式一 递归
function flat(array, newarray) {
    for (var i = 0; i < array.length; i++) {
        if(typeof array[i] == "number"){
            //类型为number, 则放入到新数组中
            newarray.push(array[i]);
        } else {
            //否则, 继续分解
            flat(array[i], newarray);
        }       
    }      
}
var array = [1,[3,[4],[5,[6,7]],8],[9,[10]]];
var newarray = [];
flat(array, newarray);

// 方式二 toString()，但是条件受限 
var array = [1,[3,[4],[5,[6,7]],8],[9,[10]]];
var newarray = array.toString().split(',');
```

// 方式三 使用es6的generator
```
var array = [1,[3,[4],[5,[6,7]],8],[9,[10]]];
function* iterTree(tree) {
  if (Array.isArray(tree)) {
    for(let i=0; i < tree.length; i++) {
      yield* iterTree(tree[i]);
    }
  } else {
    yield tree;
  }
}
for(let x of iterTree(array)) {
  console.log(x);
}
```

- 同一事件有多个监听方法，可分别删除监听方法

    当同一个对象使用.onclick的写法触发多个方法的时候，后一个方法会把前一个方法覆盖掉。而用addEventListener事件监听则不会有覆盖的现象，支持多重加载与冒泡捕获，每个绑定的事件都会被执行。

    ```
    // onclick绑定事件
    window.onload = function() {
        var btn = document.getElementById("yuanEvent");
        btn.onclick = function() {
            alert("第一个事件");
        };
        btn.onclick = function() {
            alert("第二个事件");
        }
    };
    // addEventListener绑定事件
    var eventOne = function() {
        alert("第一个监听事件");
    }
    function eventTwo() {
        alert("第二个监听事件");
    }
    window.onload = function() {
        var btn = document.getElementById("yuanEvent");
        // addEventListener：绑定函数
        btn.addEventListener("click", eventOne); 
        btn.addEventListener("click", eventTwo);
        // removeEventListener：取消绑定
        btn.removeEventListener("click",eventOne); 
    }
    ```

    解决onClick的写法触发后一个方法会把前一个方法覆盖的问题。
    ```
    //统计添加事件监听的个数，0作为预留位
    var eventHandlesCounter = 1;
    function addEvent(obj, evt, fn) {
        if(!fn.__EventID) {
            fn.__EventID = eventHandlesCounter++;
        }
        if(!obj.__EventHandles) {
            obj.__EventHandles = [];
        }
        if(!obj.__EventHandles[evt]) {
            obj.__EventHandles[evt] = [];
            // 这里记录已经使用onClick直接绑定的事件
            if(obj["on" + evt] instanceof Function) {
                obj["on" + evt].__EventID = 0;
                obj.__EventHandles[evt][0] = obj["on" + evt];
            }
            obj["on" + evt] = handleEvents;
        }
        obj.__EventHandles[evt][fn.__EventID] = fn;
      
        function handleEvents() {
            var fns = obj.__EventHandles[evt];
            for (var i = 0; i < fns.length; i++) {
                if(fns[i] instanceof Function) {
                    fns[i].call(this);
                }
            }
        }
    }

    function delEvent(obj, evt, fn) {
        if(!obj.__EventHandles || !obj.__EventHandles[evt] || !fn.__EventID){
            return false;
        }
        if(obj.__EventHandles[evt][fn.__EventID] == fn){
           delete obj.__EventHandles[evt][fn.__EventID];
        }
    }
    ```

- img标签，获取图片的base64编码
    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Document</title>
    </head>
    <body>
        <script type="text/javascript">
            function getBase64Image(img) {
                var canvas = document.createElement("canvas");
                canvas.width = img.width;
                canvas.height = img.height;
                var ctx = canvas.getContext("2d");
                ctx.drawImage(img, 0, 0, img.width, img.height);
                var dataURL = canvas.toDataURL("image/png");
                return dataURL;
            }

            function main() {
                var img = document.createElement('img');
                // 注意这个图片需要是同源的
                img.src = './1.png';
                img.onload =function() {
                    var data = getBase64Image(img);
                    console.log("图片的base64编码：", data);
                }
                document.body.appendChild(img);
            }

            main()
      </script>
    </body>
    </html>
    ```

- 实现String.prototype.trim函数的实现
    ```
    // 使用正则表达式
    String.prototype.trim = function() { 
        return this.replace(/(^\s*)|(\s*$)/g, ""); 
    } 
    String.prototype.trimLeft = function() { 
        return this.replace(/(^\s*)/g, ""); 
    } 
    String.prototype.trimRight = function() { 
        return this.replace(/(\s*$)/g, ""); 
    }
    ```

- 实现一个函数fn，只有一个参数，实现参数求和功能，例如console.log(parseInt(fn(0)(1)(2)(3)(4)(5)))，可以在控制台输出15。
    ```
    function fn(value) {
        function returnFn(value2) {
            value = value + value2;
            return returnFn;
        }
        returnFn.toString = returnFn.valueOf = function() {
            return value;
        }
        return returnFn;
    }
    ```

- 使用基于组件的开发模式，开发一个转盘抽奖组件，要求组件功能有：①可以设置旋转圈数②组件可复用③其它自行设计。设计对应的dom，css及js代码，最多可使用jQuery和zepto辅助。
    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>简单转盘效果</title>
        <style>
            #RotateDiv, #RotateDiv2 {
                width: 50px;
                height: 50px;
                color: #fff;
                text-align: center;
                line-height: 50px;
                background: #444;
                position: relative;
                margin: 20px;
                // 指针效果
                border-radius: 50px 0 50px 50px;
            }
        </style>
    </head>
    <body>
        <p>简单转盘：</p>
        <p> <button id="RotateBtn">开始抽奖</button> </p>
        <div id="RotateDiv"></div>
        <p>默认转动：</p>
        <p> <button id="RotateBtn2">开始抽奖2</button> </p>
        <div id="RotateDiv2"></div>
     
        <script type="text/javascript">
            window.iRotate = (function(w, d){
                function R(obj, json){
                    this.obj = (typeof obj === 'object') ? obj : d.querySelector(obj);
                    this.startTime = Date.now();
                    this.timer = null;
                    this.rotate(json);
                };
                R.prototype = {
                    rotate: function(json) {
                        var self = this;
                        var times = json['time'] || 1000;
                        clearInterval(self.timer);
                        self.timer = setInterval(function() {
                            var changeTime = Date.now();
                            // 当前消耗时间
                            var timing = Math.min(times, changeTime - self.startTime);
                            var tweenFun = Tween[json['easing'] || 'easeOut'];
                            // 根据当前时间计算转动角度
                            var value = tweenFun(
                                            timing,
                                            +json['start'] || 0,
                                            json['end'] - (+json['start'] || 0),
                                            times
                                        );
                            self.obj.style['transform'] = 'rotate(' + value%360 + 'deg)';
                            self.obj.style['-webkit-transform'] = 'rotate(' + value%360 + 'deg)';
                            self.obj.setAttribute('data-rotate', value%360);
                            // 停止旋转
                            if(timing == times){
                                clearInterval(self.timer);
                                json.callback && json.callback.call(self.obj);
                            }
                        }, 10)
                    },
                    stop: function(fn) {
                        clearInterval(this.timer);
                        fn && fn.call(this.obj);
                    }
                };
            return R;
        })(window, document);

        var Tween = {
            // 匀速转动
            linear: function (t, b, c, d){
                return c*t/d + b;
            },
            // 逐渐变慢
            easeOut: function(t, b, c, d){
                return -c *(t/=d)*(t-2) + b;
            }
        };
        
        (function(){
            // 点击转动
            var off = true;
            RotateBtn.onclick = function(){
                if(!off) return; // 判断是否在旋转
                off = false;
                new iRotate('#RotateDiv', {
                    end: 45 + 1800,
                    time: 5000,
                    callback : function(){ // 回调函数
                        this.innerHTML = this.getAttribute('data-rotate');
                        off = true;
                    }
                });
            }
            //默认转动
            var r = null;
            var off2 = true;
            function rotate2(){ // 递归持续旋转
                r = new iRotate('#RotateDiv2', {
                    start: 0,
                    end: 360,
                    time: 1000,
                    easing: 'linear',
                    callback: function(){
                        rotate2();
                    }
                });
            }
            rotate2();
            RotateBtn2.onclick = function(){
                if(!off2) return; // 判断是否在旋转
                off2 = false;
                r.stop(); // 停止之前的旋转
                new iRotate('#RotateDiv2', {
                    start: RotateDiv2.getAttribute('data-rotate'), // 如果不加这个会从0角度开始旋转，有抖动
                    end: 65 + 1800,
                    time: 5000,
                    callback: function(){ // 回调函数
                        this.innerHTML = this.getAttribute('data-rotate');
                        off2 = true;
                    }
                });
            }
        })();
        </script>
    </body>
    </html>
    ```
    
- 股票利润：假如一个数组中存储了一个股票在一天交易窗口内各时间点的股票价格（正整数），只允许一次买入和一次卖出，计算出通过卖出和买入可以得到的最大利润。

    思路：只要找出输入数组中最大的差值即可。遍历一遍数组，求出每个元素前面的最小值，每个元素与对应最小值的差即为该元素对应的收益，所有元素收益的最大值就是所求值。
    ```
    function maxProfit(prices) {
        var maxProfit = -1;
        if (!prices || prices.length === 0) {
            return maxProfit;
        }
        var minPrices = [];
        for(var i = 0; i < prices.length; i++) {
            if (i === 0) {
                // 第一个元素前的最小值是自己
                minPrices.push(prices[i]);
            } else {
                /*
                当前元素如果大于前一个最小值，则当前元素最小值为前一个的最小值，否则当前元素的最小值为当前元素
                */
                minPrices.push(minPrices[i-1] <= prices[i] ? minPrices[i-1] : prices[i]);
            }
        }
        for(var i = 0; i < prices.length; i++) {
            if (prices[i] - minPrices[i] > maxProfit) {
                maxProfit = prices[i] - minPrices[i];
            }
        }
        return maxProfit;
    }
    ```

- 实现图片墙的效果，要求所有图片显示的宽度相同，整个图片墙的高度尽可能小。

    ```html
    <!DOCTYPE HTML>
    <html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <title>瀑布流</title>
        <style>
            * {
                margin:0;
                padding:0;
            }
            #main {
                position:relative;
            }
            .box {
                padding:15px 0 0 15px;
                float:left;
            }
            .pic {
                padding:10px;
                border:1px solid #ccc;
                border-radius:5px;
                box-shadow:0 0 5px #ccc;
                background:#FFF;
            }
            img {
                width:236px; // 固定
                height:auto;
                opacity:1;
            }
            .pic:hover img {
                opacity:0.7;
            }
        </style>
    </head>
    <body>
        <div id="main"></div>
        <script type="text/javascript">
            // 如果没有加载,就可以加载
            var loading = false; 
            // 发起请求加载图片
            putDate();
            // 滚轮加载, 符合条件时, 当滚轮滚到最后一个div的一半时请求新的数据
            window.onscroll = function () {
                if (getMore()) {
                    // 这里是 ajax 请求, 如果没有加载,就可以加载, 加载完成后就设置为false未加在状态
                    if (!loading) {
                        loading = true;
                        // 发起请求加载图片
                        putDate();
                    }
                }
            };

            // 排序方法
            function waterfall(parent, box) {
                // 获取大盒子. 获取小盒子
                let parentBox = document.getElementById(parent);
                let theBox = document.getElementsByClassName(box);
                if (theBox.length === 0) {
                    return;
                }
                // 计算大盒子里能放几列小盒子
                let mainWidth = document.documentElement.clientWidth;
                let contentWidth = theBox[0].offsetWidth;
                let col = Math.floor(mainWidth/contentWidth);
                // 给大盒子设置宽度
                parentBox.style.cssText = `width: ${contentWidth*col}px; margin: 0 auto;`;
                /*
                计算 哪个盒子所在的位置的 offsetTop 最小
                创建一个数组, 把现在屏幕宽度能设置的列数,比如最大时4列, 把前4 个div的高度放进数组中,
                然后超过 4 的开始计算,
                1: 数组中谁最小,
                2: 获取他的值 作为这个将要定位的div 的 top值, 下标*contentWidth 作为 left的定位
                3: 更改数组, 把这个div的 offsetHeight + 最小值 更新这个值
                */
                let arr = [];
                [...theBox].map((item,index) =>{
                    if (index < col) {
                        arr.push(item.offsetHeight)
                    } else {
                        // 获取最小值
                        let getMinNum = Math.min.apply( null, arr);
                        // 获取最小值所在的Index
                        let getMinNumIndex = arr.findIndex(function(item) {
                            return item === getMinNum
                        });
                        theBox[index].style.cssText = `position: absolute; top: ${getMinNum}px; left: ${getMinNumIndex*contentWidth}px`;
                        arr[getMinNumIndex] += theBox[index].offsetHeight;
                    }
                });
            }

            /*
            继续加载的条件, 当滚动到最后一个div的中间位置, 就加载
            即 div.offsetTop + div.offsetHeight/2 小于 scrollTop(滚动到上面看不到的距离) + clientHeight (现在可视区域的高度) 
            */
            function getMore() {
                let theBox = document.getElementsByClassName('box');
                let len = theBox.length;
                let ele = theBox[len - 1 ];
                // 获取div的 offsetTop ,offsetHeight
                let divTop = ele.offsetTop + ele.offsetHeight/2 ;
                // 获取 scrollTop(滚动到上面看不到的距离) 可能有iframe吧
                let scrollT = document.body.scrollTop || document.documentElement.scrollTop;
                // 获取 clientHeight (现在可视区域的高度)
                let clitH = document.body.clientHeight || document.documentElement.clientHeight;
                return divTop < scrollT + clitH;
            }

            //后台请求数据
            function putDate() {
                // var xhr = ajaxContent();
                // xhr.onreadystatechange = function(){
                //  if(xhr.readyState == 4 && xhr.status == 200) {
                //      var res = JSON.parse(xhr.responseText);
                //      addImages(res);
                //  }
                // }
                // xhr.open('get','../config/data.js',true);
                // xhr.send();
                var res = [{"src":"1.jpg"},{"src":"2.jpg"},{"src":"3.jpg"},{"src":"4.jpg"},{"src":"5.jpg"},{"src":"6.jpg"},{"src":"7.jpg"},{"src":"8.jpg"},{"src":"9.jpg"},{"src":"10.jpg"},{"src":"11.jpg"},{"src":"12.jpg"},{"src":"13.jpg"},{"src":"14.jpg"},{"src":"15.jpg"},{"src":"16.jpg"},{"src":"17.jpg"},{"src":"18.jpg"},{"src":"19.jpg"},{"src":"20.jpg"},{"src":"21.jpg"},{"src":"22.jpg"},{"src":"23.jpg"},{"src":"24.jpg"},{"src":"25.jpg"},{"src":"26.jpg"},{"src":"27.jpg"},{"src":"28.jpg"},{"src":"29.jpg"},{"src":"30.jpg"}];
                addImages(res);
                
                function addImages(res) {
                    var oparent = document.getElementById('main');
                    res.map(function(item,index) {
                        var url = item.src;
                        var str ='<div class="pic"><img src="imgp/'+url+'" onload="waterfall(\'main\',\'box\')"></div>';
                        var mdiv = document.createElement('div');
                        mdiv.setAttribute('class','box')
                        mdiv.innerHTML = str;
                        oparent.appendChild(mdiv);
                        // 请求一次做一次定位
                        waterfall('main','box');
                        loading = false;
                    });
                }
            }

            // 封装ajax请求
            function ajaxContent(){
                var xhr = null;
                if(window.XMLHttpRequest){
                    xhr = new XMLHttpRequest();
                }else{
                    xhr = new ActiveXObjext('Microsoft.XMLHTTP');
                }
                return xhr;
            }
        </script>
    </body>
    </html>
    ```
