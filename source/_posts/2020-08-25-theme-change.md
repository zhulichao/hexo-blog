---
title: 主题切换思路
layout: post
date: 2020-08-25 16:42:43
categories: Project Base
tags: Project Base
---

## js 中动态引入样式文件 import()

不能通过 import() 动态引用样式文件来解决主题切换的问题，因为 import 文件后引入的样式会覆盖先引入的样式，如果选择主题1、主题2，再选择主题1是没办法切换回去的。

## :export 实现 CSS、JS变量共享

scss 中导出变量，js 中导入变量。但是 js 中动态改变这个变量的值后无法实现数据双向绑定，dom 不会实时动态渲染。

```scss
$--color-primary: #1890ff;

:export {
  theme: $--color-primary;
}
```

```js
import variables from '@/variables.scss'

console.log(variables.theme);
```

如果要设置主题颜色，可以将从 css 中导出的变量值注入到 js 的全局变量中，需要设置主题颜色的地方，将样式写在 js 中并使用这个全局变量。

```vue
<template>
  <el-menu
    :active-text-color="settings.theme"
  >
  <router-link
    :style="activeStyle(tag)"
  >
</template>

<script>
export default {
  computed: {
    ...mapState(["settings"]),
  },
  methods: {
    activeStyle(tag) {
      if (!this.isActive(tag)) return {};
      return {
        "background-color": this.settings.theme,
        "border-color": this.settings.theme
      };
    },
},
}
</script>
```

## js 动态改变 css 的变量

设定 css 可以直接读取的参数，注意变量名前面要加两根连词线，这是 css 的规则。

```js
document.getElementsByTagName('body')[0].style.setProperty('--参数名','值');
```

css 中读取参数

```css
$--color-primary: var(--参数名);
```

## js 改变主 html 元素上的类

js 中修改主 html 元素上的类名，css 中不同类名下定义相同的变量，取不同的颜色值，页面元素使用变量。

```js
// name 为 blue 或 red
document.documentElement.className = 'theme-' + name;
```

```css
.theme-blue {
  --color: blue;
  --background-color: red;
}

.theme-red {
  --color: red;
  --background-color: blue;
}

.item {
  color: var(--color);
  background-color: var(--background-color);
}
```

## data-theme 多套主题配色方案

html 根标签设置一个 data-theme 属性，然后通过 js 切换 data-theme 的属性值，SCSS 根据此属性来判断使用对应主题变量。

```scss
$themes: (
  red: (
    text-color-primary: #dc2b34,
    bg-color-primary: #d91720,
  ),
  blue: (
    text-color-primary: #78A4FA,
    bg-color-primary: #78A4FA,
  ),
)

@mixin themeify {
  @each $theme-name, $theme-map in $themes {
    $theme-map: $theme-map !global;
    [data-theme=#{$theme-name}] & {
      @content;
    }
  }
}

@function themed($key) {
  @return map-get($theme-map, $key);
}
```

```css
@import './mixin';

.testTheme .item {
  @include themeify {
    color: themed('text-color-primary');
    background-color: themed('bg-color-primary');
  }
}
```

```js
// name 为 blue 或 red
window.document.documentElement.setAttribute('data-theme', name);
```

## 若依方案

