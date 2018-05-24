//
//  PTHomeViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//  分段、可点击的跑马灯，自动循环滚动
//  网上看了使用2个label或自定义横向滚动列表来实现跑马灯效果的，虽然第一种有人也实现了分段、可点击。但是个人感觉还是使用系统自带的CollectionView比较好，因为系统实现了缓存池，个人实现的话，涉及到的东西太多太多。经测试，旋转tableview再旋转tableviewcell是实现不了这样的效果的且连UI都很难实现。故最终使用一个collectionview来实现，类似于banner的实现
// ios 11 会出现导航栏的item在push一个控制器在pop回来后变灰的情况，故全部自定义即可解决

import UIKit
import Cartography
import WebKit

class PTHomeViewController: PTBaseViewController {

    var titleScroller: PTTitleScroller!
    var richTitleScroller: PTRichTitleScroller!
    let fileLookVc = PTFilePreviewController()
    var documentInteractorVc: PTDocumentViewController!
    
    let sptView = PTExposureView()
    
    
    let testRealm = PTTestRealm()
    
    let ary: [String] = {
       let a = ["000", "11"] //, "22", "333", "4444444", "5"]
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
//        doThing()
        setSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        PTRouter.reShowTabBar()
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
            btn.top == safeAreaTop + 100
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
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "点击", style: .plain, target: self, action: #selector(leftItemAction))
        // 必须设置frame，不然ios11 以下的不会显示
        let customeLeftItem = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        customeLeftItem.setTitleColor(.black, for: .normal)
//        customeLeftItem.setTitleColor(.black, for: .highlighted)
        customeLeftItem.setTitle("点击", for: .normal)
        customeLeftItem.addTarget(self, action: #selector(leftItemAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customeLeftItem)
        
        // 4. ios 11 右边的item用此法会在pop回来时，此按钮变灰
//         navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "聊天", style: .plain, target: self, action: #selector(rightItemAction))
        let customeRightItem = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        customeRightItem.setTitle("聊天", for: .normal)
        customeRightItem.setTitleColor(.black, for: .normal)
//        customeRightItem.setTitleColor(.black, for: .highlighted)
        customeRightItem.addTarget(self, action: #selector(rightItemAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customeRightItem)
        // 5.
        let realmAddBtn = UIButton(frame: CGRect(x: 20, y: 150, width: 80, height: 30))
        realmAddBtn.setTitle("realm增", for: .normal)
        realmAddBtn.addTarget(self, action: #selector(realmAddAction), for: .touchUpInside)
        
        
        let realmQueryBtn = UIButton(frame: CGRect(x: 150, y: 150, width: 100, height: 30))
        realmQueryBtn.setTitle("realm查", for: .normal)
        realmQueryBtn.addTarget(self, action: #selector(realmQueryAction), for: .touchUpInside)
        
        let realmDeleteBtn = UIButton(frame: CGRect(x: 20, y: realmAddBtn.frame.maxY + 10, width: 100, height: 30))
        realmDeleteBtn.setTitle("realm删", for: .normal)
        realmDeleteBtn.addTarget(self, action: #selector(realmDeleteAction), for: .touchUpInside)
        
        addSubview(realmAddBtn)
        addSubview(realmQueryBtn)
        addSubview(realmDeleteBtn)
        
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
    
    @objc private  func leftItemAction() {
        
        
        let vc = PTBaseChatViewController()
        navigationController?.pushViewController(vc, animated: true)
        
//        sptView.stopAnimate()
        
       // 2.
//        let path = PTBaseBundle.loadFile(name: "ios.pdf")
//        let url = URL.init(fileURLWithPath: path)
//        documentInteractorVc = PTDocumentViewController.init(self, fileUrl: url)
        
        // 3.
//        let ary = ["guideImage1", "guideImage1.png", "task@2x", "snapshot", "ios.pdf"]
//        fileLookVc.filePaths = ary //["guideImage1@2x.png"] // ["ios.pdf"]
        
//       let nav = UINavigationController.init(rootViewController: fileLookVc)
       
//                navigationController?.pushViewController(fileLookVc, animated: true)
//        present(fileLookVc, animated: false, completion: nil)
    }
    
    @objc func rightItemAction() {
       let vc = PTBaseChatViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func clickAction() {
        let webVc = PTBaseWebViewController()
        let file = PTBaseBundle.loadImage(name: "ios.pdf")
        navigationController?.pushViewController(webVc, animated: true)
        // 加载本地文件 、网络文件
         webVc.urlString = file //"https://blog.csdn.net/u010105969/article/details/53942862"
        
    }
    
    
    @objc private func realmAddAction() {
        testRealm.add()
    }
    
    @objc private func realmQueryAction() {
        testRealm.query()
    }
    @objc private func realmDeleteAction() {
        testRealm.delete()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            self?.navigationController?.navigationBar.transform = CGAffineTransform.init(translationX: 0, y: -44)
//        }
        
//        let vc = PTBaseListController()
        sptView.backgroundColor = .white
//        addSubview(sptView)
        sptView.frame = view.bounds
//        sptView.startAnimate()
//        sptView.setupOther()
        
    }
    
    deinit {
        
    }
    
}




