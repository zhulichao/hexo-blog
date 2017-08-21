---
title: JavaScript-小代码
layout: post
date: 2017-08-17 17:08:11
categories: JavaScript
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
