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

- stylelint

- 语法检查
    - 参考 [TSLint 官网](https://palantir.github.io/tslint/) [tslint-react](https://github.com/palantir/tslint-react) 进行配置
    - [tslint-config-prettier](https://github.com/alexjoverm/tslint-config-prettier) 防止 tslint 和 prettier 发生冲突，prettier 负责格式，tslint 负责其它
    - VSCode 中添加 TSLint 插件

- 自动化测试
    - [Jest](https://facebook.github.io/jest/)，需安装 @types/jest
    - 参考[ts-jest](https://github.com/kulshekhar/ts-jest)，作用是将 ts 写的测试文件转为 js 的，再对这些文件执行 jest

    ```
    import * as React from 'react';
    import * as renderer from 'react-test-renderer';
    import configureStore from 'redux-mock-store';
    import thunk from 'redux-thunk';

    import App from '../App';
    import Badge, { BadgeVariant } from './Badge';

    const middlewares = [thunk];
    const mockStore = configureStore(middlewares);
    const initialState = {};

    test('正确渲染', () => {
    const store = mockStore(initialState);

    let tree = renderer
        .create(
        <App
            context={{
            fetch: () => {
                return;
            },
            store,
            client: {},
            }}
        >
            <Badge className="badge">{10}</Badge>
        </App>,
        )
        .toJSON();
    expect(tree).toMatchSnapshot();

    tree = renderer
        .create(
        <App
            context={{
            fetch: () => {
                return;
            },
            store,
            client: {},
            }}
        >
            <Badge>New</Badge>
        </App>,
        )
        .toJSON();
    expect(tree).toMatchSnapshot();
    });

    test('variant属性值应为 primary, info, success, warning, error 中的一个', () => {
    const store = mockStore(initialState);
    for (const variant in BadgeVariant) {
        if (BadgeVariant[variant]) {
        const tree = renderer
        .create(
            <App
            context={{
                fetch: () => {
                return;
                },
                store,
                client: {},
            }}
            >
            <Badge variant={BadgeVariant[variant]}>职问</Badge>
            </App>,
        )
        .toJSON();

        expect(tree).toMatchSnapshot();
        }
    }
    });
    ```

- 配置文件
    - .prettierrc 文件
    ```
    {
        "singleQuote": true,
        "trailingComma": "all"
    }
    ```
    - tslint.json 文件
    ```
    {
       {
            "extends": ["tslint:latest", "tslint-config-prettier", "tslint-react"],
            "rules": {
                "interface-name": [true, "never-prefix"],
                "no-submodule-imports": false,
                "jsx-boolean-value": false,
                "jsx-no-multiline-js": false,
                "jsx-wrap-multiline": false,
                "class-name": true,
                "comment-format": [true, "check-space"],
                "curly": true,
                "indent": [true, "spaces"],
                "one-line": [true, "check-open-brace", "check-whitespace"],
                "no-var-keyword": true,
                "quotemark": [true, "single", "avoid-escape", "jsx-double"],
                "semicolon": [true, "always", "ignore-bound-class-methods"],
                "whitespace": [
                    true,
                    "check-branch",
                    "check-decl",
                    "check-operator",
                    "check-module",
                    "check-separator",
                    "check-type"
                ],
                "typedef-whitespace": [
                true,
                {
                    "call-signature": "nospace",
                    "index-signature": "nospace",
                    "parameter": "nospace",
                    "property-declaration": "nospace",
                    "variable-declaration": "nospace"
                },
                {
                    "call-signature": "onespace",
                    "index-signature": "onespace",
                    "parameter": "onespace",
                    "property-declaration": "onespace",
                    "variable-declaration": "onespace"
                }
                ],
                "no-internal-module": true,
                "no-trailing-whitespace": true,
                "no-null-keyword": true,
                "prefer-const": true,
                "jsdoc-format": true,
                "object-literal-sort-keys": false
            }
        }
    }
    ```
    - package.json 文件
    ```
    {
        ...
        "lint-staged": {
            "*.{json,md,graphql}": [
                "prettier --write",
                "git add"
            ],
            "*.{ts,tsx}": [
                "prettier --write",
                "tslint --fix",
                "git add"
            ],
            "*.{css,less,scss,sass,sss}": [
                "prettier --write",
                "stylelint --fix",
                "git add"
            ]
        },
        "scripts": {
            "precommit": "lint-staged",
            "lint": "yarn run lint-ts && yarn run lint-css",
            "fix": "yarn run fix-ts && yarn run fix-css",
            "lint-ts": "tslint 'src/**/*.{ts,tsx}'",
            "fix-ts": "tslint --fix 'src/**/*.{ts,tsx}'",
            "lint-css": "stylelint 'src/**/*.{css,less,scss,sass,sss}'",
            "fix-css": "stylelint --fix 'src/**/*.{css,less,scss,sass,sss}'",
            ...
        }
    }
    ```
    jest.config.js 文件
    ```
    module.exports = {
        automock: false,
        browser: false,
        bail: false,
        collectCoverageFrom: [
            'src/**/*.{ts,tsx}',
            '!**/node_modules/**',
            '!**/vendor/**',
        ],
        coverageDirectory: '<rootDir>/coverage',
        globals: {
            __DEV__: true,
        },
        moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
        moduleNameMapper: {
            '\\.(css|less|scss|sss)$': 'identity-obj-proxy',
            '\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$':
            'GlobalImageStub',
        },
        transform: {
            '^.+\\.tsx?$': 'ts-jest',
        },
        testRegex: '(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$',
        verbose: true,
    };
    ```

- 持续集成 CI
https://circleci.com，setting ，project ，找到项目，Follow Project,Builds 中运行
项目中：
.circleci/config.yml

github setting branches 
    require status check
    ci/circleci


https://www.jianshu.com/p/71bbcdc8c1fc
https://www.cnblogs.com/baqiphp/p/7647912.html