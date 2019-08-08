//
//  PTIconManager.swift
//  Promote
//
//  Created by 张净南 on 2018/9/1.
//

import UIKit

class PTIconManager: NSObject {

    
    static func isSupportAlternate() -> Bool {
        if #available(iOS 10.3, *) {
            if kApplication.supportsAlternateIcons {
                PTPrint("支持icon的更改")
                return true
            } else {
                PTPrint("不支持icon的更改")
                return false
            }
        } else {
            PTPrint("ios系统版本低，不支持icon的更改")
            return false
        }
    }
}
