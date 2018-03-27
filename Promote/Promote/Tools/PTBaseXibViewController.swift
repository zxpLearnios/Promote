//
//  QLBaseXibViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.

import UIKit

class  PTBaseXibViewController: UIViewController {
    
    var nav: UINavigationController! // 导航控制器属性
    
    // 在swift里 控制器的init（构造器）发福利时无法加载xib的， 找不到。
    convenience init(){
        let type = NSStringFromClass(PTBaseXibViewController.classForCoder())
        let name = type.components(separatedBy: ".").last!
        self.init(nibName: name, bundle: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
