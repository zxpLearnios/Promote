//
//  NSObject+extention.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//  

import UIKit
import RxSwift


let disposeBagObj = DisposeBag()
var disposeKey = "dispose_Key"

extension NSObject {
    var disposeBag: DisposeBag {
        get {
            var obj = objc_getAssociatedObject(self, &disposeKey) as? DisposeBag
            if obj == nil {
                obj = disposeBagObj
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
