---
title: BLE开发基础与实践
date: 2018-11-15 11:34:32
tags: [Android, BLE, 蓝牙, 干货分享]
categories: 真假
copyright: true
---

# BLE开发基础与实践

## 1. 蓝牙简介

### 1.1 什么是蓝牙 
&emsp;&emsp;蓝牙是一种近距离无线通信技术。它的特性就是近距离通信，典型距离是 10 米以内，传输速度最高可达 24 Mbps，支持多连接，安全性高，非常适合用智能设备上。

### 1.2 蓝牙技术发展版本
- 1999年发布1.0版本，目前市面上已很少见到；
- 2002年发布1.1版本，目前市面上已很少见到；
- 2004年发布2.0版本，目前市面上已很少见到；
- 2007年发布的2.1版本，是之前使用最广的，也是我们所谓的经典蓝牙。
- 2009年推出蓝牙 3.0版本，也就是所谓的高速蓝牙，传输速率理论上可高达24 Mbit/s；
- 2010年推出蓝牙4.0版本，它是相对之前版本的集大成者，它包括经典蓝牙、高速蓝牙和蓝牙低功耗协议。经典蓝牙包括旧有蓝牙协议，高速蓝牙基于Wi-Fi，低功耗蓝牙就是BLE。也是目前使用最广泛的一种
- 2016年蓝牙技术联盟提出了新的蓝牙技术标准，即蓝牙5.0版本。蓝牙5.0针对低功耗设备速度有相应提升和优化，结合wifi对室内位置进行辅助定位，提高传输速度，增加有效工作距离，主要是针对物联网方向的改进（目前市场上还未见到5.0的蓝牙设备）。
<!-- more -->

### 1.3 低功耗蓝牙与传统蓝牙的区别
- 相较传统蓝牙，传输速度更快、覆盖范围广、安全性高、延时短、耗电低等特点。
- 传统蓝牙一般是通过socket方式通讯，而低功耗蓝牙是通过Gatt协议来实现的。
- 对于大文件传输只能通过传统蓝牙来实现。

### 1.4 Android上BLE发展
&emsp;&emsp;在Android开发过程中，版本的碎片化一直是需要考虑的问题，再加上厂商定制及蓝牙本身也和Android一样一直在发展过程中，所以对于每一个版本支持什么功能，是我们需要知道的。

> Android 4.3 开始，开始支持BLE功能，但只支持Central Mode（中心模式）
> Android 5.0开始，开始支持Peripheral Mode（外设模式）

- `Central Mode`： Android端作为中心设备，连接其他外设设备。
- `Peripheral Mode`：Android端作为外设设备，被其他中心设备连接。在Android 5.0支持外设模式之后，才算实现了两台Android手机通过BLE进行相互通信。

- `外设设备`：一般值得是用来提供数据、并连接到一个功能更强大的中心设备的一个简单的低功耗蓝牙设备，例如小米手环。
- `中心设备`：中心设备一般比较强大，用来连接其他一个或多个外围设备，比如我们的手机等。

---

## 2. BLE基础理论

### 2.1.1 什么是GAP
&emsp;&emsp;中心设备要想与外设设备通讯，得通过某种方式发现外设设备，这种方式就是蓝牙广播。

