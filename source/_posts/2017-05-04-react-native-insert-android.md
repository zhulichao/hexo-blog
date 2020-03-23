---
title: React-Native-嵌入到android
layout: post
date: 2017-05-04 16:35:58
categories: React Native
tags: React Native
---

## 参考  
[嵌入到现有原生应用](http://reactnative.cn/docs/0.44/integration-with-existing-apps.html#content)  
[史上最详细的Android原生APP中添加ReactNative 进行混合开发教程](http://www.jianshu.com/p/22aa14664cf9)

## 配置步骤

### 创建android项目

- 打开Android studio，Start a new Android Studio project 新建项目
- 其中 Application name: ReactNativeAppDemo，Company Domain: example.com，Minimum SDK: API 16:Android 4.1(Jelly Bean)
- 添加Empty Activity，其中 Activity Name: MainActivity，Layout Name: activity_main
- 在Android视图下，右键com.example.reactnativeappdemo，New -> Java Class，其中 Name：MyReactActivity

MainActivity.java完整代码如下：
```
package com.example.reactnativeappdemo;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{
    private Button btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btn = (Button)findViewById(R.id.reactive_button);
        btn.setOnClickListener(this);
    }
    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.reactive_button:
                Intent intent = new Intent(MainActivity.this,MyReactActivity.class);
                startActivity(intent);
                break;
            default:
                break;
        }
    }
}
```

MyReactActivity完整代码如下：
```
package com.example.reactnativeappdemo;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.facebook.react.common.LifecycleState;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.shell.MainReactPackage;

public class MyReactActivity extends AppCompatActivity implements DefaultHardwareBackBtnHandler{
    private ReactRootView mReactRootView;
    private ReactInstanceManager mReactInstanceManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mReactRootView = new ReactRootView(this);
        mReactInstanceManager = ReactInstanceManager.builder()
                .setApplication(getApplication())
                .setBundleAssetName("index.android.bundle")
                .setJSMainModuleName("index.android")
                .addPackage(new MainReactPackage())
                .setUseDeveloperSupport(BuildConfig.DEBUG)
                .setInitialLifecycleState(LifecycleState.RESUMED)
                .build();

        // 注意这里的HelloWorld必须对应“index.android.js”中的
        // “AppRegistry.registerComponent()”的第一个参数
        mReactRootView.startReactApplication(mReactInstanceManager, "HelloWorld", null);
        setContentView(mReactRootView);
    }
    @Override
    public void invokeDefaultOnBackPressed() {
        super.onBackPressed();
    }
    @Override
    protected void onPause() {
        super.onPause();

        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostPause(this);
        }
    }
    @Override
    protected void onResume() {
        super.onResume();

        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostResume(this, this);
        }
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();

        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostDestroy();
        }
    }
    @Override
    public void onBackPressed() {
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onBackPressed();
        } else {
            super.onBackPressed();
        }
    }
    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_MENU && mReactInstanceManager != null) {
            mReactInstanceManager.showDevOptionsDialog();
            return true;
        }
        return super.onKeyUp(keyCode, event);
    }
}

```

## React Native集成到android项目中

- cmd进入在ReactNativeAPPDemo的根目录，执行 npm init
- 执行 npm install --save react react-native
- 执行 curl -o .flowconfig https://raw.githubusercontent.com/facebook/react-native/master/.flowconfig，作用是下载.flowconfig配置文件，用于约束js代码的写法，也可以手动创建文件在浏览器打开这个网址复制内容，这一步非必需
- package.json文件如下，注意react和react native的版本
```
{
  "name": "reactnativeappdemo",
  "version": "1.0.0",
  "description": "",
  "main": "index.android.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "node node_modules/react-native/local-cli/cli.js start"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "react": "~15.4.1",
    "react-native": "0.42.0"
  }
}
```
- 添加index.android.js文件到项目中
```
import React from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';
class HelloWorld extends React.Component {
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.hello}>React Native:Hello, World</Text>
            </View>
        );
    }
}
var styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
    },
    hello: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
});
AppRegistry.registerComponent('HelloWorld', () => HelloWorld);
```
- app/build.gradle配置
```
dependencies {
    ...
    compile "com.facebook.react:react-native:+" // From node_modules.
}
```
- 整个工程build.gradle配置
```
allprojects {
    repositories {
        ...
        maven {
            // All of React Native (JS, Android binaries) is installed from npm
            url "$rootDir/node_modules/react-native/android"
        }
    }
    ...
}
```
- app/src/main/AndroidManifest.xml配置
```
...
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
<application
    ...
    <activity
        android:name=".MyReactActivity"
        android:label="@string/app_name"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar">
    </activity>
    <activity
        android:name="com.facebook.react.devsupport.DevSettingsActivity">
    </activity>
</application>
```

## 启动项目

- 先运行android项目
- cmd进入在ReactNativeAPPDemo的根目录，执行 npm start

{% img /2017/05/04/react-native-insert-android/insert-android.gif 300 运行结果 %}

## 可能出现的错误

如果点击按钮后应用崩溃了，同时Android Studio中报错 permission denied for this window type ，需要开启悬浮窗(overlay)权限。
解决方法一，修改MainActivity.java中代码如下：
```
...
@Override
public void onClick(View view) {
    switch (view.getId()){
        case R.id.reactive_button:
            // 修改了这里的代码
            if (Build.VERSION.SDK_INT >= 23) {
                if(!Settings.canDrawOverlays(this)) {
                    Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
                    startActivity(intent);
                    return;
                } else {
                    //绘ui代码, 这里说明6.0系统已经有权限了
                    Intent intent = new Intent(MainActivity.this,MyReactActivity.class);
                    startActivity(intent);
                }
            } else {
                //绘ui代码,这里android6.0以下的系统直接绘出即可
                Intent intent = new Intent(MainActivity.this,MyReactActivity.class);
                startActivity(intent);
            }
            break;
        default:
            break;
    }
}
```

解决方法二，修改MyReactActivity.java中代码如下：
```
public class MyReactActivity extends AppCompatActivity implements DefaultHardwareBackBtnHandler{
    private static final int OVERLAY_PERMISSION_REQ_CODE =10005 ;
    ...
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName()));
                startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE);
            }
        }
        ...
    }
    ...
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!Settings.canDrawOverlays(this)) {
                    // SYSTEM_ALERT_WINDOW permission not granted...
                }
            }
        }
    }
}
```
{% img /2017/05/04/react-native-insert-android/insert-android2.gif 300 运行结果 %}