//
//  UIView+extension.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.

import UIKit

extension UIView{

    /**  x值 */
    var x:CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
        
    }
    
    /**  y值 */
    var y:CGFloat {
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






