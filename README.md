gfwlist2routeos
===============

把伟大的GFWLIST转化写进RouterOS

## 这个项目的产生场景如下：

* 你有一个文本文件，里面一行是一个被墙了的域名
* 然后打开vpn，开始运行这个脚本
* 解析这些域名为ip
* 将这些ip放到/ip/route/rule下面，操作为使用名为`gfwlist`的路由表
* 如果你不想维护一个被墙了的域名的列表，你也可以使用著名的[gfwlist](https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt)做为输入。

## 所以项目仍然存在一些问题

* gfwlist 中包含一些通配符规则，如 *.google.com.* 之类的，该项目无法识别

## 安装方法

* 你的routeOS版本至少是3.0
* 安装[nodejs](http://nodejs.org/)运行环境
* sudo npm install gfwlist2routeros -g 如果是windows的话则为 npm install gfwlist2routeros -g
* 在routeros里确保/ip/service/api为enable的状态

## 使用方法

* gfwlist2routeros --host ROUTEROS的IP --username 用户名 --password 密码  (使用下载的gfwlist作为输入)
* gfwlist2routeros --host ROUTEROS的IP --username 用户名 --password 密码  --file 指定文件路径 （使用指定文件作为输入）

所以我也推荐你另外一个项目，供你衡量一下哪一个更适合你的需求

[Freedom-routes](https://github.com/GutenYe/freedom-routes)

该项目从APNIC数据库中下载按国别标示的IP地址分配数据，然后提取所有中国的IP段，写入路由（也支持routerOS），换言之，即，对所有的外国网站都使用vpn，好处是，绝对不会漏过一个被墙的，坏处是，对于许多没有被墙的外国网站，也使用vpn流量

安装和使用方法见 https://github.com/GutenYe/freedom-routes
