//
//  PTHomeViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//  分段、可点击的跑马灯，自动循环滚动
//  网上看了使用2个label或自定义横向滚动列表来实现跑马灯效果的，虽然第一种有人也实现了分段、可点击。但是个人感觉还是使用系统自带的CollectionView比较好，因为系统实现了缓存池，个人实现的话，涉及到的东西太多太多。经测试，旋转tableview再旋转tableviewcell是实现不了这样的效果的切连UI都很难实现。故最终使用一个collectionview来实现，类似于banner的实现

import UIKit
import Cartography


class PTHomeViewController: PTBaseViewController {

    var titleScroller: PTTitleScroller!
    var richTitleScroller: PTRichTitleScroller!
    
    let ary: [String] = {
       let a = ["000", "11"] //, "22", "333", "4444444", "5"]
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
//        doThing()
        
        
        let view1 = MyImgView.init(image: #imageLiteral(resourceName: "bg"))
        view1.backgroundColor = .white
        view1.frame = self.view.bounds
        self.view.addSubview(view1)
        
    }
    
//    override func loadView() {
//        super.loadView()
//        view = MyImgView() //(image: #imageLiteral(resourceName: "bg"))
//    }

   
    
    func doThing() {
        
        // 1. normal
//        titleScroller = PTTitleScroller.init(frame: CGRect.init(x: 0, y: 200, width: kwidth, height: 40))
//        addSubview(titleScroller)
//        titleScroller.dataSource = ary
        
        // 2. rich
        let frame = CGRect.init(x: 0, y: 200, width: kwidth, height: 200)
//        richTitleScroller = PTRichTitleScroller.init(frame: frame)
        richTitleScroller = PTRichTitleScroller.init(with: .left, frame: frame)
        addSubview(richTitleScroller)
        
        // 2.1 先赋空数组
//        richTitleScroller.dataSource = []
        
        // 2.2 先赋非空数组
        richTitleScroller.dataSource = ary
        
        // 2.3
        delay(2) {
            // 2.4.0
//              self.richTitleScroller.dataSource = self.ary + ["3"]
            // 2.4.1
//            self.richTitleScroller.dataSource = self.ary + ["这是", "新加的数据", "是", "为了测试在异步情况下", "该框架的性能与效果如何？", "看来，不错！"]
            
        }
        
        // 2.5 
        delay(4) {
            self.richTitleScroller.dataSource = self.ary +  ["这是", "新加的数据", "是", "为了测试在异步情况下", "该框架的性能与效果如何？", "看来，不错！"]
        }
        
        delay(6) {
            self.richTitleScroller.dataSource = self.ary
        }
        
    }
    
}


/**UIImageView是专门为显示图片做的控件，用了最优显示技术，所以不让调用darwrect方法。所以我们如果写了一个UIImageView的子类里面重写了drawRect方法是不会被调用的*/
class MyImgView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
        
        drawThing()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 因为UIImageView的drawRect方法永远不会调（即使是外部主动setNeedsDisplay也没用），所以，获取不到上下文，故此时需要自行创建
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    private func drawThing() {
        // 因为UIImageView的drawRect方法不会调，所以，获取不到上下文，故此时需要自行创建
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 1)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.move(to: CGPoint(x: 50, y: 500))
            ctx.addLine(to: CGPoint.init(x: 100, y: 300))
            ctx.addLine(to: CGPoint.init(x: 300, y: 400))
            ctx.addLine(to: CGPoint.init(x: 50, y: 500))
            
            UIColor.red.set()
            ctx.setLineWidth(5)
            ctx.strokePath()
            ctx.closePath()
    
            ctx.clip()
            
            let img = UIGraphicsGetImageFromCurrentImageContext()

            //5关闭上下文
            UIGraphicsEndImageContext()

            image = img
            
        }
        
        UIGraphicsEndImageContext()
        
        // 2.
//        let path =  CGMutablePath.init()
//        path.move(to: CGPoint(x: 50, y: 500))
//        path.addLine(to: CGPoint.init(x: 100, y: 300))
//        path.addLine(to: CGPoint.init(x: 300, y: 400))
////        path.addLine(to: CGPoint.init(x: 50, y: 500))
//
//        let beziPath = UIBezierPath.init(cgPath: path)
//
//        let shpl = CAShapeLayer.init()
//        shpl.path = beziPath.cgPath
//        layer.mask = shpl
    }
    
}

