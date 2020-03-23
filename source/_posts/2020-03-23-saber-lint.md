---
title: Saber 项目集成代码检查
layout: post
date: 2020-03-23 11:46:35
categories: Saber
tags: Saber
---

开发 Saber 项目使用 VSCode 作为编辑器。Saber 项目使用 @vue/cli 创建的，在此基础上再进行代码检查相关配置，包括拼写检查、JavaScript 代码检查、CSS 代码检查、代码风格检查、使用 Git Hook 工具进行提交前代码规范校验。

## 拼写检查

- VSCode 中添加 **Code Spell Checker** 插件，进行单词的拼写检查，如果代码中出现了拼写错误编辑器会有提示

{% img /2020/03/23/saber-lint/spell.png 400 错误提示 %}

## JS 检查

- VSCode 中添加 **ESLint** 插件，参考 [ESLint 官网](https://eslint.org/) 进行配置，进行 JavaScript 语法和格式检查
- 项目安装 eslint-plugin-import、eslint-plugin-node、eslint-plugin-promise、eslint-plugin-vue 包
- 项目根目录添加 .eslintrc.js 文件，内容如下

```
// .eslintrc.js 文件
module.exports = {
  root: true,
  env: {
    node: true
  },
  extends: [
    'plugin:vue/essential',
    'eslint:recommended',
    'prettier'
  ],
  plugins: ["import", "prettier"],
  rules: {
    "prettier/prettier": "error",
    'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
    "no-var": "error",
    "indent": ["error", 2, { "SwitchCase": 1 }],
    "quotes": [ "error", "single"],
    "semi": ["error", "always"],
    "comma-dangle": [
      "error",
      {
        "arrays": "ignore",
        "objects": "always-multiline",
        "imports": "always-multiline",
        "exports": "ignore",
        "functions": "ignore"
      }
    ],
    "no-empty": 2,
    "no-eq-null": 2,
    "no-new": 0,
    "no-fallthrough": 0,
    "no-unreachable": 0,
    "space-before-function-paren": [2, "never"],
    "import/newline-after-import": 2
  },
  parserOptions: {
    parser: 'babel-eslint',
  }
}
```

{% img /2020/03/23/saber-lint/eslint.png 500 错误提示 %}

## CSS 检查

- VSCode 中添加 **stylelint** 插件，参考 [stylelint](https://stylelint.io/) 进行配置，进行 CSS 语法和格式检查
- 项目添加 stylelint、stylelint-config-standard、stylelint-config-prettier、stylelint-order 包
- 项目根目录添加 .stylelintrc.js 文件，内容如下

```
// z.stylelintrc.js 文件
module.exports = {
  extends: ['stylelint-config-standard', 'stylelint-config-prettier'],
  plugins: ['stylelint-order'],
  rules: {
    'property-no-unknown': [
      true,
      {
        ignoreProperties: ['composes'],
      },
    ],
    'selector-pseudo-class-no-unknown': [
      true,
      {
        ignorePseudoClasses: ['global'],
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
};
```

{% img /2020/03/23/saber-lint/stylelint.png 500 错误提示 %}

## 格式检查

- VSCode 中添加 **Prettier - Code formatter** 插件，参考 [prettier 官网](https://prettier.io) 进行配置，配置完成可用 Alt + Option + F 进行代码格式化
- 项目添加 eslint-config-prettier、eslint-plugin-prettier 包
- 项目根目录添加 .prettierrc.js 文件，内容如下

```
// .prettierrc.js 文件
module.exports = {
  "singleQuote": false, // 字符串是否使用单引号，默认为false，使用双引号
  "trailingComma": "none", // 是否使用尾逗号，有三个可选值"<none|es5|all>"
}
```

{% img /2020/03/23/saber-lint/prettier.png 格式化 %}

## Git Hook

- 利用 git 的 hooks 机制，在提交 commit 时自动调用格式校验
- 项目安装 husky、lint-staged 包
- package.json 中添加如下内容

```
// package.json 文件
{
	...
  "lint-staged": {
    "*.js": [
      "vue-cli-service lint",
      "git add"
    ],
    "*.{css,less,scss,sss}": [
      "stylelint --fix",
      "git add"
    ],
    "*.vue": [
      "vue-cli-service lint",
      "git add"
    ]
  },
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  }
}
```

{% img /2020/03/23/saber-lint/githook.png Git Hook 执行 %}
