---
title: Chrome 开发者工具
layout: post
date: 2021-02-03 09:41:36
categories: 前端知识
tags: 前端知识
---

您已进入无痕模式调试性能相关的问题，禁用页面缓存，调整网络状态为 3G

- F5, Ctrl + R / Cmd + R，刷新页面
- Ctrl + F5, Ctrl + Shift + R / Cmd + Shift + R，刷新页面并忽略缓存
- Ctrl + '+' / Cmd + Shift + '+'，放大 DevTools
- Ctrl + '-' / Cmd + Shift + '-'，缩小 DevTools
- Ctrl + 0 / Cmd + 0，DevTools 恢复大小

## 模拟设备

{% img /2021/02/03/chrome-devtools/devices.jpg 模拟设备 %}

打开调试工具，点击图中【1】所指图标可模拟设备，这个功能能够将你的浏览器变成任意一款移动设备，也能为你的网页设定宽高，点击 Edit... 可选择或添加常用设备。

## Elements 面板

{% img /2021/02/03/chrome-devtools/elements.png Elements面板 %}

Elements 面板主要用于对页面 HTML 和 CSS 的检查以及可视化编辑，左上部分是一棵 DOM 树，左下部分是选中元素及所有父节点，右边是选中元素的样式。

### 检查页面 DOM 元素

- 右击页面任意一元素，选择检查
- 快捷键 Cmd + Opt + C，或点击图中【1】所指图标，在页面中选择元素
- 鼠标悬停 Elements 面板 DOM 树上的任意一个节点，页面会用淡蓝色的蒙板在页面上标记 DOM 节点对应的页面
- 按键盘的向上、向下键可以在展开的节点之间进行切换，向左、向右键可以收缩和展开节点

点击图中【2】所指图标，Settings，Elements，勾上 Show user agent shadow DOM，可查看 placeholder 样式，如图中【3】所指。

### 编辑 DOM

如图中【4】所示，选中 DOM 节点后，可双击或回车编辑，也可右键选择相应的菜单编辑。其中，Scroll into view 可让这个元素快速滚入视图中， Force state 可以触发并保持元素的伪类状态，Break on 可以添加 DOM 节点的监听，subtree modifications 表示子元素改变时、attribute modifications 表示属性改变时、node removal 表示元素被移除时。

在 Console 面板输入 `document.body.contentEditable="true"`，可以直接对页面进行编辑。

### 检查、编辑样式

**Styles** 面板，实时编辑与所选元素相关的样式，单击属性或者属性值可进行修改，按 Tab 键修改下一个属性或值，按 Tab + Shift 修改上一个属性或值。当值是数字类型时，按上下键可以以 1 为单位递增或递减，按 Alt + 上下键以 0.1 为单位递增或递减，Shift + 上下键以 10 为单位递增或递减。点击空白处可添加新的样式。

以 “Inherited from ...” 为分界，上面的样式都是作用于元素本身的，下面的都是其继承而来的，继承的对象一般不止一个，可能是父元素，父元素的父元素...，将鼠标悬停在一个选择器上时，可以看到这个选择器所影响的所有页面元素（不包括可视区域外的元素）。

图中【5】所指部分，`:hov` 可触发并保持元素的伪类状态，用于查看伪类的 css 样式。`.cls` 可临时增删元素 class。`+` 可添加新的样式规则。

长时间悬停在某 CSS 类名上，会突出显示受该属性影响的所有节点。

**Event Listeners** 面板，查看所选元素相关的监听事件。其中 Ancestors 不勾选则只显示直接定义在所选元素上的监听事件。Ancestors 后面为监听器类型，Blocking 为典型的那些过时的事件监听，Passive 指 Passive events listeners，是一个新的 web 标准，从 Chrome 51 开始添加的一个新特性，主要用来让页面滑动更加流畅。Framework listeners 检查来自框架的事件监听。右键事件监听，弹出菜单可以快速定位到源码。

**Computed** 面板，检查、编辑所选元素的盒模型。

**Layout** 面板，Grid 布局样式调试。

