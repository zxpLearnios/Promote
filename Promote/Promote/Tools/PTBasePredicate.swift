//
//  PTBasePredicate.swift
//  Promote
//
//  Created by Bavaria on 2018/5/24.
//  一些匹配操作
/**
 AND、OR、IN、NOT、ALL、ANY、SOME、NONE、LIKE、CASEINSENSITIVE、CI、MATCHES、CONTAINS、BEGINSWITH、ENDSWITH、BETWEEN、NULL、NIL、SELF、TRUE、YES、FALSE、NO、FIRST、LAST、SIZE、ANYKEY、SUBQUERY、CAST、TRUEPREDICATE、FALSEPREDICATE
 
 注：虽然大小写都可以，但是更推荐使用大写来表示这些保留字
 */



import UIKit

@objcMembers class PTBasePredicate {
    
    // ---------- 数值操作 -------- //
    /**
     * 过滤\查询 出属性在某一数值范围内的对象，如age >= 10 && age <= 100
     * 包括左右起点
     */
    static func query(for property: String, from f: Int, to t: Int?) -> NSPredicate {
        
        let operate: String
        if let right = t {
            
            if f > right {
                operate = ""
            } else if f == right {
                operate = "\(property) == \(f)"
            } else {
                operate = "\(property) >= \(f) && \(property) <= \(right)"
            }
        } else {
            operate = "\(property) >= \(f)"
        }
        
        let predicate = NSPredicate.init(format: operate)
        return predicate
    }
    
    // -------- 字符串操作 ------- //
    /**
     * 1. 对象的某个属性是否含有前缀
     * 使用like时，一定要带上通配符*。 如 "name like 'a'" ==  "name == 'a'"
     */
    open static func ishavePrefix(in property: String, prefix char: String) -> NSPredicate {
//        let operate  = "\(property) like '\(char)*'"
        let operate  = "\(property) beginswith '\(char)'"
        let predicate = NSPredicate.init(format: operate)
        return predicate
    }
    
    /**
     * 2. 对象的某个属性是否含有后缀
     */
    open static func ishaveSuffix(in property: String, suffix char: String) -> NSPredicate {
//        let operate  = "\(property) like '*\(char)'"
        let operate  = "\(property) endswith '\(char)'"
        let predicate = NSPredicate.init(format: operate)
        return predicate
    }
    
    /**
     * 3. 对象的某个属性是否含有某一字符
     */
    open static func isContainString(in property: String, string str: String) -> NSPredicate {
        let operate  = "\(property) contains '\(str)'"
        let predicate = NSPredicate.init(format: operate)
        return predicate
    }
    
    /**
     * 4. 对象的某个属性是否等于**
     */
    open static func isEqualToString(in property: String, string str: String) -> NSPredicate {
        //        let operate  = "\(property) like '\(str)'"
        let operate  = "\(property) == '\(str)'"
        let predicate = NSPredicate.init(format: operate)
        return predicate
    }
    
    
    
}
