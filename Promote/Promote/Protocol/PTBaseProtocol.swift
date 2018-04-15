//
//  BaseProtocol.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  基协议

import UIKit

// ----------- 1. 通常做法
/**
 * 抽象协议
 */
public protocol PTPromoteProtocol {
}

/**
 * 扩展
 */
public extension PTPromoteProtocol {

    // 获取遵循此协议的抽象类的实例
    public var pt: PTPromote<Self> {
        return PTPromote.init(self)
    }
    
    public static var pt: PTPromote<Self>.Type {
        get {
            return PTPromote<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }
}

/**
 * 抽象类型
 */
public final class PTPromote<Base> {
    var base: Base
//    static var pt: Base> {
//        self.base = base
//    }()
    init(_ base: Base) {
        self.base = base
    }
}

/*   ---------------  2. 利于不同类型里又有别的类型且需要给其他类型进行(协议)扩展， 参考kingfisher
// 此两句必须在协议里，不能再xie'y
public protocol PromoteProtocol {
 // 协议里的泛型必须如此写，这不同于struct class里的<T>
    associatedtype Associatedtype
    var ele: Associatedtype { get }
}

public extension PromoteProtocol {
     //获取遵循此协议的抽象类的实例
    var pt: Promote<Self> {
        return Promote.init(self)
    }
}

public final class Promote<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

*/