**DOM Breakpoints** 面板，管理添加的 DOM 节点监听。

**Properties** 面板，所选节点对应的对象及父类们。

**Accessibility** 面板，查看 Accessibility Tree，无障碍树。

## Console 面板

{% img /2021/02/03/chrome-devtools/console.png Console面板 %}

Console 面板一方面用来记录页面在执行过程中的信息（一般通过各种 console 语句来实现），另一方面用来当做 shell 窗口来执行脚本以及与页面文档、DevTools等进行交互。

打开调试工具，可以看到 Console 面板，如果在其它面板下想同时看 Console，可以按 Esc 键，将 Console 以 "Drawer" 的形式打开。Console Drawer 中，Search 面板，可全局搜索代码，点击搜索结果，会跳到具体的源码文件。

图中【1】所指按钮为清空，可以通过快捷键 Ctrl L 清空 Console 面板，这个清空并不是真正意义的清空，还可以按向上向下的按键查看在 Console 中输入的历史。

图中【2】所指为执行环境选择器，除了当前的页面的执行环境，其它的框架、拓展都有其自己的执行环境，默认的执行环境是 "top"，点击下拉框还有其它选项，保持默认的 top 即可，如果想调试 iframe 可切换到指定的 iframe 环境。

图中【3】所指 Default levels 下拉框中勾选 Verbose，显示日志级别的信息，过滤框中输入 violation，可查看针对代码的最佳实践。

图中【4】创建一个动态监听，实时监听一个变量，如果变化了，这里也会变化，如输入 `Date.now()`。

Hide network：默认是不勾选的，Console 会报告网络问题，勾选这个功能就能过滤网络报告信息。

Preserve log：默认是不勾选的，如果勾选了，刷新页面之后信息还会被保留。

- `$()` 作为 document.querySelector() 的缩写
- `$$()` 作为 document.querySelectorAll() 的缩写，返回一个数组
- `$0 ... $4`，代表 5 个最近访问过的 DOM 或者堆对象，$0 是最近访问的
- `$_` 记录了最后一次在表达式执行的结果

在 Elements 标签页中选中一个页面元素，在 Console 标签页中，调用函数 `monitorEvents($0, 'click')`，第一个参数是当前元素（$0），第二个参数是事件名（click），按 Enter后，当被选中的元素触发了点击事件之后，Console 标签页会将该点击事件对象打印出来，调用 `unmonitorEvents($0)` 进行解绑。

如果要打印的变量是一个数组，每一个元素都是一个对象，可以使用 `console.table` 来打印，其表格化的呈现更加美观易读，如图中【5】所指。

`copy()` 是一个工具函数方便将任何东西拷贝到系统的粘贴板暂存，传入一个没有格式的JSON，会返回格式化的结果，如图中【6】所指。

`console.log()` 会在浏览器控制台打印出信息。

`console.dir()` 可以显示一个对象的所有属性和方法。

## Application 面板

{% img /2021/02/03/chrome-devtools/clear.png Clear site data %}

Application 面板查看应用信息、网页加载的所有资源，包括存储信息、缓存信息以及页面用到的图片、字体、脚本、样式等信息。

Ctrl Shift P，输入 clear，选择 Clear site data，在 Application 面板中 Storage 中可看到 Clear site data 按钮，一次性清除网站所有数据。

Frames 菜单中显示了该页面所有内容资源，顶级的 top 是一个主文档，在 top 下面是主文档的 Fonts、Images、Scripts、Stylesheets 等资源，最后一个就是主文件自身。在资源上右击后在弹出菜单选择 Reveal in Network Panel，就会跳转到 Network 面板并定位到该资源的位置。

## Network 面板

{% img /2021/02/03/chrome-devtools/network.png Network面板 %}

Network 面板可查看页面中各种资源请求的情况，如资源的名称、状态、使用的协议、资源类型、资源大小、资源时间线等情况，右键列头可以添加或隐藏列，可以根据这个进行网络性能优化。Network 面板主要分为3部分，分别为图中【1】【2】【3】，其中【3】所指为 Summary 概览，显示总的请求数、数据传输量、加载时间信息，下面详细说一下【1】【2】部分。

