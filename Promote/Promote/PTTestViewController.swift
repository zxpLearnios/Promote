//
//  PTTestViewController.swift
//  Promote
//
//  Created by bavaria on 2018/4/6.
//

import UIKit

class PTTestViewController: PTBaseViewController {

    var testAry = [""]
    var testAry1 = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 此时此方法会强引用当前对象，使直到遍历结束才会相应其他操作。即此法有严重问题
//        asyncExecuteInMainThread(0) { [weak self] in
//            if let `self` = self {
//                for i in 0 ..< 10000000 {
//                    self.testAry.append("\(i)")
//                }
//            }
//
//        }
        
        
        // 2. 和第一张情况一模一样
//        asyncExecuteInMainThread(0) {
//            for i in 0 ..< 10000000 {
//                self.testAry.append("\(i)")
//            }
//        }
        
        // 3. 完美解决上述问题
        asyncExecuteInSubThread(0) { (currentThread) in
            for i in 0 ..< 10000000 {
                self.testAry.append("\(i)")
                if i == 9999999 {
                    debugPrint("遍历结束了\(self)") // self 有值的
                }
            }
            
            debugPrint("啊====== \(currentThread)")
        }
        
//        debugPrint("=--=-= \(Thread.current)")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("响应了用户的操作")
        
    }
    
}
