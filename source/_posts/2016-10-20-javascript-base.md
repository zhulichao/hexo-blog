---
title: JavaScript-基础
layout: post
date: 2016-10-20 07:53:53
categories: JavaScript
tags: JavaScript
---

JavaScript是单线程、基于原型、面向对象、弱类型的动态脚本语言。数据类型包括：字符串、数字、布尔、数组、对象、Null、Undefined、Symbol。
[JavaScript API](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript)

## typeof

通过typeof进行数据类型的判断，是一个一元运算，返回值为字符串，取值如下：

> number 表示数字  
> string 表示字符串  
> boolean 表示布尔  
> object 表示对象，null、对象、数组返回的都是object类型  
> symbol 表示Symbol
> undefined 表示Undefined  
> function 表示为一个函数  

## instanceof

是一个三元运算，用于判断一个对象是否是另一个对象的实例，可以在继承关系中用来判断一个实例是否属于它的父类型。

## 类型判断

字符串常量是基本类型string，new String()生成的字符串是对象类型。

```
typeof 'a' // 'string'
typeof new String('a') // 'object'
'a' instanceof String // false
new String('a') instanceof String // true
typeof null == 'object' // true
// 在浏览器环境中，通常要查看对象内部的[[Class]]值
Object.prototype.toString.call(a) // '[object String]'
```

null、undefined、''、0 在条件表达式中被判定为false  

```
typeof undefined // undefined
undefined instanceof Object // false
typeof null // 'object'
null instanceof Object // false
undefined == null // true
undefined === null // false
```

## undefined 和 null

null和undefined基本是同义的，只有一些细微的差别。

null表示"没有对象"，即该处不应该有值。典型用法是：

- 做为函数的参数，表示该函数的参数不是对象
- 作为对象原型链的终点，Object.getPrototypeOf(Object.prototype) 为 null

undefined表示"缺少值"，就是此处应该有一个值，但是还没有定义。典型用法是：

- 变量被声明了，但没有赋值时，就等于undefined
- 调用函数时，应该提供的参数没有提供，该参数等于undefined
- 对象没有赋值的属性，该属性的值为undefined
- 函数没有返回值时，默认返回undefined

## 函数参数数量

函数名.length 获取函数定义中的参数个数  
```
var fun = function (arg1, arg2) {};
fun.length; // 2
```

## 判断数组的方法

Array.isArray(a) === true  
a.constructor === Array  
Object.prototype.toString.call(a) === '[object Array]'  
a instanceof Array  

## Array API

array.push() -- 将一个或多个新元素添加到数组结尾，返回数组新长度  
array.unshift() -- 将一个或多个新元素添加到数组开始，返回数组新长度  
array.splice(pos, count, item1, ..., itemN) -- 删除从第一个数为起始、第二个参数为个数的这些元素后，在被截取掉的地方追加一个或多个从第三个参数开始的新元素，操作数组本身  
array.pop() -- 移除最后一个元素并返回该元素值  
array.shift() -- 移除最前一个元素并返回该元素值
array.slice(start, end) -- 返回第一个参数起始、第二个参数截至、左闭右开的数组，不操作数组本身  
array.concat() -- 将两个数组进行合并，返回数据合并的结果，参数可为元素序列或数组，不操作数据本身  
array.join() -- 将数组元素用参数中的符号连接起来，返回一个字符串
array.sort() -- 排序，可将排序方法以参数传入，如没有参数，按字符串正序排序的，操作数组本身
array.reverse() -- 逆序排序，操作数组本身
array.indexOf() -- 一个参数时，返回元素在数据中第一次出现的索引，比较时进行的是"==="的比较；两个参数时，第一个参数为起始位置，第二个参数为查询元素；
array.lastIndexOf() -- 类似indefOf，区别是从找到的是数组中最后一个出现的该元素的索引  
array.every(function(item, index, array){}) -- 对数组的每一个元素进行函数的运行，如果函数返回的都是true，最后则返回true；如果有一个元素返回false，最后则返回false *（注意，return false可终止循环）*  
array.some(function(item, index, array){}) -- 对数组的每一个元素进行函数的运行，如果函数有一个返回的是true，最后则返回true；如果都返回false，最后则返回false  
array.filter(function(item, index, array){}) -- 对数组的每一个元素进行函数的运行，将函数返回值为false的过滤掉返回  
array.forEach(function(item,index,array){}) -- 对数组的每一个元素进行函数的运行  
array.map(function(item,index,array){}) -- 对数组的每一个元素进行函数的运行，把函数每次运行的结果按序组成的新数组返回  
array.reduce(function(prev,cur,index,array){}) -- 调用一个函数，pre为上一次调用回调返回的值或者是提供的初始值，第二个参数为当前被处理的元素，第三个参数为当前位置，第四个参数为数组，依次将每次调用的结果替换掉数据中的元素，最后返回一个值  

