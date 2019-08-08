//
//  PTTestOther.swift
//  Promote
//
//  Created by 张净南 on 2018/7/19.
//  测试协议 多继承 协议关联类型 结构体

import UIKit

// 此协议只能类遵循
//protocol PTssProtocol: class {}

protocol PTTestAllProtocol {
    // 类型不同但有相同操作的，用协议的关联类型
    associatedtype PTTestAllProtocolType
    var name: String {get}
    var age: Int {set get}
    
    // 外部根据自己的情况设置PTTestAllProtocolType为特定的类型然后赋值即可
    var reallyType: PTTestAllProtocolType {set get}
    
    // 外部根据自己的情况设置PTTestAllProtocolType为特定的类型然后调用此法即可
    func getString(_ param: PTTestAllProtocolType)
}

class PTTestProtocol: PTTestAllProtocol {
    
    
    
    typealias PTTestAllProtocolType = Double
    
    var name = ""
    var age: Int = 0
    
    var reallyType: Double = 1
    
    
    func getString(_ param: Double) {
        
    }
    
    
}

class PTTestProtocolOne: PTTestAllProtocol {
    
   
    
    typealias PTTestAllProtocolType = Int
    
    var name = ""
    var age: Int = 0
    
    
    var reallyType = 9
    
    
    
    func getString(_ param: Int) {
    
    }
    
}

class PTTestAllProtocolManager {
    
    
    struct PTTestProtocolOneStruct {
        
        var name = ""
        
        // 必须使用mutating来修饰方法，以可以修改属性
        mutating func setName(_ name: String) {
            self.name = name
        }
        
    }
    
    
    init() {
//        let tp = PTTestProtocol()
//        tp.name = "啊啊"
//        tp.age = 2
//
//        let newTp = tp
//        newTp.name = "3333"
     
        // 是否遵循协议
//        if tp is NSObject {
//
//        }
        
//        var tsct = PTTestProtocolOneStruct()
//        tsct.name = "结果提"
//
//        var newTsct = tsct
//        tsct.setName("新名字")
//        tsct.name = "新名字"
        
        
        
        let unitAry = (0, ["1", "2"])
        
        testGetEveryValueInUnitArrayParam {
                debugPrint("直接使用元祖, \($0) \($1)")
        }
        
    }
    
    // MARK: 测试在方法的元祖类型参数获取值
    func testGetEveryValueInUnitArrayParam(_ closure: ((String, Int) -> ())) {
        
    }
    
    func testProtocolContain(_ obj: NSObject) {
        
    }
    
    // MARK: 协议的聚合
    func testProtocolJuhe(_ obj: NSObject & UITableViewDelegate) {
        
    }
    
}
