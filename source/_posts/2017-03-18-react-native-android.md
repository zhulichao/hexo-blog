---
title: React-Native-Android原生
layout: post
date: 2017-03-18 13:20:45
categories: React Native
tags: React Native
---

## [创建Android模块](http://reactnative.cn/docs/0.42/native-modules-ios.html#content)

- React-Native@0.42.0

- opms/android/app/java/com.opms下，新建`MyCustomModule.java`

```
package com.opms;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReactApplicationContext;

public class MyCustomModule extends ReactContextBaseJavaModule {
  public MyCustomModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "MyCustomModule";
  };

  @ReactMethod
  public void processString(String input, Callback callback) {
    callback.invoke(input.replace("Goodbye", "Hello"));
  }
}
```

- opms/android/app/java/com.opms下，新建`MyCustomReactPackage.java`

```
package com.opms;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class MyCustomReactPackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new MyCustomModule(reactContext));
        return modules;
    }

    @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
            new MyCustomImageManager()
        );
    }
}

```

- opms/android/app/java/com.opms下，修改`MainActivity.java`文件的getPackages方法

```
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        ...
        new MyCustomReactPackage()
    );
}
```

- index.android.js文件中

```
import React, { Component, PropTypes } from 'react';
import {
  NativeModules,
  View,
  AppRegistry,
} from 'react-native';

export default class opms_rn extends Component {
  componentDidMount() {
    // RN调Android原生模块
    NativeModules.MyCustomModule.processString('Goodbye World.', (text) => {
      console.log("原生模块处理后：", text);
    });
  }
  render() {
    return (
      <View>
        <Text>请打开控制台看输出结果</Text>
      </View>
    );
  }
}

AppRegistry.registerComponent('opms', () => opms);
```

- 运行结果

{% img /2017/03/18/react-native-android/Android-Module.png 调用Android原生模块 %}

## [创建Android View](http://reactnative.cn/docs/0.42/native-component-ios.html#content)

- React-Native@0.42.0

- opms/android/app/java/com.opms下，新建`MyCustomImageManager.java`

```
package com.opms;

import android.support.annotation.Nullable;
import android.widget.ImageView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.uimanager.ReactStylesDiffMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewProps;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.views.image.ImageResizeMode;
import com.facebook.react.views.image.ReactImageView;

import java.util.Arrays;

public class MyCustomImageManager extends SimpleViewManager<ReactImageView> {
    public static final String REACT_CLASS = "RCTImageView";
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected ReactImageView createViewInstance(ThemedReactContext context) {
        ReactImageView imageView = new ReactImageView(context, Fresco.newDraweeControllerBuilder(), null);
        return imageView;
    }

    @ReactProp(name = "src")
    public void setSrc(ReactImageView view, @Nullable ReadableArray  src) {
        view.setSource(src);
    }

    @ReactProp(name = "borderRadius", defaultFloat = 0f)
    public void setBorderRadius(ReactImageView view, float borderRadius) {
        view.setBorderRadius(borderRadius);
    }

    @ReactProp(name = ViewProps.RESIZE_MODE)
    public void setResizeMode(ReactImageView view, @Nullable String resizeMode) {
        view.setScaleType(ImageResizeMode.toScaleType(resizeMode));
    }
}

```

- opms/android/app/java/com.opms下，新建`MyCustomReactPackage.java`

```
public class MyCustomReactPackage implements ReactPackage {
    ...
    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
            new MyCustomImageManager()
        );
    }
}
```

- opms/android/app/java/com.opms下，修改`MainActivity.java`文件的getPackages方法

```
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        ...
        new MyCustomReactPackage()
    );
}
```

- 新建`ImageView.android.js`

```
import { PropTypes } from 'react';
import { requireNativeComponent, View } from 'react-native';

var iface = {
  name: 'ImageView',
  propTypes: {
    ...View.propTypes, // 包含默认的View的属性
    src: PropTypes.string,
    borderRadius: PropTypes.number,
    resizeMode: PropTypes.oneOf(['cover', 'contain', 'stretch']),
  },
};

module.exports = requireNativeComponent('RCTImageView', iface);
```

- index.android.js文件中

```
import React, { Component, PropTypes } from 'react';
import {
  View,
  AppRegistry,
} from 'react-native';
import ImageView from './ImageView';

export default class opms extends Component {
  render() {
    return (
      <ImageView src="https://facebook.github.io/react/img/logo_og.png" />
    );
  }
}

AppRegistry.registerComponent('opms', () => opms);
```

- 运行结果

当ImageView组件使用到属性src时，很奇怪会报错，所有操作都是按照官方教程做的仍然报错，网上也没有查到原因。
{% img /2017/03/18/react-native-android/Android-View-Err.png 300 调用Android原生View %}

但是如果使用其它属性，如borderRadius，是不会报错的，通过React组件调试工具也能看到属性已经添加上了，应该是已经成功调用了Android原生View。
{% img /2017/03/18/react-native-android/Android-View2.png 调用Android原生View %}