[详见Array API](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array)

## Object.freeze(浅冻结)

Object.freeze(object)函数执行下面的操作：
> 使对象不可扩展，无法向其添加新属性  
> 为对象的所有属性将 configurable 特性设置为 false。在 configurable 为 false 时，无法更改属性的特性且无法删除属性  
> 为对象的所有数据属性将 writable 特性设置为 false。当 writable 为 false 时，无法更改数据属性值

实现深冻结
```
function deepFreeze(obj) {
  var propNames = Object.getOwnPropertyNames(obj);
  propNames.forEach(function(name) {
    var prop = obj[name];
    if (typeof prop == 'object' && prop !== null)
      deepFreeze(prop);
  });
  return Object.freeze(obj);
}
```

## 函数表达式没有变量提升

在JavaScript中，变量和函数的声明都会提升到作用域的最前面。函数表达式并没有被提升，这也是函数表达式与函数声明的区别。
```
(function(){
  f1(); // ReferenceError: f1 is not defined
  f2();
  var f1 = function(){};
  function f2(){}
})();
```
上面代码中函数声明f2被提升，所以在前面调用f2是没问题的。虽然变量f1也被提升，但f1提升后的值为undefined，其真正的初始值是在执行到函数表达式处被赋予的。所以只有声明是被提升的。

## try、catch、finally

```
try {
    tryStatements // 尝试执行代码块
} catch (exception) {
    catchStatements// 捕获错误的代码块
} finally {
    finallyStatements// 无论try/catch结果如何都会执行的代码块
}
```

## `__defineGetter__、__defineSetter__`

类似面向对象语言中的get和set关键字

有两种方法来定义Getter或Setter方法：

1.在对象初始化时定义  
2.在对象定义后通过在原型上定义`__defineGetter__、__defineSetter__`的方法来追加定义


## 改变上下文的方式

call -- fun.call(context, arg1, ... , argn)  
applay -- fun.call(context, [arg1, ... , argn])  
bind -- fun.bind(context, arg1, ... , argn)  

## [作用域和作用域链](http://www.cnblogs.com/lhb25/archive/2011/09/06/javascript-scope-chain.html)

### 作用域

就是变量与函数的可访问范围，即作用域控制着变量与函数的可见性和生命周期。在JavaScript中，变量的作用域有全局作用域和局部作用域两种。  

全局作用域：
> 在代码中任何地方都能访问到的对象拥有全局作用域
> 最外层函数和在最外层函数外面定义的变量拥有全局作用域
> 所有末定义直接赋值的变量自动声明为拥有全局作用域
> 所有window对象的属性拥有全局作用域

局部作用域:
> 局部作用域一般只在固定的代码片段内可访问到
> 函数内部定义的变量和函数，也会看到有人把这种作用域称为函数作用域

### 作用域链

在JavaScript中，函数也是对象。函数对象和其它对象一样，拥有可以通过代码访问的属性和一系列仅供JavaScript引擎访问的内部属性。其中一个内部属性是[[Scope]]，由ECMA-262标准第三版定义，该内部属性包含了函数被创建的作用域中对象的集合，这个集合被称为函数的作用域链，它决定了哪些数据能被函数访问。

在函数执行时，会创建一个称为“运行期上下文(execution context)”的内部对象，运行期上下文定义了函数执行时的环境。每个运行期上下文都有自己的作用域链，用于标识符解析，当运行期上下文被创建时，而它的作用域链初始化为当前运行函数的[[Scope]]所包含的对象。这些值按照它们出现在函数中的顺序被复制到运行期上下文的作用域链中。它们共同组成了一个新的对象，叫“活动对象(activation object)”，该对象包含了函数的所有局部变量、命名参数、参数集合以及this，然后此对象会被推入作用域链的前端，当运行期上下文被销毁，活动对象也随之销毁。

