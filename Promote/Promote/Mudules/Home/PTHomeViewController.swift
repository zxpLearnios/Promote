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
    
    let ary: [String] = {
       let a = ["000", "1111111", "22", "333", "444", "555555", "6", "7777"]
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        doThing()
        
    }

    func doThing() {
        
        titleScroller = PTTitleScroller.init(frame: CGRect.init(x: 0, y: 200, width: kwidth, height: 40))
        addSubview(titleScroller)
        titleScroller.dataSource = ary
        
    }
    
}

