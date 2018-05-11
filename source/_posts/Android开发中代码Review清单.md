---
title: Android开发中代码Review清单
date: 2017-10-29 21:33:00
tags: [Android]
categories: 真假
copyright: true
top: 100
---

### 前言 
>  　　本文从互联网上收集以及自己平时的开发过程中提交代码时所有检查点。事实证明，这样做很大程度地提高了代码的质量以及功能的稳定性。因此在这里做个总结，以后提交代码前，都看看这一份Review清单，避免很多错误。

<!--more-->

### 清理操作
1. **页面退出时，是否完成必要的清理工作**
- 是否调用`Handler`的`removeCallbacksAndMessages(null)`来清空`Handler`里的消息；
- 是否取消了还没完成的请求；
- 在页面里注册的监听，是否解除订阅；
- 如果用到观察者模式，是否解除订阅；
- 如果使用了`RxJava`，是否解除订阅；

2. **数据库的游标是否关闭**
这个点一般人都知道，出问题一般在于，没有考虑到多线程并发时的情况下，Cursor没有被释放。所以数据库的操作需要加上同步代码块
详细可参考：http://www.2cto.com/kf/201408/329574.html


3. **打开过的流是否关闭**

4. **Android3.0以下，使用完Bitmap是否调用 `recycle()`**
Android 3.0及以上的版本不需要调用`recycle()`，因为这些版本的Bitmap全部放到虚拟机的堆内存中，让GC自动回收。
5. **`WebView`使用完是否调用了其`destory()`函数**


### 是否能进一步优化代码
1. **保存在内存中的图片，是否做过压缩处理**
图片太大可能 OOM，Android Studio自带图片处理工具
2. **Intent传递的数据过大，会导致页面切换跳转过慢**
太大的数据可以通过持久化的形式传递，比如写入文件等。
3. **频繁地操作同一个文件或者执行同一个数据库操作**
可以考虑把它用作静态变量或者局部变量的形式缓存在内存中，用空间换时间。
4. **放在主页面的控件，是否可以考虑用`ViewStub`来优化启动速度**

### 第三方包
1. **build.gradle远程依赖第三方包时，版本号注意写死，不要使用+号**
特别要注意这一点，避免由于新版本的第三方包引入新的问题。
2. **导入第三方工程时，记得把编码改换成自己当前工程的编码**
3. **调用第三方包或者JDK时，要跳进他们的源码，看看是否需要加try-catch**
否则可能导致自己的App崩溃。
4. **使用第三方包时，是否加上混淆规则**
若漏掉加上第三方包的混淆规则，会导致第三方包不该混淆的代码被混淆。在Debug版本没有发现问题，但是Release版本就会出现问题。
5. **系统应用添加so库时，是否在对应固件的Android.mk文件上加入新增的so，否则系统可能编译不过**
>   ` @lib/armeabi/libcommon.so \`
>   ` @lib/armeabi/libabcdefg.so \`

### 注意要成对出现的地方
1. **系统的，自己写的，注册与反注册的，是否成对出现**
2. **在生命周期的回调里，创建和销毁的代码是否对应起来**
比如：`onCreate()`里面创建了`Adapter`，那么对应`Adapter`的退出处理操作(比如清空Image缓存)，一般就要写在`onDestory()`，而不能写在`onDestoryView()`。
类似的生命周期对应的代码有：
`onStart()`、`onStop()`;
`onCreate()`、`onDestory()`;
`onResume()`、`onPause()`;
`onCreateView()`、`onDestoryView()`

3. **若ListView的item复用了，对Item里View的操作是否成对出现**
比如：
  ```java
switch (type) {
    case 1：
        ......
        mTvTitle.setText("哎呦哥哥");
        mIvImage.setVisibility(VISIBLE);
        mTvDesc.setText("描述1");
        mBtnAttach.setVisibility(GONE);
        break;
    case 2:
        ......
        mTvTitle.setText("嗨你好");
        mIvImage.setVisibility(GONE);
        mTvDesc.setText("");
        mBtnAttach.setVisibility(VISIBLE);
        break;
}
  ```
比如以上对mTvTitle、mIvImage和mBtnAttach的操作，都是成对出现。否则ListView可能会由于Item复用，导致Item显示错乱问题

### 内存泄露问题
1. **内部类，比如Handler、Listener、Callback是否是`static class`**
因为非静态内部类会持有外部类的引用。
2. **假如子线程持有了Activity，要用弱引用来持有**
比如Request的Activity就应该用弱引用的形式，防止内存泄漏。
3. **要求传入Activity作为参数的函数，是否可以改用getApplicationContext()来作为参数**

### Handler相关
1. **使用`View.post()`是否会有问题**
因为在View处于detached状态时，`post()`里面的`Runnable`是不会被执行的。只有在此View处于attached状态时才会执行。
如果要让`Runnable`一直执行，使用`Handler.post()`来替代。
2. **假如程序可能多次在同一个Handler里post同一个Runnable，每次post之前都应该先清空这个Handler中还没执行的该Runnable**
例如：
  ``` java
    if (mRunnable!= null) {
     mHandler.removeCallbacks(mRunnable);
     mRunnable= null;
 }
 mRunnable= new Runnable() {
     @Override
     public void run() {
         ApiRequest request = new  ApiRequest ();
        request.start();
         RequestQueue.getInstance().addRequest(request);
     }
 };
 mHandler.post(mRunnable);

  ```



### 其他
1. **多思考某些情况下，某变量是否会为空**
而且在函数体内，处理参数前，必须加上判空语句
2. **回调函数是否处理好**
回调函数很容易出问题。比如网络请求的回调，需要判断此时的Aciivity等是否还存在，再进行调用。因为异步操作回来，Activity可能就消失不存在了。
而且还要对一些可能被回收的变量进行判空。
3. **修改数据库后，是否把数据库的版本号+1**
4. **启动第三方的Activity时，是否判断了该Intent能否被解析**
 ``` java
Intent intent= new Intent(mContext, MainActivity.class);
// 这种方式判断是否存在
if (intent.resolveActivity(getPackageManager()) != null) {
    startActivity(intent);
}

 ```
 若Activity不存在，会出现ActivityNotFoundException的异常
5. **新注册的组件（Activity等）若AndroidManifest.xml中exported属性为true，要考虑是否会引发安全性问题**
因为exported属性为true时，外部应用就可以直接调用起该Activity。
可能导致的问题：
- 若外部应用直接启动详情页，从而让某些验证页面直接被绕过
- 若外部应用给该Activity传递乱七八糟的Intent，可能让该应用崩溃。也就是Android中的拒绝服务漏洞
6. **除数是否做了非0判断**
7. **不要在Activity的onCreate里调用PopupWindow的showAsLoaction方法，由于Activity还没被加载完，会报错**

### 完成某功能时自测点
1. ** 思考某些情况下，某个变量是否会造成空指针问题**
2. **横竖屏切换时，布局是否有bug**
3. **在不同分辨率上，布局是否有bug**
4. **多语言时外文是否显示完整**
5. **低版本升级上来是否会有bug**
特别是数据库兼容
6. **按下home再返回是否正常**
7. **熄屏再打开是否正常**
8. **切换其他应用再切换回来是否正常**
9. **利用手机的开发者选项中的 “调试GPU过度绘制” ，“GPU呈现模式分析” 和 “显示FPS和功耗” 功能，看自己的新功能是否会导致过度绘制、是否会掉帧**
10. ** 测试看是否影响启动速度**
adb shell am start -W 包名/Activity
11. **对比apk安装包是否增大，是否正常**
12. **跑1小时Monkey，测试其稳定性**