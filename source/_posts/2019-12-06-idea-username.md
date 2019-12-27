---
title: 讨论用户名
layout: post
date: 2019-12-06 16:26:55
categories: Ideas
tags: Ideas
---

## [关于用户名的讨论](https://www.b-list.org/weblog/2018/feb/11/usernames/)

- 用户名用需要从三个方面正确的识别用户，每个标识应该是独立的
  - 系统级标识，适合作为数据库的外键
  - 登录标识，适合进行证书检查
  - 公众标识，适合展示给其它用户
- 如何保证唯一性
  - 不区分大小写，如 john_doe 和 JOHN_DOE
  - 选择一种形式进行标准化
  - 考虑非 ASCII，如 StraßburgJoe 和 StrassburgJoe
  - 使用 Unicode 库
  - 处理可能混淆的情况，如 jane_doe 和 jаne_doe
  - 如果是邮箱地址，忽略点或加号后面的字符
  - 保留一些名字，如 login、www、mail 等

## [用户账户、授权和密码管理的 12 个最佳实践](http://www.360doc.com/content/18/0310/10/31784658_735849146.shtml)

- Hash those passwords 对密码进行散列处理
- Allow for third-party identity providers if possible 如果可以的话，允许第三方提供身份验证
- Separate the concept of user identity and user account 区分用户身份和用户账户的概念
- Allow multiple identities to link to a single user account 允许单一用户账户关联多重身份
- Don't block long or complex passwords 不要限制较长或者复杂的密码
- Don't impose unreasonable rules for usernames 不要对用户名强加不合理的规则
- Allow users to change their username 允许用户修改用户名
- Let your users delete their accounts 让你的用户删掉他们的账户
- Make a conscious decision on session length 在对话长度上做出理智的选择
- Use 2-Step Verification 使用两步身份验证
- Make user IDs case insensitive 用户 ID 不区分大小写
- Build a secure auth system 建立一个安全认证系统
