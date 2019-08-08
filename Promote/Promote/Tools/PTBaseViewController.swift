//
//  PTBaseViewController.swift
//  Promote
//
//  Created by Bavaria on 28/03/2018.
//

import UIKit

class PTBaseViewController: UIViewController {

    /// 控制状态栏的隐藏与显示
    var isStatusBarHidden = false {
        didSet {
            if let statusBarWindow = kApplication.value(forKey: "statusBarWindow") as? UIWindow {
                if let statusBar = statusBarWindow.value(forKey: "statusBar") as? UIView {
//                    statusBar.setValue(isStatusBarHidden, forKey: "hidden")
//                    statusBar.setValue(1, forKey: "alpha")
//                    UIView.animate(withDuration: 0.3) {
//                        statusBar.alpha = 1
//                        statusBar.isHidden = false
//                    }
                }
            }
            
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
//    override func setNeedsStatusBarAppearanceUpdate() {
//        super.setNeedsStatusBarAppearanceUpdate()
//    }
    
    /// 重写此get属性
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    


}
