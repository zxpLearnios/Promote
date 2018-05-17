//
//  PTHomeViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//  分段、可点击的跑马灯，自动循环滚动
//  网上看了使用2个label或自定义横向滚动列表来实现跑马灯效果的，虽然第一种有人也实现了分段、可点击。但是个人感觉还是使用系统自带的CollectionView比较好，因为系统实现了缓存池，个人实现的话，涉及到的东西太多太多。经测试，旋转tableview再旋转tableviewcell是实现不了这样的效果的且连UI都很难实现。故最终使用一个collectionview来实现，类似于banner的实现

import UIKit
import Cartography
import WebKit

class PTHomeViewController: PTBaseViewController {

    var titleScroller: PTTitleScroller!
    var richTitleScroller: PTRichTitleScroller!
    let fileLookVc = PTFilePreviewController()
    var documentInteractorVc: PTDocumentViewController!
    
    let sptView = PTExposureView()
    
    let ary: [String] = {
       let a = ["000", "11"] //, "22", "333", "4444444", "5"]
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
//        doThing()
//        setSubviews()
        
        testRichLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        PTRouter.reShowTabBar()
    }
    
    func testRichLabel() {
        
        let richLab = PTRichLabel()
        addSubview(richLab)
        constrain(richLab) { (lab) in
            let sv = lab.superview!
            lab.center == sv.center
            lab.width <= 200
        }
    }
    
    
    func setSubviews() {
        
        // 1. 测试safeArea扩展
        let btn = UIButton()
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        addSubview(btn)
        constrain(btn) { btn in
            btn.width == 200
            btn.height == 200
            btn.top == safeAreaTop + 5
            btn.left == safeAreaLeft + 5
        }
        
        
       // 2.
        let img =  #imageLiteral(resourceName: "bg")
        let imagV = UIImageView.init(image: img)
        addSubview(imagV)
        imagV.backgroundColor = .white
        
        let beziPath = UIBezierPath()
        beziPath.move(to: CGPoint(x: 5, y: 100))
        beziPath.addLine(to: CGPoint.init(x: 100, y: 80))
        beziPath.addLine(to: CGPoint.init(x: 70, y: 150))
        beziPath.addLine(to: CGPoint.init(x: 5, y: 100))
        imagV.clipImage(with: beziPath)
        
        // 3.
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "点击", style: .plain, target: self, action: #selector(leftItemAction))
    }
    
    private func doThing() {
        
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
//        delay(2) {
            // 2.4.0
//              self.richTitleScroller.dataSource = self.ary + ["3"]
            // 2.4.1
//            self.richTitleScroller.dataSource = self.ary + ["这是", "新加的数据", "是", "为了测试在异步情况下", "该框架的性能与效果如何？", "看来，不错！"]
            
//        }
        
        // 2.5 
        delay(4) {
            self.richTitleScroller.dataSource = self.ary +  ["这是", "新加的数据", "是", "为了测试在异步情况下", "该框架的性能与效果如何？", "看来，不错！"]
        }
        
        delay(6) {
            self.richTitleScroller.dataSource = self.ary
        }
        
        
    }
    
    @objc private  func leftItemAction() {
        
        
        
        sptView.stopAnimate()
        return
       // 2.
        let path = PTBaseBundle.loadFile(name: "ios.pdf")
        let url = URL.init(fileURLWithPath: path)
        documentInteractorVc = PTDocumentViewController.init(self, fileUrl: url)
        
        // 3.
//        let ary = ["guideImage1", "guideImage1.png", "task@2x", "snapshot", "ios.pdf"]
//        fileLookVc.filePaths = ary //["guideImage1@2x.png"] // ["ios.pdf"]
        
//       let nav = UINavigationController.init(rootViewController: fileLookVc)
       
//                navigationController?.pushViewController(fileLookVc, animated: true)
//        present(fileLookVc, animated: false, completion: nil)
    }
    
    @objc private func clickAction() {
        let webVc = PTBaseWebViewController()
        let file = PTBaseBundle.loadImage(name: "ios.pdf")
        navigationController?.pushViewController(webVc, animated: true)
        // 加载本地文件 、网络文件
         webVc.urlString = file //"https://blog.csdn.net/u010105969/article/details/53942862"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            self?.navigationController?.navigationBar.transform = CGAffineTransform.init(translationX: 0, y: -44)
//        }
        
//        let vc = PTBaseListController()
        
//        sptView.backgroundColor = .white
//        addSubview(sptView)
//        sptView.frame = view.bounds
//        sptView.startAnimate()
        
    }
    
    deinit {
        
    }
    
}