&emsp;&emsp;了解蓝牙广播前先引入一个概念 `GAP`（Generic Access Profile），它用来控制设备的广播和连接，`GAP`使你的设备能被其他设备可见，并决定了你的设备是否可以或者怎么样与其他设备通讯交互。（例如标准的Beacon设备只能向外发射广播，不支持连接通讯，我们常见的BLE设备例如各种手环就可以与中心设备连接通讯），更多关于`GAP`的介绍可以去[BLE Introduction](https://learn.adafruit.com/introduction-to-bluetooth-low-energy?view=all#gap)上查看。

&emsp;&emsp; 外设设备通过`GAP`向外广播时，广播包分为两部分:`Advertising Data Payload`和 `Scan Response Data Payload`，也就是广播数据包和扫描回复包，每个包里面的数据最多可以包含31`byte`。广播数据包是每个蓝牙设备必须的，因为只有外设设备不断向外广播，中心设备才能知道他的存在。而扫描回复包则是可选的，中心设备可以外设设备请求扫描回复，这里包含一些设备额外的信息，例如设备的名字。在`Android`中,系统会把这两个数据拼接在一起,给上层返回一个62byte的数组。Android APP开发者需要自己去手动解析这些广播数据，虽然Android 5.0中`ScanRecord` 这个类提供了如下方法：
```java 
public static ScanRecord parseFromBytes(byte[] scanRecord){
    ......
}
```
会发现在实际代码中根本无法通过`ScanRecord.parseFromBytes(scanRecord)`得到实例，必须得查看源码自己写工具类解析广播数据。

&emsp;&emsp; 那么蓝牙广播数据中有哪些数据类型呢？设备连接属性、标识设备支持的BLE模式（必须）、设备名称、设备保护的GATT service，或者Service data，厂商自定义数据等。外设设备会设定一个广播时间间隔，每个广播间隔中，它会重发一次广播数据包。间隔时间越长，外设设备也就越省电，同时也越不容易被其他设备扫描到。
### 2.1.2 GAP连接方式
&emsp;&emsp;上面说到`GAP`决定了设备是否可以或者怎么样与其他设备通讯交互，答案是两种:
- 完全基于广播的方式 
  > 这种模式就是完全不需要连接的，只要设备不断向外发送广播数据即可。这种模式的设备主要是将自己的信息发送给多个中心设备。使用这种模式的最典型的案例就是苹果公司的iBeacon设备。这是苹果公司定义的基于BLE广播实现的功能，可以实现广告推送、室内定位、会议签到等功能。这同时也说明了App使用BLE，需要定位权限。
  > 这种不需要连接，依赖于BLE广播的设备，也叫作Beacon。

- 基于GATT连接的方式
  > 大部分情况下，外设设备通过发送广播来让中心设备发现自己，并建立`GATT`(Generic Attribute Profile)连接，从而进行更多的数据交换。
  > GATT连接需要特别注意的是：这种连接是一对一的，是独占的。也就是说一个BLE设备同时只能与一个中心设备连接。一旦外设设备被连接，它马上就会停止向外发送广播，这样它对其他设备来说就是不可见的了。只有当它与连接的设备断开时才会重新对外发送广播。中心设备要与外设设备双向通讯的话，唯一的方式就是建立GATT连接。
  > GATT通讯的双方是C/S模式。外设设备作为Service端，中心设备作为Client端。所有的通讯事件，都是由客户端发起，并且接收服务端的响应。

### 2.1.3 BLE通讯基础
&emsp;&emsp;BLE通讯有两个重要概率：ATT和GATT。
- ATT 
> ATT全称attribute protocol（属性协议）。它是BLE通讯的基础。ATT把数据封装，向外暴露为“属性”。提供“属性”的为服务端，获取“属性”的为客户端。ATT是专门为低功耗蓝牙设计的，结构简单，数据长度很短。

- GATT
> GATT全称Generic Attribute Profile（通用属性配置文件）。它是在ATT的基础上，对ATT进一步封装，定义数据的交互方式和含义。GATT是我们在做BLE开发时直接接触的概念。

- GATT层级
> GATT按照层级定义了4个概念：Profile（配置文件）、Service（服务）、Characteristic（特征）和Descriptor（描述）。他们之间的关系是这样的：Profile定义了一个实际的场景，一个Profile包含多个Service，一个Service包含多个Characteristic，一个Characteristic可以包含多个Descriptor。

<div align="center"><img src="https://cdn-learn.adafruit.com/assets/assets/000/013/828/medium800/microcontrollers_GattStructure.png?1390836057"></div>
<div align="center"><font color=gray> 图一：GATT层级关系</font></div>


<div align="center"><img src="https://upload-images.jianshu.io/upload_images/163823-19fd9546160a38aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/504/format/webp"></div>

- Profile
> Profile其实并不是实际存在BLE设备中的，它只是被规则设定者预先定义的一个Service集合。比如比较常见的小米手环上的`心率Profile(Heart Rate Profile)`就是结合了Heart Rate Service和Device Information Service。官方有个约定GATT Profile列表可以在[这里](https://www.bluetooth.com/specifications/profiles-overview/archived-profiles)查看。

- Service
> Service是把数据分成一个个独立的逻辑项，它包含一个或多个Characteristic。每个Service都有一个UUID作为唯一标识。UUID有16bit和128bit两种(具体区别后面UUID模块说明)。官方定义了一些[标准Service](https://www.bluetooth.com/specifications/gatt/services)。还是以`Heart Rate`为例，官方定义的16bitUUID是`0x180D`，它包含3个Characteristic：Heart Rate Measurement， Body Sensor Location 和 Heart Rate Control Point。

- Characteristic
> Characteristic定义了数值和操作，包含一个Characteristic声明、Characteristic属性、值、值的描述（Optional）。通常我们说的BLE通讯，本质上就是对Characteristic的读写和订阅通知。比如在实际操作中，对某一个Characteristic进行读，实际上就是获取这个Characteristic的value。

- Descriptors
> 用于表达 特征 的其他附加信息，如特征值的有效范围，可读性描述等信息。
> 其中包含了特殊的 CCCD（Client Characteristic Configuration Descriptor，Assigned Number : 0x2902）：
> CCCD 可以设置 服务端 在对应特征值发生变化时，是否对 客户端 进行信息 推送（直接发送信息） 或 提示（发送一个提示并等待回复）。
> 当特征包含通知能力时，CCCD为必选项。
> 描述符相关内容可在[这里](https://www.bluetooth.com/specifications/gatt/descriptors)查看。

- UUID
> Service、Characteristic等都是使用UUID作为唯一标识的。
> UUID 是全局唯一标识，它是 128bit 的值，为了便于识别和阅读，一般以 “8位-4位-4位-4位-12位”的16进制标示，比如“12345678-abcd-1000-8000-123456000000”。
> 但是由于128bit的UUID太长，考虑到在低功耗蓝牙中，数据长度非常受限的情况下，蓝牙又使用所谓的16bit或32bit的UUID，形式如下“0000XXXX-0000-1000-8000-00805F9B34FB”，除了XXXX，其余都是固定不变的。所以说，其实 16 bit UUID 是对应了一个 128 bit 的 UUID。这样一来，UUID 就大幅减少了，例如 16 bit UUID只有有限的 65536个。与此同时，因为数量有限，所以 16 bit UUID 并不能随便使用。蓝牙技术联盟已经预先定义了一些 UUID，我们可以直接使用，比如“00001011-0000-1000-8000-00805F9B34FB”就一个是常见于BLE设备中的UUID。当然也可以花钱定制自定义的UUID。
> 由于大Android开源框架为了统一处理，会将一些16bit的UUID转换为128bit的UUID，导致iOS端拿到的是16bit的UUID(如0x180D)，而Android端拿到的是128bit（如0000180D-0000-1000-8000-00805F9B34FB），其实这两者是同一个东西。

---

## 3. Android上的BLE开发

&emsp;&emsp;通过上面BLE的基础理论，我们可以分析得知，BLE通讯实际上是先通过客户端与服务端连接，拿到服务端的Characteristic进行两者间的数据交换。

### 3.1 Android手机与BLE设备通讯的大致流程
1. 扫描周围已打开蓝牙的BLE设备
2. 扫描结束后在扫描的结果中选取一个符合条件的BLE设备，在APP扫描（BLE设备广播）的过程中，BLE设备会有以下几个属性用于辨别身份：蓝牙名、MAC、广播数据。
3. 对选取的BLE设备进行连接。
4. 连接成功后可以列出这个设备所包含的所有服务和特征，服务和特征是APP与设备进行交互的通道。
5. 指定的特征进行通知、读、写等操作。常用的操作是notify和wirte，前者是APP接收BLE发过来的数据，后者是APP向BLE设备发送数据。
6. APP与BLE设备断开连接。

### 3.2 Android BLE开发实践
&emsp;&emsp; 前面的内容其实全部是关于BLE的理论知识，概念比较多，有些开发者在还没有了解过BLE的基础理论就开始开发，个人是不建议这种做法的，在前期没有足够了解BLE相关的知识，一旦当硬件开发那边对蓝牙也是一知半解时，遇到坑的几率会大很多（本人亲身经验）。

- **搜索设备**

首先别忘了在AndroidManifest.xml中声明蓝牙权限。
```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
- android.permission.BLUETOOTH : 这个权限允许程序连接到已配对的蓝牙设备，请求连接/接收连接/传输数据需要该权限，主要用于对配对后进行操作;
- android.permission.BLUETOOTH_ADMIN : 这个权限允许程序发现和配对蓝牙设备，该权限用来管理蓝牙设备，有了这个权限，应用才能使用本机的蓝牙设备，主要用于对配对前的操作;
- android.permission.ACCESS_COARSE_LOCATION和android.permission.ACCESS_FINE_LOCATION：Android 6.0以后，这两个权限是必须的，蓝牙扫描周围的设备需要获取模糊的位置信息。这两个权限属于同一组危险权限，在清单文件中声明之后，还需要再运行时动态获取。

一般在程序开始或者开始使用蓝牙的时候得先判断当前Android设备是否支持蓝牙(前文有说Android4.3才开始支持BLE)
```java
if (getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
    Log.d(TAG, "支持BLE");
} else {
    Log.d(TAG, "不支持BLE");
}
```
当手机支持BLE时就可以进行下一步了，接着我们需要用到蓝牙适配器，然后判断蓝牙是否开启，没开启就会提示开启。
> 需要注意的是对于Android6.0上蓝牙操作需要动态申请模糊定位权限，比较简单这里就不提供代码了
```java
//通过系统服务获取蓝牙管理者
BluetoothManager mBluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
//获取蓝牙适配器
BluetoothAdapter mBluetoothAdapter = mBluetoothManager.getAdapter();
if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
    Log.e(TAG, "蓝牙没有开启");
    //请求打开蓝牙
    Intent enableBleIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    //开启成功或者失败的回调在onActivityResult里面处理
    startActivityForResult(enableBleIntent,REQUEST_CODE_ENABLE_BLE);
}
```
蓝牙开启成功后就可以开始搜索设备了，注意在Android API 21(Android 5.0)后修改蓝牙的扫描API，之前Android 4.3开始的扫描方法被废弃了。
- Android 4.3 - Android 5.0扫描方法
```java
private BluetoothAdapter.LeScanCallback mLeScanCallback = new BluetoothAdapter.LeScanCallback() {
    //当搜索到一个设备，这里就会回调，注意这里回调到的是子线程。
    @Override
    public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
        //在这里可以把搜索到的设备保存起来
        //device.getName();获取蓝牙设备名字
        //device.getAddress();获取蓝牙设备mac地址。
        //这里的rssi即信号强度，即手机与设备之间的信号强度。
        //注意，这里不是搜索到1个设备后就只回调一次这个设备，可能过个几秒又搜索到了这个设备，还会回调的
        //也就是说同一个设备可能会回调多次
        //所以，这里可以实时刷新设备的信号强度rssi，但是保存的时候就只保存一次就行了。
        }
    };


//开始扫描
mBluetoothAdapter.startLeScan(mLeScanCallback);
//停止扫描  由于扫描消耗电量，所以不能一直处于扫描状态 可以设置一个定时器来停止扫描
mBluetoothAdapter.stopLeScan(mLeScanCallback);
```
- Android 5.0及以上扫描方法
```java
private ScanCallback mScanCallback = new ScanCallback() {
    @Override
    public void onScanResult(int callbackType, ScanResult result) {
        super.onScanResult(callbackType, result);
        //这个方法和4.3的onLeScan一样 搜索到一个设备，这里就会回调，注意这里回调到的是子线程。
        //通过result.getDevice()获取BluetoothDevice对象
    }

    @Override
    public void onBatchScanResults(List<ScanResult> results) {
        super.onBatchScanResults(results);
        //在此返回一个包含所有扫描结果的列表集，包括以往扫描到的结果。
    }

    @Override
    public void onScanFailed(int errorCode) {
        super.onScanFailed(errorCode);
        //扫描失败后的处理。
};

//Android5.0以上要通过BluetoothLeScanner来进行扫描相关操作
BluetoothLeScanner mBluetoothLeScanner = mBluetoothAdapter.getBluetoothLeScanner();
//开始扫描
mBluetoothLeScanner.startScan(mScanCallback);
//停止扫描  由于扫描消耗电量，所以不能一直处于扫描状态 可以设置一个定时器来停止扫描
mBluetoothLeScanner.stopScan(mScanCallback);
```

- **连接设备**

搜索到蓝牙设备之后就可以开始连接了，通过`BluetoothDevice`的`connectGatt()`来进行连接，这个方法有三个入参，第一个context不用说了，第二个是boolean类型的，表示是否自动连接，第三个参数又是一个回调，这个回调比较重要，后续很多操作都跟这个回到有关。
```java 
mBluetoothDevice.connectGatt(context, false, mBluetoothGattCallback);


private BluetoothGattCallback mBluetoothGattCallback = new BluetoothGattCallback() {
        
    //连接状态改变时回调
    //连接成功或者断开连接之后的操作在这个回调里面执行
    //比如说连接成功之后开始执行获取服务
    @Override
    public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
        super.onConnectionStateChange(gatt, status, newState);
    }

    //发现服务的回调
    @Override
    public void onServicesDiscovered(BluetoothGatt gatt, int status) {
        super.onServicesDiscovered(gatt, status);
    }

    //写操作的回调
    @Override
    public void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
        super.onCharacteristicWrite(gatt, characteristic, status);
    }

    //数据返回的回调
    @Override
    public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
        super.onCharacteristicChanged(gatt, characteristic);
    }

    //写入描述符后的回调
    @Override
    public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
        super.onDescriptorWrite(gatt, descriptor, status);
    }
};

