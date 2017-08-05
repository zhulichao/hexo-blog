---
title: React-Native-android-apk
layout: post
date: 2017-05-03 16:09:03
categories: React Native
tags: React Native
---

## RN项目打包

- cmd下执行 cd .android 进入系统android目录
- 执行 keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000 ，它会在android目录(C:/Users/Administrator/.android/)下生成一个叫做my-release-key.keystore的密钥库文件
- 把my-release-key.keystore文件放到工程中的android/app文件夹下
- 编辑~/.gradle/gradle.properties，~表示用户目录，比如windows上可能是C:\Users\用户名，而mac上可能是/Users/用户名，没有就创建一个，添加如下的代码，把其中的****替换为相应密码：
```
MYAPP_RELEASE_STORE_FILE=my-release-key.keystore
MYAPP_RELEASE_KEY_ALIAS=my-key-alias
MYAPP_RELEASE_STORE_PASSWORD=*****
MYAPP_RELEASE_KEY_PASSWORD=*****
```
- 编辑你项目目录下的android/app/build.gradle，添加如下的签名配置：
```
...
android {
    ...
    defaultConfig { ... }
    signingConfigs {
        release {
            storeFile file(MYAPP_RELEASE_STORE_FILE)
            storePassword MYAPP_RELEASE_STORE_PASSWORD
            keyAlias MYAPP_RELEASE_KEY_ALIAS
            keyPassword MYAPP_RELEASE_KEY_PASSWORD
        }
    }
    buildTypes {
        release {
            ...
            signingConfig signingConfigs.release
        }
    }
}
...
```
- cmd进入项目android目录，执行 gradlew installRelease，生成的APK文件位于项目的android/app/build/outputs/apk/app-release.apk

## 报错处理

执行`gradlew installRelease` 如果报错`Unable to process incoming event 'ProcessComplete' <ProgressCompleteEvent>`，这种错误
需要在在混淆文件/android/app/proguard-rules.pro末尾中加入
```
-keep class android.text {* ;}
-dontwarn android.text.*
```

## 修改安装文件图标及显示名称

将 /android/app/src/main/res/values/strings.xml 中 app_name 的值改成想要的app名称

将 /android/app/src/main/res/ 路径下，mipmap-开头的目录中的图片替换为同名的其它图片


