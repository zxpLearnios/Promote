//
//  PTTestScreenRotationViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/8/28.
//  屏幕旋转屏幕

import UIKit
import Cartography


class PTTestScreenRotationViewController: PTBaseViewController {
    
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // 先设置未知，防止设置失败
        PTDeviceManager.screenOritation = .unknown
        PTDeviceManager.screenOritation = .landscapeLeft
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isStatusBarHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PTDeviceManager.screenOritation = .portrait
    }
    
    
    
    func setup() {
        addSubview(label)
        label.text = "24234"
        constrain(label) { (lb) in
            let sv = lb.superview!
            lb.center == sv.center
        }
    }

}