```
- **发现服务**

在建立连接之后，就可以通过`BluetoothGatt`实例来进行获取服务，查找设备支持的服务列表
```java
/**
 * 异步操作，发现服务完成时，会回调onServicesDiscovered()方法。
 * 假如发现服务已在启动状态中，则返回true
 */
gatt.discoverServices();
```
发现服务之后上面我们说的那个回调的`onServicesDiscovered()`会被回调
```java
    /**
     * @param gatt:   执行发现服务后的GATT客户端。
     * @param status: 发现服务的执行结果, 成功返回 GATT_SUCCESS
     */
    @Override
    public void onServicesDiscovered(BluetoothGatt gatt, int status) {
        super.onServicesDiscovered(gatt, status);
        //记得在这把BluetoothGatt缓存下来
    }
```
当`status`返回`GATT_SUCCESS`，表示与外部设备成功建立**可通信连接**，意味着可以执行如：写入数据，读取蓝牙设备的数据等 蓝牙通信操作了。

- **获取服务**

发现服务成功之后，可以通过以下的方法尝试获取 BluetoothGattService 实例：
```java
/* 获取远程设备提供的服务列表，
 * 如果未执行发现服务，会返回一个空列表 */
mGatt.getServices();

/* 通过服务的UUID，获取指定的服务，
 * 如果远程设备不支持给定UUID的服务，返回null，
 * 如果远程设备存在多个给定UUID的服务实例，则返回第一个实例 */
