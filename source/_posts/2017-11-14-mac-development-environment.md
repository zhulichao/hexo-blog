---
title: Mac-开发环境配置
layout: post
date: 2017-11-14 09:42:13
categories: 开发环境
tags: 开发环境
---

## Web端环境

- 安装 Homebrew

    `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”`

- 安装 Node

    `brew install node`

- 安装 Yarn

    `brew install yarn`

- 全局安装 babel-cli

    `yarn global add babel-cli`

- 安装 Mongo

    `brew install mongo`

- 安装 git

    `brew install git`

- 注册服务并启动

    `brew services start mongodb`

- 导入数据库文件 xx.ar

    `cat xx.ar| mongorestore -h localhost --port 27017 --drop --gzip --archive -vvvv --stopOnError`

- 安装 Robo 3T，创建连接

- 安装 Java

    ```
    brew cask search java
    brew cask info java
    brew cask install java
    ```

- 下载 [elasticsearch](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.3.zip)解压

    ```
    cd elasticsearch
    ./bin/elasticsearch (这个窗口不能关)
    ```

- 安装 VSCode，使用Setting Sync，安装插件

- 在 VSCode 中，alt + command + p 打开命令面板，输入 shell command 找到：Install‘code’ command in PAH，即可在终端中通过 code . 打开所在目录

## 移动端环境

- 安装工具

    ```
    npm install -g yarn react-native-cli
    brew install watchman
    brew install flow
    ```

- 安装 Xcode

    > 虽然一般来说命令行工具都是默认安装了，但你最好还是启动Xcode，并在Xcode -> Preferences -> Locations 菜单中检查一下是否装有选中的Command Line Tools。

- 安装 Android Studio

    [下载 SDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)，注意不要使用 JDK 9.0，启动项目时会报错，如果安装了多个 JDK，要用如下指令指定使用哪个版本。
    `export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home`

    Android Studio 中，File -> Project Structure 中， SDK Location 中，JDK location 取消勾选“Use embedded JDK”，输入框中写入上面导出对应的路径，为 `/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home`。

    [下载 Android Studio](https://developer.android.com/studio/index.html)，按步骤安装，注意需要翻墙安装 SDK。

    如果启动项目报如图所示错误，修改 android/build.gradle 文件如下：

    ```
    buildscript {
        repositories {
            /*
            解决图中所示错误
            */
            maven { url 'https://maven.google.com' }
            jcenter()
        }
        dependencies {
            classpath 'com.android.tools.build:gradle:3.0.0'
        }
    }

    allprojects {
        repositories {
            mavenLocal()
            jcenter()
            /*
            解决找不到
            import com.facebook.react.ReactApplication;
            import com.facebook.react.ReactNativeHost;
            */
            maven {
                url "$rootDir/../node_modules/react-native/android"
            }
        }
    }
    ```

    {% img https://zhulichao.github.io/2017/11/14/mac-development-environment/maven.png 错误信息 %}