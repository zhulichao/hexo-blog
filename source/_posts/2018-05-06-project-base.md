---
title: 项目基础配置
layout: post
date: 2018-05-06 09:57:52
categories: Project Base
tags: Project Base
---

- 在 github 中配置
    - 默认分支
    - 保护分支，注意里面的配置项

- VSCode 中添加 Code Spell Checker 进行拼写检查

- VSCode 中添加 EditorConfig for VS Code 进行风格统一
    - 参考 [EditorConfig 官网](http://editorconfig.org)
    - 项目根目录添加 .editorconfig 文件
    - editorConfig 不是什么软件，而是一个名称为 .editorconfig 的自定义文件，该文件用来定义项目的编码规范，编辑器的行为会与.editorconfig 文件中定义的一致，并且其优先级比编辑器自身的设置要高

- 格式检查
    - 参考 [prettier 官网](https://prettier.io) 进行配置，它可以很好的集成的到项目中，利用 git 的 hooks 的机制，在提交 commit 时自动调用 prettier，使用 husky 和 lint-staged 配合使用
        - husky ：可以方便的通过 npm scripts 来调用各种 git hooks
        - lint-staged ：利用 git 的 staged 特性，可以提取出本次提交的变动文件，让 prettier 只处理这些文件
    - husky 配合 lint-stage 的过程可以通过 pretty-quick 来取代，但如果项目中也使用了其它工具，比如ESLint，请使用lint-stage
    - VSCode 中添加 Prettier - Code formatter 插件
    - 执行 `./node_modules/.bin/prettier --single-quote --write "src/**/*.{js,jsx,json,css}"` 来检查整个项目

- 样式检查
    - 参考 [stylelint](https://stylelint.io/) 进行配置
    - 安装 stylelint-config-standard、stylelint-order
    - VSCode 中添加 stylelint 插件

- 语法检查
    - 参考 [TSLint 官网](https://palantir.github.io/tslint/) [tslint-react](https://github.com/palantir/tslint-react) 进行配置
    - [tslint-config-prettier](https://github.com/alexjoverm/tslint-config-prettier) 防止 tslint 和 prettier 发生冲突，prettier 负责格式，tslint 负责其它
    - VSCode 中添加 TSLint 插件

- 自动化测试
    - 参考 [Jest](https://facebook.github.io/jest/)，需安装 @types/jest
    - 参考 [ts-jest](https://github.com/kulshekhar/ts-jest)，作用是将 ts 写的测试文件转为 js 的，再对这些文件执行 jest
    - VSCode 中添加 jest 插件

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
    - .editorconfig 文件
    ```
    root = true

    [*]
    indent_style = space
    indent_size = 2
    end_of_line = lf
    charset = utf-8
    trim_trailing_whitespace = true
    insert_final_newline = true

    # editorconfig-tools is unable to ignore long strings or urls
    max_line_length = null
    ```
    - .prettierrc 文件
    ```
    {
        "singleQuote": true,
        "trailingComma": "all"
    }
    ```
    - .stylelintrc 文件
    ```
    {
        extends: 'stylelint-config-standard',
        plugins: [
            'stylelint-order',
        ],
        rules: {
            'property-no-unknown': [
                true,
                {
                    ignoreProperties: [
                    'composes',
                ],
                },
            ],
            'selector-pseudo-class-no-unknown': [
                true,
                {
                    ignorePseudoClasses: [
                        'global',
                    ],
                },
            ],
            'string-quotes': 'single',
            'order/order': [
                'custom-properties',
                'dollar-variables',
                'declarations',
                'at-rules',
                'rules',
            ],
            'order/properties-order': [
                'composes',
                'position',
                'top',
                'right',
                'bottom',
                'left',
                'z-index',
                'display',
                'align-content',
                'align-items',
                'align-self',
                'flex',
                'flex-basis',
                'flex-direction',
                'flex-flow',
                'flex-grow',
                'flex-shrink',
                'flex-wrap',
                'justify-content',
                'order',
                'float',
                'width',
                'height',
                'max-width',
                'max-height',
                'min-width',
                'min-height',
                'padding',
                'padding-top',
                'padding-right',
                'padding-bottom',
                'padding-left',
                'margin',
                'margin-top',
                'margin-right',
                'margin-bottom',
                'margin-left',
                'margin-collapse',
                'margin-top-collapse',
                'margin-right-collapse',
                'margin-bottom-collapse',
                'margin-left-collapse',
                'overflow',
                'overflow-x',
                'overflow-y',
                'clip',
                'clear',
                'font',
                'font-family',
                'font-size',
                'font-smoothing',
                'osx-font-smoothing',
                'font-style',
                'font-weight',
                'hyphens',
                'src',
                'line-height',
                'letter-spacing',
                'word-spacing',
                'color',
                'text-align',
                'text-decoration',
                'text-indent',
                'text-overflow',
                'text-rendering',
                'text-size-adjust',
                'text-shadow',
                'text-transform',
                'word-break',
                'word-wrap',
                'white-space',
                'vertical-align',
                'list-style',
                'list-style-type',
                'list-style-position',
                'list-style-image',
                'pointer-events',
                'cursor',
                'background',
                'background-attachment',
                'background-color',
                'background-image',
                'background-position',
                'background-repeat',
                'background-size',
                'border',
                'border-collapse',
                'border-top',
                'border-right',
                'border-bottom',
                'border-left',
                'border-color',
                'border-image',
                'border-top-color',
                'border-right-color',
                'border-bottom-color',
                'border-left-color',
                'border-spacing',
                'border-style',
                'border-top-style',
                'border-right-style',
                'border-bottom-style',
                'border-left-style',
                'border-width',
                'border-top-width',
                'border-right-width',
                'border-bottom-width',
                'border-left-width',
                'border-radius',
                'border-top-right-radius',
                'border-bottom-right-radius',
                'border-bottom-left-radius',
                'border-top-left-radius',
                'border-radius-topright',
                'border-radius-bottomright',
                'border-radius-bottomleft',
                'border-radius-topleft',
                'content',
                'quotes',
                'outline',
                'outline-offset',
                'outline-width',
                'outline-style',
                'outline-color',
                'opacity',
                'filter',
                'visibility',
                'size',
                'zoom',
                'transform',
                'box-align',
                'box-flex',
                'box-orient',
                'box-pack',
                'box-shadow',
                'box-sizing',
                'table-layout',
                'animation',
                'animation-delay',
                'animation-duration',
                'animation-iteration-count',
                'animation-name',
                'animation-play-state',
                'animation-timing-function',
                'animation-fill-mode',
                'transition',
                'transition-delay',
                'transition-duration',
                'transition-property',
                'transition-timing-function',
                'background-clip',
                'backface-visibility',
                'resize',
                'appearance',
                'user-select',
                'interpolation-mode',
                'direction',
                'marks',
                'page',
                'set-link-source',
                'unicode-bidi',
                'speak',
            ],
        },
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
    - tsConfig.json 文件
    ```
    {
        "compilerOptions": {
            "outDir": "build/dist",
            "module": "esnext",
            "target": "es5",
            "lib": ["es7", "dom"],
            "sourceMap": true,
            "allowJs": true,
            "jsx": "react",
            "moduleResolution": "node",
            "rootDirs": ["src", "config"],
            "forceConsistentCasingInFileNames": true,
            "noImplicitReturns": true,
            "noImplicitThis": true,
            "noImplicitAny": true,
            "strictNullChecks": true,
            "suppressImplicitAnyIndexErrors": true,
            "noUnusedLocals": true
        },
        "exclude": [
            "node_modules",
            "build",
            "scripts",
            "acceptance-tests",
            "webpack",
            "jest",
            "src/setupTests.ts"
        ]
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
    - 参考 [CircleCi](https://circleci.com)
    - 登录 CircleCi，进入 Projects，Add Project，找到项目，Follow Project，Builds 中运行
    - 登录 GitHub，github setting branches，require status check，ci/circleci
    - 项目中配置 .circleci/config.yml 文件如下
    - CI 中需配置环境变量
    ```
    version: 2
    jobs:
    build:
        working_directory: ~/repo
        docker:
        - image: circleci/node:latest
        steps:
        - checkout
        - restore_cache:
            keys:
            - v1-dependencies-{{ checksum "package.json" }}
            - v1-dependencies-
        - run: yarn install
        - save_cache:
            paths:
                - node_modules
            key: v1-dependencies-{{ checksum "package.json" }}
        - run: yarn run lint
        - run: yarn run test
        - run:
            name: yarn build
            command: |
                if [ "$CIRCLE_BRANCH" != "develop" ] && [ "$CIRCLE_BRANCH" != "master" ]; then
                yarn build;
                fi
        - store_artifacts:
            path: build
            destination: build
        - store_test_results:
            path: coverage
    ```

    在运行测试时 `yarn test` 命令有时会带参数 `yarn test --maxWorkers 2`，[Jest 官方文档](https://facebook.github.io/jest/docs/zh-Hans/cli.html)描述如下：
    > 设定测试会使用的最大 worker 数目。 默认会使用你的计算机上可用的内核的数量。 在类似 CI 等有资源限制的环境下需要进行相关调整时很有用。但多数场景都应该使用默认值。

注意：[TypeScript 2.7](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-7.html) 支持 `import React from 'react'` 的方式，需要在 ts.config 中配置 `"module": "commonjs"` `"esModuleInterop": true`。

