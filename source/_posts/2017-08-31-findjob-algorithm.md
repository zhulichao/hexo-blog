---
title: 算法基础
layout: post
date: 2017-08-31 08:27:53
categories: Algorithm
tags: Algorithm
---

## 堆排序

首先要知道**完全二叉树**的概念：叶节点只能出现在最下层和次下层，并且最下面一层的结点都集中在该层最左边的若干位置的二叉树。

{% img https://zhulichao.github.io/2017/08/31/findjob-algorithm/CompleteBinaryTree.png 完全二叉树 %}

堆可以视为一棵完全的二叉树，大顶堆中每个父节点的元素值都大于等于其孩子结点的值，小顶堆中每个父节点的元素值都小于等于其孩子结点的值。

**堆排序不需要大量的递归或者多维的暂存数组，这对于数据量非常巨大的序列是合适的，比如超过数百万条记录。**因为快速排序，归并排序都使用递归来设计算法，在数据量非常大的时候，可能会发生堆栈溢出错误。堆排序会将所有的数据建成一个堆，最大的数据在堆顶，然后将堆顶数据和序列的最后一个数据交换。接下来再次重建堆，交换数据，依次下去，就可以排序所有的数据。如果要取大量数据中最大或最小的几个，这种时候用堆排比较好，取出要求的前几个最大元素即可停止了。

**建堆思路：**从最后一个非叶子节点开始，按照从下到上、从右到左的顺序进行迭代，让它（下标记为x）同其孩子节点（下标：2x、2x+1）比较，如果它小于任何一个孩子节点，则说明这个子树是符合堆规则的；否则把它同其较小的子节点交换。由于交换后，以这个节点（x）会破坏原来孩子的堆特性，因此这里有一个子迭代，让它继续上面的行为，直到找到一个合适的位置落脚。如此，直到根节点，就可以保证整颗完全树具备堆的性质。

**堆排序思路：**对于一个最小堆，去掉它的堆顶元素，然后以最末端元素移动到堆顶位置，然后进行调整，使之再次成为最小堆。如此迭代，直到没有剩余的元素，依次取出来的顺序就是实现排序的过程。

js实现代码如下：
```
function adjustHeap(arr, len, first) {
    var sortedFlag = true;
    var i = first ? Math.floor(len/2-1) : 0;
    while(i >= 0) {
        var j = i;
        i--;
        var flag = true;
        while(flag) {
            flag = false;
            var largePos;
            if (j*2+1 < len) {
                largePos = j*2+1;
            }
            if ( (j*2+2) < len && arr[j*2+2] > arr[largePos]) {
                largePos = j*2+2;
            }   
            if (largePos && arr[j] < arr[largePos] ) {
                flag = true;
                var temp = arr[j];
                arr[j] = arr[largePos];
                arr[largePos] = temp;
                j = largePos;
            }
        }
    }
}
function heapSort(arr) {
    var first = true;
    for(var i= arr.length; i > 0; i--) {
        adjustHeap(arr, i, first);
        first = false;
        var temp = arr[0];
        arr[0] = arr[i-1];
        arr[i-1] = temp;
    }
}
var arr = [16, 4, 10, 14, 7, 9, 3, 2, 8, 1];
heapSort(arr);
```

## 100万个数取最大的5个，要求尽量提升性能

思路一

用一个长度为5的数组存结果，对100万个数进行一遍扫描，先存入前5个元素从小到大插入结果数组，对于后面的每个元素，如果小于第一个元素则继续，如果大于第五个元素则删除第一个元素将当前元素插入，如果大于第一个元素小于第五个元素，找到元素所在位置插入并删除最小的元素，这样扫描一遍就可以找到最大的5个元素。

思路二

使用快速排序的思路，在递归时放弃处理值小的那部分，每次都是递归处理值大的部分，直到要处理的元素个数为5个停止。

思路三

查找1000个数中最大或最小的10个，这种时候用堆排比较好。

## 冒泡排序

```
function bubbleSort(arr) {
    for(var i = 0; i < arr.length; i++) {
        var pos = i;
        var min = arr[i];
        for( var j = i+1; j < arr.length; j++) {
            if (min > arr[j]) {
                min = arr[j];
                pos = j;
            }
        }
        var temp = arr[pos];
        arr[pos] = arr[i];
        arr[i] = temp;
    }
}
const arr = [19, 32, 35, 40, 69, 74, 84, 91, 96, 98];
bubbleSort(arr);
```
