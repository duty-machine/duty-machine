# archives

这是一套使用github actions抓取文章保存成issue的组件。

使用方法：
1. 新建一个issue，标题需为`request_index`，内容为要收录的文章网址，目前只支持matters.news。
2. 【推荐】fork到自己仓库，在设置里打开issue功能，并启用github actions，然后按上述操作。
3. 使用 https://duty-machine-panel.herokuapp.com 进行提交，初次使用可能需要等一段时间。

提交完成后等待一分钟左右即可抓取完毕，也可以在actions中查看实时进度，如有问题可以使用`bug`标签提交issue。
