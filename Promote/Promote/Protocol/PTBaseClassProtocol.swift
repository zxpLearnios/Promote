//
//  PTBaseClassProtocol.swift
//  Promote
//
//  Created by bavaria on 2018/4/12.
//  限制此协议只能被类遵循



protocol PTBaseClassProtocol { // class struct enum
    var name: String {get set}
    var part: String {get}
    
    // mutating 只能用于修饰值类型的enum、struct
    mutating func setNewName(new name: String)
}

//class test: PTBaseClassProtocol {
//    var name: String = ""
//
//    var part: String = ""
//
//    func setNewName(new name: String) {
//
//    }
//
//}

struct test1: PTBaseClassProtocol {

    var name: String

    var part: String

    mutating func setNewName(new name: String) {
        self.name = name
    }
}


