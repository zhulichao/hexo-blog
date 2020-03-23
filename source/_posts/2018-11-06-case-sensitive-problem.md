---
title: 大小写敏感问题
layout: post
date: 2018-11-06 09:42:53
categories: Git
tags: Git
---

在项目开发中，如果改变了文件或文件夹名称的大小写，默认情况下 git 是无法检测到的，因为 git 是不区分大小写的，windows 和 mac 系统默认也是不区分大小写的，可通过以下两种方式进行处理。

## 方式一

- `git config core.ignorecase false` 关闭 git 忽略大小写
- 修改文件名称 README.md 为 readme.md
- `git mv README.md readme.md` 在 git 中对文件重命名，如图1
- 修改文件夹名称 Folder 为 folder
- `git mv Folder temp && git mv temp folder` 在 git 中对文件夹重命名，注意需使用临时名称，否则无法重命名，如图2、3
- 后面正常提交就可以了

{% img /2018/11/06/case-sensitive-problem/mv_file.png 400 图1 %}

{% img /2018/11/06/case-sensitive-problem/err.png 400 图2 %}

{% img /2018/11/06/case-sensitive-problem/mv_folder.png 400 图3 %}

## 方式二

可以将电脑磁盘单独分出一个大小写敏感的分区作为开发空间，再关闭 git 忽略大小写即可。注意在大小写敏感的分区开发时，如果存在同名大小写不同的文件，有些编辑器如 vscode 可能只会加载一个文件。
