---
title: 使用 git 开发流程
layout: post
date: 2019-11-12 11:31:58
categories: Git
tags: Git
---

我们的项目中，master、develop 为受保护分支，master 对应生产环境，develop 对应测试环境，不能直接在该分支上提交代码。开发某个特性时，需要从 develop 分支拉出一条 feature 分支，例如 feature-1 与 feature-2，在这些分支上并行地开发具体特性。当特性开发完毕后，提交 pull request 到 develop 分支，所有前端进行 code review，如果有问题进行 Request changes，如果没问题点击 Approve，审核没问题后才合并到 develop 分支，并自动部署到测试环境。测试过程中如果发现 bug，从 develop 拉出新的分支修改发现的 bug。当测试没问题需要发布新版本时，需要从 develop 分支上拉出一条 release 分支，例如 release-1.0.0，更新 CHANGELOG.md 文件和 package.json、package-lock.json 的 version，提交 pull request 到 master 和 develop 分支，进行合并，并自动发布到生产环境和测试环境。release 的 pull request，到 develop 和 master 上都用 “Create a merge commit” ，其它提交到 develop 的 pull request，都用 “Squash and merge” 合并。**Squash and merge 方式可能会产生一些问题。**

当生产环境发现紧急 bug 时，直接从对应的 master 拉出一条 hotfix 分支（例如 hotfix-1.0.1），在该分支上做 bug 修复，并提交 pull request 到 develop 和 master 分支，进行合并。

如果 develop 分支发生变化时，有正在开发的 feature 分支，需要执行 rebase 操作以保证是基于最新的 develop 分支。

对于版本号我们也有要求，格式为：x.y.z，其中，x 用于有重大重构时才会升级，y 用于有新的特性发布时才会升级，z 用于修改了某个 bug 后才会升级。
