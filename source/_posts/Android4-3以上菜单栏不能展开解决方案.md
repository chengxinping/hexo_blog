---
title: Android4.3以上菜单栏不能展开解决方案
status: public
date: 2016-07-05 18:42:00
tags: [Android]
categories: 真假
copyright: true
---


<span lang="x-none">Android 4.3</span><span lang="zh-CN">以上</span><span lang="x-none">menu item showAsAction="always"</span><span lang="zh-CN">无效<img src="http://img.blog.csdn.net/20160705184548287" alt="" /></span>

<span lang="zh-CN">效果图</span>

<span lang="zh-CN"><img src="http://img.blog.csdn.net/20160705184621209" alt="" />
</span>
<!-- more -->
<span lang="zh-CN">会发现菜单 无法展开 始终收缩在里面
</span>

解决方法：自定义命名空间

<span lang="en-US">                     </span><span lang="zh-CN">用自定义命名空间来标明</span><span lang="en-US"> showAsAction</span>

<span lang="en-US"><img src="http://img.blog.csdn.net/20160705184632912" alt="" />
</span>

<span lang="en-US">更改后效果图
</span>

<span lang="en-US"><img src="http://img.blog.csdn.net/20160705184642022" alt="" /></span>