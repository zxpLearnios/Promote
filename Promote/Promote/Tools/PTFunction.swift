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


func PTPrint(_ items: Any...) {
    #if DEBUG
    debugPrint(items)
    #else
    #endif
}

// -----------  coreText 专用 ------------ //
func deallocFunc(ref: UnsafeMutableRawPointer) -> Void {
}

func widthFunc(ref: UnsafeMutableRawPointer) -> CGFloat {
    let sObj = ref.assumingMemoryBound(to: [String: CGFloat].self)
    let dicPointee = sObj.pointee
    if let width = dicPointee["width"] {
        return width
    }
    return 0
}

func ascentFunc(ref: UnsafeMutableRawPointer) -> CGFloat {
    //            let x = ref.bindMemory(to: [String: CGFloat].self, capacity: 1)
    // 由指针获取swift对象
    let sObj = ref.assumingMemoryBound(to: [String: CGFloat].self)
    let dicPointee = sObj.pointee
    if let height = dicPointee["height"] {
        return height
    }
    return 0
}

func descentFunc(ref: UnsafeMutableRawPointer) -> CGFloat {
    return 0
}

// -------     //

func getAppBundleId() -> String {
    return  kbundle.infoDictionary!["CFBundleIdentifier"] as! String
}

// MARK: 打印内存地址
func PTPrintMemoryAddressForAnyObject(_ obj: AnyObject) {
    let address = Unmanaged<AnyObject>.passUnretained(obj as AnyObject).toOpaque()
    PTPrint(address)
}