[若依管理系统在线演示地址](https://vue.ruoyi.vip/login)

思路是下载 element-ui 的 theme-chalk 样式文件，将其中的主题相关颜色替换成新的颜色值，然后添加到页面的 style 标签上。因为页面中除了 element-ui 还有自己定义的主题样式，再查找一遍所有的 style 标签找到使用主题颜色的标签，替换其中的主题相关颜色值。

```vue
<template>
  <el-color-picker
    v-model="theme"
    :predefine="['#409EFF', '#1890ff', '#304156','#212121','#11a983', '#13c2c2', '#6959CD', '#f5222d', ]"
    class="theme-picker"
    popper-class="theme-picker-dropdown"
  />
</template>

<script>
const version = require('element-ui/package.json').version // element-ui version from node_modules
const ORIGINAL_THEME = '#409EFF' // default color

export default {
  data() {
    return {
      chalk: '', // content of theme-chalk css
      theme: ''
    }
  },
  computed: {
    // store 中的 theme 值
    defaultTheme() {
      return this.$store.state.settings.theme
    }
  },
  watch: {
    // 监听 store 中的 theme 值发生变化，修改 theme 值
    defaultTheme: {
      handler: function(val, oldVal) {
        this.theme = val
      },
      immediate: true
    },
    // 监听 theme 值发生变化
    async theme(val) {
      const oldVal = this.chalk ? this.theme : ORIGINAL_THEME
      if (typeof val !== 'string') return
      const themeCluster = this.getThemeCluster(val.replace('#', ''))
      // 此次改变时，上一次的颜色值，用来替换带有主题颜色值的 style 标签
      const originalCluster = this.getThemeCluster(oldVal.replace('#', ''))

      const $message = this.$message({
        message: '  Compiling the theme',
        customClass: 'theme-message',
        type: 'success',
        duration: 0,
        iconClass: 'el-icon-loading'
      })

      const getHandler = (variable, id) => {
        return () => {
          // 初始化时的主题颜色值，用来修改 element-ui 的 theme-chalk 文件中对应的值，因为每次改变并没有将新的值更新到 this.chalk，所以每次都是用初始值替换新的值
          const originalCluster = this.getThemeCluster(ORIGINAL_THEME.replace('#', ''))
          const newStyle = this.updateStyle(this[variable], originalCluster, themeCluster)

          let styleTag = document.getElementById(id)
          if (!styleTag) {
            styleTag = document.createElement('style')
            styleTag.setAttribute('id', id)
            document.head.appendChild(styleTag)
          }
          styleTag.innerText = newStyle
        }
      }

      // 用 this.chalk 保存下载的 element-ui 的 theme-chalk 样式文件
      if (!this.chalk) {
        const url = `https://unpkg.com/element-ui@${version}/lib/theme-chalk/index.css`
        await this.getCSSString(url, 'chalk')
      }

      const chalkHandler = getHandler('chalk', 'chalk-style')
      // 替换 this.chalk 样式文件中的主题相关颜色值，将新的内容赋给指定的 style 标签
      chalkHandler()
      // 找到页面中带有旧颜色值的 style 标签，替换其中的主题相关颜色值
      const styles = [].slice.call(document.querySelectorAll('style'))
        .filter(style => {
          const text = style.innerText
          return new RegExp(oldVal, 'i').test(text) && !/Chalk Variables/.test(text)
        })
      styles.forEach(style => {
        const { innerText } = style
        if (typeof innerText !== 'string') return
        style.innerText = this.updateStyle(innerText, originalCluster, themeCluster)
      })

      this.$emit('change', val)

      $message.close()
    }
  },

  methods: {
    updateStyle(style, oldCluster, newCluster) {
      let newStyle = style
      oldCluster.forEach((color, index) => {
        newStyle = newStyle.replace(new RegExp(color, 'ig'), newCluster[index])
      })
      return newStyle
    },

    getCSSString(url, variable) {
      return new Promise(resolve => {
        const xhr = new XMLHttpRequest()
        xhr.onreadystatechange = () => {
          if (xhr.readyState === 4 && xhr.status === 200) {
            this[variable] = xhr.responseText.replace(/@font-face{[^}]+}/, '')
            resolve()
          }
        }
        xhr.open('GET', url)
        xhr.send()
      })
    },

    getThemeCluster(theme) {
      const tintColor = (color, tint) => {
        let red = parseInt(color.slice(0, 2), 16)
        let green = parseInt(color.slice(2, 4), 16)
        let blue = parseInt(color.slice(4, 6), 16)

        if (tint === 0) { // when primary color is in its rgb space
          return [red, green, blue].join(',')
        } else {
          red += Math.round(tint * (255 - red))
          green += Math.round(tint * (255 - green))
          blue += Math.round(tint * (255 - blue))

          red = red.toString(16)
          green = green.toString(16)
          blue = blue.toString(16)

          return `#${red}${green}${blue}`
        }
      }

      const shadeColor = (color, shade) => {
        let red = parseInt(color.slice(0, 2), 16)
        let green = parseInt(color.slice(2, 4), 16)
        let blue = parseInt(color.slice(4, 6), 16)

        red = Math.round((1 - shade) * red)
        green = Math.round((1 - shade) * green)
        blue = Math.round((1 - shade) * blue)

        red = red.toString(16)
        green = green.toString(16)
        blue = blue.toString(16)

        return `#${red}${green}${blue}`
      }

      const clusters = [theme]
      for (let i = 0; i <= 9; i++) {
        clusters.push(tintColor(theme, Number((i / 10).toFixed(2))))
      }
      clusters.push(shadeColor(theme, 0.1))
      return clusters
    }
  }
}
</script>

<style>
.theme-message,
.theme-picker-dropdown {
  z-index: 99999 !important;
}

.theme-picker .el-color-picker__trigger {
  height: 26px !important;
  width: 26px !important;
  padding: 2px;
}

.theme-picker-dropdown .el-color-dropdown__link-btn {
  display: none;
}
</style>
```
