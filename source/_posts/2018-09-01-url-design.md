---
title: URL 设计规范
layout: post
date: 2018-09-01 13:12:13
categories: URL
tags: URL
---

- 使用kebab-case（短横线分割）的 URL
- 在查询字符串或资源字段中使用 camelCase 模式
- 在 URL 中使用多个kebab-case作为资源名称
- 总是使用复数名词来命名指向一个集合的 url：/users
- 在源代码中，将复数转换为具有列表后缀名描述的变量和属性
- 坚持这样一个概念：始终以集合名起始并以标识符结束，如 /students/123
- 避免这样的网址：GET /blogs/:blogId/posts/:postId/summary，完全可以将属性作为参数传递，以减少响应
- URLs 里面请尽量少用动词
- 为非资源型请求使用动词。在这种情况下，您的 API 并不需要返回任何资源。而是去执行一个操作并返回执行结果。这些不是 CRUD 操作
- 请求体或响应类型如果是 JSON，那么请遵循camelCase规范为JSON属性命名来保持一致性
- 即使资源类似于对象实例或数据库记录这样的单一概念，您也不应该将table_name用作资源名称或将column_name作为资源属性
- 只有在您的 URL 上面命名资源时才使用名词，不要尝试解释其功能
- 对于嵌套资源，请在 URL 中把他们的关系表现出来，如 /schools/2/students/31 , 应该得到学生 31 的详细信息，且此学生属于学校 2