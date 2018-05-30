//
//  PTBasePredicate.swift
//  Promote
//
//  Created by Bavaria on 2018/5/24.
//  一些匹配操作, 谓词过滤集合效率好
/**
  谓词保留字（大小写皆可）： AND、OR、IN、NOT、ALL、ANY、SOME、NONE、LIKE、CASEINSENSITIVE、CI、MATCHES、CONTAINS、BEGINSWITH、ENDSWITH、BETWEEN、NULL、NIL、SELF、TRUE、YES、FALSE、NO、FIRST、LAST、SIZE、ANYKEY、SUBQUERY、CAST、TRUEPREDICATE、FALSEPREDICATE
 
 AND、&&：逻辑与，要求两个表达式的值都为YES时，结果才为YES。
 OR、||：逻辑或，要求其中一个表达式为YES时，结果就是YES
 NOT、 !：逻辑非，对原有的表达式取反
 
 谓词占位符（必须大写）： 1. %K：用于动态传入属性名  %@：用于动态设置属性值 （ %K %@ 用于字符串操作）  2. %K > $VALUE （%K $VALUE 用于数值比较操作，$VALUE是一个可以动态变化的值，它其实最后是在字典中的一个key，所以可以根据你的需要写不同的值，但是必须有$开头，随着程序改变$VALUE这个谓词表达式的比较条件就可以动态改变。使用时，VALUE需要先设置VALUE对应哪个属性 [predTemp predicateWithSubstitutionVariables:@{@"VALUE" : @32}]）
 
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
//        NSRegularExpression
        let operate: String
        if let right = t {
            
            if f > right {
                operate = ""
            } else if f == right {
//                operate = "\(property) == \(f)"
                operate = "\(property) between {\(f), \(right)}"
            } else {
                operate = "\(property) >= \(f) && \(property) <= \(right)"
                
//                operate = "\(property) between {\(f), \(right)}"
            }
        } else {
            operate = "\(property) >= \(f)"
        }
        
        let predicate = NSPredicate.init(format: operate)
        
//        let predicate = NSPredicate.init(format: "%K > %d", property, f)
        
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
//        let predicate = NSPredicate.init(format: operate)
        
         let predicate = NSPredicate.init(format: "%K contains %@", property, str)
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
    
//    open static func isProperyContainedInArray(property: String, in array: [String]) -> NSPredicate {
//        
//        let operate  = String(format: "\(property) in %@", array) // "\(property) in  }"
//        let predicate = NSPredicate.init(format: operate)
//        return predicate
//    }
    
}
