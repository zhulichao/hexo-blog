---
title: JSDoc-修改模板
layout: post
date: 2020-08-06 10:43:33
categories: JavaScript
tags: JavaScript
---

JSDoc 无法修改 Title 名称，显示一直为 Home，无法解析方法返回值的对象结构，可以通过修改模板来解决这些问题。

### 自定义模板

复制 /node_modules/jsdoc/templates/default 目录到项目目录下，命令中添加 -t path/to/default 即指定了使用项目下的 default 目录作为模板，这时我们就可以修改模板了。

### 修改 Title 名称

将 default/publish.js 中替换 Home 替换为想要的值即可。

### 解析方法返回值的对象结构

default/tmpl/method.tmpl 文件中

```
// 原内容
<?js if (data.returns && returns.length) { ?>
<h5>Returns:</h5>
<?js if (returns.length > 1) { ?><ul><?js
    returns.forEach(function(r) { ?>
        <li><?js= self.partial('returns.tmpl', r) ?></li>
    <?js });
?></ul><?js } else {
    returns.forEach(function(r) { ?>
        <?js= self.partial('returns.tmpl', r) ?>
    <?js });
} } ?>

// 替换为
<?js if (data.returns && returns.length) { ?>
<h5>Returns:</h5>
<?js= this.partial('params.tmpl', returns) ?>
<?js } ?>
```

default/publish.js 文件中

```js
// 原内容
returnTypesString = util.format(' &rarr; %s{%s}', attribsString, returnTypes.join('|'));

// 替换为
returnTypesString = util.format(' &rarr; %s{%s}', attribsString, returnTypes[0]);
```

添加自定义插件如下

```
exports.handlers = {
  newDoclet: e => {
    // 修改对 return 的解析
    if (e.doclet.returns) {
      e.doclet.returns.forEach(item => {
        if (item.description) {
          const parseArr = item.description.split(' - ');
          if (parseArr.length > 1) {
            item.description = parseArr[1];
            item.name = parseArr[0];
          } else {
            item.description = parseArr[0];
          }
        }
      });
    }
  },
};
```

效果为

```js
/**
  * 返回 viewer.
  * @return {object} viewer - The viewer value.
  * @return {number} viewer.key1 - 描述1
  * @return {string} viewer.key2 - 描述2
  */
static getViewer() {
  return this.viewer;
}
```

{% img /2020/08/06/jsdoc-template/return.png 400 返回对象 %}

## 类名称显示模块路径

default/publish.js 文件中，将 buildMemberNav 方法替换为如下内容

```js
// 替换为
function buildMemberNav(items, itemHeading, itemsSeen, linktoFn) {
  let nav = '';

  if (items.length) {
    let itemsNav = '';
    let pathName = '';
    items.forEach(item => {
      const result = item.comment.match(/@path \{[^\}]+\}/);
      if (result && result[0]) {
        pathName = result[0].replace('@path {', '').replace('}', '');
      }

      let displayName;

      if (!hasOwnProp.call(item, 'longname')) {
        itemsNav += `<li>${linktoFn('', item.name)}</li>`;
      } else if (!hasOwnProp.call(itemsSeen, item.longname)) {
        if (env.conf.templates.default.useLongnameInNav) {
          displayName = item.longname;
        } else if (pathName) {
          displayName = pathName;
        } else {
          displayName = item.name;
        }
        itemsNav += `<li>${linktoFn(
          item.longname,
          displayName.replace(/\b(module|event):/g, '')
        )}</li>`;

        itemsSeen[item.longname] = true;
      }
    });

    if (itemsNav !== '') {
      nav += `<h3>${itemHeading}</h3><ul>${itemsNav}</ul>`;
    }
  }

  return nav;
}
```

效果为

```js
/**
 * 通过火星科技创建地球
 * @hideconstructor
 * @path {EVECesium.App.Viewer}
 */
class Viewer {}
```

{% img /2020/08/06/jsdoc-template/path.png Class显示模块路径 %}