在函数执行过程中，每遇到一个变量，都会经历一次标识符解析过程以决定从哪里获取和存储数据。该过程从作用域链头部，也就是从活动对象开始搜索，查找同名的标识符，如果找到了就使用这个标识符对应的变量，如果没找到继续搜索作用域链中的下一个对象，如果搜索完所有对象都未找到，则认为该标识符未定义。

一般情况下，在运行期上下文运行的过程中，其作用域链只会被 with 语句和 catch 语句影响。当代码运行到with语句时，运行期上下文的作用域链临时被改变了。一个新的可变对象被创建，它包含了参数指定的对象的所有属性。这个对象将被推入作用域链的头部，这意味着函数的所有局部变量现在处于第二个作用域链对象中，因此访问代价更高了。因此在程序中应避免使用with语句。

另外一个会改变作用域链的是try-catch语句中的catch语句。当try代码块中发生错误时，执行过程会跳转到catch语句，然后把异常对象推入一个可变对象并置于作用域的头部。在catch代码块内部，函数的所有局部变量将会被放在第二个作用域链对象中。一旦catch语句执行完毕，作用域链即会返回到之前的状态。

## [闭包](http://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html)

Javascript语言，函数内部可以直接读取全局变量，在函数外部自然无法读取函数内的局部变量。如果要得到函数f1内的局部变量，就需要在函数f1的内部，再定义一个函数f2，f2可以读取f1中的局部变量，只要把f2返回，就可以在f1外部读取它的内部变量了。**这样的f2函数，就是闭包。**注意，f1是f2的父函数，而f2被赋给了一个全局变量，这导致f2始终在内存中，而f2的存在依赖于f1，因此f1也始终在内存中，不会在调用结束后，被垃圾回收机制（garbage collection）回收。

闭包可以用在许多地方，它的最大用处有两个：一个是前面提到的可以读取函数内部的变量，另一个就是让这些变量的值始终保持在内存中。

使用闭包的注意点：
1）由于闭包会使得函数中的变量都被保存在内存中，内存消耗很大，所以不能滥用闭包，否则会造成网页的性能问题，在IE中可能导致内存泄露，解决方法是，在退出函数之前，将不使用的局部变量全部删除。
2）闭包会在父函数外部，改变父函数内部变量的值。所以，如果你把父函数当作对象使用，把闭包当作它的公用方法，把内部变量当作它的私有属性，这时一定要小心，不要随便改变父函数内部变量的值。

## 原型、原型链

