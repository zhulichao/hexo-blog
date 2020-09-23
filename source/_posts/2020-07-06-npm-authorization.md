---
title: NPM-授权安装
layout: post
date: 2020-07-06 10:59:12
categories: NPM
tags: NPM
---

问题描述：工作中遇到一个特殊的需求，部门自己研发的平台，纯前端项目，没有后端，发布为私有包，希望可以通过授权安装控制项目分摊成本。

任何客户端都存在同样的问题，无论如何代码都要在客户端运行，所以就目前的技术而言是无法避免文件拷贝的。但可以通过混淆、加密等手段增加对方使用代码的成本。webpack 的 uglifyjs-webpack-plugin 插件可以进行代码混淆，但是还是能搜索到一些关键字。如果要对整个 js 文件进行加密，浏览器是无法识别加密后的文件的，可以考虑只对关键信息进行加密，解密后再执行。

## 方式一：输出版权信息

思路：这是收费 js 的通用做法，只能限制商业运用，但任何人都可以得到你的源码。下载源码后，搜索版权信息中的关键字，很容易就能定位到这段代码，然后自己删除掉。为了不让用户轻易找到输出版权信息的代码，可以对这部分输出代码进行加密，减小用户找到这段代码的可能性。

借助 webpack 的 copy-webpack-plugin 插件，可以在打包时对静态资源进行加密，使用 axios 加载打包后的静态资源再进行解密，这样就可以在代码中写明文的输出信息，方便维护，打包后就是进行了加密的代码。

实现代码：

```js
// encrypt.js 加密文件
var CryptoJS = require('crypto-js');
var config = require('../config');

function encrypt(content, path) {
  var str = content.toString();
  // 密钥 16 位
  var key = config.encrypt.key;
  // 初始向量 initial vector 16 位
  var iv = config.encrypt.iv;
  // key 和 iv 可以一致

  key = CryptoJS.enc.Utf8.parse(key);
  iv = CryptoJS.enc.Utf8.parse(iv);

  var encrypted = CryptoJS.AES.encrypt(str, key, {
    iv: iv,
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.Pkcs7,
  });

  // 转换为字符串
  encrypted = encrypted.toString();

  // mode 支持 CBC、CFB、CTR、ECB、OFB, 默认 CBC
  // padding 支持 Pkcs7、AnsiX923、Iso10126
  // 、NoPadding、ZeroPadding, 默认 Pkcs7, 即 Pkcs5

  return encrypted;
}

module.exports = encrypt;
```

```js
// decrypt.js 解密文件
var CryptoJS = require('crypto-js');
var config = require('../config');

function decrypt(content) {
  var key = config.encrypt.key;
  var iv = config.encrypt.iv;

  key = CryptoJS.enc.Utf8.parse(key);
  iv = CryptoJS.enc.Utf8.parse(iv);

  // DES 解密
  var decrypted = CryptoJS.AES.decrypt(content, key, {
    iv: iv,
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.Pkcs7,
  });

  // 转换为 utf8 字符串
  decrypted = CryptoJS.enc.Utf8.stringify(decrypted);
  return decrypted;
}

module.exports = decrypt;
```

```js
// webpack.config.js webpack 配置
const CopyWebpackPlugin = require('copy-webpack-plugin')
...
plugins: [
  new CopyWebpackPlugin([
    {
      from: path.resolve(__dirname, '../../static/info'),
      to: 'static',
      transform (content, path) {
        return encrypt(content, path)
      }
    }
  ]),
]

// static/info 输入版权信息的静态文件
console.log(
  '%c未授权 xxxx公司 版权所有 copyright@2020',
  '\n\tfont-size: 16px;\n\tcolor: red;\n'
);

// 代码中读取加密后的静态文件，解密后执行
axios.get('static/info').then(result => {
  eval(decrypt(result.data));
});
```

## 方案二：授权安装

思路：利用 NPM 的 preinstall 钩子，可以在输入 npm install 后，安装包之前，执行一个 Node.js 脚本，在这个脚本中，可以要求用户输入一个 token 到后端进行校验，也可以拿到 mac 地址到后端请求进行验证，也可以拿项目目录下的授权文件，解密后校验，如果可以安装则继续，如果不可以安装则中断安装。

实现代码：

