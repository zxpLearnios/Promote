//
//  PTExposureView.swift
//  Promote
//
//  Created by bavaria on 2018/5/12.
//  雷达辐射 动画

import UIKit

class PTExposureView: UIView {

    let entityLayer = CAShapeLayer() 
    let groupAnimate = CAAnimationGroup()
    let keyframeAnimate = CAKeyframeAnimation.init(keyPath: "transform.scale")
    let animatekey = "ptexposureView_groupAnimate_key"
    
    convenience init() {
        self.init(frame: .zero)
//        setupOther()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if subviews.count != 0 {
            return
        }
//        setup()
    }
    
    func setup() {
        let width = self.bounds.size.width
        entityLayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        entityLayer.position = center
        entityLayer.backgroundColor = UIColor.clear.cgColor
        entityLayer.path = UIBezierPath(ovalIn: entityLayer.bounds).cgPath
        entityLayer.fillColor = UIColor.blue.cgColor
        entityLayer.opacity = 0.8
        

        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        replicatorLayer.position = CGPoint(x: width/2, y: width/2)
        replicatorLayer.instanceCount = 4  // 三个复制图层
        replicatorLayer.instanceDelay = 1  // 频率
        replicatorLayer.addSublayer(entityLayer)
        self.layer.addSublayer(replicatorLayer)
        self.layer.insertSublayer(replicatorLayer, at: 0)
        
    }
    
    func setupOther() {
        
        let l = CALayer()
        l.backgroundColor = UIColor.red.cgColor
        
        let l1 = CALayer()
        l1.backgroundColor = UIColor.red.cgColor
        l.bounds = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        l.position = center
        
        l1.bounds = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        l1.position = center
        
        l.cornerRadius = 25
        l1.cornerRadius = 25
        
        
        l.opacity = 0.8
        l1.opacity = 0.8
        
        
        let l2 = CALayer()
        l2.backgroundColor = UIColor.red.cgColor
        l2.bounds = CGRect.init(x: 0, y: 0, width: 50 * 6, height: 50 * 6)
        l2.position = center
        l2.cornerRadius = 25 * 6
        l2.opacity = 0.2
        
        layer.addSublayer(l)
        
        let opacityAnimate = CABasicAnimation(keyPath: "opacity")
        opacityAnimate.fromValue = 0.8
        opacityAnimate.toValue = 0.2
        
        let scaleAnimate = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = CGPoint.init(x: 1, y: 1)
        scaleAnimate.toValue = CGPoint.init(x: 6, y: 6)
        
        groupAnimate.animations = [opacityAnimate,scaleAnimate]
        groupAnimate.duration = 2
        groupAnimate.autoreverses = false  // 循环效果
        groupAnimate.isRemovedOnCompletion = false
        groupAnimate.repeatCount = HUGE
        // 动画执行完成后保持最新的效果
//        groupAnimate.fillMode = kCAFillModeBoth
        
        groupAnimate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        
       
        l.add(groupAnimate, forKey: animatekey)
        delay(1) {
            self.layer.addSublayer(l1)
            l1.add(self.groupAnimate, forKey: self.animatekey)
        }
        delay(2) {
            self.layer.addSublayer(l2)
        }
        
    }
    
    func startAnimate() {
        entityLayer.add(groupAnimate, forKey: animatekey)
    }
    
    func stopAnimate() {
        entityLayer.removeAnimation(forKey: animatekey)
    }
}
