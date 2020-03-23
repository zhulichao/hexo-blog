---
title: React-Native-Android使用百度地图
layout: post
date: 2017-06-17 11:31:13
categories: React Native
tags: React Native
---

## 百度地图key值

- http://developer.baidu.com/，注册开发者帐号
- 进入百度地图->API控制台，创建应用，应用类型选择Android SDK，输入发布版SHA1和包名提交即可

{% img /2017/06/17/react-native-baidu-map-android/key.png 申请百度地图key %}

## 显示地图及定位

使用[react-native-baidu-map](https://github.com/lovebing/react-native-baidu-map)依赖。

* `NPM install`
```
npm install react-native-baidu-map --save
```
* `android/setting.gradle`:
```
include ':react-native-baidu-map'
project(':react-native-baidu-map').projectDir = new File(settingsDir, '../node_modules/react-native-baidu-map/android')
```
* `android/app/build.gradle`:
```
    compile project(':react-native-baidu-map')
```
* `MainApplication.java`:
```
import org.lovebing.reactnative.baidumap.BaiduMapPackage;

      return Arrays.<ReactPackage>asList(
          ...
          , new BaiduMapPackage(getApplicationContext())
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
        android:name="com.baidu.lbsapi.API_KEY"
        android:value="baidu-key"/><!--百度地图key值-->
       ...
```
* Usage
```
import React, { Component } from 'react';
import {
  View,
  Text,
  TouchableHighlight,
  StyleSheet,
  InteractionManager,
  Dimensions,
  Platform,
  StatusBar,
  NativeAppEventEmitter,
  Alert,
} from 'react-native';
import { Button } from 'antd-mobile';
import { MapView, MapTypes, MapModule, Geolocation } from 'react-native-baidu-map';

class BaiduLocationTest extends Component {
  constructor(props) {
    super(props);
    this.state = {
      mayType: MapTypes.NORMAL,
      zoom: 15,
      center: {
        longitude: 113.981718,
        latitude: 22.542449
      },
      trafficEnabled: false,
      baiduHeatMapEnabled: false,
      markers: [{
        longitude: 113.981718,
        latitude: 22.542449,
        title: "Window of the world"
      },{
        longitude: 113.995516,
        latitude: 22.537642,
        title: ""
      }]
    };
    this.timer = null;
  }
  componentDidMount() {

  }
  componentWillUnmount () {
    this.timer && clearInterval(this.timer);
  }
  getLocation = () => {
    this.timer = setInterval(
      () => {
        Geolocation.getCurrentPosition()
          .then(data => {
            console.log(JSON.stringify(data));
            this.setState({
              marker: {
                latitude: data.latitude,
                longitude: data.longitude,
                title: 'Your location'
              },
              center: {
                latitude: data.latitude,
                longitude: data.longitude,
                rand: Math.random()
              }
            });
          })
          .catch(e =>{
            console.warn(e, 'error');
          })
      },
      2000
    );
  }
  render() {
    return (
      <View style={styles.container}>
        <MapView
          trafficEnabled={this.state.trafficEnabled}
          baiduHeatMapEnabled={this.state.baiduHeatMapEnabled}
          zoom={this.state.zoom}
          mapType={this.state.mapType}
          center={this.state.center}
          marker={this.state.marker}
          markers={this.state.markers}
          style={styles.map}
          onMarkerClick={(e) => {
            console.warn(JSON.stringify(e));
          }}
          onMapClick={(e) => {
          }}
        >
        </MapView>
        <View style={styles.row}>
          <Button style={styles.btn} onClick={this.getLocation}>获取位置信息</Button>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  button: {
    margin: 20,
  },
  row: {
    flexDirection: 'row',
    height: 40
  },
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  map: {
    width: Dimensions.get('window').width,
    height: Dimensions.get('window').height - 200,
    marginBottom: 16
  }
});

export default BaiduLocationTest;
```

{% img /2017/06/17/react-native-baidu-map-android/map.gif 300 百度地图 %}

{% img /2017/06/17/react-native-baidu-map-android/location.png 500 位置信息 %}