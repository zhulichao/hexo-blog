---
title: 自文档化代码
layout: post
date: 2020-10-10 09:45:18
categories:
tags:
---

## 自文档化代码（Self Documenting Code）

- 不需要额外的编写、维护文档或注释的工作
- 文档或注释要随着代码更新，维护版本，多了不好管理
- 文档或注释会增加人们的阅读量
- 不要编写需要外部文档支持的代码
- 唯一能完整并正确地描述代码的文档就是代码本身

## 怎么做

- 变量、函数名语义化
- 避免过多地嵌套语句
- 要谨慎地优化代码，防止它不再清晰地表达基础的算法
- 结构化，分解为原子函数
- 把条件表达式换成函数或变量
- 选择有描述型的类型
- 命名常量
- 提供必要的、有意义的注释，如复杂逻辑
- 恰当的处理错误