mGatt.getService(UUID);
```
获取到 BluetoothGattService 之后，就可以通过获取服务的特征进行读写。

- **特征的读写数据**

上面介绍了BLE通讯的实质是`Characteristic`，要进行读写操作，其实就是在操作特征里的属性词条，所以要先通过`Service`获取`Characteristic`:
```java
/* 假设 service 是从上一步获取到的一个 BluetoothGattService 实例*/
··· BluetoothGattService service;
/* 获取该服务的特征列表 */
service.getCharacteristics();

/* 通过特征的UUID，获取指定的特征，
 * 如果没有找到给定UUID的特征，返回null，
 * 如果服务中存在多个给定UUID的特征，则返回第一个实例 */
service.getCharacteristic(UUID);
```
获取到了特征之后，就可以通过上面获取到的 mGatt 读写信息：
```java
/* 上一步获取的 BluetoothGattCharacteristic 实例 */
··· BluetoothGattCharacteristic characteristic;

/* 从关联的远程设备读取请求的特征，
 * 异步操作，请求发起成功则返回true，读取完成会回调：
 * BluetoothGattCallback.onCharacteristicRead() */
mGatt.readCharacteristic(characteristic);

/* 将给定的特征及其值写入关联的远程设备，
 * 异步操作，请求发起成功则返回true，写入完成会回调：
 * BluetoothGattCallback.onCharacteristicWrite() */
