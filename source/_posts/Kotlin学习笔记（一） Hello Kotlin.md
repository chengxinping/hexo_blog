---
title: Kotlin学习笔记（一） Hello Kotlin
date: 2017-06-16 10:12:11
tags: [Kotlin]
categories: Kotlin学习笔记
copyright: true
---
### 写在前面
>   就在刚过去的谷歌开发者大会上，谷歌宣布将` Kotlin `作为` Android `开发的一级语言，哈哈哈小三终于扶正了。` Kotlin `是有` JetBrains `公司开发的，对没错就是那个开发` IDEA `、` WebStorm `的那个公司，` Kotlin `与` Java `100%互通，并且` Kotlin `的每个特点都是针对` Java `的痛点开发的，哈哈哈。闲话少说，学习一门新语言，按照传统是来一段` Hello World `(手动滑稽）。

<!--more-->
### 1. Kotlin的Hello World
　　`Kotlin`的程序非常简单，简单到只需要三行代码就能写出`HelloWorld`，比起`Java`连包名都不需要
``` kotlin
fun main (args: Array<String>){
	print("Hello World!")
}
```
　　运行结果如下所示
![Alt text](/img/kotlin/20170616_1111.png)
　　与` Java `一样，` Kotlin `程序的主入口也是` main() `函数。但是作为函数是一等公民的语言，它不像` Java `那样必须声明一个类。
　　在` Kotlin `里面，函数的声明用` fun `表示，变量也与` Java `不同，是变量名在前，变量类型在后，中间用`:`隔开。` Kotlin `程序非常简洁，连分号也不必写（当然写了也没错）。
### 2. 面向对象的Kotlin程序
  >  接下来我们看看` Kotlin `世界里的面向对象

　　我们创建一个包，并在包下面新建` Person `的类

``` kotlin
package com.kotlin.hello

class Person(val name: String) {
    fun printName() {
        println(name)
    }
}
```
　　然后回到` HelloWorld.kt `里修改` main() `函数
``` kotlin
import com.kotlin.hello.Person

fun main(args: Array<String>) {
    println("Hello World!")
    Person("哎呦哥哥").printName()
}
```
　　运行结果如下图所示：
![Alt text](/img/kotlin/20170616_1411.png)
　　仔细看代码会发现` Kotlin `创建对象时并不需要` new `出来，而是像调用普通方法一样直接调用构造方法。　　
### 3. 编码风格
　　编码风格和` Java `类似，建议使用驼峰命名法，类名首字母大写，每个单词的首字母大写；方法和属性变量首字母小写；采用四个空格缩进。
　　同时，` Kotlin `官方建议不要给属性前面加前缀（例如` Java `里面成员变量前面加` m `）；冒号在分割两个类型时，左右两边应该都有空格，在 实例和类型之间，应该紧靠实例变量，例如：
``` kotlin
interface Foo<out T : Any> : Bar {
	fun foo(a: Int): T
}
```
对于Lambdas表达式，如果只用一行就能简单表达lambdas，应该遵循在大括号的两侧、箭头的两侧、参数的两侧都使用空格分隔开。例如：
``` kotlin
list.filter{ it > 10 }.map { element -> element * 2 }
```
### 4. 小结
　　` Kotlin `的热度以及持续了一个多月了，观望了接近一个月才开始学习` Kotlin ` ，才刚刚敲了一会` Kotlin `就爱上了这个语言，如果以后一直用这个语言开发Android App，是真的会减少好多代码，同时也希望自己能坚持学下去，也能坚持地写博客。最后感谢[张涛大神的` Kotlin `教程](https://kymjs.com/)。