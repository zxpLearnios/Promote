//
//  PTUIViewController+extension.swift
//  Promote
//
//  Created by Bavaria on 27/03/2018.
//

import UIKit

extension UIViewController {
    
    /**
     通过SB加载控制器, 最后转换， 如： as QLRegisterViewController（这种使用泛型的情况）
     */
    class func load<T>(withStoryBoardName name:String) -> T {
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: name) as! T
        return vc
    }
    
    /**
     * 给控制器添加子view
     */
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
}
