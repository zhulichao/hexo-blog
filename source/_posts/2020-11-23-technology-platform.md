---
title: technology-platform
layout: post
date: 2020-11-23 09:37:58
categories:
tags:
---

## 结构简介

技术平台 epipe-visual-engine 项目，其实是三个项目，一个是 EVECesium 项目，一个是 EVEThree 项目，一个是网站项目。我们是通过一套代码，或者说是一个代码仓库，来维护的这三个项目，通过配置 webpack，打包后也是生成三个包。

{% img /2020/11/23/technology-platform/folder.jpg 400 目录结构 %}

- /app 下是网站代码
- /EVECesium 是 cesium API 代码
- /EVEThree 是 three.js API 代码
- /build/app 是打包网站的配置
- /build/EVECesium 是打包 cesium API 的配置
- /build/EVEThree 是打包 three.js API 的配置
- /dist_app 是网站打包后的文件
- /dist_EVECesium 是 cesium API 打包后的文件，可发布到 npm 安装使用
- /dist_EVEThree 是 three.js API 打包后的文件，可发布到 npm 安装使用
- /static/app 是网站中使用的静态资源
- /static/doc 是使用 jsdoc 生成的静态文件，里面分别有 EVECesium、EVEThree 目录
- /static/EVECesium 是 cesium API 使用的静态资源，如地图上的图片
- /static/EVEThree 是 three.js API 使用的静态资源，如模型上的图片
- /jsdoc 下是使用 jsdoc 根据注释生成的静态文件的自定义配置
- /build/generateLicense.js 文件是生成秘钥的脚本，被 `npm run generateLicense` 命令引用

## 授权简介

{% img /2020/11/23/technology-platform/authorization.jpg 授权逻辑 %}

### 生成秘钥

`npm run generateLicense` 将 /static/license 明文文件加密后生成 /license 文件，拷贝到需要的项目即可。

```json
{
  "modules": [
    "EVECesium",
    "EVEThree"
  ],
  "type": "permanent",
  "domains": [
    "localhost",
    "127.0.0.1",
    "192.168.70.119",
    "192.168.70.69"
  ],
  "created": "2020-08-11",
  "expired": "60"
}
```

- modules 表示授权的包，可为多个
- 本项目或业务平台引用指定 type 为 permanent，添加 domains 为本地域名
- 生产环境指定 type 为 production，添加 domains 为域名或IP加端口
- 开发环境指定 type 为 development，添加 created 创建时间、expired 过期天数

### 解密逻辑、输出版权信息

EVECesium 或 EVEThree 中读入 static/license 文件，校验逻辑放在 static/EVECesium/validate 中，输出版权信息放在 static/EVECesium/info 中。解密逻辑和输出版权信息，在 epipe-visual-engine 项目中看到的，是明文的文件，但是在打包后生成的是加密后的文件。上面三个文件读入后，都需要执行解密逻辑，然后通过 eval 执行 validate 校验和输入版权信息。

再说 static/license 正常应该是加密后的授权文件，在技术平台自身的项目 epipe-visual-engine 中，为了维护方便，static/license 是明文文件，就像 validate 和 info 文件一样，通过 webpack 插件 copy-webpack-plugin 打包后生成加密后的文件。
