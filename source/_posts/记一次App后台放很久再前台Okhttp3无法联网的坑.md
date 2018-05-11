---
title: 记一次App后台放很久再前台Okhttp3无法联网的坑
date: 2018-04-17 16:04:04
tags: [Android, 爬坑]
categories: 真假
copyright: true
---

### App后台放很久再前台Okhttp3无法联网的坑
#### 1.错误描述
开发过程中遇到一个很奇葩的问题，就是APP在后台放十分钟左右，再打开到前台，发现所有接口都无法联网，只能杀死APP再重新打开才能正常使用，错误日志大致如下
``` java
ERROR [IOException]-[120]

    java.io.IOException: unexpected end of stream on okhttp3.Address@178de5cc

    at okhttp3.internal.http.Http1xStream.readResponse(Http1xStream.java:201)
    at okhttp3.internal.http.Http1xStream.readResponseHeaders(Http1xStream.java:127)
    at okhttp3.internal.http.CallServerInterceptor.intercept(CallServerInterceptor.java:53)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:92)
    at okhttp3.internal.connection.ConnectInterceptor.intercept(ConnectInterceptor.java:45)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:92)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:67)
    at okhttp3.internal.cache.CacheInterceptor.intercept(CacheInterceptor.java:109)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:92)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:67)
    at okhttp3.internal.http.BridgeInterceptor.intercept(BridgeInterceptor.java:93)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:92)
    at okhttp3.internal.http.RetryAndFollowUpInterceptor.intercept(RetryAndFollowUpInterceptor.java:124)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:92)
    at okhttp3.internal.http.RealInterceptorChain.proceed(RealInterceptorChain.java:67)
    at okhttp3.RealCall.getResponseWithInterceptorChain(RealCall.java:170)
    at okhttp3.RealCall.access$100(RealCall.java:33)
    at okhttp3.RealCall$AsyncCall.execute(RealCall.java:120)
    at okhttp3.internal.NamedRunnable.run(NamedRunnable.java:32)
    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1112)
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:587)
    at java.lang.Thread.run(Thread.java:841)
Caused by: java.io.EOFException: \n not found: size=0 content=…
    at okio.RealBufferedSource.readUtf8LineStrict(RealBufferedSource.java:215)
    at okhttp3.internal.http.Http1xStream.readResponse(Http1xStream.java:186)
    ... 21 more

```

<!-- more -->

#### 2.错误解决
通过错误日志发现应该是Okhttp3拦截器里面有问题，不知道是Okhttp3的bug还是什么奇妙的原因，苦逼地找了一下午才找到了一个解决方案，就是在`HTTP`头部添加`addHeaders("Connection", "close");`,即在头部增加关闭链接功能，不让它保持连接，后来让测试的同学长期测试也就再没出现这个问题。
#### 3.错误分析
> 经过抓包后发现再不加这个头部，即保持默认时`Connection`的值为`Keep-Alive`,增加Connection=false后头部值为`Connection=close`

- 关于Http头 Connection=close的作用：

在http1.1中request和reponse header中都有可能出现一个connection头字段，此header的含义是当client和server通信时对于长链接如何进行处理。
在http1.1中，client和server都是默认对方支持长链接的， 如果client使用http1.1协议，但又不希望使用长链接，则需要在header中指明connection的值为close；如果server方也不想支持长链接，则在response中也需要明确说明connection的值为close.

不论request还是response的header中包含了值为close的connection，都表明当前正在使用的tcp链接在请求处理完毕后会被断掉。以后client再进行新的请求时就必须创建新的tcp链接了。 HTTP Connection的 close设置允许客户端或服务器中任何一方关闭底层的连接双方都会要求在处理请求后关闭它们的TCP连接。
