### 在React Native中使用flexbox

RN目前主要支持flexbox的如下6个属性：

1.alignItems

用来定义伸缩项目在交叉轴上的对齐方式，语法为：
alignItems:flex-start（默认值） | flex-end | center | stretch

2.alignSelf

用来设置单独的伸缩项目在交叉轴上的对齐方式，会覆盖默认的对齐方式，其语法为：alignSelf:auto | flex-start | flex-end | center | stretch(伸缩项目在交叉轴方向占满伸缩容器，如果交叉轴为垂直方向的话，只有在不设置高度的情况下才能看到效果)

3.flex

是flex-grow flex-shrink flex-basis这三个属性的缩写，其语法为：flex:none | flex-grow flex-shrink flex-basis，其中第二个和第三个参数为可选参数，默认值为：0 1 auto

4.flexDirection

指定主轴的方向 flex-direction:row| row-reverse | column（默认值） | column-reverse

5.flexWrap

伸缩容器在主轴线方向空间不足的情况下，是否换行以及该如何换行
flexWrap:nowrap（默认值） | wrap | wrap-reverse

6.justifyContent

用来定义伸缩项目在主轴线的对齐方式，语法为：
justifyContent:flex-start（默认值） | flex-end | center | space-between | space-around