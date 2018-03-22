//
//  PromoteProtocol+extension.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  对UIView类型在PromoteProtocol下进行扩展

import UIKit

// 1.
//extension UIView :ShakeAble {}
extension UIView: PromoteProtocol {}

// 2.
//extension UIView: PromoteProtocol {
//    public typealias Associatedtype = UIImageView
//    public var ele: UIImageView {
//        return UIImageView.init()
//    }
//}

// --------------- 扩展协议，限制特定功能在特定类里
//extension PromoteProtocol where Self: UIView {
//
//    func shake() {
//        layer.removeAllAnimations()
//        let animate = CABasicAnimation(keyPath: "position")
//        animate.duration = 0.05
//        animate.repeatCount = 5
//        animate.autoreverses = true
//        animate.fromValue =
//            NSValue(cgPoint: CGPoint(x: self.center.x - 4.0, y: self.center.y))
//        animate.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4.0, y: self.center.y))
//
//        layer.add(animate, forKey: "position")
//    }
//
//    func scale() {
//        layer.removeAllAnimations()
//        UIView.animate(withDuration: 2) {
//            self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0)
//        }
//    }
//}

// 2. 扩展抽象类，给特定的类以特定的行为
extension Promote where Base: UIView {
 
    func shake() {
        base.layer.removeAllAnimations()
        let animate = CABasicAnimation(keyPath: "position")
        animate.duration = 0.05
        animate.repeatCount = 5
        animate.autoreverses = true
        animate.fromValue =
            NSValue(cgPoint: CGPoint(x:  base.center.x - 4.0, y:  base.center.y))
        animate.toValue = NSValue(cgPoint: CGPoint(x:  base.center.x + 4.0, y:  base.center.y))
         base.layer.add(animate, forKey: "position")
    }
 
    func scale() {
        base.layer.removeAllAnimations()
        UIView.animate(withDuration: 2) { [weak self] in
            self?.base.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0)
        }
    }
}

