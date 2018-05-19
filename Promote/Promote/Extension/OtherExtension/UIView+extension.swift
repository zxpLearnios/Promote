//
//  UIself+extension.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  使用Cartography，为view增加安全区域属性，区别于系统自带的

import UIKit
import Cartography

extension UIView {
    
    /** 安全区域: 上 */
    var safeAreaTop: Edge {
        if #available(iOS 11.0, *) {
            return self.asProxy().safeAreaLayoutGuide.top
        } else {
            return self.asProxy().top
        }
    }
    
    /** 安全区域: 左 */
    var safeAreaLeft: Edge {
        if #available(iOS 11.0, *) {
            return self.asProxy().safeAreaLayoutGuide.left
        } else {
            return self.asProxy().left
        }
    }
    
    /** 安全区域: 下 */
    var safeAreaBottom: Edge {
        if #available(iOS 11.0, *) {
            return self.asProxy().safeAreaLayoutGuide.bottom
        } else {
            return self.asProxy().bottom
        }
    }
    
    /** 安全区域: 右 */
    var safeAreaRight: Edge {
        if #available(iOS 11.0, *) {
            return self.asProxy().safeAreaLayoutGuide.right
        } else {
            return self.asProxy().right
        }
    }
    
    /**  x值 */
    var x: CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
        
    }
    
    /**  y值 */
    var y: CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
        
    }
    
    /**  宽度 */
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }

    }

    /**  高度 */
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }

    }

    
}






