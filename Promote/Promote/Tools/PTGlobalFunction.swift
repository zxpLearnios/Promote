//
//  PTGlobalFunction.swift
//  Promote
//
//  Created by Bavaria on 30/03/2018.
//  全局函数

import UIKit
//import Foundation

/**
 * 在子线程里延迟，延迟结束后立马回到主线程异步执行
 */
func delay(_ time: Double, callback: @escaping () -> ()) {

    let d = DispatchTime.init(uptimeNanoseconds: 0)
    DispatchQueue.global().async {
        Thread.sleep(forTimeInterval: time)
//        debugPrint("当前线程: \(Thread.current)")
        DispatchQueue.main.asyncAfter(deadline: d) {
            callback()
        }
    }
    
    
}
