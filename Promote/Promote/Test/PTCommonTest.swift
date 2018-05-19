//
//  PTCommonTest.swift
//  Promote
//
//  Created by bavaria on 2018/4/27.
//

import UIKit

class PTCommonTest {

    
    init() {
//        let a = sortArray()
        
        do {
            let result = try testThrow()
        } catch let err {
            debugPrint("\(err)")
        }
    }
    
    /**
     * 0. 方法后缀throws，表示此法须使用try catch样式
     */
    func testThrow() throws -> Bool {
        return true
    }
    
    
    /**
     *  1. 将一给定数组里的相同元素放在一个数组里
     */
    func sortArray() -> [[String]] {
        let originAry = ["1", "22", "s", "1", "a", "1", "32", "32", "aa", "s", "s", "22"]
        
//        var indexs = [Int]() // [[String: Int]]()
        var elements = [String]()
        var mutiplySpaceAry = [[String]]()
        
        for i in 0..<originAry.count {
            let element = originAry[i]
            if i == 0 {
                elements.append(element)
                let subAry = [String].init(arrayLiteral: element)
                mutiplySpaceAry.append(subAry)
            } else {
                if elements.contains(element) { // 有相同元素
                    let index = elements.index(of: element)!
                    var subAry = mutiplySpaceAry[index]
                    subAry.append(element)
                    mutiplySpaceAry.remove(at: index)
                    mutiplySpaceAry.insert(subAry, at: index)
                } else {
                    elements.append(element)
                    let subAry = [String].init(arrayLiteral: element)
                    mutiplySpaceAry.append(subAry)
                }
            }
        }
       return mutiplySpaceAry
    }
    
}
