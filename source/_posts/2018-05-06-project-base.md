---
title: 项目基础配置
layout: post
date: 2018-05-06 09:57:52
categories: project-base
tags: project-base
---

- 在 github 中配置
    - 默认分支
    - 保护分支，注意里面的配置项

- 格式检查
    - 参考 [prettier 官网](https://prettier.io) 进行配置，它可以很好的集成的到项目中，利用 git 的 hooks 的机制，在提交 commit 时自动调用 prettier，使用 husky 和 lint-staged 配合使用
        - husky ：可以方便的通过 npm scripts 来调用各种 git hooks
        - lint-staged ：利用 git 的 staged 特性，可以提取出本次提交的变动文件，让 prettier 只处理这些文件
    - husky 配合 lint-stage 的过程可以通过 pretty-quick 来取代，但如果项目中也使用了其它工具，比如ESLint，请使用lint-stage
    - VSCode 中添加 Prettier - Code formatter 插件
    .prettierrc 文件
    ```
    {
        "singleQuote": true,
        "trailingComma": "all"
    }
    ```
    package.json 文件
    ```
    {
        ...
        "scripts": {
            "precommit": "lint-staged",
            ...
        }
    }
    ```

- stylelint

- 语法检查
    - 参考 [TSLint 官网](https://palantir.github.io/tslint/) [tslint-react](https://github.com/palantir/tslint-react) 进行配置
    - [tslint-config-prettier](https://github.com/alexjoverm/tslint-config-prettier) 防止 tslint 和 prettier 发生冲突，
    Do you want to use tslint and prettier without conflicts? tslint-config-prettier disables all conflicting rules that may cause such problems. Prettier takes care of the formatting whereas tslint takes care of all the other things.
    - VSCode 中添加 TSLint 插件
    
    tslint.json 文件
    ```
    {
        "defaultSeverity": "error",
        "extends": [
            "tslint:latest", "tslint-react"
        ],
        "jsRules": {},
        "rules": {},
        "rulesDirectory": []
    }
    ```
    package.json 文件
    ```
    {
        ...
        "scripts": {
            "lint-ts": "tslint -c tslint.json -p tsconfig.json 'src/**/*.tsx'",
            "fix-ts" "tslint -c tslint.json -p tsconfig.json --fix 'src/**/*.tsx'",
            "lint": "yarn run lint-ts && yarn run lint-css",
            ...
        }
    }
    ```

    查一下 tslint-config-prettier

    https://juejin.im/post/5a791d566fb9a0634853400e

- 持续集成 CI
https://circleci.com，setting ，project ，找到项目，Follow Project,Builds 中运行
项目中：
.circleci/config.yml

github setting branches 
    require status check
    ci/circleci


- 自动化测试 ts-jest