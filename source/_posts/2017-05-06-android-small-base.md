---
title: Android-Small框架-基础
layout: post
date: 2017-05-06 16:30:06
categories: Android
tags: Android
---

[Small github地址](https://github.com/wequick/Small)  
[Small官方教程](http://code.wequick.net/Small/cn/quickstart)  
[使用Small进行Android模块化开发](http://www.jianshu.com/p/cd152c75b0e0?nomobile=yes)  
[small的插件化的基本使用](http://www.jianshu.com/p/8eca24846445)

## 简介

插件模块是Small特有的插件化与IDE完美结合的产物，做到了“模块即组件，组件即插件”。 组件是工程的角度，插件是应用的角度。只有做到了清晰的组件解耦，才能更好的拆分插件模块。

出于业务需求考虑，Small定义了两类插件：公共库插件与应用插件。应用插件相对简单，就是用来把大应用拆分成一个个小的业务单元，公共库插件则是为这些业务单元提供公共的代码与资源。

通过设定 URI，宿主、本地化应用插件、本地化web插件、在线网页，以及任何自定义的插件之间能够相互调起与传递参数。

目前已支持 Android 、iOS 以及 HTML5 插件。并且三者之间可以通过同一套 JavaScript 接口进行通信。

## 开发基础

- 通过 build.gradle 集成 Small，项目的build.gradle文件中
```
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
        ...
        classpath 'net.wequick.tools.build:gradle-small:1.2.0-beta3'
    }
}
...
apply plugin: 'net.wequick.small'
small {
    aarVersion = '1.2.0-beta3'
}
```
- 通过 自定义Application 初始化 Small，app > java > com.example.mysmall > SmallApp中
```
public class SmallApp extends Application {
    public SmallApp() {
        // Small框架初始化
        Small.preSetUp(this);
    }
}
```
    AndroidManifest.xml中
```
<application
    android:name=".SmallApp"
    ...>
</application>
```
- 创建插件模块 App.main，注意包名为com.example.app.main
- 通过 buildLib，buildBundle 编译 Small 插件，命令后面可添加 -Dbundle.arch=x86
```
gradlew buildLib -q
gradlew buildBundle -q
```
- 通过 bundle.json 配置插件路由，右键 app 模块，New > Folder > Assets Folder 新建 assets 目录，在新建配置文件bundle.json内容如下
```
{
  "version": "1.0.0",
  "bundles": [
    {
      "uri": "main",
      "pkg": "com.example.appmain"
    }
  ]
}
```
- 通过 Small.openUri 启动插件，宿主的 app > java > com.example.mysmall > MainActivity中
```
@Override
protected void onStart() {
    super.onStart();
    // Small插件初始化
    Small.setUp(this, new Small.OnCompleteListener() {
        @Override
        public void onComplete() {
            // 通过uri启动插件
            Small.openUri("main", MainActivity.this);
        }
    });
}
```
- 创建公共库插件模块 Lib.style，注意包名为com.example.lib.style，将app.main/src/main/res/values 下除了strings.xml的文件移动到lib.style/src/main/res/values 目录下，修改 lib.style/src/main/res/colors.xml中colorPrimary值为#2FA739
- 添加公共库引用，修改 app.main/build.gradle，增加对 lib.style 的依赖
```
dependencies {
    ...
    compile project(':lib.style')
}
```
- 添加插件路由
```
"bundles": [
    ...
    {
        "pkg": "com.example.libstyle"
    }
]
```
- 重新运行
```
gradlew cleanLib -q
gradlew buildLib -q
gradlew buildBundle -q
```

## 工程结构图

{% img /2017/05/06/android-small-base/small.png 工程目录结构 %}

- 宿主：工程中的app模块，不能依赖lib.xxx
    - assets目录下的bundle.json声明宿主使用的插件，每个bundle可定义一些rule去启动特定的Activity
    - 可增加签名配置和共享的依赖库
```
signingConfigs {
    release {
        storeFile file('../sign/release.jks')
        storePassword "5mall@ndro!d"
        keyAlias "small"
        keyPassword "5mall@ndro!d"
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}

[...]

compile 'com.android.support:design:23.1.1'
```
- 公共库插件：工程中的lib.xxx模块，是标准的Android库工程
    - 第三方依赖合并到lib.vendor中管理
    - 样式相关的资源放在lib.style中管理
    - 其它工具类，以及网络、存储等跨业务模块的底层代码可以在lib.utils中管理
    - 可以通过compile project(':插件模块名')来被应用插件模块所引用
    - 编译时(buildLib)会被打包成为一个可独立更新的插件
- 业务插件：工程中的app.xxx模块，是标准的Android应用工程
    - app.main一般是程序的入口，并控制业务逻辑的主线
    - 其他app.xxx一般是业务逻辑的支线，插件内的业务逻辑之间关联性较强
    - app.xxx可以依赖多个lib.xxx
    - 可独立运行、独立更新
- 宿主分身模块：工程中的app+xxx模块，是标准的Android应用工程
    - 分身是宿主的一部分，最终编译到宿主中，不可被独立更新
    - 具备占坑(stub)的功能，即在宿主中预留特定的(无法插件化的)资源、代码或manifest项目，使系统可以正常识别，任何稳定的资源、代码、第三方库也可使用分身下沉到宿主中，以减少插件体积
    - 它提供了可以让插件模块自由访问其中的资源与代码的能力，并为所有插件模块添加该依赖
    - 需要占坑的项目为
        - 必须在宿主Manifest注册的项目，包括：所有权限，受限 Activity，任何 Provider、Service、BroadcastReceiver
        - 必须在宿主占坑的资源，包括：转场动画、通知栏图标、自定义视图、桌面快捷方式图标
- web插件工程：工程中的web.xxx模块，本地网页组件

## 常用命令

- gradlew samll          # 查看编译情况
- gradlew buildLib -q    # 编译公共库插件，不仅编译了lib.xxx，还编译了宿主模块
- gradlew buildBundle -q # 编译业务插件 
- gradlew -p app.main assembleRelease # 单独编译一个插件app.main
- gradlew cleanLib -q    # 清除公共库
- gradlew cleanBundle -q # 清除业务库

其中-q是安静模式，可以让输出更好看，也可以不加。对插件的编译，会在app/smallLibs/生成对应的so文件，这些so文件本质上就是独立的apk包。

## 常用API

// 框架初始化  
Small.preSetUp(this);

// 浏览器跳转url  
Small.setBaseUri("http://code.wequick.net/small-sample/");

// 在宿主的 Application 里指定是否从 assets 读取插件，有build.gradle 中 buildToAssets的值指定  
Small.setLoadFromAssets(BuildConfig.LOAD_FROM_ASSETS);

// 设定基本的跳转地址  
Small.openUri("https://github.com/wequick/Small/issues", MainActivity.this);

// 更新bundles.json和version信息  
Small.updateManifest(info.manifest, false)

// 获取补丁文件目录  
net.wequick.small.Bundle bundle = Small.getBundle(u.packageName);
File file = bundle.getPatchFile();

// 使更新后的插件生效  
bundle.upgrade();

// 暗度插件意图  
Small.wrapIntent(intent);

// 创建远程fragment  
Small.createObject("fragment-v4", sUris[position], MainActivity.this);

// 设置网页的基本回调
Small.setWebViewClient(new MyWebViewClient());

// TODO 
Small.getBundleVersions()

// TODO
Small.setWebActivityTheme(R.style.AppTheme);

// TODO
Small.getIsNewHostApp()

## 其它

- 对插件的编译，会在app/smallLibs/生成对应的so文件，这些so文件本质上就是独立的apk包，所以修改某个模块之后，要在运行时生效，必须先编译对应的插件，更新smallLibs下的.so文件
- 编译后的lib，如果删除资源再编译就会出现错误“No support deleting resources on lib.* now!”，所以在删除lib中的资源后，需要删除lib.xxx模块下的public.txt再通过cleanLib, buildLib, cleanBundle, buildBundle重新编译
- 从插件初始化，到初始化完成会耗费几百毫秒，甚至更多可以考虑将欢迎页放入宿主工程之中，如果欢迎页有比较复杂的广告逻辑或统计相关的逻辑，则可以考虑在主插件中做一个透明的Activity来处理
- 关于插件的Manifest，可以在插件的Manifest中指定application，每个插件的Application都会在Small.setup时被创建；对于需要处理android:configChanges的Activity需要在宿主中注册；如果要通过uri启动Activity，则对应Activity应该Manifest中进行注册，如果需app插件可以独立运行，但在Manifest中至少要注册一个主Activity

## 热更新？

打开项目的app工程也就是入口工程，文件夹里有一个smallLibs文件夹，里面有一个armeabi文件，里面是.so文件，这些文件就是通过buildLib和buildBundle来把非宿主的app中的文件打包成的.so文件。最终安装到手机上的apk其实就是只有宿主的apk和其内部的.so文件，通过加载.so文件来实现加载插件中的文件。热更新就是更新bundle.json文件和插件.so文件的过程。

## 增量更新？

增量更新的原理是：在服务器端先拿新版本安装包和旧版本安装包进行对比，在生成差异包之后下发，之后客户端根据对应的差异包和本地旧版本安装包合成，便生成了新版本安装包。

对于Small框架，它把每个插件都编译成.so文件，然后存放到app的native目录下，不过，如果它发现自己的download目录有新的插件，那么就会去加载download目录下的插件，并且这种加载优先权是最大的，也就是说它会优先加载download目录下的插件。所以，如果我们要做增量更新，旧文件就从app的native目录进行读取，然后从服务器端下载增量包，最后合成的文件存放到download目录下，这样每次插件启动都会到download目录下加载新的插件。