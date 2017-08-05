---
title: React-Native-IOS使用高德地图
layout: post
date: 2017-03-24 23:11:04
categories: React Native
tags: React Native
---

## 高德地图key值

- http://lbs.amap.com/，注册帐号
- 登录后，进入控制台，应用管理->我的应用，添加新key
    - Bundle ID值为 Xcode 切换到 General 标签，查看 Bundle Identifier的值

{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/ios-key.png 申请高德地图key %}

## 地图及定位

在github上找了好几个使用React Native封装基于ios的高德地图的依赖，但是大多数依赖无论手动连接还是自动连接都会有报错，个人感觉最大的可能就是不兼容现在的react-native^0.42.0，最后找到两个可以在IOS上显示的高德地图依赖和一个可以定位的依赖。

### [react-native-maps](https://github.com/airbnb/react-native-maps)

可以显示高德地图，配置过程也非常简单，只需执行如下两个命令，运行时模拟器中地图显示的是英文，真机上地图显示的汉字，但是样式看上去有点奇怪，不知道是不是版本老的原因。

- `npm install react-native-maps --save `
- `react-native link react-native-maps`

{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/map1.jpg 300 高德地图 %}

虽然这个依赖显示了高德地图，但是经过这些安装高德地图的试验，我感觉这个依赖很奇怪。（1）没有看到高德地图相关的文件`MAMapKit.framework、AMapFoundationKit.framework、AMapSearchKit.framework `；（2）没有进行高德key值的配置，个人感觉在`react-native-maps/ios/AirMaps/AIRMapManager.m`文件中，31行应该是输入高德key值的地方。
  
### [react-native-smart-amap](https://github.com/react-native-component/react-native-smart-amap)

在ios上，可以按照说明文档进行配置，也就是手动链接。我是先执行`react-native link react-native-smart-amap`进行自动链接，然后再按照说明文件进行配置，需要注意的地方有两点：

- 拖进项目的RCTAMap.xcodeproj是在\node_modules\react-native-smart-amap\ios\RCTAMap路径下的，不是\node_modules\react-native-smart-amap\RCTAMap下的。
- "点击在Libraries下已拖进来的RCTAMap.xcodeproj, 选择Build Settings, 找到Framework Search Paths, 将$(SRCROOT)/../../../ios/Frameworks替换成$(SRCROOT)/../../../../ios/Frameworks"这个步骤在每次重装依赖后都要重新执行。

```
import React, { Component } from 'react';
import { StyleSheet, Dimensions, Platform, StatusBar } from 'react-native';
import AMap from 'react-native-smart-amap';

const WINDOW_WIDTH = Dimensions.get('window').width;
const WINDOW_HEIGHT = Dimensions.get('window').height;
const StatusBar_HEIGHT = StatusBar.currentHeight;

class SmartAmap extends Component {
  constructor(props) {
    super(props);
    this.state = {
      latitude: 39.889725,
      longitude: 116.357357,
    };
  }
  render() {
    const options = {
      frame: {
        width: WINDOW_WIDTH,
        height: Platform.OS === 'ios' ? WINDOW_HEIGHT - 55 : WINDOW_HEIGHT - StatusBar_HEIGHT - 55,
      },
      showsUserLocation: true,
      userTrackingMode: Platform.OS === 'ios' ? AMap.constants.userTrackingMode.none : null,
      centerCoordinate: {
        latitude: this.props.centerCoordinate ? this.props.centerCoordinate.latitude : this.state.latitude,
        longitude: this.props.centerCoordinate ? this.props.centerCoordinate.longitude : this.state.longitude,
      },
      zoomLevel: 18.1,
      centerMarker: Platform.OS === 'ios' ? 'icon_location' : 'poi_marker',
    };
    return (
      <AMap
        ref={ component => this._amap = component }
        style={{...StyleSheet.absoluteFillObject}}
        options={options}
        radius={100}
      />
    );
  }
}
```

这时的运行结果如下图所示，地图上并没有标注出坐标的位置，查了issuse列表看到别也提了这个问题，估计是依赖的问题，我就查了一下依赖的源码，试着找了一下，发现将**react-native-smart-amap/ios/RCTAMap/RCTAMap/RCTAMapManager.m文件中422、423、424行的NO改为YES**，地图上的位置标注就出来了，如下图所示。
{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/ios-map.png ios高德地图 %}