mGatt.writeCharacteristic(characteristic);
```
读写操作都是异步操作，方法返回的是请求是否成功，请求结果都会回调上面的`BluetoothGattCallback`的方法
```java
/**
 * 读操作的回调
 * @param characteristic：  读取后的特征
 * @param status：          读取结果，成功为 GATT_SUCCESS
 */
@Override
public void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
    super.onCharacteristicWrite(gatt, characteristic, status);
}
/**
 * 写操作的回调
 * @param characteristic：  写入后的特征
 *                          注意：这里返回的特征，为设备当前的特征，应该在该回调中，应对比该特征的内容是否符合期望值，如果与期望值不同，应该选择重发或终止写入。                    
 * 
 * @param status：          写入结果，成功为 GATT_SUCCESS
 */

@Override
public void onCharacteristicRead(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
    super.onCharacteristicRead(gatt, characteristic, status);
}
```
- **描述符的读写数据**

读写方式与`Characteristic`的读写方式基本一致，不再过多描述 ：
```java
/* 获取描述符 */
··· BluetoothGattCharacteristic characteristic;
characteristic.getDescriptors();
characteristic.getDescriptor(UUID);

/* 通过 mGatt 读写数据
 * 同样，写操作需要做写入结果校验 */
··· BluetoothGattDescriptor descriptor;
mGatt.readDescriptor(descriptor);
mGatt.writeDescriptor(descriptor);
```
结果回调如下:
```java
//写入描述符后的回调
@Override
public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
    super.onDescriptorWrite(gatt, descriptor, status);
}

