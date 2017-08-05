---
title: React-Native-BackAndroid
layout: post
date: 2017-07-03 11:05:00
categories: React Native
tags: React Native
---

## BackAndroid 物理返回键的使用

在android上，点击物理返回键时，通常会进行返回上个页面的操作，如果已经回到主页、没有上一级页面，则会弹出是否退出应用的提示。在RN中，对物理返回键的监听尽量放在最上层的组件中，示例代码如下。如果哪个页面单独定义了点击返会的操作，如给出提示是否保存当前页面，可在这个组件中再进行物理返回键的监听，注意最后要return true，这样就不会进入到全局的监听方法了。

```
import {
  ...
  Platform,
  BackAndroid,
} from 'react-native';

class App extends Component {
  constructor(props){
    super(props);
  }
  componentWillMount() {
    if (Platform.OS === 'android') {
      BackAndroid.addEventListener('hardwareBackPress', this.onBackAndroid);
    }
  }
  componentWillUnmount() {
    if (Platform.OS === 'android') {
      BackAndroid.removeEventListener('hardwareBackPress', this.onBackAndroid);
    }
  }
  onBackAndroid = () => {
    const navigator = this.refs.navigator;
    const routers = navigator.getCurrentRoutes();
    if (routers.length > 1) {
      navigator.pop(); // 没到主页，直接弹出到上一个页面
      return true; // 接管默认行为
    } else {
      // 到了主页了，最近2秒内按过back键，退出应用；否则弹出提示
      if (this.lastBackPressed && this.lastBackPressed + 2000 >= Date.now()) {
        return false;
      }
      this.lastBackPressed = Date.now();
      Toast.info('再按一次退出应用');
      return true;
    }
  }
  render () {
    return (
        <Navigator
            ref="navigator"
            initialRoute={initialRoute}
            shadowHidden={true}
            translucent={true}
            configureScene={this.configureScene}
            renderScene={this.renderScene}
          />
    );
  }
}
```