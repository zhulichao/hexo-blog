---
title: project-base
layout: post
date: 2018-05-06 09:57:52
categories:
tags:
---

- 在 github 中配置
    - 默认分支
    - 保护分支，注意里面的配置项

- 格式检查
    - 参考 [prettier 官网](https://prettier.io) 进行配置，它可以很好的集成的到项目中，利用 git 的 hooks 的机制，在提交 commit 时自动调用 prettier
        - husky ：可以方便的通过 npm scripts 来调用各种 git hooks
        - lint-staged ：利用 git 的 staged 特性，可以提取出本次提交的变动文件，让 prettier 只处理这些文件
    - VSCode 中添加 Prettier - Code formatter 插件

- 语法检查
    TSLint https://palantir.github.io/tslint/
    tslint.json 是配置文件，./node_modules/tslint/bin/tsline --init 生成 tslint.json 文件
    文档 configuration