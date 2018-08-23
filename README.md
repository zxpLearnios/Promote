# Promote

# 本项目为[![Swift 4](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](https://swift.org)项目，使用<font color=red>cocoapods</font>进行第三方库的管理
<br> 工具
* Xcode 9.3+ 
***

## 1. 项目采用*MVVM*设计模式

M  | V |  VM
:-|:-:|-:
数据模型层，只是一个简单的数据模型，里面会进行相应的转换操作但不进行存储操作     |     视图层    |   逻辑处理层，但是目前一些简单的UI逻辑不会在此进行，仍然在相应的view里进行。此层可直接单元测试    
## 2. 项目文件结构
+ \*Global
+ Libs
+ \*Tools
+ \*Extension
+ Request
+ Modules

## 3. 项目*整体主线*
- 各自实体的职责非常明确，只处理划归自己的消息
- 会有一个主类或抽象父类，但不进行具体操作
- 具体操作由**相应的类**去处理，并遵循一些抽象协议，且有自己的特质     

## 4. 规范参考
[git提交规范](http://www.cnblogs.com/okokabcd/p/9388288.html)

```
一些代码规范展示
```
---
待续。。。
