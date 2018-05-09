---
title: project-base
layout: post
date: 2018-05-06 09:57:52
categories:
tags:
---

- 在 github 中配置
    - 默认分支
    - 保护分支，注意里面的配置项

- 格式检查
    - 参考 [prettier 官网](https://prettier.io) 进行配置，它可以很好的集成的到项目中，利用 git 的 hooks 的机制，在提交 commit 时自动调用 prettier
        - husky ：可以方便的通过 npm scripts 来调用各种 git hooks
        - lint-staged ：利用 git 的 staged 特性，可以提取出本次提交的变动文件，让 prettier 只处理这些文件
    - VSCode 中添加 Prettier - Code formatter 插件
    .prettierrc
    ```
    {
        "singleQuote": true,
        "trailingComma": "all"
    }
    ```
    package.json
    ```
    {
        ...
        "scripts": {
            "precommit": "lint-staged",
            ...
        }
    }
    ```
    stylelint
    tslint
    lint-staged 还用写吗

- 语法检查
    - 参考 [TSLint 官网](https://palantir.github.io/tslint/) [tslint-react](https://github.com/palantir/tslint-react) 进行配置
    - VSCode 中添加 TSLint 插件
    
    tslint.json
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
    package.json
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

    查一下 tslint-config-prettier、pretty-quick
    lint-staged 怎么用

- 持续集成 CI
https://circleci.com，setting ，project ，找到项目，Follow Project,Builds 中运行
项目中：
.circleci/config.yml

github setting branches 
    require status check
    ci/circleci


- 自动化测试 ts-jest