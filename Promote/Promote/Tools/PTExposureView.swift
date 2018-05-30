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
    let hintGroupAnimate = CAAnimationGroup()
    let keyframeAnimate = CAKeyframeAnimation.init(keyPath: "transform.scale")
    let animatekey = "ptexposureView_groupAnimate_key"
    let hintLayer = CALayer()
    var timer: Timer!
    var timelength = 0
    
    convenience init() {
        self.init(frame: .zero)
        timer = Timer.init(timeInterval: 1, repeats: true, block: {[weak self] (_) in
            self?.timelength += 1
        })
        setupOther()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if subviews.count != 0 {
            return
        }
        setup()
    }
    
    func setup() {
        let width = self.bounds.size.width
        entityLayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        entityLayer.position = center
        entityLayer.backgroundColor = UIColor.clear.cgColor
        entityLayer.path = UIBezierPath(ovalIn: entityLayer.bounds).cgPath
        entityLayer.fillColor = UIColor.blue.cgColor
        entityLayer.opacity = Float(0.8)
        

        hintLayer.backgroundColor = UIColor.blue.cgColor
        hintLayer.bounds = CGRect.init(x: 0, y: 0, width: 50*6, height: 50*6)
        hintLayer.position = center
        hintLayer.cornerRadius = 150
        entityLayer.opacity = 0.2
        delay(3) {
            self.layer.addSublayer(self.hintLayer)
        }
        
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
        let opacityAnimate = CABasicAnimation(keyPath: "opacity")
        opacityAnimate.fromValue = 0.8
        opacityAnimate.toValue = 0.2
        
        let scaleAnimate = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = CGPoint.init(x: 1, y: 1)
        scaleAnimate.toValue = CGPoint.init(x: 6, y: 6)
        scaleAnimate.delegate = self
        
        groupAnimate.animations = [opacityAnimate,scaleAnimate]
        groupAnimate.duration = 3
//        groupAnimate.beginTime = CACurrentMediaTime() + 1
        groupAnimate.delegate = self
        groupAnimate.autoreverses = false  // 循环效果
        groupAnimate.isRemovedOnCompletion = true
        groupAnimate.repeatCount = HUGE
        // 动画执行完成后保持最新的效果
//        groupAnimate.fillMode = kCAFillModeBoth
        
        groupAnimate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        
        
        
        hintGroupAnimate.animations = [opacityAnimate,scaleAnimate]
        hintGroupAnimate.duration = 3
        //        groupAnimate.beginTime = CACurrentMediaTime() + 1
        hintGroupAnimate.delegate = self
        hintGroupAnimate.autoreverses = false  // 循环效果
        hintGroupAnimate.isRemovedOnCompletion = true
        hintGroupAnimate.repeatCount = 1
        // 动画执行完成后保持最新的效果
        groupAnimate.fillMode = kCAFillModeBoth
        
        groupAnimate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        
//        entityLayer.add(groupAnimate, forKey: animatekey)
        
        
//        delay(1) {
//            self.layer.addSublayer(l1)
//            l1.add(self.groupAnimate, forKey: self.animatekey)
//        }
//        delay(2) {
//            self.layer.addSublayer(l2)
//        }
        
    }
    
    func startAnimate() {
//        hintLayer.add(hintGroupAnimate, forKey: animatekey)
        entityLayer.add(groupAnimate, forKey: animatekey)
    }
    
    func stopAnimate() {
        if self.timelength % 3 == 0 {
            entityLayer.removeAnimation(forKey: animatekey)
        }
        
        
    }
    
    deinit {
        debugPrint("PTExposureView 释放了")
    }
    
}

extension PTExposureView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        debugPrint("33333")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
    
}