[理解JavaScript原型](http://blog.jobbole.com/9648/)  
[彻底理解JavaScript原型](http://blog.csdn.net/wxw_317/article/details/49617767)

### 原型

原型是一个对象，所有对象都可以成为原型，其它对象可以通过它实现属性继承。原型真正魅力体现在多个实例共用一个通用原型的时候。如果试图获取一个主数据类型的原型时，它会被强制转化成了一个对象。

构造函数提供了一种方便的跨浏览器机制，这种机制允许在创建实例时为实例提供一个通用的原型。函数A的原型属性(prototype property )是一个对象，当这个函数被用作构造函数来创建实例时，该函数的原型属性将被作为原型赋值给所有对象实例，即所有实例的原型引用的是函数的原型属性。**即所有实例的原型引用的是函数的原型属性。**

如果修改了构造函数的原型属性，那么已经存在的该构造函数的实例将获得构造函数的最新版本。
如果修改了构造函数的原型属性所指向的对象，那么新创建实例时实例原型所指向的是新对象，但是这并不会影响已经创建的实例的原型。

要注意区分原型属性和原型对象：  
> `object.prototype` -- 原型属性    
> `Object.getPrototypeOf(object) 、object.__proto__ 、object.constructor.prototype` -- 原型对象，真正的原型   
> constructor -- 是原型对象的属性，对应创建所有指向该原型的实例的构造函数   
> 对于所有对象，都有`__proto__`属性，这个属性对应该对象的原型    
> 对于所有函数对象，除了`__proto__`属性之外，还有`prototype`属性，当一个函数被用作构造函数来创建实例时，该函数的`prototype`属性值将被作为原型赋值给所有对象实例（也就是设置实例的`__proto__`属性）

通过修改原型可以达到继承的效果，如:
```
var a = {};
a.__proto__ = Array.prototype;
a.length; // 0
```

{% img https://zhulichao.github.io/2016/10/20/javascript-base/prototype.png 原型示意图 %}

### 原型链

所有的对象在默认的情况下都有一个原型，因为原型本身也是对象，所以每个原型自身又有一个原型，对象的原型指向对象的父，而父的原型又指向父的父，我们把这种通过原型层层连接起来的关系撑为原型链。这条链的末端一般总是默认的对象原型。

所有对象的原型都将追溯到"Object{}"对象，Object对象本身是一个函数对象。如果a的原型属于A的原型链，表达式 a instance of A 值为true。

原型的继承机制是发生在内部且是隐式的。当想要获得一个对象a的属性foo的值，javascript会在原型链中查找foo的存在，如果找到则返回foo的值，否则undefined被返回。如果想要覆盖原型链上的一些属性，就可以直接在对象中定义这些属性。

`hasOwnProperty`是`Object.prototype`的一个方法，该方法能判断一个对象是否包含自定义属性而不是原型链上的属性，`hasOwnProperty`是JavaScript中唯一一个处理属性但是不查找原型链的函数。

二维作用域链查找：当代码需要查找一个属性或者描述符的时候，首先会通过作用域链来查找相关的对象；一旦对象被找到，就会根据该对象的原型链来查找属性。

## 严格模式

详见 [Javascript 严格模式详解](http://www.ruanyifeng.com/blog/2013/01/javascript_strict_mode.html)

## DOM和BOM

参考  [DOM与BOM](http://www.cnblogs.com/yexiaochai/archive/2013/05/28/3102674.html) 和 [BOM和DOM详解](http://www.jb51.net/article/55851.htm)

javascript 有三部分构成：ECMAScript，DOM和BOM。根据宿主（浏览器）的不同，具体的表现形式也不尽相同，ie和其他的浏览器风格迥异。
> 核心（ECMAScript）：描述了JS的语法和基本对象  
> 文档对象模型（DOM）：描述了处理网页内容的方法和接口，Document对象  
> 浏览器对象模型（BOM）：描述了与浏览器交互的方法和接口，Window对象  

### DOM（Document Object Model）

DOM（文档对象模型）是W3C的标准，所有浏览器公共遵守的标准。  
DOM 是HTML和XML的应用程序接口（API），就是把「文档」当做一个「对象」来看待。  
DOM 使程序和脚本有能力动态地访问和更新文档的内容、结构以及样式，是平台和语言中立的接口。
{% img https://zhulichao.github.io/2016/10/20/javascript-base/DOM.gif DOM基本操作思维导图 %}

### BOM（Browser Object Model）

BOM（浏览器对象模型）是各个浏览器厂商根据DOM在各自浏览器上的实现，表现为不同浏览器定义有差别，实现方式不同。  
BOM 就是把「浏览器」当做一个「对象」来看待，BOM除了可以访问文档中的组件之外，还可以访问浏览器的组件。  
BOM 定义了JavaScript可以进行操作的浏览器的各个功能部件的接口，主要处理浏览器窗口和框架，不过通常浏览器特定的JavaScript扩展都被看做BOM的一部分，这些扩展包括：  
> 弹出新的浏览器窗口  
> 移动、关闭浏览器窗口以及调整窗口大小  
> 提供Web浏览器详细信息的定位对象  
> 提供用户屏幕分辨率详细信息的屏幕对象  
> 对cookie的支持  
> IE扩展了BOM，加入了ActiveXObject类，可以通过JavaScript实例化ActiveX对象

{% img https://zhulichao.github.io/2016/10/20/javascript-base/Window.gif Window对象思维导图 %}

注意：window 是 BOM 对象，而非 js 对象  

### 关系

Javacsript是通过访问BOM对象来访问、控制、修改客户端(浏览器)，由于**BOM的window**包含了document，因此可以直接使用window对象的document属性来访问、检索、修改XHTML文档内容与结构。因为**document对象又是DOM**模型的根节点，也就是DOM的最根本的对象是BOM的window对象的子对象，可以说，BOM包含了DOM，浏览器提供出来给予访问的是BOM对象，从BOM对象再访问到DOM对象，从而js可以操作浏览器以及浏览器读取到的文档。  
区别：DOM描述了处理网页内容的方法和接口，BOM描述了与浏览器进行交互的方法和接口。

{% img https://zhulichao.github.io/2016/10/20/javascript-base/domAndBom.jpg BOM和DOM的结构关系示意图 %}

## 获取字符串实际长度(包含汉字)

方法一  
```
function getStrLength1 (str) {
  // 获得字符串实际长度，中文2，英文1
  var realLength = 0, len = str.length, charCode = -1;
  for (var i = 0; i < len; i++) {
    charCode = str.charCodeAt(i);
    if (charCode >= 0 && charCode <= 128)
      realLength += 1;
    else
      realLength += 2;
  }
  return realLength;
};

```

方法二  
```
function getStrLength2 (str) {
  // 先把中文替换成两个字节的英文，再计算长度
  // [\u0391-\uFFE5]匹配双字节字符（汉字+符号）
  // str.replace(/[^\x00-\xff]/g, 'aa');
  // [^\x00-\xff]，匹配双字节字符，检查是否是汉字或者全角
  return str.replace(/[\u0391-\uFFE5]/g,"aa").length;  
};  
```

## 关联数组

关联数组是指每个元素自定义字符串的下标的数组，由于是自定义的下标所以关联数组的length属性没有效果。

```
// 直接定义数组
myhash = {"key1": "val1", "key2": "val2" }

// 用Array 定义数组
myhash = new Array();
myhash["key1"] = "val1";
myhash["key2"] = "val2";
```

感觉关联数组和对象基本上一样，目前只看到**可以用`obj.key1`引用对象的属性，但不能`myhash.key1`这样引用数组的元素**这一个区别。


## 对象遍历

发现javascript中的对象，如果key值为整数或整数字符，则该对象会的属性会按key值排序，使用时要注意。

{% img https://zhulichao.github.io/2016/10/20/javascript-base/obj1.png 对象属性 %}

## JSON对象

### JSON.stringify(value [, replacer] [, space]) 

- value：是必选字段。就是你输入的对象，比如数组，类等。 
- replacer：这个是可选的。它又分为2种方式，一种是数组，第二种是方法。 
    - 情况一：replacer为数组时，通过后面的实验可以知道，它是和第一个参数value有关系的。一般来说，系列化后的结果是通过键值对来进行表示的。 所以，如果此时第二个参数的值在第一个存在，那么就以第二个参数的值做key，第一个参数的值为value进行表示，如果不存在，就忽略。
    - 情况二：replacer为方法时，那很简单，就是说把系列化后的每一个对象（记住是每一个）传进方法里面进行处理。 
- space：就是用什么来做分隔符的。
    - 如果省略的话，那么显示出来的值就没有分隔符，直接输出来 。
    - 如果是一个数字的话，那么它就定义缩进几个字符，当然如果大于10 ，则默认为10，因为最大值为10。
    - 如果是一些转义字符，比如“\t”，表示回车，那么它每行一个回车。 
    - 如果仅仅是字符串，就在每行输出值的时候把这些字符串附加上去。当然，最大长度也是10个字符。 

### JSON.parse() 

将字符串转为json对象，不允许有尾逗号

## 操作event对象

在我的项目中，想要点击Grid行的时候有点击行首部Checkbox的效果，对我来说最简单的方式就是在点击行的事件中调用点击Checkbox的方法handleChecked，但handleChecked需要event参数并且要取event.target.checked值。于是我克隆了一个event对象，显示的给它的target.checked赋值，并使用下面的语句给event的target赋checked属性，即可达到想要的效果。
```
event.target.setAttribute('checked', true);
event.target.getAttribute('checked', true);
```

## 如何让setTimeout立即执行

注意，不是time, 而是time(), 这样浏览器解码的时候扫到这一行的代码直接就执行了。
```
function time(){
  console.log("it's A good question");
}
setTimeOut( time(), 100000 );
```

## 实现鼠标双击事件不触发单击事件

```
var timeFunName = null;
// 单击事件处理
$("button").bind("click", function () {         
  // 取消上次延时未执行的方法      
  clearTimeout(timeFunName);
  // 延时300毫秒执行单击
  timeFunName = setTimeout(function () {
    // TODO 执行单击操作
  }, 300);
});
// 双击事件处理
$("button").bind("dblclick", function () {
  // 取消上次延时未执行的方法
  clearTimeout(timeFunName);
  // TODO 执行双击操作
});
```
