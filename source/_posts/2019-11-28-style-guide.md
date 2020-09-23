---
title: 风格指南
layout: post
date: 2019-11-28 13:42:28
categories: Project Base
tags: Project Base
---

一定要语义化，所有命名使用有意义的英文单词，复数加 s，一定不要拼写错误，尽量不要缩写，可以借助 IDE 插件进行检查，如 Code Spell Checker，使用统一的风格，哪里用 camelCase，哪里用 kebab-case，保持一致，减少写注释。

[火星科技Web前端编码规范](http://marsgis.cn/w3cschool/codeguide/index.html)

## 环境变量

- 使用环境变量加载与部署相关的配置，永远也不要把它们作为常量写入代码，密钥和其它有价值的信息应该与代码库分离
- 使用 dotenv 配置环境变量

## 命名规则

- [Vue 风格指南](https://cn.vuejs.org/v2/style-guide/index.html)
- [Vue.js 组件编码规范](https://pablohpsilva.github.io/vuejs-component-style-guide/#/chinese)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- 公用组件使用 PascalCase
- 页面使用 kebab-case 或者 camelCase
- 方法名、变量使用 camelCase
- 数据相关的文件以 _data 结尾
- create 表示从无到有, 产生了新的东西
- add 通常是把一个东西添加到另一个东西，比如 add to cart, 通常产生的是一个关系，而不是一个具体的东西
- new 通常是 ui 用的
- update 是修改内容, 产生新的值
- change 是替换，一个换另一个
- edit 通常用于 ui
- remove 是移走, 消失的往往是关系
- delete 是删除，真的把东西给消失掉了
- 方法名称 handleXXX 形式，如 handleClick
- 如果是不使用的变量，如方法中的参数，可以命名为 _

## 目录结构

```text
- components
    - AdvSearch
        - index.js
        - AdvSearch.vue
        - AdvSearch.less
- views
    - home
        - home.less
        - home.vue
        - components
            - homeHeader.vue
            - homeHeader.less
```

## 代码

- 前端统一使用一个 IDE，尽量统一配置，文件要经常格式化
- 确定使用 yarn 还是 npm 装包后只用一个，不要混着用，可以借助代码审核机制 pull request
- 删除无用的文件、注释代码、未使用的引用
- 尽量不要自己拼接字符串和格式转换，使用 classsnames、query-string、numerical、lodash、date-fns、moment.js 等第三方工具
- 验证尽量使用 validator 等第三方工具
- 页面中使用封装好的组件进行布局，如 Layout、Row、Column、Container，当需要做页面适配的时候，只需修改这些公用组件，其它地方是不需要处理的
- 即使有默认值也最好写上，万一以后改了默认值就不用修改代码了
- 标签引用顺序保持一致，template、script、style
- 引用时绝对路径引用和相对路径引用分开，中间加空行；如果是引用到目录，以斜杠结尾 `import AdvSearch from 'components/AdvSearch/'`；引用文件和正式代码中间加空行
- 单引号、双引号使用场景
- 结尾都写分号，分行的对象属性结尾都写逗号
- 组件的文件夹下，用 index 文件进行默认导出
- 多个地方引用的常量，通过 config 文件进行配置，统一从 config 文件引用，常量用全大写
- 引用有使用 @ 的，还有写完整路径的，主要是 api 文件夹下
- style 写成内联还是用 class 引用
- 注释符号后有一个空格，英文单词和汉字中间有空格
- `+` 等符号前后都有空格
- 图片如果比较大使用 [img.top](https://img.top/) 压缩，也可以使用打包工具压缩
- public 中的文件，是不会经过编译的，打包后复制一遍，public 建议放一些外部第三方文件，src/assets 放自己的文件

## 配置

- eslint、tslint、stylelint 配合 prettier，配置 js、css 等代码检查工具
- husky、lint-staged 在提交 commit 前进行格式化

## commit

- 动宾短语，如 添加 xx，修正 xx，更新 xx，删除 xx
- 完成一个完整的功能时尽早提交，不要提这个功能无关的代码
- 装包或配置相关的代码单独提交，只提交一个功能相关的代码
- 除非已沟通过，否则不要提交别人的代码
- 可以使用 rebase 命令修正前面的 commit
- `git commit --fixup commitID`
- `git rebase -i --autosquash HEAD~3`

## changelog

- [Keep a Changelog](http://keepachangelog.com/)
- [Semantic Versioning](http://semver.org/)
- 简洁，主要描述功能的修改
- markdown 格式，最新发布的版本在上面
- 标明分类，新增、修改、删除等

```md
## 1.1.1 - 2018-11-21

### 新增

- 新增市场活动功能

### 修改

- 修改导航栏样式
```
