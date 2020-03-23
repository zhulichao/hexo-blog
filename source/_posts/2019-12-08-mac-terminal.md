---
title: Mac-终端配置
layout: post
date: 2019-12-08 14:45:55
categories: Mac
tags: Mac
---

- 安装 [Homebrew](https://brew.sh/)
- 安装 [ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)，安装成功可查看版本 `zsh —version`
- 配置终端默认使用 ZSH `chsh -s $(which zsh)`
- 安装 [iTerm2](https://www.iterm2.com/) `brew cask install iterm2`
- 配置 iTerm2 主题
  - 下载 [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)，
  - `iTerm → Preferences → Profiles → Colors → Color Presets... → Import → OceanicMaterial`
  - `iTerm → Preferences → Profiles → Keys → Load Preset... → Natural Text Editing`
- 使用 Antigen 管理 ZSH 插件，`brew install antigen`
- 编辑 `~/.zshrc`，添加如下内容，执行 `source ~/.zshrc`
```
# Antigen https://github.com/zsh-users/antigen
source /usr/local/share/antigen/antigen.zsh
DEFAULT_USER=`id -un`

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle autojump
antigen bundle aws
antigen bundle docker
antigen bundle git
antigen bundle npm
antigen bundle nvm
antigen bundle osx
antigen bundle react-native

# zsh-nvm https://github.com/lukechilds/zsh-nvm
NVM_LAZY_LOAD=true
NVM_AUTO_USE=true
antigen bundle lukechilds/zsh-nvm

# Npm completion
antigen bundle lukechilds/zsh-better-npm-completion
antigen bundle akoenig/npm-run.plugin.zsh

# Zsh completion
antigen bundle zsh-users/zsh-completions

# Auto suggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true
antigen bundle zsh-users/zsh-autosuggestions

# Syntax highlighting bundle.
antigen bundle zdharma/fast-syntax-highlighting

# Automatic update antigen bundles
antigen bundle unixorn/autoupdate-antigen.zshplugin

# Load the theme.
# Powerlevel9k
# https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions
POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status nvm node_version)

antigen theme bhilburn/powerlevel9k powerlevel9k

# Tell Antigen that you're done.
antigen apply
```
- 配置 Powerlevel9k 主题
  - `brew tap caskroom/fonts`
  - `brew cask install font-firacode-nerd-font`
  - `iTerm → Preferences → Profiles → Text → Change Font → Fura Code Nerd Font`，勾选 `Use ligatures`
- 配置 VS Code 配置终端，首选项 → 设置 → 用户，在 setting.json 中添加
```
"terminal.integrated.shell.osx": "/bin/zsh",
"terminal.integrated.fontFamily": "'FuraCode Nerd Font'",
```

{% img /2019/12/08/mac-terminal/terminal.jpg 效果图 %}