### Controls

图中【1】所指为 Controls 控制面板，控制 Network 的外观和功能。其中点击【4】所指过滤图标显示【6】所指过滤面板，Filter 输入框中可输入文本、正则表达式、属性过滤、`-` 开头表示取反，在显示的文件类型中，可按 Ctrl 键多选，WS 指 WebSocket，都是控制 Requests Table 具体显示哪些内容。Preserve log 勾选后刷新页面不清空 Network，Disable cache 勾选后禁用缓存。点击 Throttling 节流按钮，可模拟网络状态，默认值是 Online。点击【5】所指设置图标显示【7】所示更多控制选项，勾选 Show overview 会显示【8】所指面板，显示获取到资源的时间轴信息，其中蓝色竖线表示 DOMContentLoaded 事件被触发，并且在 Summary 以蓝色文字显示确切的时间，红色竖线表示 load 事件被触发，在 Summary 也会以红色文字显示确切的时间。勾选 Capture screenshots 重新加载页面即可捕获屏幕，双击其中的截屏可以放大显示，在放大的图下方可以点击跳转到上一帧或者下一帧，单击则可以查看该帧被捕获时的网络请求信息，并且在 Overview 上会有一条黄色竖线以标记该帧被捕获的具体时间点。

- DOMContentLoaded 事件会在页面上 DOM 完全加载并解析完毕之后触发，不会等待 CSS、图片、子框架加载完成
- load 事件会在页面上所有 DOM、CSS、JS、图片完全加载完毕之后触发

### Requests Table

图中【2】所指为 Requests Table 请求表格，按照请求的顺序排序，显示所有获取到的资源信息。点击一个请求的 Name 列可以了解更多信息，其中：

- Headers 该资源的HTTP头信息
- Preview 根据你所选择的资源类型（JSON、图片、文本）显示相应的预览
- Response 显示HTTP的Response信息
- Cookies 显示资源HTTP的Request和Response过程中的Cookies信息
- Timing 显示资源在整个请求生命周期过程中各部分花费的时间

在 Timing 标签中可以显示资源在整个请求生命周期过程中各部分时间花费信息，可能会涉及到如下过程的时间花费情况：

- Queuing 排队的时间花费，可能由于该请求被渲染引擎认为是优先级比较低的资源（图片）、服务器不可用、超过浏览器的并发请求的最大连接数（Chrome的最大并发连接数为6）
- Stalled 从HTTP连接建立到请求能够被发出送出去(真正传输数据)之间的时间花费，包含用于处理代理的时间，如果有已经建立好的连接，这个时间还包括等待已建立连接被复用的时间
- Proxy Negotiation 与代理服务器连接的时间花费
- DNS Lookup 执行DNS查询的时间，网页上每一个新的域名都要经过一个DNS查询，第二次访问浏览器有缓存的话，则这个时间为0
- Initial Connection 建立连接的时间花费，包含了TCP握手及重试时间
- SSL 完成SSL握手的时间花费
- Request sent 发起请求的时间
- Waiting (Time to first byte (TTFB)) 是最初的网络请求被发起到从服务器接收到第一个字节这段时间，它包含了TCP连接时间，发送HTTP请求时间和获得响应消息第一个字节的时间
- Content Download 获取Response响应数据的时间花费

通过按住 Shift 并且把光标移到请求行上，在该资源的上方第一个标记为绿色的资源就是该资源的发起者（请求源），有可能会有第二个标记为绿色的资源是该资源的发起者的发起者，以此类推，在该资源的下方标记为红色的资源是该资源的依赖资源，也就是对该资源的请求过程中引发了哪些资源，如下图所示。

{% img /2021/02/03/chrome-devtools/shift.png 按住shift %}

右键一个请求行，弹出菜单，其中：

