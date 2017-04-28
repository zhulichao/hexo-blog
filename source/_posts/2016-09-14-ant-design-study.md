---
title: Ant Design 组件学习经验
layout: post
date: 2016-09-14 14:39:06
categories: Ant Design
tags: Ant Design
---

---
## Tree组件

参考 [TreeSelect](https://ant.design/components/tree-select/)

### 异步加载数据

使用redux时，TreeSelect异步加载数据需要通过触发action调用后台获取数据，根据reducer更新的state显示出加载的数据。需添加loadData属性，值为一个方法，如onLoadData，内容如下。
这个函数的返回值好像必须是一个Promise对象，如果不这么写，会报`Uncaught TypeError: Cannot read property 'then' of undefined(…)`。

```
onLoadData(treeNode) {
    return new Promise((resolve) => {
        // 树形显示的数据在this.state.treeData中，在this.state.treeData中找到当前操作节点
        const pathArr = treeNode.props.pos.split('-');
        let findTreeNode = null;
        for (let i=1,len=pathArr.length; i < len ; i++) {
            if( i === 1){
                findTreeNode = this.state.treeData[pathArr[i]];
            } else {
                findTreeNode = findTreeNode.children[pathArr[i]];
            }
        }
        // 如果该节点没有子节点，表示没加载过其子节点，进行加载
        if (findTreeNode.children.length <= 0) {
            // 设置展开的节点为当前节点
            this.state.openKey = treeNode.props.eventKey;
            // 组织后台查询条件
            const queryData = {
                LEVEL: 1, // TODO  不知道什么规则
                _extWhere: this.state.queryData._extWhere,
                PID: treeNode.props.eventKey,
                NAME: treeNode.props.title,
                checkstate: ''
            }
            const dict = {
                dictId: this.state.dictId,
                dictData: this.props.dict.dictData
            }
            // 发起action，获取数据
            this.props.updataDictByPid(this.props.servId, this.props.itemCode, objectUtils.clone(dict), queryData, this.props.servType, this.props.opeCode, this.props.queryServId);
        }
        resolve();
        });
    }
```

---
## Form组件(待完成)

参考 [Form](https://ant.design/components/form/) 和 [rc-form](http://react-component.github.io/form/)

### 使用mapPropsToFields和onFieldsChange的校验问题

Form组件如下方式使用，获取不到校验信息了，浏览器的控制台会有打印的校验结果，但没有反映在页面上，但如果不使用mapPropsToFields是好使的。
```
// 必填校验
const validateArray = [{
    rules: [{
        required: true,
        message: '邮箱必填'
    }],
    trigger: ['onChange']
}];

let fieldPropsOptions = {
    validate: validateArray
};
...
<FormItem
    label="email"
    validateStatus={getFieldError('email') ? 'success' : 'error'}
    help={isFieldValidating('email') ? '' : errMessage}
>
    <Input {...getFieldProps('email', fieldPropsOptions)} />;
</FormItem>
...
NewForm = Form.create({onFieldsChange, mapPropsToFields})(NewForm);
```

解决方法是调用Form组件是传入一个props及更新该props的方法，如formErrItem、updateFormErrItem，在onFieldsChange中添加
```
function onFieldsChange(props, fields){
    // 调用父组件更新formErrItem的方法
    const newFormErrItem = {
        ...props.formErrItem,
        ...fields,
    };
    props.updateFormErrItem(newFormErrItem);
    ...
}
```
在Form组件中通过，this.props.formErrItem可获取校验信息。

### ref引用

在使用Form组件时，在Form.create时需要添加`withRef: true`才能获取到组件内部定义的方法或state。

```
// MyForm.jsx中，定义了 MyForm 组件，是对Form组件的封装，返回的是antd的Form组件。
class MyForm extends Component {
    render() {
        return <Form />;
    }
}
MyForm = Form.create({onFieldsChange, mapPropsToFields, withRef: true})(MyForm);
export default MyForm;
// App.jsx中，引用了MyForm组件，如果要引用到MyForm组件内部定义的方法或state，需要使用如下方式。
class App extends Component {
    clickHandler() {
        // 引用MyForm组件中定义的方法或state
        const formRef = this.refs.myForm.refs.wrappedComponent.refs.formWrappedComponent;
    }
    render() {
        return (
            <div>
                <MyForm ref="myForm" />
                <Button onClick={this.clickHandler.bind(this)}>点击</Button>
            </div>
        );
    }
}

```

---
## Table组件

参考 [Table](https://ant.design/components/table/)

### 单选

如果Table组件中要进行单选，需要进行如下配置：

- 将Table组件rowSelection属性的type值设置为radio，当前选中的数据由radioIndex控制
- 注意，ant-design的Table组件，对于单选类型的，无法自己管理radioIndex值，如果想要自己管理radioIndex值，需要在Table组件中添加如下代码
```
if (('radioIndex' in nextProps) && nextProps.radioIndex !== null ) {
    this.setState({
        radioIndex: nextProps.radioIndex || null
    });
}
```

### 行样式

Table组件的rowClassName属性，如：`rowClassName={(record, index) => record['_delete_'] ? 'ant-table-row-delete' : '' }`

### 不显示页码

Table组件的pagination属性为false

### pagination
pagination.pageSize不为10、20、30、40中的值时，分页处显示的只有一个值，如15，而不是像10 条/页这样
需要给Table组件传入的pagination中有自定义的pageSizeOptions属性，该属性的值为所有需要显示的每页条数的数组

### 列表勾选行样式问题

在勾选列表行的checkbox或是列表可编辑的下拉框时，点击所在的行会发生颜色抖动，直接运行官方例子也有这个问题。后来发现可能是Chrome浏览器的问题，如果用360浏览器就不会有这个问题。很奇怪！