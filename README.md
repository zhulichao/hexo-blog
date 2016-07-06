# 使用Hexo以及NexT主题开发的静态博客生成系统

## 常用命令

### new

``` bash
$ hexo new [layout] <title>
```

新建一篇文章。如果没有设置 `layout` 的话，默认使用 [_config.yml](configuration.html) 中的 `default_layout` 参数代替。如果标题包含空格的话，请使用引号括起来。

### generate

``` bash
$ hexo generate
```

生成静态文件。

选项 | 描述
--- | ---
`-d`, `--deploy` | 文件生成后立即部署网站
`-w`, `--watch` | 监视文件变动

### publish

``` bash
$ hexo publish [layout] <filename>
```

发表草稿。

### server

``` bash
$ hexo server
```

启动服务器。默认情况下，访问网址为： `http://localhost:4000/`。

选项 | 描述
--- | ---
`-p`, `--port` | 重设端口
`-s`, `--static` | 只使用静态文件
`-l`, `--log` | 启动日记记录，使用覆盖记录格式

### deploy

``` bash
$ hexo deploy
```

部署网站。

参数 | 描述
--- | ---
`-g`, `--generate` | 部署之前预先生成静态文件


## 相关文档

[Hexo中文主站](https://hexo.io/zh-cn/)
[NexT官方主站](http://theme-next.iissnan.com/)
