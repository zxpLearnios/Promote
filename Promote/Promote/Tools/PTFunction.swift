//
//  PTGlobalFunction.swift
//  Promote
//
//  Created by Bavaria on 30/03/2018.
//  全局函数

import UIKit
import Foundation

/**
 * 0. 在子线程里延迟，延迟结束后立马回到主线程异步执行
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

/**
 * 1. 在子线程异步执行
 */
func asyncExecuteInSubThread(_ after: Double, callback: @escaping () -> ()) {
    let dgQueue = DispatchQueue.global()
    dgQueue.async {
        callback()
    }
}

@discardableResult func asyncExecuteInSubThread(_ after: Double, callback: @escaping (_ thrad: Thread) -> ()) {
    var thd: Thread!

    let dgQueue = DispatchQueue.global()
    dgQueue.async {
        thd = Thread.current
        callback(thd)
    }
}

/**2. 在主线程异步执行
 */
func asyncExecuteInMainThread(_ after: UInt64, callback: @escaping () -> ()) {
    let time = DispatchTime.init(uptimeNanoseconds: after)
    DispatchQueue.main.asyncAfter(deadline: time) {
        callback()
    }
    
    
}

/**
 * 3. 颜色
 */
func ColorRGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor.init(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

