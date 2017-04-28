---
title: React-Native-Android使用高德地图
layout: post
date: 2017-03-24 23:08:46
categories: React-Native
tags: React-Native
---

## 高德地图key值

- http://lbs.amap.com/，注册帐号
- 登录后，进入控制台，应用管理->我的应用，添加新key
    - PackageName为`/android/app/src/main/AndroidManifest.xml`中package的值
    - 发布版安全码SHA1，在cmd下执行如下命令会生成SHA1值  
        `cd .android`  
        `keytool -list -v -keystore debug.keystore`

{% img https://zhulichao.github.io/2017/03/24/react-native-amap-android/android-key.png 申请高德地图key %}

## 显示地图

使用[react-native-amap](https://github.com/dwd-fe/react-native-amap)依赖。

* `NPM install`
```
npm install react-native-amap --save
```
* `android/setting.gradle`:
```
include ':react-native-amap-view'
project(':react-native-amap-view').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-amap-view/android')
```
* `android/app/build.gradle`:
```
    compile project(":react-native-amap-view")
```
* `MainApplication.java`:
```
import com.dianwoba.rctamap.AMapPackage;

      return Arrays.<ReactPackage>asList(
          ...
          , new AMapPackage()
          ...
```
* `AndroidManifest.xml`:
```
    <!--用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
    <!--用于访问GPS定位-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
    <!--获取运营商信息，用于支持提供运营商信息相关的接口-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
    <!--用于访问wifi网络信息，wifi信息会用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission>
    <!--这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
    <!--用于访问网络，网络定位需要上网-->
    <uses-permission android:name="android.permission.INTERNET"></uses-permission>
    <!--用于读取手机当前的状态-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE"></uses-permission>
    <!--写入扩展存储，向扩展卡写入数据，用于写入缓存定位数据-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>

    <application
      android:name=".MainApplication"
      android:allowBackup="true"
      android:label="@string/app_name"
      android:icon="@mipmap/ic_launcher"
      android:theme="@style/AppTheme">
      <service android:name="com.amap.api.location.APSService"></service>
      <meta-data
       android:name="com.amap.api.v2.apikey"
       android:value="e55ba4f9a563450e0e63f0493f01c323"/><!--高德地图key值-->
       ...
```
* Usage
```
import React, { Component } from 'react';
import { View, Text, TouchableHighlight, StyleSheet, InteractionManager, MapView } from 'react-native';
import AMapView from 'react-native-amap-view';

class Amap extends Component {
  render(){
    return (
        <View style={{flex: 1, backgroundColor: '#f00'}}>
            <AMapView initialRegion={{latitude: 30.315888, longitude: 120.165817}} showsUserLocation>
                <AMapView.Marker pinColor="green" draggable title='xxx' description="这是一个好地方" coordinate={{latitude: 30.315888, longitude: 120.165817}} />
            </AMapView>
        </View>
    );
  }
}
export default Amap;
```
* 启动
react-native run-android 启动后，报如下错误，将`node_modules\react-native-amap-view\android\src\main\java\com\dianwoba\rctamap\RegionChangeEvent.java`的17行 改为`super(id);`就不报这个错了。**之后可能需要重启6、7次才能正常启动起来。**

  {% img https://zhulichao.github.io/2017/03/24/react-native-amap-android/mapError.png 报错如图 %}

## 地图定位

使用[react-native-amap-location
](https://github.com/xiaobuu/react-native-amap-location)依赖，该依赖仅用于android。

* `NPM install`
```
npm install react-native-amap-location --save
```
* `android/setting.gradle`:
```
include ':reactamaplocation'
project(':reactamaplocation').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-amap-location')
```
* `android/app/build.gradle`:
```
    compile project(':reactamaplocation')
```
* `MainApplication.java`:
```
import com.xiaobu.amap.AMapLocationReactPackage;
      
      return Arrays.<ReactPackage>asList(
          ...
          , new AMapLocationReactPackage()
          ...
```
* `AndroidManifest.xml`:
```
    <!--用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
    <!--用于访问GPS定位-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
    <!--获取运营商信息，用于支持提供运营商信息相关的接口-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
    <!--用于访问wifi网络信息，wifi信息会用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission>
    <!--这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
    <!--用于访问网络，网络定位需要上网-->
    <uses-permission android:name="android.permission.INTERNET"></uses-permission>
    <!--用于读取手机当前的状态-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE"></uses-permission>
    <!--写入扩展存储，向扩展卡写入数据，用于写入缓存定位数据-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>

    <application
      android:name=".MainApplication"
      android:allowBackup="true"
      android:label="@string/app_name"
      android:icon="@mipmap/ic_launcher"
      android:theme="@style/AppTheme">
      <service android:name="com.amap.api.location.APSService"></service>
      <meta-data
       android:name="com.amap.api.v2.apikey"
       android:value="e55ba4f9a563450e0e63f0493f01c323"/><!--高德地图key值-->
       ...
```
* Usage
```
import React, { Component } from 'react';
import { View, Text, TouchableHighlight, StyleSheet, InteractionManager, MapView } from 'react-native';
import AMapView from 'react-native-amap-view';
import AMapLocation from 'react-native-amap-location';

class Amap extends Component {
  constructor(props) {
    super(props);
    this.state = {
      latitude: 39.888396427164594,
      longitude: 116.35112870293183,
    };
    this.clearInterval = null;
  }
  componentDidMount() {
    this.listener = AMapLocation.addEventListener((data) => {
      console.log('data', data);
      this.setState({
        latitude: data.latitude,
        longitude: data.longitude,
      });
    });

    AMapLocation.startLocation({
      accuracy: 'HighAccuracy',
      killProcess: true,
      needDetail: true,
    });
  }
  componentWillUnmount() {
    AMapLocation.stopLocation();
    this.listener.remove();
  }
  render() {
    return (
      <View style={{height: 500, width: 500,}}>
      </View>
    );
  }
  render(){
    return (
      <View style={{flex: 1, backgroundColor: '#f00'}}>
        <AMapView initialRegion={{latitude: this.state.latitude, longitude: this.state.longitude}} showsUserLocation>
          <AMapView.Marker pinColor="green" draggable title='当前位置' description="这是一个好地方" coordinate={{latitude: this.state.latitude, longitude: this.state.longitude}} />
        </AMapView>
      </View>
    );
  }
}
export default Amap;
```

{% img https://zhulichao.github.io/2017/03/24/react-native-amap-android/map.jpg 300 地图 %}
{% img https://zhulichao.github.io/2017/03/24/react-native-amap-android/locationText.png 位置信息 %}

注意，如果是在模拟器上可能由于缺少定位权限报如下错误。

{% img https://zhulichao.github.io/2017/03/24/react-native-amap-android/mapError3.png 300 报错 %}
{% img https://zhulichao.github.io/2017/03/24/react-native-amap-android/mapError4.png 缺少定位权限 %}