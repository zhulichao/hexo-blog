---
title: React-Native-打开文件
layout: post
date: 2017-04-07 16:32:03
categories: React Native
tags: React Native
---

## 本地应用打开文件  [react-native-file-opener](https://github.com/huangzuizui/react-native-file-opener)

* `NPM install`
```
npm install --save react-native-file-opener
```
* `IOS install`
```
在Xcode中，将node_modules/react-native-file-opener/ios/RNFileOpener.xcodeproj添加到项目的Libraries目录；
将Libraries/RNFileOpener.xcodeproj/Products/libRNFileOpener.a拖拽到Build Phases -> Link Binary With Libraries中。
```
* `Android install`
```
// file: android/settings.gradle
...
include ':react-native-file-opener'
project(':react-native-file-opener').projectDir = new File(settingsDir, '../node_modules/react-native-file-opener/android')
```

    ```
    // file: android/app/build.gradle
    ...
    dependencies {
        ...
        compile project(':react-native-file-opener')
    }
    ```

    ```
    // file: MainActivity.java
    ...
    import com.fileopener.FileOpenerPackage;//<- import package

    public class MainActivity extends ReactActivity {
        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new FileOpenerPackage() //<- Add package
            );
        }
    ...
    }
    ```
* `Usage`
在上一篇[React-Native-上传下载](/2017/04/03/react-native-upload/)例子的基础上，添加如下代码
```
...
import FileOpener from 'react-native-file-opener';
...
class TestFileStream extends Component {
  ...
  openFile(fileName) {
    const FilePath = Platform.OS === 'android' ? dirs.DCIMDir + '/' + fileName : dirs.DocumentDir + '/' + fileName;
    const FileMimeType = 'image/jpg';
    FileOpener.open(
        FilePath,
        FileMimeType
    ).then((msg) => {
        console.log('success!!')
    },(err) => {
        console.log('打开失败:', err)
    });
  }
  ...
}
export default TestFileStream;
```
{% img /2017/04/07/react-native-open/open.gif 300 运行结果 %}