//
//  UIImageView+extension.swift
//  Promote
//
//  Created by bavaria on 2018/4/14.
//

import UIKit


extension UIImageView {
    
    /**
     *  在UIImageView上面直接剪切它
     */
    func clipImage<T>(with path: T) {
        
        var beziPath = UIBezierPath()
        if T.self == CGPath.self || T.self == CGMutablePath.self {
            beziPath.cgPath = path as! CGPath
        } else if T.self == UIBezierPath.self {
            beziPath = path as! UIBezierPath
        }
        let shpl = CAShapeLayer.init()
        shpl.path = beziPath.cgPath
        layer.mask = shpl
    }
    
}