//读取描述符后的回调
 @Override
public void onDescriptorRead(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
    super.onDescriptorRead(gatt, descriptor, status);
}
```
- **数据变更通知**
前面说到除了**读（Read）** 和 **写（Write）**，BLE还有一种**通知（Notify）**
一些特征在值发生变化时，可以主动向申请了监听数据变化的客户端推送通知（有数据）或指示（无数据）。
开启特征的监听，需要进行两步操作：
1. 设置特征信息推送：

```java
/**
 * 启用或禁用给定特征的通知或指示
 * @param characteristic:  需要进行操作的特征
 * @param enable :         开启或关闭
 */
BluetoothGatt.setCharacteristicNotification(BluetoothGattCharacteristic characteristic,boolean enable);
```
2. 写入CCCD：

虽然开启了特征的信息推送，但假如特征本身禁用了通知和指示，则不会有更新推送。
前面提到了一个特殊的标识符CCCD，用于控制特征的消息推送。需要对特征的CCCD描述符进行操作，将其值置为 1 / 2，才能开启对应的 通知 / 指示 功能。
```java 
/* 设置特征信息推送 */
··· BluetoothGattCharacteristic characteristic;
    mGatt.setCharacteristicNotification(characteristic,true);

/* CCCD 的UUID */
private UUID ID_CCCD = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb");  

/* 获取CCCD */
BluetoothGattDescriptor cccd = characteristic.getDescriptor(ID_CCCD);

/* 设置推送通知，参考值为：
 * BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE:   通知
 * BluetoothGattDescriptor.ENABLE_INDICATION_VALUE:     指示
 * BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE:  关闭
 */  
cccd.setValue(参考值);
/* 写入CCCD */
mGatt.writeDescriptor(descriptor);
```
以上操作完成后，即开启对应特征的更新推送了。

- **接收推送**

更新推送会回调`BluetoothGattCallback`的`onCharacteristicChanged()`方法：
```java
/**
 * 特征变更推送触发的回调
 * @param gatt:            特征 关联的 BluetoothGatt 实例
 * @param characteristic:  更新后的 特征
 */
@Override
public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
    super.onCharacteristicChanged(gatt, characteristic);
}
```

-  **关闭连接**

```java
/* 断开当前连接，如果正在连接中，则取消连接操作 */
BluetoothGatt.disconnect();
```
断开连接操作后，结果回调`onConnectionStateChange()`方法，应该通过回调返回的结果`status `和`newState`判断是否成功断开。
断开连接之后还应该调用`BluetoothGatt`的`close()`方法来释放资源，这一步很重要，不然下次连接会报`gattStatus=133`错误，导致无法连接！

---

## 4.参考文章
1. [蓝牙技术基础知识学习](https://www.jianshu.com/p/78460132a563)
1. [GATT协议及蓝牙核心系统结构](https://blog.csdn.net/ohyeahhhh/article/details/52175596)
2. [安卓 BLE 开发详解](https://www.jianshu.com/p/43b1956d9f5c)
3. [Android BLE开发详解和FastBle源码解析](https://www.jianshu.com/p/795bb0a08beb)