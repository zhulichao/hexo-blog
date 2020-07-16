---
title: Lodash 之 debounce
layout: post
date: 2018-01-26 10:17:56
categories: JavaScript
tags: JavaScript
---

## 了解 Throttling（防抖） 和 Debouncing（节流）

参考：
[The Difference Between Throttling and Debouncing](https://css-tricks.com/the-difference-between-throttling-and-debouncing/)
[Debouncing and Throttling Explained Through Examples](https://css-tricks.com/debouncing-throttling-explained-examples/)

应用场景：一个典型的应用场景是浏览器窗口中 scrolling 和 resizing，如设置了滚动的监听函数，在滚动 5000px的时候可能会触发 100 次以上的监听事件，如果监听事件做了大量计算或操作很多 DOM 元素，可能就会遇到性能问题。即时搜索也有同样的问题。

相同点：它们是为了解决性能问题而限制基于 DOM 事件的 JavaScript 的执行次数的两种方式，这是在事件和函数执行之间加的控制，因为 DOM 事件的触发频率是无法控制的。

不同点：**Throttling** 是限制一个函数能够被执行的最大时间间隔，保证了函数至少每隔 X 毫秒会被调用一次，如每隔 100ms 执行一次函数。**Debouncing** 是限制一个函数距上次调用达到一定时间间隔才会被再次调用，相当于连续的事件被分成了一组，只触发一次函数调用，如距上次调用达到 100ms 才会再次执行。

## 了解 requestAnimationFrame

`window.requestAnimationFrame(callback)` 方法告诉浏览器执行动画并请求浏览器在下一次重绘之前调用函数 callback 来更新动画，返回一个 long 整数的 ID，可以通过传此值到 `window.cancelAnimationFrame()` 来取消回调函数的执行，注意只是在下一次重绘时调用回调函数。

requestAnimationFrame 的优势，在于充分利用显示器的刷新机制，比较节省系统资源。显示器有固定的刷新频率（60Hz 或 75Hz），requestAnimationFrame 的基本思想就是与这个刷新频率保持同步，利用这个刷新频率进行页面重绘。此外，使用这个API，一旦页面不处于浏览器的当前标签，就会自动停止刷新，这就节省了CPU、GPU和电力。注意 requestAnimationFrame 是在主线程上完成，这也意味着，如果主线程非常繁忙，requestAnimationFrame 的动画效果会大打折扣。

requestAnimationFrame 是限制函数执行次数的另一种方式，可以被认为是 `_.throttle(dosomething, 16)`，但是是高保真的，会针对不同设备本身的性能而更精确一些，浏览器内部决定渲染的最佳时机，它可以作为 throttle 的替换。

如果浏览器标签不是激活状态，就不会被执行，虽然对滚动、鼠标或键盘事件没有影响。还有需要考虑浏览器兼容性，node.js 中也没有提供该 API。

最佳实践：使用 requestAnimationFrame 进行重新绘制、计算元素位置或直接改变属性的操作，使用 `_.debounce` 或 `_.throttle` 进行 Ajax 请求或添加、移除 class（可以触发 CSS 动画），这时可以设置一个低一些的频率，如 200ms。

## lodash 之 debounce 源码

这里不再描述 throttle 了，其实 throttle 就是设置了 maxWait 的 debounce，lodash 源码中对 throttle 的实现就是调用了 wait 和 maxWait 相等的 debounce。

```js
/*
 * root 为全局变量，浏览器下为 window，node.js 下为 global
 * isObject 函数判断传入参数是否为一个对象
 * 创建一个 debounced 函数并返回，该函数延迟 func 在距离上一次调用达到 wait 时间之后再执行，如果在这期间内又调用了函数则将取消前一次并重新计* 算时间
 * options.leading 函数在每个等待延迟的开始被调用
 * options.trailing 函数在每个等待延迟的结束被调用
 * options.maxWait 函数被调用的最大等待时间，实现 throttle 效果，保证大于一定时间后一定能执行
 * 如果 leading 和 trailing 都设置为 true 了，只有函数在 wait 时间内被执行一次以上才会执行 trailing
 */
function debounce(func, wait, options) {
    // 变量初始化
    let lastArgs,
        lastThis,
        maxWait,
        result,
        timerId,
        lastCallTime;
    let lastInvokeTime = 0;
    let leading = false;
    let maxing = false;
    let trailing = true;

    // 如果 wait = NaN 并且当前是浏览器环境 requestAnimationFrame 存在时，返回 true
    const userRAF = (!wait && wait !== 0 && typeof root.requestAnimationFrame === 'function');

    // 传入参数的验证
    if (typeof func != 'function') {
        throw new TypeError('Expected a function');
    }
    wait = +wait || 0; // 将传入的 wait 转为数字，如果没有传入值默认赋值为 0
    if (isObject(options)) {
        leading = !!options.leading;
        maxing = 'maxWait' in options;
        // maxWait 为设置的 maxWait 值和 wait 值中最大的，因为如果 maxWait 小于 wait，debounce 就失效了，相当于只有 throttle 了
        maxWait = maxing ? Math.max(+options.maxWait || 0, wait) : maxWait;
        trailing = 'trailing' in options ? !!options.trailing : trailing;
    }

    function invokeFunc(time) {
        // 进入 debounced 函数时对 lastArgs、lastThis 进行的赋值，在这里执行完函数后，对 lastArgs、lastThis 进行了重置
        // 个人认为这样做的原因，是保证通过计时的方式执行函数最多只能执行一次
        const args = lastArgs;
        const thisArg = lastThis;
        lastArgs = lastThis = undefined;
        lastInvokeTime = time;
        result = func.apply(thisArg, args);
        return result;
    }

    function startTimer(pendingFunc, wait) {
        if (userRAF) {
            return root.requestAnimationFrame(pendingFunc);
        }
        return setTimeout(pendingFunc, wait);
    }

    function cancelTimer(id) {
        if (userRAF) {
            return root.cancelAnimationFrame(id);
        }
        clearTimeout(id);
    }

    function leadingEdge(time) {
        // TODO 不明白为什么这里需要更新 lastInvokeTime，进入 leadingEdge 函数不一定会真的触发函数的执行
        lastInvokeTime = time;
        // 为 trailingEdge 触发函数调用设置定时器
        timerId = startTimer(timerExpired, wait);
        // 如果 leading 为 true，会触发函数执行，否则返回上一次执行结果
        return leading ? invokeFunc(time) : result;
    }

    // 主要作用就是触发 trailingEdge
    function timerExpired() {
        const time = Date.now();
        // 在 trailingEdge 且时间符合条件时，调用 trailingEdge函数，否则重启定时器
        if (shouldInvoke(time)) {
            return trailingEdge(time);
        }
        // 重启定时器，保证下一次时延的末尾触发
        timerId = startTimer(timerExpired, remainingWait(time));
    }

    function remainingWait(time) {
        // 距离上次函数被调用的时间
        const timeSinceLastCall = time - lastCallTime;
        // 距离上次函数被执行的时间
        const timeSinceLastInvoke = time - lastInvokeTime;
        // wait - timeSinceLastCall 为距离下一次 trailing 的位置
        const timeWaiting = wait - timeSinceLastCall;

        // maxWait - timeSinceLastInvoke 为距离下一次 maxing 的位置
        // 有maxing：比较出下一次 maxing 和下一次 trailing 的最小值，作为下一次函数要执行的时间
        // 无maxing：在下一次 trailing 时执行 timerExpired
        return maxing ? Math.min(timeWaiting, maxWait - timeSinceLastInvoke) : timeWaiting;
    }

    function trailingEdge(time) {
        timerId = undefined;

        // 有 lastArgs 才执行，意味着只有 func 已经被 debounced 过一次，也就是被调用过一次，以后才会在 trailingEdge 执行
        if (trailing && lastArgs) {
            return invokeFunc(time);
        }
        // 每次 trailingEdge 都会清除 lastArgs 和 lastThis，目的是避免最后一次函数被执行了两次
        // 举个例子：最后一次函数执行的时候，可能恰巧是前一次的 trailing edge，函数被调用，而这个函数又需要在自己时延的 trailing edge 触发，导致触发多次
        lastArgs = lastThis = undefined;
        return result;
    }

    function shouldInvoke(time) {
        const timeSinceLastCall = time - lastCallTime;
        const timeSinceLastInvoke = time - lastInvokeTime;

        return (
            lastCallTime === undefined                    // 第一次调用
            || (timeSinceLastCall >= wait)                // 距离上次被调用已经超过 wait
            || (timeSinceLastCall < 0)                    //系统时间倒退
            || (maxing && timeSinceLastInvoke >= maxWait) //超过最大等待时间
        );
    }

    // 取消函数延迟执行
    function cancel() {
        if (timerId !== undefined) {
            cancelTimer(timerId);
        }
        lastInvokeTime = 0;
        lastArgs = lastCallTime = lastThis = timerId = undefined;
    }

    // 触发函数立即执行
    function flush() {
        // 如果前面没有定时任务在执行，也就是没有前面没有调用过函数，返回最后一次执行的结果，否则才会触发一次函数执行
        return timerId === undefined ? result : trailingEdge(Date.now());
    }

    // 检查当前是否在计时中
    function pending() {
        return timerId !== undefined;
    }

    // 返回的控制函数真正调用频率的函数
    function debounced(...args) {
        const time = Date.now();
        const isInvoking = shouldInvoke(time);

        lastArgs = args;
        lastThis = this;
        // 更新上次函数调用时间
        lastCallTime = time;
        // 无 timerId 的情况有两种：1.首次调用 2.trailingEdge执行过函数
        if (isInvoking) {
            if (timerId === undefined) {
                return leadingEdge(lastCallTime);
            }
            if (maxing) {
                // Handle invocations in a tight loop.
                timerId = startTimer(timerExpired, wait);
                return invokeFunc(lastCallTime);
            }
        }
        // 负责一种 case：trailing 为 true 的情况下，在前一个 wait 的 trailingEdge 已经执行了函数；
        // 而这次函数被调用时 shouldInvoke 不满足条件，因此要设置定时器，在本次的 trailingEdge 保证函数被执行
        if (timerId === undefined) {
            timerId = startTimer(timerExpired, wait);
        }
        return result;
    }

    debounced.cancel = cancel;
    debounced.flush = flush;
    debounced.pending = pending;
    return debounced;
}
```