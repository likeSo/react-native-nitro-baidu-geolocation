# react-native-nitro-baidu-geolocation

react-native-nitro-baidu-geolocation 是一款基于Nitro的百度定位插件。

[![Version](https://img.shields.io/npm/v/react-native-nitro-baidu-geolocation.svg)](https://www.npmjs.com/package/react-native-nitro-baidu-geolocation)
[![Downloads](https://img.shields.io/npm/dm/react-native-nitro-baidu-geolocation.svg)](https://www.npmjs.com/package/react-native-nitro-baidu-geolocation)
[![License](https://img.shields.io/npm/l/react-native-nitro-baidu-geolocation.svg)](https://github.com/patrickkabwe/react-native-nitro-baidu-geolocation/LICENSE)

## Requirements

- React Native v0.76.0+
- Node 18.0.0+

## 安装

```sh
npm install react-native-nitro-baidu-geolocation react-native-nitro-modules
```

## 配置

在安卓清单的`application`节点下，添加`meta-data`字段，存放百度的授权AK：

```xml
<meta-data
    android:name="com.baidu.lbsapi.API_KEY"
    android:value="内容替换为你的AK" >
</meta-data>
```

## 使用

```typescript
import { NitroBaiduGeolocation } from 'react-native-nitro-baidu-geolocation';

/// 接受隐私协议。国内市场中，在用户接受隐私协议的时候调用该方法。务必在初始化之前调用，否则不会生效。
NitroBaiduGeolocation。agreePrivacyPolicy(true)

/// 初始化SDK，初始化定位插件实例
await NitroBaiduGeolocation.initialize(ak)

/// 拿到当前定位，一次定位
await NitroBaiduGeolocation.getCurrentLocation({})
```


## 待办事项

- [ ] 持续定位


## 联系我

请进QQ群交流：682911244

