---
title: NPM-发布包
layout: post
date: 2019-10-16 15:55:35
categories: NPM
tags: NPM
---

## 准备

注册 [npm](https://www.npmjs.com/) 账号

## 发布

`npm adduser` 如果报了 401 Unauthorized 错误，查看是否设置过镜像，删除 .npmrc 中的 registry 行即可

`npm publish .`

## 更新

修改 package.json 中的 version

`npm publish .`

## 删除

`npm unpublish [name] --force` 只有发布72小时之内的包可以删除

## 使用命令

安装包后如果想要在终端中使用命令，package.json 中需要添加 bin 字段定义命令及对应的执行文件，且该文件的第一行添加 `#!/usr/bin/env node`。

`#!` 指明这个脚本文件的解释程序，`/usr/bin/env` 就是告诉系统可以在 PATH 目录中查找，`node` 指明用 node 执行脚本文件，所以配置 `#!/usr/bin/env node`，就是解决了不同的用户 node 路径不同的问题，可以让系统动态的去查找 node 来执行你的脚本文件。

## 搭建私有仓库

`npm install –global verdaccio` 全局安装 [verdaccio](https://github.com/verdaccio/verdaccio)
`verdaccio` 启动 verdaccio
`npm adduser --registry http://localhost:4873` 登录用户
`npm set ca null` 如果不使用 https，设置为 null 即可
`npm publish --registry http://localhost:4873` 发布包，不能与线上包同名
`npm unpublish --registry http://localhost:4873 --force` 删除包
