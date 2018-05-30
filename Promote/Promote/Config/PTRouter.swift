//
//  PTRouter.swift
//  Promote
//
//  Created by bavaria on 2018/4/20.
//

import UIKit

class PTRouter: NSObject {

    
    static func push(viewController: UIViewController) {
        let rootVc = kwindow!.rootViewController!
        var nav: UINavigationController!
        
        if rootVc.classForCoder == PTTabBarController.self {
            if let tabBarVc = rootVc as? UITabBarController {
                if let selectVc = tabBarVc.selectedViewController {
                    if selectVc.classForCoder == UINavigationController.self {
                        nav = selectVc as! UINavigationController
                    }
                }
            }
        } else if rootVc.classForCoder == UINavigationController.self {
            nav = rootVc as! UINavigationController
        }
        
        guard nav == nil else {
            nav.pushViewController(viewController, animated: true)
            return
        }
        
    }
    
    /**
     *  重新显示tabbar
     */
    static func reShowTabBar() {
        let rootVc = kwindow!.rootViewController!
        
        if rootVc.classForCoder == PTTabBarController.self {
            let tabBarVc = rootVc as! UITabBarController
            tabBarVc.tabBar.isHidden = false
        }
            
    }
    
    
    /**
     * 设置主控制器
     */
    static func setRootViewController(viewController vc: UIViewController) {
        kwindow!.rootViewController = vc
        kwindow?.makeKeyAndVisible()
    }
    
}


