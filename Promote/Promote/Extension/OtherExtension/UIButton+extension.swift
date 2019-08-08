//
//  UIButton+extension.swift
//  TestNormal
//
//  Created by Bavaria on 2019/8/8.
//  Copyright © 2019 Bavaria. All rights reserved.
//  暂时解决不了 UITabBarButton crash，此分类暂时不能使用. reason: '-[UITabBarButton ex_sendAction:to:for:]: unrecognized selector sent to instance 0x7fa58d514380'

import UIKit

private var tapTimeIntervalKey = 0
private var tapEnableKey = 0

extension UIButton {
    
    /// 当前屏幕正在展示的控制器
    var tapTimeInterval: TimeInterval {
        get {
            var obj = objc_getAssociatedObject(self, &tapTimeIntervalKey) as? TimeInterval
            if obj == nil {
                obj = 2
                objc_setAssociatedObject(self, &tapTimeIntervalKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return  obj!
        }
        set {
            objc_sync_enter(self)
            objc_setAssociatedObject(self, &tapTimeIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_sync_exit(self)
        }
    }
    
    
    
    var tapEnable: Bool {
        get {
            var obj = objc_getAssociatedObject(self, &tapEnableKey) as? Bool
            if obj == nil {
                obj = false
                objc_setAssociatedObject(self, &tapEnableKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return  obj!
        }
        set {
            objc_sync_enter(self)
            objc_setAssociatedObject(self, &tapEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_sync_exit(self)
        }
    }
    
    
    
    
    static func swiftLoad() {
        if self == UIButton.self {
            let selector = #selector(UIButton.sendAction(_:to:for:))
            let selector1 = #selector(UIButton.ex_sendAction(_:to:for:))
            
            let oldFunc = class_getInstanceMethod(UIButton.self, selector)!
            let newFunc = class_getInstanceMethod(self, selector1)!
            
            let isTrue = class_addMethod(self, selector1, method_getImplementation(oldFunc), method_getTypeEncoding(oldFunc))
            
            if isTrue{
                class_replaceMethod(self, selector1, method_getImplementation(oldFunc), method_getTypeEncoding(oldFunc))
            } else {
                method_exchangeImplementations(oldFunc, newFunc)
            }
        }
    }
    
    
    
    //------------------ private -------------------
    @objc dynamic private func ex_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if !tapEnable {
            tapEnable = true
            ex_sendAction(action, to: target, for: event)
            self.perform(Selector(("changeTapEnable")), with: nil, afterDelay: tapTimeInterval)
        }
    }
    
    
    @objc dynamic private func changeTapEnable() {
        tapEnable = false
    }
    
    
}
