---
title: React-Native-上传下载
layout: post
date: 2017-04-03 00:22:48
categories: React Native
tags: React Native
---

## 文件的上传下载[ react-native-fetch-blob](https://github.com/wkh237/react-native-fetch-blob)

* `NPM install`
```
npm install --save react-native-fetch-blob
```
* `Automatically Link Native Modules`
```
react-native link react-native-fetch-blob
```
* `AndroidManifest.xml`:
```
...
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />                                               
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" /> 
...
<intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
    <action android:name="android.intent.action.DOWNLOAD_COMPLETE"/>         
</intent-filter>
```
* `Notice`
对于下载路径 RNFetchBlob.fs.dirs 的结论如下：
```
CacheDir:"/data/user/0/com.gps/cache" ---- ios需越狱；android需root权限才能看
DocumentDir:"/data/user/0/com.gps/files" ---- ios需越狱；android需root权限才能看
MainBundleDir:"/data/user/0/com.gps" ---- ios系统app才能用；android需root权限才能看
DCIMDir:"/storage/emulated/0/DCIM" ---- 不支持ios；android的DCIM目录
DownloadDir:"/storage/emulated/0/Download" ---- 不支持ios；android的Download目录
MovieDir:"/storage/emulated/0/Movies" ---- 不支持ios；android的Download目录
MusicDir:"/storage/emulated/0/Music" ---- 不支持ios；android的Download目录
PictureDir:"/storage/emulated/0/Pictures" ---- 不支持ios；android的Download目录
SDCardDir:"/storage/emulated/0" ---- 不支持ios；android的Download目录
```
    **个人感觉下载时应该下载到DocumentDir或CacheDir中，这两个个目录是用户不可见的，只用当用户显示发出了保存到相册的动作时才应该把下载的图片放到相册，通过调用React Native 提供的CameraRoll可以达到这个效果，这样用户对相册中图片的任何操作才不会对系统产生影响。**
