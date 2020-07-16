---
title: GitLab 代码审核
layout: post
date: 2020-06-12 10:10:05
categories: Git
tags: Git
---

## 设置钉钉 GitLab 机器人

打开钉钉，在需要配置 GitLab 机器人的群中，点击【群设置】→【智能群助手】→【添加机器人】→【GitLab】→【添加】，复制生成的 Webhook 地址备用。

进行如下 GitLab 配置。

{% img /2020/06/12/gitlab-pull-request/integration.png 设置钉钉 webhook %}

## GitLab 代码审核配置

{% img /2020/06/12/gitlab-pull-request/branch.png 分支设置 %}

{% img /2020/06/12/gitlab-pull-request/merge-request.png 设置 merge request %}

开发人员创建一个 merge request，然后线下 @审核人 进行代码审核，添加评论，开发人员解决评论中的问题，重复这个步骤直至所有评论解决后，线下 @Maintainer 进行合并。

代码审核要求：

- 格式规范
- 变量名称要是单词，符合语义
- 局部逻辑，尽量简化
- 复杂逻辑要补充注释
- 一个组件不要写的太复杂，适当拆分
- 公共模块需要提取
