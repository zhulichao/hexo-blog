---
title: styled-components
layout: post
date: 2019-12-11 15:51:36
categories: React
tags: React
---

## 介绍

[styled-components](https://www.styled-components.com/) 是一个针对 React 的 css in js 类库。和所有同类型的类库一样，通过 js 赋能解决了原生 css 所不具备的能力，比如变量、循环、函数等。解决了 css 全局命名空间，避免样式冲突的问题，维护起来更加方便。

## 优点

- 贯彻 React 的 everything in JS 理念，降低 js 对 css 文件的依赖
- 保留前端开发 CSS 书写习惯，无学习和迁移成本
- 使用方便，不需要配置 webpack，开箱即用
- 不用再担心样式命名的问题，移除样式与组件之间的对应关系
- 样式可以使用变量，更加灵活
- 组件的逻辑、生命周期、样式、结构完全和其它组件解耦，对组件维护很有帮助

## 缺点

- 可读性差，不方便直接看出组件的 html 元素

## 开发环境

### IDE 插件

VSCode 插件 vscode-styled-components

### Babel 配置

```js
...
"plugins": [
    [
      "babel-plugin-styled-components",
      {
        "ssr": true,
        "displayName": true,
        "fileName": false,
        "preprocess": false
      }
    ]
  ],
...
```

### stylelint 配置

```js
...
"processors": [
  "stylelint-processor-styled-components"
],
"extends": [
  "stylelint-config-recommended",
  "stylelint-config-styled-components"
],
...
```

## 使用

```js
const Button = styled.button`
  background: ${props => props.primary ? "blue" : "white"};
`;

render(
  <div>
    <Button>Normal</Button>
    <Button primary>Primary</Button>
  </div>
);
```

```js
const Button = styled.button`
  color: blue;
  border-radius: 3px;
`;

const TomatoButton = styled(Button)`
  color: tomato;
`;
```

```js
const Button = styled.button`
  display: inline-block;
  color: blue;
  font-size: 1em;
`;
const TomatoButton = styled(Button)`
  color: tomato;
`;

render(
  <div>
    <Button>Normal Button</Button>
    <Button as="a" href="/">Link with Button styles</Button>
    <Button as={TomatoButton}>Custom Button with Normal Button styles</Button>
  </div>
);
```

```js
const Thing = styled.div`
  color: blue;
  &:hover {
    color: red;
  }
  & ~ & {
    background: yellow; // <Thing> as a sibling of <Thing>, but maybe not directly next to it
  }
  & + & {
    background: green; // <Thing> next to <Thing>
  }
  &.something {
    background: orange; // <Thing> tagged with an additional CSS class ".something"
  }
  .other-thing {
    background: blue; // CSS class ".other-thing" inner <Thing>
  }
  .something-else & {
    background: red; // <Thing> inside another element labeled ".something-else"
  }
`
render(
  <React.Fragment>
    <Thing>Hello world!</Thing>
    <Thing>green</Thing>
    <Thing className="something">orange</Thing>
    <Thing>
      <div className="other-thing">blue</div>
    </Thing>
    <div>Pretty nice day today.</div>
    <Thing>yellow</Thing>
    <div className="something-else">
      <Thing>red</Thing>
    </div>
  </React.Fragment>
)
```

```js
const Input = styled.input.attrs(props => ({
  // we can define static props
  type: "password",
  // or we can define dynamic ones
  size: props.size || "1em",
}))`
  font-size: 1em;
  margin: ${props => props.size};
  padding: ${props => props.size};
`;

render(
  <div>
    <Input placeholder="A small text input" />
    <br />
    <Input placeholder="A bigger text input" size="2em" />
  </div>
);
```

```js
const rotate = keyframes`
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
`;
const Rotate = styled.div`
  display: inline-block;
  animation: ${rotate} 2s linear infinite;
`;

render(
  <Rotate>&lt; 💅 &gt;</Rotate>
);
```

```js
const Button = styled.button`
  color: ${props => props.theme.fg};
  border: 2px solid ${props => props.theme.fg};
  background: ${props => props.theme.bg};
`;
Button.defaultProps = {
  theme: {
    fg: "mediumseagreen"
    bg: "white",
  }
};
const theme = {
  fg: "palevioletred",
  bg: "white"
};
const invertTheme = ({ fg, bg }) => ({
  fg: bg,
  bg: fg
});

render(
  <div>
    <Button>mediumseagreen</Button>
    <ThemeProvider theme={theme}>
      <div>
        <Button>Default Theme</Button>
        <ThemeProvider theme={invertTheme}>
          <Button>Inverted Theme</Button>
        </ThemeProvider>
      </div>
    </ThemeProvider>
  </div>
);
```

```js
import { withTheme } from 'styled-components';

class MyComponent extends React.Component {
  render() {
    console.log('Current theme: ', this.props.theme);
    // ...
  }
}

export default withTheme(MyComponent);
```

```js
import { useContext } from 'react';
import { ThemeContext } from 'styled-components';

const MyComponent = () => {
  const themeContext = useContext(ThemeContext);

  console.log('Current theme: ', themeContext);
  // ...
}
```

```js
const Button = styled.button`
  color: ${props => props.theme.main};
`;
const theme = {
  main: "mediumseagreen"
};
render(
  <div>
    <Button theme={{ main: "royalblue" }}>royalblue</Button>
    <ThemeProvider theme={theme}>
      <div>
        <Button>mediumseagreen</Button>
        <Button theme={{ main: "darkorange" }}>darkorange</Button>
      </div>
    </ThemeProvider>
  </div>
);
```
