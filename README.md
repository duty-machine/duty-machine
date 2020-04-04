## 简介

这是一个使用github issue为网路上的文章存档的工具，可以将文章转为issue进行持久保存。文章的抓取使用github actions实现。

目前已进行适配的网站，其他网站会尝试抓取`<article>`标签内容：
* matters.news
* telegra.ph
* chinadigitaltimes.net
* mp.weixin.qq.com

已抓取的文章可见 https://github.com/duty-machine/archives/issues?q=label%3Afetched+is%3Aclosed .

## 使用方法
有三种方式：
1. 直接在本仓库新建一个issue，使用`请求抓取`模板，并在内容中写入要抓取的网址。
2. fork到自己仓库，在设置里打开issue功能，并启用github actions，然后按上述新建issue。
3. 使用 https://duty-machine-panel.herokuapp.com 进行提交，可匿名进行。

提交完成后等待数分钟即可完成抓取，也可以在actions中查看实时进度。

## 问题反馈及建议
请到这个仓库发送issue： https://github.com/duty-machine/discuss 。
