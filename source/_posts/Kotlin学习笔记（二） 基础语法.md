---
title: Kotlin学习笔记（二） 基础语法
date: 2017-06-27 10:06:17
tags: [Kotlin]
categories: Kotlin学习笔记
copyright: true
---
### 2.1 变量与常量
#### 2.1.1 认识Kotlin的变量和常量
　　话不多少，还是先来看一段代码（毕竟有代码才有说服力嘛）
``` kotlin
fun main(args: Array<String>) {
    val name: String = "哎呦哥哥"
    val weight: Double = 45.0
    var age = 22 //var age: Double = 22
    println("我是$name,我体重是${weight}KG。")
    println("我今年${age}岁")
    age += 1  //var定义的是变量，可以重新赋值
    //weight+=2  这一句报错，因为val定义的是常量无法修改
    println("我明年${age}岁")
}
```
　　上面的代码中，我们声明了一个` String `类型和一个` double `类型的常量，声明了一个名为` age `的变量，并且初始化为22。
　　运行结果显而易见，就不贴图了，直接手打出来吧
```
我是哎呦哥哥,我体重是45.0KG。
我今年22岁
我明年23岁

Process finished with exit code 0
```
<!--more-->
　　通过这段代码可以看出，` Kotlin `语言声明一个常量量关键字是` val `，声明一个变量的关键字是` var `，声明时` Kotlin `语言是可以自动推测出字段类型的（所以说智能嘛），例如上面的` var age = 22 `会被认为是` Int `类型，但如果希望它是一个` Double `类型，则需要显示声明，例如` var age: Double = 22 `。
#### 2.1.2 Kotlin中val和var的区别
> val用于声明常量

``` kotlin
/**
 * 声明常量
 */
fun main(args: Array<String>){
    val a: Int = 1 //立即初始化
    val b = 2 //自动推导出是Int类型
    val c: Int //当没有初始化值的时候必须声明类型
    c = 3 //赋值
}
```
> var用于声明变量

``` kotlin
/**
 * 变量
 */
fun main(args: Array<String>){
    var  x = 5 //自动推导出Int类型，var x: Int = 5
    x += 1
    println("x = $x")
}
```
### 2.2 语句
#### 2.2.1 in关键字的使用
　　判断一个对象是否在某个区间内，可以使用` in `关键字（例如集合的遍历等）
> Tips: ` Kotlin `中新增了` 区间（Range） `的概念。在` Kotlin `中` 1..1024 `的意思是是数学里面区间[1,1024]，` 1 until 1024 `表示[1,1024)。在` Kotlin `中常用的集合有` IntRange `、` LongRange `、` CharRange `等。

``` kotlin
//如果存在于区间[1,Y-1]，则打印OK
if (x in 1..y-1) 
  print("OK")

//如果x不存在于array中，则输出Out
if (x !in 0..array.lastIndex) 
  print("Out")

//打印1到5
for (x in 1..5) 
  print(x)

//遍历集合(类似于Java中的for(String name : names))
for (name in names)
  println(name)

//如果names集合中包含text对象则打印yes
if (text in names)
  print("yes")
```
#### 2.2.2 when表达式
