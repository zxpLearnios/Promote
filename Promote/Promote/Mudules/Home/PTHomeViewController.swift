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
        doThing()
        
    }

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

