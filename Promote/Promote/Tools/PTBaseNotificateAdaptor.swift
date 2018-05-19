//
//  PTBaseNotificateAdaptor.swift
//  Promote
//
//  Created by bavaria on 2018/5/19.
//

import UIKit

class PTBaseNotificateAdaptor {

    private(set) var observerAndNotifateNameKeyValues = [String]()
    
    static func addNotification(with observer: AnyObject, method: Selector, notificateName name: NSNotification.Name?) {
        
//        let observerAndNotifateNameStr = "\(observer.classForCoder)" + "\(method)"
        kNotificationCenter.addObserver(observer, selector: method, name: name, object: nil)
    }
    
    static func removeNotification(with observer: Any, notificateName name: NSNotification.Name?) {
        kNotificationCenter.removeObserver(observer, name: name, object: nil)
    }
}
