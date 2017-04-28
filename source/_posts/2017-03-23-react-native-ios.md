---
title: React-Native-IOS开发
layout: post
date: 2017-03-23 08:25:52
categories: React-Native
tags: React-Native
---

最近在入门用React Native进行IOS开发，由于开始的时候没有设备，是在Android上开发的，开发出一部分功能后又在IOS上调试的，其中遇到的问题整理如下。

## mac常用

### 快捷键

- Command+M             最小化当前窗口
- Command+Option+M      最小化当前应用程序所有窗口
- Command+H             隐藏除当前应用程序之外所有程序
- Command+Option+M+H    隐藏所有应用程序窗口
- Command+Q             关闭当前应用程序
- Command+Tab 选中程序，松开Tab，按住Command不放的同时按住Opt，松开Command 将最小化的窗口恢复回来
- Command+Shift+K       Xcode中clean项目

### 命令

- xcodebuild -version   查看Xcode版本号

### 真机运行报错

#### 错误1
{% img https://zhulichao.github.io/2017/03/23/react-native-ios/ios-start-err.jpg 真机运行报错1 %}
需修改一下Bundle Identifier的值。

#### 错误2
{% img https://zhulichao.github.io/2017/03/23/react-native-ios/Team.jpg 真机运行报错2 %}
需在Xcode的`Select a project or target`中选择以Tests结尾的项目，然后选择Team。

#### 错误3
```
1.BDVRClientSample requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor.
2.Code signing is required for product type ‘Application‘ in SDK ‘iOS 10.0‘
```
需先取消Generate中Automatically manage signing的勾选，然后将Build Settings中Code Signing Identity下的4个值都改为iOS Developer（这之后可能需要关闭Xcode重新打开），在恢复Generate中Automatically manage signing的勾选。

## React Native IOS模拟器调试

- Command+R 刷新
- Command+D 菜单
- Shift+Command+H 返回主界面

## React Native 兼容问题

- Text组件，要有backgroundColor，如果只设置color，会连背景都为color的颜色，就看不到字了
- WingBlank、WhiteSpace组件，背景色为透明色，需要显示设置为白色，否则可能有穿透效果
- Tabs在IOS需要paddingTop样式，原因如图

{% img https://zhulichao.github.io/2017/03/23/react-native-ios/tabs.png Tabs在Android和IOS的不同 %}

- TabBar的图标非常大，需要添加scale属性，表示图标缩小的比例，如`128*128`的图标，sacle为4，则显示效果为`32*32`
   
```
    <TabBar
        unselectedTintColor="#8a8a8a"
        tintColor="#108ee9"
        barTintColor="white"
    >
        <TabBar.Item
            icon={{ uri: Icons.task, scale: 4 }}
            selectedIcon={{ uri: Icons.taskActive, scale: 4 }}
            title="任务"
            key="task"
            selected={this.state.selectedTab === 'task'}
            onPress={this.onPress.bind(this, 'task')}
        >
            <Tasks navigator={this.props.navigator} />
        </TabBar.Item>
    </TabBar>
```

- 根据平台使用不同样式

```
const Global = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    ...Platform.select({
      ios: {
        height: WINDOW_HEIGHT-TABBAR_HEIGHT-TABS_HEIGHT-20,
      },
      android: {
        height: WINDOW_HEIGHT-TABBAR_HEIGHT-TABS_HEIGHT-StatusBar_HEIGHT,
      },
    }),
  },
});
```

## React Native 连接原生

由于之前是使用Windows在Android上开发的，使用到的依赖
react-native-vector-icons、react-native-image-picker需要与IOS原生连接，此时如果执行`react-native link`自动连接，担心会影响到已有的Android端的配置，因为Android是进行手动连接的，执行自动连接没有生效，而且也会将不需要连接的依赖一起连接了。所以想按照说明文档进行手动连接，但试过后并没有好使，即使是新初始化的项目，react-native-vector-icons在IOS上进行手动连接也是不好使的。后来我是新初始化了一个同名项目，安装完react-native-vector-icons、react-native-image-picker依赖后进行自动连接，运行好使了，我就把新项目与原项目ios目录中的文件进行了对比，将配置移到原项目中，运行后好使了。

过了两天发现这种方式有点傻，因为那时不知道`react-native link`可以指定手动连接的依赖。虽然没有试验，但是感觉只需要单独执行`react-native link react-native-vector-icons`和`react-native link react-native-image-picker`，再将android目录下变化的文件恢复，应该就可以了。
