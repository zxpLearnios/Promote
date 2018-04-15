//
//  NSObject+extention.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//     运行时 runtime

import UIKit
import RxSwift


var disposeKey = 0 // "" 亦可

extension NSObject {
    var disposeBag: DisposeBag {
        get {
            var obj = objc_getAssociatedObject(self, &disposeKey) as? DisposeBag
            if obj == nil {
                obj = DisposeBag.init() // disposeBagObj
                objc_setAssociatedObject(self, &disposeKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return  obj!
        }
        set {
            objc_sync_enter(self)
            objc_setAssociatedObject(self, &disposeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_sync_exit(self)
        }
    }
    
    
}