```js
const os = require('os');
const chalk = require('chalk');
const getMAC = require('getmac');
const path = require('path');

// 输出 mac 地址，可做校验
console.log(getMAC.default());

// 读取项目目录下 static/config.json 文件，可做校验
const configJSON = require(path.resolve(
  process.cwd(),
  '../../static/config.json'
));
console.log('====', configJSON);

// 用户输入指定信息，可做校验
process.stdout.write(`${chalk.cyan('Please input token:')}`);
process.stdin.on('data', (input) => {
  const token = input.toString().trim();
  if (token !== 'aaa') {
    console.log('认证失败，结束安装！');
    process.exit(1);
  }
  console.log('认证成功，开始安装...');
  process.stdin.pause();
});
```

但是这种方式还是存在问题，主要问题是在不同环境下执行安装包命令时获取的 mac 地址可能不正确，如在容器中执行，或 CI 的线上环境。而且包一旦被安装了，就在项目的 node_modules 目录下了，一是可以通过拷贝的方式泄露，二是安装到本地后执行解密的代码就泄露了。

## 方式三：授权运行

思路：不控制安装，所有人都可以进行安装包的操作，使用时需要给项目一个加密的授权文件，运行时拿到这个授权文件，解密后进行校验，如果正确则向下运行，否则终止运行。这就要求授权文件中被加密的信息要是运行时能拿到的信息，并且具有唯一性，由于客户端是没办法获取 mac 地址的，可以使用域名和时间的方式进行加密。运行时获取授权文件，判断如果是生产环境授权文件，进行域名和端口号的校验，如果是开发环境授权文件，则校验授权日期和过期天数。

生成授权文件时我们向用户要了域名，那用户就知道我们是使用了域名进行校验，肯定有获取域名的代码，在代码中搜索 `location.host` 很容易定位到进行校验的代码，仔细读读就可以进行破解，因此希望能对这段校验的代码进行加密。我们使用方案一中对静态资源加密的方式，把校验逻辑的代码写在一个静态文件中。注意这里不能把整个校验逻辑写成一个完整的方法放在静态文件中导出使用，因为这个文件没有被 babel 处理，解密后的文件中会存在 import 等浏览器无法识别的关键字。

最后为了使用方便，还需要一个能生成授权文件的脚本。

实现代码：

```js
// generateLicense.js 生成授权文件
var fs = require('fs');
var path = require('path');
var chalk = require('chalk');
var encrypt = require('./encrypt');

/*
 * static/license 为加密前的明文文件
 * 生产环境指定 type 为 production，添加 domains
 * 开发环境指定 type 为 development，添加 created 创建时间、expired 过期天数
 */
const buffer = fs.readFileSync(path.resolve(__dirname, '../static/license'));

// 写入文件，项目根目录下 license，不会被提交
var ws = fs.createWriteStream('./license');
ws.write(encrypt(buffer));
ws.end();
console.log(chalk.green('已生成 license 文件'));
```

```js
// webpack.config.js webpack 配置
const CopyWebpackPlugin = require('copy-webpack-plugin')
...
plugins: [
  new CopyWebpackPlugin([
    {
      from: path.resolve(__dirname, '../../static/validate'),
      to: 'static',
      transform (content, path) {
        return encrypt(content, path)
      }
    }
  ]),
]

// 项目入口进行授权校验
/* eslint-disable */
let validate = false;
try {
  // 获取授权文件
  const result = await axios.get('static/license');
  const FORMAT = 'YYYY-MM-DD';
  const str = decrypt(result.data);
  const data = JSON.parse(str);
  const nowDate = moment().format(FORMAT);
  // 获取加密后的校验逻辑文件，执行校验
  const validate = await axios.get('static/validate')
  eval(decrypt(validate.data));
} catch (error) {
  console.error(error);
}
/* eslint-enable */

if (!validate) {
  // 校验失败处理
  return;
}

// 校验通过，向下运行
...

// static/validate 校验逻辑静态文件
if (data.type === 'production' && data.domains.includes(window.location.host)) {
  validate = true;
}
if (data.type === 'development') {
  const expiredDate = moment(data.created, 'YYYY-MM-DD')
    .add(data.expired, 'days')
    .format('YYYY-MM-DD');
  if (nowDate <= expiredDate) {
    validate = true;
  }
}
```
