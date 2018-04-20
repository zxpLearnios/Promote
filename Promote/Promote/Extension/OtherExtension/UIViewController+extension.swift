//
//  Promote
//
//  Created by Bavaria on 27/03/2018.
//  为控制器也扩展了，安全区域属性，这本是view的

import UIKit
import Cartography

extension UIViewController {
  
    
    /** 安全区域: 上 */
    var safeAreaTop: Edge { // 也可以返回Expression<Edge>类型，如 return view.asProxy().top + 10，即Expression<Edge>比Edge多了个运算功能
        if #available(iOS 11.0, *) {
             return view.asProxy().safeAreaLayoutGuide.top
        } else {
            return view.asProxy().top
        }
    }
    
    /** 安全区域: 左 */
    var safeAreaLeft: Edge {
        if #available(iOS 11.0, *) {
            return view.asProxy().safeAreaLayoutGuide.left
        } else {
            return view.asProxy().left
        }
    }
    
    /** 安全区域: 下 */
    var safeAreaBottom: Edge {
        if #available(iOS 11.0, *) {
            return view.asProxy().safeAreaLayoutGuide.bottom
        } else {
            return view.asProxy().bottom
        }
    }
    
    /** 安全区域: 右 */
    var safeAreaRight: Edge {
        if #available(iOS 11.0, *) {
            return view.asProxy().safeAreaLayoutGuide.right
        } else {
            return view.asProxy().right
        }
    }
    
    
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
