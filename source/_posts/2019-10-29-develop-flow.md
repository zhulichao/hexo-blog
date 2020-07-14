---
title: 项目开发流程
layout: post
date: 2019-10-29 10:03:13
categories: Project Management
tags: Project Management
---

## 工作流程

{% img /2019/10/29/develop-flow/work-flow.jpg 项目开发流程 %}

如图所示，项目的运行一共涉及6个环节。PM 在与业务方进行需求确认后产出文档，评审通过后通过 [Confluence](https://www.atlassian.com/software/confluence) 交付；UX 根据需求文档进行交互涉及，产出交互稿，评审通过后通过 [Abstract](https://www.abstract.com/) 交付，查看文件时使用 [Sketch](https://www.sketch.com/) 查看；后面 BE 和 UI 并行工作，BE 根据 UX 交互稿开发接口，没有评审，通过 Docker 镜像的形式交付，或者线上的开发环境，或者 FE 自己拉取项目启动，查看 graphql 文档；UI 根据交互稿设计页面，评审通过后通过[蓝湖](https://lanhuapp.com/web/#/item)交付，同时也会上传文件到 Abstract；BE 和 UI 都交付后，FE 进行开发，完成开发后部署到测试环境；最后由 QA 进行功能测试，使用 [fir.im](https://fir.im/) 发布移动端安装包，使用 [Jira](https://www.atlassian.com/software/jira) 进行 bug 管理 。

BE 和 FE 都使用 VSCode 进行开发，项目托管在 GitHub，使用 GitHub Desktop 维护代码，具体的开发流程参考[使用 git 开发流程](/2019/11/12/git-workflow/)。

tip：最好从 PM 环节开始，功能模块的名称及对应的英文就已确定，后面的环节都使用统一的名称。最好所有人都参与评审，在每个环节评审前都给参与评审的人留出一些时间，提前仔细看一遍评审的内容，尽量在评审时发现并提出问题。

## 评审注意点

### PM —> UX

- 成本：人力、时间、紧急程度
- 项目复杂度
- 能不能基于现有程序解决
- 可行的解决方案（从工程师角度出发）
- 和现有的业务是什么关系
- 对公司意味着什么

## UX —> UI、BE

- 功能和跳转逻辑
- 后端数据关联、数据结构、穷尽所有的状态和类型
- 状态的更新
- 各个环节提示、报错信息、placeholder
- 与以后的后台是否有冲突、更改、新增

## BE -> FE

- 接口齐全
- 参数、返回有清晰描述
- 接口可使用
- 有测试数据

## UI —> FE

- 文案 、素材、图片格式是否齐全
- 是否遵守规范
- 是否极端情况考虑（字最多/少）
- 适配
- 动画的开发成本
- 是否与 UX 保持一致

## 开发 —> QA

- 准备好基础数据，如果需要准备 mock 数据
- 完成冒烟测试
- 之前测试的bug和功能是否覆盖