以上都是在ios上的配置，在android端也有需要注意的地方。上一篇[React-Native-Android使用高德地图](https://zhulichao.github.io/2017/03/24/react-native-amap-android/)已经讲了在android上使用高德地图，如果想在android端也使用react-native-smart-amap这个依赖来保持一致的话，需要先将android/setting.gradle、android/app/build.gradle、MainApplication.java中关于react-native-amap-android的配置去掉，然后再按照说明文档配置react-native-smart-amap，否则会报两个错误。

第一个错误如下图所示，解决办法是将gradle.properties文件中被注释的`org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8`放开。
{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/jvmargs.png 报错1 %}
第二个错误如下图所示，是由于包冲突，因为已经存在一个高德地图的依赖了，解决办法就是将android/setting.gradle、android/app/build.gradle、MainApplication.java中关于react-native-amap-android的配置去掉，只保留一个高德地图的配置。
{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/transformClassesWithDexForDebug.png 报错2 %}

而且android也是存在位置标注不显示的问题，需要将**react-native-smart-amap/android/src/main/reactnativecomponent/amap/RCTAMapView.java文件的202行注释放开**，地图上的位置标注就出来了，如下图所示。
{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/android-map.png android高德地图 %}

### [react-native-smart-amap-location](https://github.com/react-native-component/react-native-smart-amap-location)

在ios上，还是执行`react-native link react-native-smart-amap-location`进行自动链接，然后再按照说明文件进行配置，只有下面这一条需要注意：

- "点击在Libraries下已拖进来的RCTAMapLocation.xcodeproj, 选择Build Settings, 找到Framework Search Paths, 将$(SRCROOT)/../../../ios/Frameworks替换成$(SRCROOT)/../../../../ios/Frameworks"这个步骤在每次重装依赖后都要重新执行。

```
import React, { Component } from 'react';
import { View, StyleSheet, Dimensions, Platform, StatusBar, NativeAppEventEmitter, Alert } from 'react-native';
import { Button } from 'antd-mobile';
import AMapLocation from 'react-native-smart-amap-location';
import AppEventListenerEnhance from 'react-native-smart-app-event-listener-enhance';

const WINDOW_WIDTH = Dimensions.get('window').width;
const WINDOW_HEIGHT = Dimensions.get('window').height;
const StatusBar_HEIGHT = StatusBar.currentHeight;

class SmartAmap extends Component {
  constructor(props) {
    super(props);
    this.state = {
      latitude: 39.889725,
      longitude: 116.357357,
    };
    this.info = '';
    this._onLocationResult = this._onLocationResult.bind(this);
  }
  componentDidMount() {
    let viewAppearCallBack = (event) => {
      AMapLocation.init(null); //使用默认定位配置
    }
    this.addAppEventListener(
        this.props.navigator.navigationContext.addListener('didfocus', viewAppearCallBack),
        NativeAppEventEmitter.addListener('amap.location.onLocationResult', this._onLocationResult)
    );
  }
  componentWillUnmount () {
    //停止并销毁定位服务
    AMapLocation.cleanUp()
  }
  getLocation() {
    AMapLocation.getLocation();
  }
  getReGeocode() {
    AMapLocation.getReGeocode();
  }
  _onLocationResult(result) {
    if(result.error) {
      Alert.alert(`错误代码: ${result.error.code}, 错误信息: ${result.error.localizedDescription}`)
    }
    else {

      if(result.formattedAddress) {
        console.log("定位逆地理编码信息：", result)
        Alert.alert(`格式化地址 = ${result.formattedAddress}`);
      }
      else {
        console.log("定位地理编码信息：", result)
        Alert.alert(`纬度 = ${result.coordinate.latitude}, 经度 = ${result.coordinate.longitude}`)
      }
    }
  }
  render() {
    return (
      <View>
        <Button type="primary" onClick={this.getLocation}>
            定位地理编码信息
        </Button>
        <Button type="primary" onClick={this.getReGeocode}>
            定位逆地理编码信息
        </Button>
      </View>
    );
  }
}

export default AppEventListenerEnhance(SmartAmap);
```

{% img https://zhulichao.github.io/2017/03/24/react-native-amap-ios/location.png 高德地图定位 %}