- 选择 Copy -> Copy as fetch，复制为一个完整的 Fetch 请求的代码
- 选择 Block request domain 或 Block request URL，可以分别阻塞该请求所在 domain 下的所有请求 和 该请求

## Sources 面板

{% img /2021/02/03/chrome-devtools/sources.png Sources面板 %}

主要用来调试页面中的 JavaScript。Ctrl Shift P，输入 folding，选择 Enable code folding，或通过 Setting -> Preferences -> Sources，勾选 Code folding，可以在 Source 面板的编辑器和 Network 面板的 Preview 窗口下折叠 CSS 和 JavaScript 代码。设置断点可通过如下几种方式：

- 在 JS 文件中输入 `debugger` js 文件运行的时候会在此处暂停
- 在 Sources 面板中打开文件，点击行号可添加断点，有时会出现行内断点，如【4】所示，点击即可激活，右键行号，Add condition breakpoints 可添加条件断点，Add logpoint 可快速注入一条 `console.log` 消息，设置的行断点可以在 Breakpoints 小窗口做统一管理
- 在 Elements 面板右键元素，Break on 可添加 DOM 断点
- XHR/fetch Breakpoints 可添加 URL 包含某一字符串的断点，会在 XHR 调用 `send()` 那行代码的地方暂停
- Event Listener Breakpoints 可勾选某一类别的事件或者是某一具体的事件添加事件监听器断点
- 点击图中【2】所指图标可在捕获的异常处暂停，未捕获的异常不考虑

图中【1】所指按钮可停用所有断点，在不取消断点标记的情况下，使得所有断点失效；【3】所指按钮可将压缩的代码格式化显示。

当在某行代码暂停时，在调用栈窗口（Call Stack）的任意地方右键选择 Restart Frame，DevTools 会在调用栈 top 函数的第一行代码处暂停，top 函数就是指最后一个被调用的函数，在调用栈中位于最上面，所以叫 top 函数。可以在 Scope 窗口查看、编辑某些属性值和变量值，这些属性和变量按照作用域又分属在不同的地方，如局部作用域内、闭包内或者全局作用域内。在编辑器窗口打开对应的 js 文件中，可选择变量添加到 Watch 中进行监听，可在任意地方右键选择 Blackbox script 忽略该脚本文件，如第三方的库文件。可在 Settings -> Blackboxing 中统一管理黑盒中的所有脚本文件。可在编辑器窗口直接修改文件，按Command+S(Mac)或者Ctrl+S保存修改，DevTools会重新编译脚本，继续在页面上进行某些操作，比如点击事件，就可以看到修改代码的效果了。Global Listeners 显示全局监听器，在浏览器中 window 是全局对象，所以在 Global Listeners 面板中显示绑定在 window 对象上的事件监听。

Overrides 子标签，选择 + Select folder for overrides，来为 Overrides 设置一个保存重写属性的目录，启用本地覆盖 ,面板上会显示你刚刚选择的文件夹。在 Page 子标签里选择你要修改的文件，Ctrl+S 保存修改，此时会在 Overrides 中你选择的文件夹下产生目录对应的本地副本文件。当存在本地副本时，本地覆盖启用，且工作空间下有该网站的同名覆盖文件，浏览器会优先执行覆盖文件。

Content scripts 指的是 Chrome 拓展注入在网页中的脚本。

Snippets 子标签来辅助 Debugging，以创建和保存小段代码的工具，比如 可以快速给任何应用添加lodash，右键可执行。

```js
(function () {
    'use strict';

    var element = document.createElement('script');
    element.src = "https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.15.0/lodash.min.js";
    element.type = "text/javascript";
    document.head.appendChild(element);
})();
```

## Performance 面板

