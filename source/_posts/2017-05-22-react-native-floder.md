---
title: React-Native-目录结构
layout: post
date: 2017-05-22 09:15:02
categories: React Native
tags: React Native
---

## 项目目录

```
jxtrq_rn                                
  ├── /_test_                  # RN生成，测试目录
  ├── /android                 # RN生成，android代码目录，具体见下图
  ├── /ios                     # RN生成，代码目录，具体见下图
  ├── /node_modules            # 自动生成，安装依赖的目录，不会被提交
  ├── .babelrc                 # RN生成，Babel配置文件
  ├── .buckconfig              # RN生成，Buck是Mac OS X和Linux使用的构建工具
  ├── .flowconfig              # RN生成，Flow是一个静态的类型检查工具
  ├── .gitattributes           # RN生成，配置Git对一个特定的子目录或子文件集运用那些设置项
  ├── .gitignore               # RN生成，配置Git忽略提交的文件
  ├── .watchmanconfig          # RN生成，Watchman用于监控文件变化，辅助实现工程修改所见即所得
  ├── yarn.lock                # RN生成，Yarn是node包管理器，yarn.lock文件使程序在不同的机器上以同样的方式安装依赖
  ├── package.json             # RN生成，用于描述项目的基本信息以及需要的依赖信息
  ├── index.android.js         # RN生成，android入口文件
  ├── index.ios.js             # RN生成，ios入口文件
  |
  ├── index.web.js             # 自定义，web入口文件
  ├── CHANGELOG.md             # 自定义，版本更新日志
  ├── README.md                # 自定义，项目运行说明
  ├── /docs                    # 自定义，项目相关的说明目录
  |     ├── /dev                    # 开发相关目录
  |     |     ├── api                   # 接口相关目录
  |     ├── /work                   # 工作内容、计划目录
  |     └── /training               # 培训相关文档
  └── /app                     # 自定义，项目主体RN代码
        ├── config                  # 项目相关的配置信息，配置后台接口等
        ├── resources               # 项目资源目录，目前主要是图片资源
        ├── actions                 # redux的action的目录
        ├── reducers                # redux的reducer的目录，一般与actions对应
        ├── components              # 组件目录，这些组件在项目中属于展示组件，不直接关联redux
        ├── containers              # 组件目录，这些组件在项目中属于智能组件，直接关联redux，里面再返回展示组件
        ├── store                   # 初始化redux的目录
        ├── utils                   # 相当于工具类
        ├── styles                  # 项目公共样式、主题相关的目录
        └── App.js                  # 平台无关的项目入口文件，通常根据条件决定显示欢迎页、登录页或主页
```

{% img /2017/05/22/react-native-floder/android.png 300 android目录截图 %}

{% img /2017/05/22/react-native-floder/ios.png 300 ios目录截图 %}
