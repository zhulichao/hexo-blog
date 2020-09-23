---
title: Commander.js-demo
layout: post
date: 2020-07-24 10:25:33
categories: Project Base
tags: Project Base
---

```js
#!/usr/bin/env node

const commander = require('commander');
const inquirer = require('inquirer');
const ora = require('ora');
const chalk = require('chalk');
const symbols = require('log-symbols');

const packageJson = require('./package.json');
const spinner = ora('正在下载模板...');

// 命令
const program = new commander.Command(packageJson.name)
  .version(packageJson.version)
  .arguments('<name>')
  .action((name) => {
    // 问题
    inquirer
      .prompt([
        {
          type: 'input',
          name: 'description',
          message: '请输入项目描述',
        },
        {
          type: 'input',
          name: 'author',
          message: '请输入作者名称',
        },
      ])
      .then((answers) => {
        // 显示下载中
        spinner.start();
        setTimeout(() => {
          spinner.succeed();
          console.log(symbols.success, name + '下载完成');
          console.log('问题答案：', symbols.info, answers);
          console.log('--verbose 参数：', program.verbose);
          console.log('--info 参数：', program.info);
          console.log('--use-npm 参数', program.useNpm);
        }, 5000);
      });
  })
  .option('--verbose', 'print additional logs')
  .option('--info', 'print environment debug info')
  .option('--use-npm')
  .allowUnknownOption()
  .usage(`${chalk.green('<name>')} [options]`)
  .on('--help', () => {
    console.log(
      `  If you have any problems, do not hesitate to file an issue.`
    );
  })
  .parse(process.argv);
```

{% img /2020/07/24/commander-demo/commander.png 效果图 %}
