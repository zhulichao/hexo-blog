---
title: git-fork-sync
layout: post
date: 2021-01-08 10:34:25
categories: Git
tags: Git
---

## fork 项目

- 打开 [epipe-vp-web](https://git.gitedit.com:8081/gis-platform/epipe-vp-web) ，点击 Fork
- 选择一个空间即可
- Settings -> General -> Advanced settings，修改项目名称和 Path

{% img /2021/01/08/git-fork-sync/fork.jpg Fork 项目 %}

## clone 项目

- git clone 新项目地址， 默认分支为 master
- cd epipe-vp-web-new
- git remote add upstream https://git.gitedit.com:8081/gis-platform/epipe-vp-web.git
- git checkout -b project-name 作为项目开发用

## 更新项目

{% img /2021/01/08/git-fork-sync/fork-old.jpg 分支关系 %}

### epipe-vp-web

- 在 business 分支开发
- git checkout develop
- git merge business
- git push
- git checkout master
- git merge develop
- git push

### 新项目

- git checkout master
- git fetch upstream
- git merge upstream/master
- git push
- git checkout project-name
- git merge master

{% img /2021/01/08/git-fork-sync/relation.jpg 分支关系 %}

- 有没有可能出现，同时开发 A、B 两个项目，同时需要业务平台修改，添加 featureA、featureB 功能？
- 其实新项目可以拉取原项目的任意分支

## 多次 fork

同一组下只能 fork 一次，若想达到 fork 多次的效果，可以通过如下两种方式：

### 删除与源项目的 fork 关系

- Settings -> General -> Advanced settings -> Remove fork relationship

### 通过 git 命令初始化

- git clone https://git.gitedit.com:8081/gis-platform/epipe-vp-web.git
- git remote rename origin upstream
- git remote add origin https://git.gitedit.com:8081/zhulichao/epipe-fork.git
- git push -u origin —all