Performance 面板可查看页面加载过程中的详细信息，不仅可以看到通过网络加载资源的信息，还能看到解析 JS、计算样式、重绘等页面加载的方方面面的信息。Cmd + Shift + N 打开 Chrome 的无痕模式，打开 [在线DEMO](https://googlechrome.github.io/devtools-samples/jank/) 链接，Cmd + Option + I 打开开发者工具，点击 Performance 面板。

{% img /2021/02/03/chrome-devtools/performance1.png Performance面板 %}

其中，【1】中三个按钮分别表示手动开始记录、自动重启页面并记录整个页面的加载过程、清除性能录制的记录，点击【2】按钮会进行一次垃圾回收，点击【3】Capture Settings（⚙️）按钮会展示更多设置来模拟各种状况，Disable JavaScript samples 选项勾选会使工具忽略记录 JS 的调用栈，Enable advanced paint instrumentation 选项勾选会详细记录某些渲染事件的细节，Network 选项可模拟网络状态，CPU选项可进行CPU限速。

点击左上角的 Record 按钮开始记录，然后模拟正常用户使用网页，点击 Stop 停止记录，生成性能报告。

{% img /2021/02/03/chrome-devtools/performance2.png Performance报告 %}

第一部分中，右测分别有 FPS、CPU、NET、HEAP：

- FPS 对应的是帧率，绿色代表帧率正常，绿色条越高，FPS 越高，红色代表帧率低，如果发现了一个红色的长条，那就说明这些帧存在严重问题，可能会降低用户体验，FPS ≥ 60性能最佳，FPS < 24 会让用户感觉到卡顿
- CPU 部分上有黄色、紫色、绿色等色块，它们的释义看图的左下角 Summary 标签，谁的占比高，说明 CPU 主要的时间花在哪里
- NET 每条彩色横杠表示一种资源，横杠越长，检索资源所需的时间越长，每个横杠的浅色部分表示等待时间（从请求资源到第一个字节下载完成的时间）
- HEAP 就是堆内存占用

对于这个DEMO，可以很容易观察到性能问题，现在已经确定到这个页面的动画性能表现不太好，注意第四部分 Summary 面板中，也会发现CPU花费了大量的时间在 Rendering 上，提高性能就是一门做减法的艺术，目标就是减少 Rendering 的时间。

第二部分中，把鼠标移动到 Frames 的绿色条状上时，会展示这个帧的FPS。展开 Main 图表，展示了主线程运行状况，X轴代表着时间，每个长条代表着一个event，长条越长就代表这个event花费的时间越长，Y轴代表了调用栈，上面的event调用了下面的event。在事件长条的右上角出，如果出现了红色小三角，说明这个事件是存在问题的，需要特别注意。可使用键盘A键（选区轨迹左移）、D键（选区轨迹右移）、W键（缩小选区）、S键（增大选区）调整选择区域。

点击带有红色小三角的的事件，在 Summary 面板会看到详细信息，包括警告信息，如果存在 Reveal 的链接，双击它会让高亮触发这个事件的event，Reveal 下面是源码文件的链接，点击就会跳转到对应的代码处。点击 app.js:95 这个链接，就会跳转到对应的代码处，定位到是 update 方法造成的，但还不够明确。

{% img /2021/02/03/chrome-devtools/performance3.png Performance报告 %}

在 app.update 这个事件的长条下方，有很多被触发的紫色长条，放大这些事件长条，会看到它们每个都带有红色小三角，点击其中一个紫色事件长条，在 Summary 面板里展示了更多关于这个事件的信息。这里有“Forced reflow is a likely performance bottleneck.”警告，即强制回流可能是性能瓶颈，点击 Reveal 下面的源码链接 app.js:70 会跳转到需要优化的代码处。

{% img /2021/02/03/chrome-devtools/performance4.png Performance报告 %}
{% img /2021/02/03/chrome-devtools/performance5.png 源码文件 %}

这段代码的问题在于，在每个动画帧中，它会更改每个方块的位置，然后查询页面上每个方块的位置，由于样式发生了变化，浏览器不知道每个方块的位置是否发生了变化，因此必须重新布局方块以计算其位置。优化代码是将 offsetTop 替换成 style.top，后者虽然取的是上一帧动画的元素位置，但并不影响计算下一帧动画位置，省去了重排获取位置的过程，减少了不必要的重排。

## Lighthouse 面板

{% img /2021/02/03/chrome-devtools/lighthouse1.png Lighthouse 面板 %}

{% img /2021/02/03/chrome-devtools/lighthouse2.png Lighthouse 报告 %}

从以下5个方面来对页面的加载进行分析，生成报告，然后给出提高页面性能的建议。

- Performance 性能检测，如网页的加载速度、响应时间等
  - First Contentful Paint（FCP） 首次内容绘制时间
  - Speed Index（SI）速度指数，是一个页面加载性能指标，明显的页面填充的速度，此指标的分数越低越好
  - Largest Contentful Paint（LCP） 最大内容渲染时间，LCP是一个页面加载时长的技术指标，用于表示当前页面中最重要/占比最大的内容显示出来的时间点。不同于FCP，FCP代表的是第一次页面内容渲染的时间点，LCP是FCP的一个重要的补充，它可以代表当前页面主要内容展示的时间，LCP低于2.5s则表示页面加载速度优良
  - Time to Interactive（TTI）可互动时间，页面中的大多数网络资源完成加载并且CPU在很长一段时间都很空闲的所需的时间，此时可以预期CPU非常空闲，可以及时的处理用户的交互操作
  - Total Blocking Time（TBT）累积阻塞时长，TBT是一个衡量用户事件响应的指标，TBT会统计在FCP和TTI时间之间，主线程被阻塞的时间总和，当主线程被阻塞超过50ms导致用户事件无法响应，这样的阻塞时长就会被统计到TBT中，TBT越小说明页面能够更好的快速响应用户事件
  - Cumulative Layout Shift（CLS）累积布局变化量，CLS是一个衡量页面内容是否稳定的指标，CLS会将页面加载过程中非预期的页面布局的累积变动，CLS的分数越低，表明页面的布局稳定性越高，通常低于0.1表示页面稳定性良好
- Accessibility 无障碍使用，是指所创建的网站对所有用户都可用/可访问，不管用户的生理/身体能力如何、不管用户是以何种方式访问网站
- Best practices 最佳实践，实践性检测，如网页安全性，如是否开启HTTPS、网页存在的漏洞等
- SEO 搜索引擎优化，如网页 title 是否符合搜索引擎的优化标准等
- Progressive Web App 离线应用检测

点击 View Original Trace 按钮可进入 Performance 面板中进行进一步分析。

## Memory 面板

{% img /2021/02/03/chrome-devtools/memory1.png Memory面板 %}

Memory 面板可以记录某个时刻的页面内存情况，一般用于分析性能问题、内存问题。推荐用户在创建堆快照时，不要在 Console 中执行代码，也不要启用调试断点。【1】表示开始记录，【2】表示清除，【3】表示进行一次垃圾回收。开始录制前先点击下垃圾回收，如果要查看JS堆内存动态分配时间线，结束之前要再点击下垃圾回收，再结束录制。

**Heap snapshot** 用以打印堆快照，堆快照文件显示页面的 javascript 对象和相关 DOM 节点之间的内存分配，如下图所示。【1】可以选择查看内存快照的方式，【2】能够按照列出来的 Constructor 值进行筛选，【3】能够选择查看哪些阶段的对象，如 "Objects allocated before Snapshot1"、"Objects allocated between Snapshot1 and Snapshot2"。

内存快照的查看方式包括：

- Summary 总览视图，可以显示按构造函数名称分组的对象，使用此视图可以根据按构造函数名称分组的类型深入了解对象（及其内存使用），适用于跟踪 DOM 泄漏
- Comparison 对比视图，可以显示两个快照之间的不同，比较两个（或多个）内存快照在某个操作前后的差异，检查已释放内存的变化和参考计数，可以确认是否存在内存泄漏及其原因
- Containment 内容视图，此视图提供了一种对象结构视图来分析内存使用，由顶级对象作为入口，有助于分析对象的引用情况，适用于分析闭包以及深入分析对象
- Statistic 统计视图，内存使用饼状的统计图
  
内存快照信息中，各个字段代表信息如下：

- Constructor - 表示使用此构造函数创建的所有对象
- Distance - 显示使用节点最短简单路径时距根节点的距离
- Shallow Size - 显示通过特定构造函数创建的所有对象浅层大小的总和。浅层大小是指对象自身占用的内存大小（一般来说，数组和字符串的浅层大小比较大）
- Retained Size - 显示同一组对象中最大的保留大小。保留大小指某个对象删除后（其依赖项不再可到达）可以释放的内存大小
- #New - 对比视图下特有，新增项
- #Deleted - 对比视图下特有，删除项
- #Delta - 对比视图下特有，增量
- Alloc. Size - 对比视图下特有，内存分配大小
- Freed Size - 对比视图下特有，释放大小
- Size Delta - 对比视图下特有，内存增量

{% img /2021/02/03/chrome-devtools/memory2.png Heap snapshot %}

**Allocation instrumentation on timeline** 在时间轴上随着时间变化记录内存信息，显示了对象在什么时候被创建、什么时候存在内存泄漏。当勾选 Record allocation stacks 框后，还可以在 Allocation stack 面板里打印出调用堆栈。每条线的高度与最近分配的对象大小对应，竖线的颜色表示这些对象是否仍然显示在最终的堆快照中，蓝色竖线表示在时间线最后对象仍然显示，灰色竖线表示对象已在时间线期间分配，但曾对其进行过垃圾回收。可以重复执行某个动作，如果最后有不少蓝色柱被保留，这些蓝色柱就是潜在的内存泄露问题。

{% img /2021/02/03/chrome-devtools/memory3.png Allocation instrumentation on timeline %}

**Allocation sampling** 内存信息采样，使用采样的方法记录内存分配，可以查看哪些函数影响了内存的分配，并且该函数所耗内存在内存分配中占比多少，图中函数可以直接点击跳转到函数定义的文件和位置。【1】可以选择查看方式，其中：

- Chart，整个内存占用堆栈图信息，root是整个标签加载所需内存，向下逐步拆解形成的内存堆栈
- Heavy，将堆栈图自底向上的罗列出来
- Tree，将堆栈图自顶向下的罗列出来

{% img /2021/02/03/chrome-devtools/memory4.png Allocation sampling %}

## JavaScript Profiler 面板

{% img /2021/02/03/chrome-devtools/profile.png JavaScript Profiler %}

可以记录函数的耗时情况，方便找出耗时较多的函数，分析内存泄露。【1】可以选择查看方式，Chart 表示按时间先后顺序显示 CPU 性能，Heavy(Bottom Up) 根据对性能的消耗影响列出所有的函数，并可以查看该函数的调用路径，Tree(Top Down) 从调用栈的顶端（最初调用的位置）开始，显示调用结构的总体的树状图情况。

在 Chart 视图下，Overview 部分是整个录制结果的概览，柱形条的高度对应了调用堆栈的深度，也就是说柱形条高度越高，调用堆栈的深度越深。Call Stacks 部分在录制过程中被调用的函数的调用堆栈，横轴表示时间，纵轴表示调用栈，自上而下的表示函数的调用情况。视图中的函数颜色是随机显示的，相同的函数颜色标记是相同的。纵轴表示的函数调用堆栈高度仅仅是函数的调用嵌套层次比较深，不表示其重要性很高，但是横轴上一个很宽的柱形条则意味着函数的调用需要一个很长的时间去完成，那么就需要考虑去做一些优化了。将鼠标移到Call Stacks中的函数上可以显示如下信息：

- Name 函数名称
- Self time 函数的本次调用运行的时间，不包含它所调用的子函数的时间
- Total time 函数的本次调用运行的总时间，包含它所调用的子函数的运行时间
- URL 函数定义在文件中所在的位置，其格式为file.js:100，表示函数在file.js文件中的第100行
- Aggregated self time 在这次的录制过程中函数调用运行的总时间，不包含它所调用的子函数的时间
- Aggregated total time 在这次的录制过程中所有的函数调用运行的总时间，包含它所调用的子函数的时间
- Not optimized 如果优化器检测到该函数有潜在的优化空间，那么该函数会被列在这里

## Rendering 面板

{% img /2021/02/03/chrome-devtools/rendering.png Rendering面板 %}

Rendering 面板页面的绘制时间。可通过点击 More tools -> Rendering 打开，或者 ESC 弹出 Console Drawer 面板，点击左边竖形排列的三个小点，选择 Rendering 打开。

- Paint flashing 实时高亮重绘区域（绿色）
- Layout Shift Regions 实时高亮重排，及重新布局区域（蓝色）
- Layer Border 高亮成层用边框（橙色、橄榄色、青色）
- Frame Rendering Stats，显示 GPU 的信息，旧版本还有实时 FPS 显示，但新版本不知道为何没有（chrome 86）
- Scrolling performance issues 高亮可能会影响滚动性能的元素，这些元素主要指绑定了scroll事件和touch事件的元素
- Highlight ad frames 高亮用于广告的 iframe
- Hit-test borders 展示点击测试的区域
- Emulate CSS media type 模拟媒体查询是打印还是终端屏幕
- Emulate CSS media feature prefers-color-scheme 模拟媒体查询的系统主题
- Emulate CSS media feature prefers-reduced-motion 模拟媒体查询的开启动画减弱功能
- Emulate vision deficiencies 模拟色盲等视觉障碍

## Layers 面板

{% img /2021/02/03/chrome-devtools/layers.png Layers面板 %}

点击图中【1】所指按钮 ，More tools，Layers，展示页面中的分层情况的3D视图，可平移、旋转查看。

## Security 面板

{% img /2021/02/03/chrome-devtools/security.png Security面板 %}

通过该面板你可以去调试当前网页的安全和认证等问题并确保您已经在你的网站上正确地实现 HTTPS 和哪些内容没有通过 HTTPS 连接。

## Performance monitor 面板

{% img /2021/02/03/chrome-devtools/monitor.png Performance monitor面板 %}

Ctrl Shift P，输入 Show Performance Monitor 回车，可调出性能监视器，具有实时更新的可视化功能，能突出显示页面中的性能瓶颈。

## 任务管理器

{% img /2021/02/03/chrome-devtools/memory0.png 任务管理器 %}

浏览器右上角三个点的符号 -> 更多工具 -> 任务管理器，主要关注内存占用空间、Javascript使用的内存，Javascript使用的内存默认不显示，可以点击右键添加，可结束指定进程。

- 内存占用空间，表示本机内存，DOM节点存储在本机内存中，如果这个值在增加，则说明正在创建DOM节点。
- JavaScript 使用的内存，表示JS堆，这一列包含两个值，关注实际使用大小即可（括号中的数字），跳动的数字表示您网页上的可获得的对象正在使用多少内存，如果这个数字在增加，那说明正在创建新对象，或现有对象正在增长。

如果内存占用空间一直在增长但JS内存不增长，可能是浏览器还没有回收，不操作闲置一段时间看下是否会下降。如果是内存占用空间在增长，但JS内存增长得很缓慢，有可能是有JS变量引用了DOM，这个DOM节点本身不大，但影响了其他DOM节点(比如父级节点树)。

## 其它

浏览器窗口地址栏中输入 `chrome://flags/`，可以看到实验性的功能。

Settings 中，Experiments 菜单，勾选 CSS Overview，可以看到页面的 CSS 统计信息。

{% img /2021/02/03/chrome-devtools/css-overview.png CSS Overview %}

Settings 中，Experiments 菜单，勾选 Record coverage while performance tracing，在 Performance 面板进行性能录制时可选择捕获代码覆盖率。Coverage 录制结果展示了录制过程中加载的所有 JS 和 CSS 文件以及每个文件的的大小、运行时覆盖率，红色表示未执行，绿色表示已执行。

{% img /2021/02/03/chrome-devtools/coverage.png Coverage %}

Settings 中，Experiments 菜单，勾选 Automatically pretty print in Sources Panel，开启自动美化代码模式。