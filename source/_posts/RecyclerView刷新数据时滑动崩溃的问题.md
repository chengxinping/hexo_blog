---
title: RecyclerView刷新数据时滑动崩溃的问题
date: 2018-05-11 16:10:04
tags: [Android, RecyclerView]
categories: 真假
copyright: true
---

### RecyclerView刷新数据时滑动崩溃的问题
目前开发的App首页使用的RecyclerView，从其他页面回到首页产品要求要刷新数据，有时候就会出现崩溃的问题，抓到的log如下：
``` java
 java.lang.IndexOutOfBoundsException: Inconsistency detected. Invalid view holder adapter positionViewHolder{4b31b51 position=4 id=-1, oldPos=-1, pLpos:-1 no parent} android.support.v7.widget.RecyclerView{9d24c83 VFED..... .F...... 0,624-1440,2288 #7f0a0206 app:id/home_recycler_view}, adapter:com.delicloud.app.smartoffice.mvp.adapter.RecyclerViewGridAdapter@22cae00, layout:android.support.v7.widget.LinearLayoutManager@e0a4639, context:com.delicloud.app.smartoffice.mvp.ui.activity.DeliAssistantActivity@e33da87
        at android.support.v7.widget.RecyclerView$Recycler.validateViewHolderForOffsetPosition(RecyclerView.java:5421)
        at android.support.v7.widget.RecyclerView$Recycler.tryGetViewHolderForPositionByDeadline(RecyclerView.java:5603)
        at android.support.v7.widget.RecyclerView$Recycler.getViewForPosition(RecyclerView.java:5563)
        at android.support.v7.widget.RecyclerView$Recycler.getViewForPosition(RecyclerView.java:5559)
        at android.support.v7.widget.LinearLayoutManager$LayoutState.next(LinearLayoutManager.java:2229)
        at android.support.v7.widget.LinearLayoutManager.layoutChunk(LinearLayoutManager.java:1556)
        at android.support.v7.widget.LinearLayoutManager.fill(LinearLayoutManager.java:1516)
        at android.support.v7.widget.LinearLayoutManager.scrollBy(LinearLayoutManager.java:1330)
        at android.support.v7.widget.LinearLayoutManager.scrollVerticallyBy(LinearLayoutManager.java:1074)
        at android.support.v7.widget.RecyclerView.scrollByInternal(RecyclerView.java:1758)
        at android.support.v7.widget.RecyclerView.onTouchEvent(RecyclerView.java:2970)
        at android.view.View.dispatchTouchEvent(View.java:10731)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2859)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2535)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at android.view.ViewGroup.dispatchTransformedTouchEvent(ViewGroup.java:2865)
        at android.view.ViewGroup.dispatchTouchEvent(ViewGroup.java:2550)
        at com.android.internal.policy.DecorView.superDispatchTouchEvent(DecorView.java:509)
        at com.android.internal.policy.PhoneWindow.superDispatchTouchEvent(PhoneWindow.java:1863)
        at android.app.Activity.dispatchTouchEvent(Activity.java:3226)
        at android.support.v7.view.WindowCallbackWrapper.dispatchTouchEvent(WindowCallbackWrapper.java:68)
        at com.android.internal.policy.DecorView.dispatchTouchEvent(DecorView.java:471)
        at android.view.View.dispatchPointerEvent(View.java:10960)
        at android.view.ViewRootImpl$ViewPostImeInputStage.processPointerEvent(ViewRootImpl.java:5068)
        at android.view.ViewRootImpl$ViewPostImeInputStage.onProcess(ViewRootImpl.java:4920)
        at android.view.ViewRootImpl$InputStage.deliver(ViewRootImpl.java:4451)
        at android.view.ViewRootImpl$InputStage.onDeliverToNext(ViewRootImpl.java:4504)
        at android.view.ViewRootImpl$InputStage.forward(ViewRootImpl.java:4470)
04-08 17:44:31.528 7237-7237/com.delicloud.app.smartoffice E/CrashHandler:     at android.view.ViewRootImpl$AsyncInputStage.forward(ViewRootImpl.java:4603)
        at android.view.ViewRootImpl$InputStage.apply(ViewRootImpl.java:4478)
        at android.view.ViewRootImpl$AsyncInputStage.apply(ViewRootImpl.java:4660)
        at android.view.ViewRootImpl$InputStage.deliver(ViewRootImpl.java:4451)
        at android.view.ViewRootImpl$InputStage.onDeliverToNext(ViewRootImpl.java:4504)
        at android.view.ViewRootImpl$InputStage.forward(ViewRootImpl.java:4470)
        at android.view.ViewRootImpl$InputStage.apply(ViewRootImpl.java:4478)
        at android.view.ViewRootImpl$InputStage.deliver(ViewRootImpl.java:4451)
        at android.view.ViewRootImpl.deliverInputEvent(ViewRootImpl.java:6953)
        at android.view.ViewRootImpl.doProcessInputEvents(ViewRootImpl.java:6892)
        at android.view.ViewRootImpl.enqueueInputEvent(ViewRootImpl.java:6853)
        at android.view.ViewRootImpl$WindowInputEventReceiver.onInputEvent(ViewRootImpl.java:7063)
        at android.view.InputEventReceiver.dispatchInputEvent(InputEventReceiver.java:185)
        at android.view.InputEventReceiver.nativeConsumeBatchedInputEvents(Native Method)
        at android.view.InputEventReceiver.consumeBatchedInputEvents(InputEventReceiver.java:176)
        at android.view.ViewRootImpl.doConsumeBatchedInput(ViewRootImpl.java:7027)
        at android.view.ViewRootImpl$ConsumeBatchedInputRunnable.run(ViewRootImpl.java:7090)
        at android.view.Choreographer$CallbackRecord.run(Choreographer.java:927)
        at android.view.Choreographer.doCallbacks(Choreographer.java:702)
        at android.view.Choreographer.doFrame(Choreographer.java:632)
        at android.view.Choreographer$FrameDisplayEventReceiver.run(Choreographer.java:913)
        at android.os.Handler.handleCallback(Handler.java:751)
        at android.os.Handler.dispatchMessage(Handler.java:95)
        at android.os.Looper.loop(Looper.java:154)
        at android.app.ActivityThread.main(ActivityThread.java:6646)
        at java.lang.reflect.Method.invoke(Native Method)
        at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:1468)
        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:1358)

```
<!-- more -->
很尴尬，从日志里面无法分析出问题所在，依靠万能的谷歌，找到了Drakeet大神的一片博客：
> https://drakeet.me/recyclerview-inconsistency-detected-invalid-item/

> 重现方法是：RecyclerView绑定的 List 对象在更新数据之前进行了 clear，而这时用户紧接着迅速上滑 RV，就会造成崩溃，而且异常不会报到你的代码上，属于RV内部错误。初次猜测是，当你 clear 了 list 之后，这时迅速上滑，而新数据还没到来，导致 RV 要更新加载下面的 Item 时候，找不到数据源了，造成 crash.

解决方法是在刷新也就是`list clear`的同时，让`RecyclerView`暂时不能滑动或者通知RV内部的`holder`数据改变了，把RV内部`holder`数据也清空。

更新数据时禁止滑动：
``` java
mRecyclerView.setOnTouchListener(
        new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (mIsRefreshing) {
                    return true;
                } else {
                    return false;
                }
            }
        }
);

```

通知RV内部`hodler` 数据改变：
``` java
int preSize = mDatas.size();
mDatas.clear();
mGridAdapter.notifyItemRangeRemoved(0, preSize);

```
