//
//  PTTestOffScreenRenderViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/7/17.
//  离屏渲染

/*
 屏幕渲染有如下三种：
 
 GPU中的屏幕渲染：
 
 1、On-Screen Rendering
 意为当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行
 
 2、Off-Screen Rendering
 意为离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
 
 3、CPU中的离屏渲染（特殊离屏渲染，即不在GPU中的渲染）
 如果我们重写了drawRect方法，并且使用任何Core Graphics的技术进行了绘制操作，就涉及到了CPU渲染
 */

import UIKit
import Cartography


class PTTestOffScreenRenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gayView = UIView()
        let btn = UIButton()
        let lab = UILabel()
        let imgV = UIImageView()
        let drawView = PTTestDrawIsCanOffScreenRender()
        let maskView = UIView()
        
        addSubview(gayView)
        addSubview(btn)
        addSubview(lab)
        addSubview(imgV)
        addSubview(drawView)
        addSubview(maskView)
        
        imgV.backgroundColor = .red
        gayView.backgroundColor = .gray
        btn.setTitle("按钮的情况", for: .normal)
        lab.text = "label的情况"
        btn.backgroundColor = .gray
        lab.backgroundColor = .gray
        
        // 不会产生离屏渲染
        //        gayView.layer.cornerRadius = 20
        //        gayView.layer.masksToBounds = true
        
        // 加上 shadowPath后就不会产生离屏渲染
        //        gayView.layer.shadowColor = UIColor.red.cgColor
        //        gayView.layer.shadowOpacity = 0.7
        // Core Animation会去自动计算，这就会触发离屏渲染。如果人为指定了阴影路径，就可以免去计算，从而避免产生离屏渲染
        //        gayView.layer.shadowPath = UIBezierPath.init(rect: gayView.bounds).cgPath
        
        // 按钮直接设置就会有圆角，且不会产生离屏渲染
//        btn.layer.cornerRadius = 10
//
//        // label 这样不会产生离屏渲染
//        lab.layer.cornerRadius = 10
//        lab.layer.masksToBounds = true
        // 设置开启光栅化，会导致离屏渲染
//        lab.layer.cornerRadius = 10
//        lab.layer.masksToBounds = true
//        // 开启光栅化将圆角缓存起来
//        lab.layer.shouldRasterize = true
        
        // ios 9后imgV这样设置即可实现圆角，且不会产生离屏渲染
//        imgV.layer.cornerRadius = 10
        // 不会产生离屏渲染
//        imgV.image = #imageLiteral(resourceName: "base_chat_cancleAudio")
//        imgV.layer.cornerRadius = 50
//        imgV.clipsToBounds = true

        maskView.backgroundColor = .gray
        let showView = UIView(frame: CGRect(x: 10, y: 10, width: 140, height: 40))
        showView.backgroundColor = .red
        maskView.mask = showView
        
        
        let grayLayer = CALayer()
        grayLayer.backgroundColor = UIColor.gray.cgColor
        view.layer.addSublayer(grayLayer)
        grayLayer.frame = CGRect.init(x: 50, y: 90, width: 200, height: 30)
        // layer 的contens必须是CGImage才会显示
        let grayLayerContentImg = #imageLiteral(resourceName: "base_chat_cancleAudio").cgImage
        grayLayer.contents = grayLayerContentImg
        
        // 设置圆角可以使用CAShapelayer + UIBeziPath 或 上下文
        // 即使是动态变化的视图,开启 Rasterization 后能够有效降低 GPU 的负荷,不过在动态视图里是否启用还是看 Instruments 的数据。
        
        // 滑动时若需要圆角效果，开启光栅化。
        
        
        constrain(gayView, btn, lab, imgV, drawView, maskView) { (v, btn, lab, imgV, dv, msk) in
            let sv = v.superview!
            
            v.left == sv.left + 100
            v.top == sv.top + 130
            v.width == 100
            v.height == 100
            
            btn.top == v.bottom + 10
            btn.centerX == v.centerX
            lab.centerX == v.centerX
            lab.top == btn.bottom + 10
            
            btn.width == 100
            lab.width == 100
            
            imgV.left == sv.left
            imgV.top == lab.bottom + 10
            imgV.width == imgV.height
            imgV.width == 50
            
            dv.left == imgV.right + 10
            dv.top == imgV.top
            dv.width == 100
            dv.height == 100
            
            
            msk.width == 200
            msk.height == 50
            msk.top == dv.bottom + 10
            msk.centerX == sv.centerX
            
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


fileprivate class PTTestDrawIsCanOffScreenRender: UIView {
    
    let operation = BlockOperation()
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .gray
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let ctx = UIGraphicsGetCurrentContext() {
            
            DispatchQueue.global().async {
                
                ctx.setStrokeColor(UIColor.red.cgColor)
                asyncExecuteInMainThread(2, callback: {
                    ctx.move(to: .zero)
                    ctx.addLine(to: CGPoint(x: 20, y: 40))
                    ctx.strokePath()
                })
            }
            
            
        }
      
        
    }
    
}


