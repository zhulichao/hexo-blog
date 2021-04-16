---
title: business-platform
layout: post
date: 2020-11-23 13:41:21
categories:
tags:
---

## 简介

epipe-vp-web 用户端项目，epipe-vp-web-cms 后台项目。这两个项目独立开发，epipe-vp-web-cms 打包后，发布到 npm 上。epipe-vp-web 通过 npm install 安装后台项目，通过 iframe 引用后台项目，iframe 无法直接引用 node_modules 下的资源，可以通过 webpack 配置，将打包后的静态文件拷贝到当前项目中，iframe 就能引到了。

## Vuex 结构

```js
const store = new Vuex.Store({
  modules: {
    user, // 登录相关、用户信息
    permission, // 根据路由生成菜单信息
    userConfig, // 用户设置，主题、布局等
    checkedLayer, // 图层树中已勾选的图层
    checkedProject, // 项目过滤中已勾选的项目
    companyInfo, // 公司信息
    createdModal, // 已经初始化的 Modal 弹框，可全局控制关闭
    currentPage, // 当前页面
  },
  getters,
});
```

## 巧用 css

select 用图片回填，可以用 css 绝对定位将要显示的元素，也就是图片，放在 select 输入框元素的上面，设置 `pointer-event: none;` 将鼠标事件穿透，来正常触发 select 点击事件。

底图切换按钮，将 cesium 底图切换按钮用绝对定位放在自定义底图按钮下层，将图片透明度设置为 0，自定义的底图按钮设置 `pointer-event: none;` 将鼠标事件穿透，来触发 cesium 底图切换按钮。这时功能是没问题的，但是因为将自定义底图按钮的鼠标事件穿透了，也无法触发 hover 和 active 样式，效果不好。处理方式是将自定义底图按钮通过 `visibility: hidden;` 隐藏起来，cesium 底图按钮除了图片透明度为 0，还需要用 `:after` 设置按钮中的文字，背景色设置成按钮一样可切换主色，就实现了自定义底图按钮的效果。

## iView 按需引用

项目里，除了主要使用的组件库，如 element-ui，其它使用的组件库，尽量使用按需引用，减少打包后的体积。

## Modal 组件

基于 el-dialog 组件进行封装，在 mounted 中根据传入的 left、right 等值，设置 Modal 的位置，`this.$refs.mapModal.$refs.dialog.style.setProperty('top', this.top);` ，在 watch 中监听 left、right 等参数的变化修改位置。使用 setProperty 是因为这种方式可以设置样式的 `!important`。

在全局状态管理中管理 Modal，在 created 的时候将 Modal 的名字和关闭的回调函数添加到 vuex 中，代码如下：

```js
created() {
  if (this.addCloseToStore) {
    this.$store.dispatch('AddCreatedModal', {
      name: this.name,
      handleModalClose: this.handleModalClose,
    });
  }
},
```

在 vuex 中有关闭所有 Modal、关闭指定的多个 Modal、关闭除指定外的所有 Modal 的事件。

## Modal 避让

在要打开多个 Modal 的组件中，定义一个记录当前打开 Modal 的数组，每次打开一个 Modal 时调用 handleModalShow 方法将要打开的 Modal 的名字和宽度放入数组中，并调用 reCalculateLeft() 方法计算 left 值，该值时传入 Modal 组件的参数。每次关闭 Modal 时将数组中的对应元素去掉，并调用所有 Modal 对应的 reCalculateLeft() 方法重新计算位置，页面中添加动画。

```js
handleModalShow(refName) {
  let position = -1;
  this.openedModal.forEach((item, index) => {
    if (item.name === this.$refs[refName].name) {
      position = index;
      return;
    }
  });
  if (position < 0) {
    this.openedModal.push({
      name: this.$refs[refName].name,
      width: this.$refs[refName].width,
    });
    this.$refs[refName].handleShow();
  }
},
handleModalClose(name) {
  let position = -1;
  this.openedModal.forEach((item, index) => {
    if (item.name === name) {
      position = index;
      return;
    }
  });
  if (position > -1) {
    this.openedModal.splice(position, 1);
  }
  this.$refs.pbsTreeModal && this.$refs.pbsTreeModal.reCalculateLeft();
  this.$refs.pbsIntroductionModal && this.$refs.pbsIntroductionModal.reCalculateLeft();
},
```

## 添加新模块

- /src/views/map/components 中添加新模块，如文件名为 XXX，有 handleOpen 方法入口

- /src/views/map/header/Content/index.vue 中添加新组件 XXX 的引用

- 菜单管理中，需要有一个名为“用户端菜单”的菜单，它下面添加的菜单会显示在用户端Header中

- 菜单管理中，添加新菜单，路由地址中填入 XXX，与文件名或文件夹名保持一致
