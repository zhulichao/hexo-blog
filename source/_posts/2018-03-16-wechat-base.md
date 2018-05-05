---
title: 微信小程序基础1
layout: post
date: 2018-03-16 23:30:41
categories: WeChat Mini Program
tags: WeChat Mini Program
---

我们的项目中是使用 TypeScript 写代码，通过 rollup 编译成 javascript，在微信开发者工具打开 build 后的目录，即可运行，开发模式下在每次保存完代码后都会进行编译。仍使用 yarn add xxx 集成第三方 package，在使用 import 引入第三方依赖的时候，会将第三方文件打包进去，因此不用特殊处理。当然如果没有必要引用或者没有必要全部引用的，尽量不引用或引用局部文件，防止将所有文件都打包进去最终超过 2M 的限制。

请注意因为使用了 ts，再引入第三方 package 时，有时 ts 校验会报错，可以关闭一次编辑器重新打开确认一下是否真的有校验错误，我在引入 moment 时就遇到了这个问题，第一次引入时有校验报错，第二天再试时就好了。

## 集成 Redux、Redux-Persist、Graphql、Apollo-Client

`yarn add redux redux-persist`
`yarn add apollo-client graphql-tag`

[Redux](https://github.com/reactjs/redux)的使用参考官方文档即可。小程序中不能使用 react-redux，为了能够像以前 react 使用 redux 一样在小程序中使用 redux，我参考了 [小程序 Redux 绑定库](https://github.com/charleyw/wechat-weapp-redux)，将其中的 warning.js、shallowEqual.js、wrapActionCreators.js、connect.js、Provider.js 简单修改为 ts 文件集成到项目中，就可以用使用 react-redux 的方式使用 redux 了。

在使用的过程中，connect 在 Page 上使用没有问题，但小程序中 Component 使用 connect 没有效果，这是因为 Component 的声明周期中没有 onLoad、onUnload，有的是 attached、detached 方法，因此修改 connect.ts 文件，通过传入固定参数 type 为 Component 来决定使用哪两个生命周期方法，这样支持了 Component 也能通过 connect 使用 redux。

使用 [redux-persist](https://github.com/rt2zz/redux-persist) 可以将 store 的整个数据保存到指定的 storage 中，如浏览器的 LocalStorage、react-native 的 AsyncStorage 等。将微信 storage 的 api 进行封装，也可直接使用[redux-persist-weapp-storage](https://github.com/cuijiemmx/redux-casa/tree/master/packages/redux-persist-weapp-storage)，可指定使用微信的 storage。参考 redux-persist 的文档，将 store 存储到 storage 可使用 persistStore 方法，或将 active 置为 true 在每次 store 变化时都保存到 storage 中。但在程序初始化时将 storage 中保存的数据放入 store 的操作在文档中没找到，官方提供的方式是针对 react 组件的，我自己找了两种可以达到该效果的方式，一种是直接从 storage 中读出数据，另一种是使用 getStoredState 读出数据，具体代码参考下面。

Apollo-Client 默认是使用 fetch 进行网络请求的，但是小程序中没有 fetch，只能使用 wx.request 进行网络请求，在官方文档也没有找到可以自定义或传入 fetch 的方式。后来查了源码，在 new ApolloClient 的 networkInterface 参数中可以传入 query 参数，这样将 wx.request 进行封装通过 query 参数传入，就可以使用 Apollo-Client 进行网络请求了。在我们的项目中有使用轮询的需求，使用的是 Apollo-Client 的 watchQuery 方法，因为每次需要指定 pollInterval 参数，感觉不太方便管理，因此对 watchQuery 的使用进行了封装，具体代码参考下面。

现在虽然能使用 Apollo-Client 进行网络请求了，但还没有办法直接拿到请求返回的结果，在 Web 端是使用 react-apollo 的 compose 将请求结果通过 props 传入组件，但是小程序无法使用。目前我使用了两种不是很好的方式临时解决的这个问题，如果是 mutation，直接使用 then 来拿到返回结果，如果是 query，是在 mapPropsToState 中，使用 Apollo-Client 的 readQuery 拿到请求的返回结果，进行处理后传入 Page 的 data。

**主要代码如下：**

configureStore.ts
```
import ApolloClient from 'apollo-client';
import { applyMiddleware, combineReducers, createStore, Store } from 'redux';
import { getStoredState, persistReducer, persistStore } from 'redux-persist';
import thunk from 'redux-thunk';

import createApolloClient from './createApolloClient';
import reducer from './reducers/index';
import WxStorage from './storage';

interface CreateRootReducer {
  apolloClient: ApolloClient;
}

function createRootReducer({ apolloClient }: CreateRootReducer) {
  return combineReducers({
    apollo: apolloClient.reducer(),
    ...reducer,
  });
}

let store: Store<{}>;

export default function configureStore() {
  const apolloClient = createApolloClient();
  const middleware = [thunk, apolloClient.middleware()];
  const enhancer = applyMiddleware(...middleware);
  const rootReducer = createRootReducer({ apolloClient });

  const persistConfig = {
    // active: true, // store 在每次变化后都会同步保存到 storage 中
    key: 'root',
    storage: WxStorage,
    version: 2,
  };

  const persistedReducer = persistReducer(persistConfig, rootReducer);
  // 将 storage 中保存的数据初始化给 store
  // 方式一
  const storedState = wx.getStorageSync('persist:root');
  const state: any = {};
  if (typeof storedState === 'string' && storedState) {
    const rawState = JSON.parse(storedState);
    Object.keys(rawState).forEach(key => {
      state[key] = JSON.parse(rawState[key]);
    });
  }
  // 方式二
  getStoredState(persistConfig)
    .then(res => {
      store.dispatch({
        key: 'root',
        payload: res,
        type: 'persist/REHYDRATE',
      });
    })
    .catch(error => {
      throw error;
    });

  store = createStore(persistedReducer, {}, enhancer);
  return {
    apolloClient,
    persistStore: () => persistStore(store), // 将 store 数据保存到 storage 中
    store,
  };
}
```

storage.ts
```
interface Storage {
  getItem(key: string, ...args: any[]): any;
  setItem(key: string, value: any, ...args: any[]): any;
  removeItem(key: string, ...args: any[]): any;
}

const WxStorage: Storage = {
  getItem: key =>
    new Promise((resolve, reject) => {
      wx.getStorage({
        fail: res => {
          reject(res);
        },
        key,
        success: res => {
          resolve(res.data);
        },
      });
    }),
  removeItem: key =>
    new Promise((resolve, reject) => {
      wx.removeStorage({
        fail: res => {
          reject(res);
        },
        key,
        success: res => {
          resolve(res);
        },
      });
    }),
  setItem: (key, data) =>
    new Promise((resolve, reject) => {
      wx.setStorage({
        data,
        fail: res => {
          reject(res);
        },
        key,
        success: res => {
          resolve(res);
        },
      });
    }),
};

export default WxStorage;
```

warning.ts
```
export default function warning(message: string) {
  if (typeof console !== 'undefined' && typeof console.error === 'function') {
    console.error(message);
  }
  try {
    // This error was thrown as a convenience so that if you enable
    // "break on all exceptions" in your console,
    // it would pause the execution at this line.
    throw new Error(message);
  } catch (e) {
    console.log(e);
  }
}
```

shallowEqual.ts
```
export default function shallowEqual(objA: any, objB: any) {
  if (objA === objB) {
    return true;
  }

  const keysA = Object.keys(objA);
  const keysB = Object.keys(objB);

  if (keysA.length !== keysB.length) {
    return false;
  }

  let result = true;
  // Test for A's keys different from B.
  const hasOwn = Object.prototype.hasOwnProperty;
  keysA.forEach(keyA => {
    if (!hasOwn.call(objB, keysA) || objA[keyA] !== objB[keyA]) {
      result = false;
      return false;
    }
    return;
  });

  return result;
}
```

wrapActionCreators.ts
```
function bindActionCreator(actionCreator: any, dispatch: any) {
  return () => dispatch(actionCreator.apply(undefined, arguments));
}

function bindActionCreators(actionCreators: any, dispatch: any) {
  if (typeof actionCreators === 'function') {
    return bindActionCreator(actionCreators, dispatch);
  }

  if (typeof actionCreators !== 'object' || actionCreators === null) {
    throw new Error(
      'bindActionCreators expected an object or a function, instead received ' +
        (actionCreators === null ? 'null' : typeof actionCreators) +
        '. ' +
        'Did you write "import ActionCreators from" instead of "import * as ActionCreators from"?',
    );
  }

  const keys = Object.keys(actionCreators);
  const boundActionCreators: any = {};
  keys.forEach(actionKey => {
    const tempActionCreator = actionCreators[actionKey];
    if (typeof tempActionCreator === 'function') {
      boundActionCreators[actionKey] = bindActionCreator(
        tempActionCreator,
        dispatch,
      );
    }
  });

  return boundActionCreators;
}

export default function wrapActionCreators(actionCreators: any) {
  return (dispatch: any) => bindActionCreators(actionCreators, dispatch);
}
```

connect.ts
```
import shallowEqual from './shallowEqual';
import warning from './warning';
import wrapActionCreators from './wrapActionCreators';

const defaultMapStateToProps = (state: object) => {
  console.log(state);
  return {};
};
const defaultMapDispatchToProps = (dispatch: any) => ({ dispatch });

export default function connect(mapStateToProps: any, mapDispatchToProps: any) {
  const shouldSubscribe = Boolean(mapStateToProps);
  const mapState = mapStateToProps || defaultMapStateToProps;
  const app = getApp();

  let mapDispatch: any;
  if (typeof mapDispatchToProps === 'function') {
    mapDispatch = mapDispatchToProps;
  } else if (!mapDispatchToProps) {
    mapDispatch = defaultMapDispatchToProps;
  } else {
    mapDispatch = wrapActionCreators(mapDispatchToProps);
  }

  return function wrapWithConnect(pageConfig: any) {
    function handleChange(this: any, options: any) {
      if (!this.unsubscribe) {
        return;
      }

      const state = this.store.getState();
      const mappedState = mapState(state, options);
      if (!this.data || shallowEqual(this.data, mappedState)) {
        return;
      }
      this.setData(mappedState);
    }

    let { onLoad: pageConfigOnLoad, onUnload: pageConfigOnUnload } = pageConfig;

    // 支持 Component 使用
    if (pageConfig.type === 'Component') {
      pageConfigOnLoad = pageConfig.attached;
      pageConfigOnUnload = pageConfig.detached;
    }

    function onLoad(this: any, options: any) {
      this.store = app.store;
      if (!this.store) {
        warning('Store对象不存在!');
      }
      if (shouldSubscribe) {
        this.unsubscribe = this.store.subscribe(
          handleChange.bind(this, options),
        );
        handleChange.call(this, options);
      }
      if (typeof pageConfigOnLoad === 'function') {
        pageConfigOnLoad.call(this, options);
      }
    }

    function onUnload(this: any) {
      if (typeof pageConfigOnUnload === 'function') {
        pageConfigOnUnload.call(this);
      }
      if (typeof this.unsubscribe === 'function') {
        this.unsubscribe();
      }
    }

    // 支持 Component 使用
    if (pageConfig.type === 'Component') {
      return Object.assign(
        {},
        pageConfig,
        {
          methods: {
            ...pageConfig.methods,
            ...mapDispatch(app.store.dispatch),
          },
        },
        {
          attached: onLoad,
          detached: onUnload,
        },
      );
    } else {
      return Object.assign({}, pageConfig, mapDispatch(app.store.dispatch), {
        onLoad,
        onUnload,
      });
    }
  };
}
```

Provider.ts
```
import warning from './warning';

function checkStoreShape(store: object) {
  const missingMethods = ['subscribe', 'dispatch', 'getState'].filter(
    m => !store.hasOwnProperty(m),
  );

  if (missingMethods.length > 0) {
    warning(
      'Store 似乎不是一个合法的 Redux Store对象: ' +
        '缺少这些方法: ' +
        missingMethods.join(', ') +
        '。',
    );
  }
}

export default function Provider(store: object) {
  checkStoreShape(store);
  return (appConfig: object) => Object.assign({}, appConfig, { store });
}
```

config.ts
```
export default {
  requestUrl: 'http://127.0.0.1:8888',
  pollInterval: 3000,
};
```

createApolloClient.ts
```
import ApolloClient, {
  createNetworkInterface,
  ObservableQuery,
  WatchQueryOptions,
} from 'apollo-client';
import config from './config';

interface CustomClient extends ApolloClient {
  allQueryWatchers?: Set<ObservableQuery<{}>>;
  watchQueryStart?: (options: WatchQueryOptions) => ObservableQuery<{}>;
}

// 封装通用 fetch，gql 返回类型就是 any
export const query = (input: any) => {
  return new Promise(resolve => {
    wx.request({
      ...input,
      data: {
        query: input.query.loc.source.body, // 获取查询语句字符串
        variables: input.variables || {},
      },
      method: 'POST',
      header: {
        cookie: getApp().globalData.cookie,
      },
      fail: res => {
        throw res;
      },
      success: res => {
        resolve(res.data);
      },
      url: `${config.requestUrl}/graphql`,
    });
  });
};

const client: CustomClient = new ApolloClient({
  networkInterface: {
    ...createNetworkInterface({
      opts: {
        credentials: 'include',
      },
      uri: `${config.requestUrl}/graphql`,
    }),
    query,
  },
  queryDeduplication: true,
  addTypename: false,
  reduxRootSelector: state => state.apollo,
});

export default function createApolloClient() {
  client.allQueryWatchers = new Set();
  // 封装通用 watchQuery，具有统一的轮询间隔
  client.watchQueryStart = function(options: WatchQueryOptions) {
    const queryWatcher = client.watchQuery(options);
    queryWatcher.startPolling(config.pollInterval);
    if (this.allQueryWatchers) {
      this.allQueryWatchers.add(queryWatcher);
    }
    return queryWatcher;
  };
  return client;
}
```

发起 query 的示例如下：

```
import gql from 'graphql-tag';

const products = gql`
  query Products {
    products {
      id
      name
      description
      amount
      code
      lectures {
        type
        lecture {
          ... on Live {
            __typename
            id
            name
            startDate
            endDate
          }
        }
      }
    }
  }
`;
export default products;
```

```
import productsQuery from '../../graphql/products';

const pageConfig: wx.PageParam = {
    onLoad() {
        app.globalData.apolloClient.query({
            query: productsQuery,
        });
    },
    ...
};

const mapStateToData = (state: any) => {
  const pagesInstance = getCurrentPages();
  let products: ProductType[] = [];

  pagesInstance.forEach(page => {
    // 通过路由判断找到当前 Page 实例，这样可以获取到当前页面的 data、options 等信息
    if (page.route === 'pages/home/home') {
      const data: ProductsType =
        state.apollo.data.ROOT_QUERY && state.apollo.data.ROOT_QUERY[`products`]
          ? app.globalData.apolloClient.readQuery({
              query: productsQuery,
            })
          : [];

      if (data.products) {
        products = data.products.map(product => {...});
      }
    }
  });

  return {
    products,
  };
};

const nextPageConfig = connect(mapStateToData, undefined)(pageConfig);
Page(nextPageConfig);
```

发起 mutation 的示例如下：

```
import gql from 'graphql-tag';

const createActivityRecord = gql`
  mutation CreateActivityRecord(
    $input: ActivityRecordInput!
    $byOrder: Boolean
  ) {
    createActivityRecord(input: $input, byOrder: $byOrder) {
      id
      product {
        id
        name
      }
    }
  }
`;

export default createActivityRecord;
```

```
app.globalData.query({
    query: createActivityRecord,
    variables: {
        input: {
            activityId: this.data.activityId,
            productId: this.data.productId,
            ownerId: this.data.ownerId,
        },
        byOrder: false,
    },
}).then((res: any) => {
    if (res.data.errors) {
        wx.showToast({
        title: '操作失败',
        icon: 'none',
        });
    } else {
        this.sendFlowerSuccess();
    }
});
```

## 登录、授权

因为调用后台的请求都需要带着 cookie，所以一定是先执行登录逻辑。在 app.ts 的 onLaunch 方法中，执行 wx.login 拿到 code 再调用后台的登录方法，登录成功后保存 cookie，查询用户信息 viewer，再进行获取用户信息授权的操作，获取用户信息后调用后台方法记录到数据库。

```
import { setCookie } from './actions/cookie';
import { LocationParam, updateLocation } from './actions/router';
import { setUserInfo } from './actions/userInfo';
import config from './config';
import configureStore from './configureStore';
import { query } from './createApolloClient';
import updateOwnerInfo from './graphql/updateOwnerInfo';
import viewer from './graphql/viewer';
import Provider from './utils/Provider';

const configuredStore = configureStore();

const appConfig: wx.AppParam = {
  getUserInfo() {
    wx.getUserInfo({
      fail: () => {
        this.globalData.authorized = false;
        wx.redirectTo({
          url: '/pages/authorize/authorize',
        });
      },
      success: res => {
        this.saveUserInfo(res.userInfo);
        // 后台保存用户信息
        query({
          query: updateOwnerInfo,
          variables: {
            input: {
              wxInfo: res.userInfo,
            },
          },
        });
      },
      withCredentials: true,
    });
  },
  saveUserInfo(userInfo: wx.UserInfo) {
    this.globalData.authorized = true;
    configuredStore.store.dispatch(setUserInfo(userInfo));
  },
  onLaunch() {
    wx.showLoading({
      title: '加载中',
      mask: true,
    });
    // 登录
    wx.login({
      success: res => {
        if (res.code) {
          wx.request({
            url: `${config.requestUrl}/api/login`,
            data: {
              code: res.code,
            },
            method: 'POST',
            success: (requestRes: any) => {
              console.log('登录成功===', requestRes);
              const cookie = requestRes.data.cookie || '';
              this.globalData.cookie = cookie;
              configuredStore.apolloClient.query({
                query: viewer,
              });
              configuredStore.store.dispatch(setCookie(cookie));
              wx.hideLoading();
              // 授权，放着这里是因为获取用户信息后需要同步到后端，需要 cookie
              this.getUserInfo();
            },
          });
        } else {
          console.log('登录失败===', res);
        }
      },
    });
    // 记录屏幕宽度
    this.globalData.windowWidth = wx.getSystemInfoSync().windowWidth;
  },
  onHide() {
    // 小程序退到后台时触发
    // configuredStore.persistStore();
  },
  onLocationChange(param: LocationParam) {
    configuredStore.store.dispatch(updateLocation(param));
  },
  globalData: {
    authorized: false,
    cookie: '',
    apolloClient: configuredStore.apolloClient,
    query,
    persistStore: configuredStore.persistStore,
    store: configuredStore.store,
  },
};

App(Provider(configuredStore.store)(appConfig));
```

但是这里存在一个问题，常见的出现时机是在分享出去的页面，虽然也会先进入 app.ts 文件，但是这里的 login 还没有返回就执行了其它 Page 页面的网络请求，这些网络请求就会报没有权限，而在 login 成功后有了 cookie，也没有办法触发重新发起网络请求。正常的思路应该是等待 app.ts 中初始化的一系列操作完成后再进入其它 Page 页面，但是目前无法达到这个效果，小程序社区中也有人提出相同的疑惑。目前只能在分享出去的页面中发起网络请求的地方进行统一的 cookie 验证，如果没有登录则先进行登录，但是可能存在进行两次 login 请求的问题。

## 分享

关于分享的逻辑参考[官方文档](https://developers.weixin.qq.com/miniprogram/dev/api/share.html#onshareappmessageoptions)就可以，经过试验结论如下：withShareTicket 参数，只有在分享到一个群时（非个人、非多个群），在 success 回调中才可以获取到 shareTickets 值，经过 wx.getShareInfo 及解密的处理可以拿到群对当前小程序的唯一 ID，wxml 中使用 `<open-data type="groupName" open-gid="xxxxxx" />` 可展示群名称。如果想进行任意的分享及打开分享时能进行关联关系的绑定，还是需要使用 path 中传入参数的形式，自己制定参数规则进行处理。

目前小程序无法直接分享到朋友圈，社区中有提供方案在后端生成小程序码，返回图片给前端，用户自己将图片保存到相册，然后自己在朋友圈转发。但是，社区中也有描述因诱导分享朋友圈审核不通过的。

## 支付

先请求后台创建订单，拿着订单 ID 获取支付参数，然后再执行 `wx.requestPayment` 发起支付。

```
// 创建订单
app.globalData.query({
    query: createOrderMutation,
    variables,
}).then((createOrderRes: any) => {
    if (createOrderRes.errors) {
        wx.showToast({
            title: '创建订单失败',
            icon: 'none',
        });
    } else {
        // 获取支付参数
        wx.request({
            url: `${config.requestUrl}/api/beecloud/forward`,
            data: {
              bill_no: createOrderRes.data.createOrder.id,
            },
            header: {
              cookie: app.globalData.cookie,
            },
            method: 'POST',
            success: (requestRes: any) => {
                // 发起支付
                wx.hideLoading();
                wx.requestPayment({
                    timeStamp: requestRes.data.timestamp,
                    nonceStr: requestRes.data.nonce_str,
                    package: requestRes.data.package,
                    signType: requestRes.data.sign_type,
                    paySign: requestRes.data.pay_sign,
                    success: () => {
                        // 支付成功后的操作
                        ...
                    },
                });
            },
        });
    }
}).catch((createOrderError: any) => {
    throw createOrderError;
});
```

## 音频（待优化）

音频播放是自己封装了 Component，传入参数进行展示，如是否播放中、当前播放进度、总时长，主要是样式的封装，在播放音频的地方调用[背景音频播放管理 api](https://developers.weixin.qq.com/miniprogram/dev/api/getBackgroundAudioManager.html) 进行播放，在各种回调的方法中更新参数。需要注意的是 title 参数必须设置，否则 ios 会报错。

```
Page({
    onLoad() {
        this.backgroundAudioManager = wx.getBackgroundAudioManager();
        this.backgroundAudioManager.onPlay(() => {...});
        this.backgroundAudioManager.onPause(() => {...});
        this.backgroundAudioManager.onEnded(() => {...});
        this.backgroundAudioManager.onStop(() => {...});
        this.backgroundAudioManager.onTimeUpdate(() => {...});
    },
    handleVoicePlay(this: PageData, e: PageCustomEvent) {
        // title 必须设置，否则 ios 会报错
        this.backgroundAudioManager.title = '标题';
        this.backgroundAudioManager.coverImgUrl = '图片 url';
        this.backgroundAudioManager.src = e.target.dataset.src;
        this.backgroundAudioManager.startTime = 0;
    },
    handleVoicePause(this: PageData) {
        this.backgroundAudioManager.stop();
    },
    handleVoiceSeek(this: PageData, e: PageCustomEvent) {
        this.backgroundAudioManager.seek(e.detail.value);
    },
})
```

## 视频

视频播放如无特殊要求，使用官方提供的 video 组件即可。但是注意“请勿在 scroll-view、swiper、picker-view、movable-view 中使用 video 组件”，这些情况下样式会有较严重的问题。也可以在这些情况下使用一张预览图占位显示视频，点击后跳转到一个新页面使用 video 播放视频。

## 集成 Lodash

`yarn add lodash-es`
`yarn add -D @types/lodash-es`

import debounce from 'lodash-es/debounce';
...

在使用的地方局部引用即可。在使用 debounce 方法时，会报下图所示的错误。原因是小程序没有全局的 window 对象，但查看源码只要有全局 self、global 之一即可，通过 console 输出看到小程序有 global 对象，因此在 app.ts 中添加如下代码，之后就可以正常使用 lodash 了。

```
// 全局 global 处理，lodash 中使用了 global
Object.assign(global, {
    Array,
    Date,
    Error,
    Function,
    Math,
    Object,
    RegExp,
    String,
    TypeError,
    setTimeout,
    clearTimeout,
    setInterval,
    clearInterval,
});

App({...});
```

{% img https://zhulichao.github.io/2018/03/16/wechat-base/lodash.png 使用 lodash 报错 %}