* `Usage`
```
import React, { Component } from 'react';
import { View, Text, StyleSheet, ScrollView, Image, Platform, CameraRoll, TouchableHighlight, Dimensions } from 'react-native';
import { Button } from 'antd-mobile';
import RNFetchBlob from 'react-native-fetch-blob';
import Icon from 'react-native-vector-icons/FontAwesome';

import Global from '../styles/Global';
import NavBar from './NavBar';
import { default as config } from '../config/base';
import { getCommonHeaders } from '../utils/fetchUtil';

const dirs = RNFetchBlob.fs.dirs;
const WINDOW_WIDTH = Dimensions.get('window').width;
const WINDOW_HEIGHT = Dimensions.get('window').height;

class TestFileStream extends Component {
  constructor(props) {
    super(props);
    this.state = {
      downImageView: null,
      fileList: [],
    };
    this.uploadFile = this.uploadFile.bind(this);
    this.downloadFile = this.downloadFile.bind(this);
    this.getFilesInfo = this.getFilesInfo.bind(this);
    this.goBack = this.goBack.bind(this);
  }
  goBack() {
    this.props.navigator.pop();
  }
  uploadFile() {
    const data = '{\"SERV_ID\":\"'+'OPMS_EVENTATTACH_RECORD_PAGE'+'\",'
              + '\"FILE_CAT\":\"'+'ATTACH_IMG'+'\",'
              + '\"DATA_ID\":\"'+'0S8iwECYm1d68jb4FElvoKDb'+'\",'
              + '\"FILE_SORT\":' + 0 +'}';
    const commonHeader = getCommonHeaders();
    const header = {
      'ACCESS_TOKEN': commonHeader.ACCESS_TOKEN,
      'Content-Type': 'multipart/form-data',
    };
    RNFetchBlob.fetch('POST', `${config.applicationIpAndPort}/file?data=${encodeURIComponent(data)}`,
      header,
      [{
        name : 'Filedata',
        filename : 'cdpImage.png',
        data: RNFetchBlob.wrap(Platform.OS === 'android' ? 'file://'+ dirs.DCIMDir + '/cdpImage.png' : dirs.DocumentDir + '/cdpImage.png')
      }]
    ).then((res) => {
      console.log('上传成功：', res.text());
      alert("上传成功,浏览器中有信息");
    }).catch((err) => {
      console.log('上传失败：', err);
      alert("上传失败,浏览器中有信息");
    });
  }
  downloadFile() {
    RNFetchBlob.config({
      fileCache : true,
      path : Platform.OS === 'android' ? dirs.DCIMDir + '/logo.png' : dirs.DocumentDir + '/logo.png',
    }).fetch('GET', `https://facebook.github.io/react/img/logo_og.png`, {
      //some headers ..
    }).then((res) => {
      // 下载成功： /storage/emulated/0/Download/logo.png
      console.log('下载成功：', res.path());
      const imageStyle = {
        borderWidth: 1,
        width: 100,
        height: 100
      };
      const downImageView = (
        <View style={{justifyContent: 'center', alignItems: 'center'}}>
          <Image source={{ uri : Platform.OS === 'android' ? 'file://' + res.path()  : '' + res.path() }} style={imageStyle}/>
        </View>
      );
      this.setState({
        downImageView,
      });
      // 如果是 ios,同时下载到相册
      if (Platform.OS === 'ios') {
        CameraRoll.saveToCameraRoll(res.path(), 'photo');
      }
    }).catch((err) => {
      console.log("下载失败：", err);
      alert("下载失败,浏览器中有信息");
    });
  }
  getFilesInfo() {
    // 显示文件，返回数组
    RNFetchBlob.fs.ls(Platform.OS === 'android' ? dirs.DCIMDir : dirs.DocumentDir)
    .then((files) => {
        console.log("dirs.DocumentDir目录中的文件：", files);
        this.setState({
          fileList: files,
        });
    }).catch((err) => {
      console.log("获取失败：", err);
    });
  }
  openFile(fileName) {
    alert(`打开文件：${fileName}`);
  }
  showFileList() {
    return this.state.fileList.map((item, index) => {
      return (
        <TouchableHighlight
          style={styles.container}
          underlayColor="rgba(34, 26, 38, 0.1)"
          onPress={() => this.openFile(item)}
          key={index}
        >
          <View style={{flexDirection:'row'}}>
            <View style={styles.icon}>
              <Text style={styles.iconText}>{index}</Text>
            </View>
            <View style={styles.textContent}>
              <Text style={[styles.title, ]}>{item}</Text>
            </View>
          </View>
        </TouchableHighlight>
      );
    });
  }
  render() {
    return (
      <View style={[Global.flex1, {width: WINDOW_WIDTH}]}>
        <NavBar
          title={this.props.route.params.title}
          goBack={this.goBack}
        />
        <ScrollView style={styles.temporaryTask}>
          <View style={[Global.containerCenter, styles.marginBottom20]}>
            <Text style={{fontSize: 15}}>测试上传、下载的服务为：</Text>
            <Text style={{fontSize: 15}}>OPMS_EVENTATTACH_RECORD_PAGE</Text>
          </View>
          <View style={Global.flex1}>
            {this.state.downImageView}
            <Button
              type="primary"
              onClick={this.downloadFile}
              style={styles.marginBottom20}
            >
              <Icon name="cloud-download" size={20} />  下载文件
            </Button>
            <Button
              type="primary"
              onClick={this.uploadFile}
              style={styles.marginBottom20}
            >
              <Icon name="plus" size={20} />  上传文件
            </Button>
            <Button
              type="primary"
              onClick={this.getFilesInfo}
              style={styles.marginBottom20}
            >
              <Icon name="folder-open" size={20} />  获取文件列表
            </Button>
            {this.showFileList()}
          </View>
        </ScrollView>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  temporaryTask: {
    marginTop: 20,
    marginBottom: 10,
    marginHorizontal: 20,
    // alignItems: 'stretch',
    flex: 1,
    width: WINDOW_WIDTH - 40,
  },
  marginBottom20: {
    marginBottom: 20,
  },
  container: {
    width: WINDOW_WIDTH - 40,
    flexDirection:'row',
    backgroundColor: '#BFEFFF',
    borderRadius: 7,
    alignItems: 'flex-start',
    marginBottom: 10,
  },
  content: {
    flex: 1,
  },
  icon: {
    width: 35,
    height: 35,
    margin: 10,
    backgroundColor: '#108ee9',
    justifyContent: 'center',
    alignItems: 'center',
    flexDirection: 'row',
  },
  iconText: {
    fontSize: 28,
    color: '#fff',
    fontWeight: '400',
  },
  textContent: {
    flex: 1,
    padding: 10
  },
  title: {
    color: '#101010',
    fontSize: 17,
    fontWeight: "400",
  },
});

export default TestFileStream;
```
{% img /2017/04/03/react-native-upload/file.gif 300 运行结果 %}
{% img /2017/04/03/react-native-upload/file.png 打印结果 %}
