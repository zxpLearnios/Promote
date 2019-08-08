//
//  PTPopMessageContainerView.swift
//  Promote
//
//  Created by 张净南 on 2018/10/23.
//  1. view.layer.presentationLayer 用来显示动画（属性随动画过程慢慢改变）2、view.layer 用来处理用户交互（动画一开始属性值已经改变到动画结束时的状态）这就是为什么label平移时，上面添加的点击手势无法触发的原因。

import UIKit

class PTPopMessageContainerView: UIView {

//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        var hitTestView = super.hitTest(point, with: event)
//        for subview in subviews {
//            if subview is PTTapLabel {
//                if subview.frame.contains(point) {
//                    hitTestView = subview
//                }
//            }
//        }
//        return hitTestView
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as! UITouch)
        let point = touch.location(in: self)
        
        for subview in subviews {
            if subview is PTPopMessageLabel {
                let tapLab = subview as! PTPopMessageLabel
                let newPoint = convert(point, to: tapLab)
                // 做动画时才有
                if let tapLabelShowLayer = tapLab.layer.presentation(), tapLabelShowLayer.frame.contains(point){
                    tapLab.tapClosure?(tapLab)
                }
                
            }
        }
    }

}
