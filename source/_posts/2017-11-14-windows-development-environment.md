---
title: Windows-开发环境配置
layout: post
date: 2017-11-14 09:42:39
categories: 开发环境
tags: 开发环境
---

## 安装 Python

[下载](https://www.python.org)

[安装教程](http://jingyan.baidu.com/article/7908e85c78c743af491ad261.html)

## 安装 Node

[下载](https://nodejs.org)

[安装教程](http://my.oschina.net/JeeChou/blog/219699?fromerr=RAIpMmVj)

**<font color="red" size = "4px">注意</font>：** 通篇看完一遍教程和下面注意事项后再进行安装。

> 安装路径：X:\Program Files\nodejs，X是你自己的盘符，其它路径名称不要改，可能出问题
> 执行完安装教程后，npm -v 查看版本号如果没有反映，请删除C:\Users\{账户}\下的.npmrc文件
> NODE_PATH 环境变量为：`X:\Program Files\nodejs\node_global`
> path 环境变量为： `X:\Program Files\nodejs\;F:\Program Files\nodejs\node_global;`
> X:\Program Files\nodejs\node_modules\npm 路径下，npmrc文件第二行添加 `registry = https://registry.npm.taobao.org` 配置淘宝镜像
> npm 升级，执行 npm install npm -g
> X:\Program Files\nodejs\node_global\node_modules\npm 路径下，npmrc文件第二行添加 `registry = https://registry.npm.taobao.org`

## 安装 Git

[下载](https://git-scm.com/download)
[安装教程](http://jingyan.baidu.com/article/90895e0fb3495f64ed6b0b50.html)

**注意** Adjusting your PATH environment 选择 Run Git from the Windows Command Prompt.

## 安装 TortuiseGit

[下载](https://download.tortoisegit.org)

## Sublime Text 3

[下载](https://www.sublimetext.com/)
[注册码](http://blog.sina.com.cn/s/blog_68e267e10102v76h.html) 
[安装Package Control](http://www.cnblogs.com/luoshupeng/archive/2013/09/09/3310777.html)

## 前端代码运行

`npm install babel-cli -g`

`git clone http://xxx.git`

`cd xxx`

`npm install`

`npm update`

`npm start`

## 后端代码运行

在 eclipse 工作空间执行：`git clone http://yyy.git`

解压 ide-setting.zip 到当前目录

将项目导入到 Eclipse 中

确定 Build Path 里没有问题，jdk 用1.7或1.8的

右键项目，Run As ——> Run on Server 进行项目启动，如果没起起来，看一下Server.xml中内容是否如下，最后将端口改为8088

{% img /2017/11/14/windows-development-environment/server.png Server.xml配置 %}

**注意：** 数据库配置在 /WebRoot/WEB-INF/db.properties 中
