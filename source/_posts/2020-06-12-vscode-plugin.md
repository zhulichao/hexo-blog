---
title: VSCode 插件
layout: post
date: 2020-06-12 10:09:39
categories: VSCode
tags: VSCode
---

## 常用插件

[Auto Close Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag) 自动闭合 HTML 标签

[Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag) 自动修改匹配的标签

[AutoFileName](https://marketplace.visualstudio.com/items?itemName=JerryHong.autofilename) 输入的文件路径的智能补全

[Path Autocomplete](https://marketplace.visualstudio.com/items?itemName=ionutvmi.path-autocomplete) 文件路径补全，可设置别名

[Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense) 文件路径补全

[Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments) 美化注释

[Bracket Pair Colorizer](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer) 为括号提供颜色高亮

[Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) 拼写检查

[Color Highlight](https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight) 颜色值在代码中高亮显示

[Document This](https://marketplace.visualstudio.com/items?itemName=joelday.docthis) 注释文档生成

[DotENV](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv) DotENV 插件

[EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) EditorConfig 插件

[ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) ESLint 插件，高亮提示

[Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory) 查看 Git log

[gitignore](https://marketplace.visualstudio.com/items?itemName=codezombiech.gitignore) 更好的使用 gitignore

[GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) 显示当前行commit信息

[indent-rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow) 突出显示代码缩进

[markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) markdown 格式检查

[Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) 设置文件图标

[Polacode](https://marketplace.visualstudio.com/items?itemName=pnp.polacode) 代码截图工具

[Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) Prettier 插件

[stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint) stylelint 插件

[Sort lines](https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines) 排序选中行

[Vetur](https://marketplace.visualstudio.com/items?itemName=octref.vetur) Vue 语法高亮

[Visual Studio IntelliCode](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode) 代码智能提示

[vue-beautify](https://marketplace.visualstudio.com/items?itemName=peakchen90.vue-beautify) vue 格式化

[vue-helper](https://marketplace.visualstudio.com/items?itemName=shenjiaolong.vue-helper) Vue2 代码片段

[Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) 设置同步

## Settings Sync 使用

### 上传设置

- 需要 GitHub 账号
- 安装 Settings Sync 插件
- cmd + shift + p，输入 Sync:Advanced Options，LOGIN WITH GITHUB
- [生成 Github Token](https://github.com/settings/tokens)
- Gist ID，输入上步获取的 Token
- cmd + shift + p，输入 Sync:Upload/Update Settings 上传设置

### 下载设置

- cmd + shift + p，输入 Sync:Advanced Options，LOGIN WITH GITHUB
- 输入 Gist ID 和 获取令牌
- cmd + shift + p，输入 Sync:Download Settings 下载设置
- 若未下载成功，多尝试几次，注意确认 Gist ID 和 获取令牌是否正确