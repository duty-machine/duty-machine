## 简介

这是一个使用github issue为网路上的文章存档的工具，可以将文章转为issue进行持久保存。文章的抓取使用github actions实现。抓取效果见https://github.com/duty-machine/archives/issues?q=label%3Afetched+is%3Aclosed 。

请使用 https://archives.duty-machine.now.sh/ 匿名提交想要抓取的页面。此网页由 https://vercel.com 托管，部署记录已公开，在最新的commit下可看到now机器人提供的部署信息。在 https://vercel.com/duty-machine/archives/版本号 可检查当前版本源码。

提交完成后等待数分钟即可完成抓取，也可以在actions中查看实时进度。

目前已进行适配的网站，其他网站会尝试抓取`<article>`标签内容：
* matters.news
* telegra.ph
* chinadigitaltimes.net
* mp.weixin.qq.com

## fork指南

此项目可以fork到自己仓库使用，以下是操作步骤：
1. fork
2. 启用Issues功能。在项目的Settings - Features下勾选Issues并保存。
3. 启用Github Action功能。在Actions标签卡下按提示操作。
4. 在 https://vercel.com/ 注册账号，并添加一个github integration。
5. 在vercel的配置里添加两个环境变量：
```
TOKEN: 你的github api token，需要有repo权限。
REPO: fork后的repo名，格式如 'duty-machine/archives'。
```
6. 在vercel的build histories里点击redeploy，使配置的环境变量生效。

## 问题反馈及建议
请到这个仓库发送issue： https://github.com/duty-machine/discuss 。
