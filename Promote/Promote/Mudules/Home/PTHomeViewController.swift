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


protocol PTHomeViewControllerProtocol: class {
    func doThing()
}

class PTHomeViewController: PTBaseViewController {

    var titleScroller: PTTitleScroller!
    var richTitleScroller: PTRichTitleScroller!
    let fileLookVc = PTFilePreviewController()
    var documentInteractorVc: PTDocumentViewController!
    
    var bm: PTBlurredViewManager!
    
    var testClosure: (() -> ())?
    
    weak var delegate: PTHomeViewControllerProtocol!
    
    let ary: [String] = {
       let a = ["000", "11"] //, "22", "333", "4444444", "5"]
        return a
    }()
    
    lazy var testLazyView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        self.view.addSubview(view)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
//        doThing()
//        setSubviews()
        testMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        PTRouter.reShowTabBar()
    }
    
//    override var prefersStatusBarHidden: Bool {
//
//    }
    
    func setSubviews() {
        
        // 1. 测试safeArea扩展
        let btn = PTBaseButton()
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        addSubview(btn)
        constrain(btn) { btn in
            btn.width == 200
            btn.height == 200
            btn.top == safeAreaTop + 100
            btn.left == safeAreaLeft + 5
        }
        
        
       // 2. 测试圆角图片
        let img =  #imageLiteral(resourceName: "bg")
        let imagV = UIImageView(frame: CGRect(x: 50, y: 150, width: 100, height: 100)) // UIImageView.init(image: img)
        addSubview(imagV)
        imagV.backgroundColor = .white
        
        let beziPath = UIBezierPath()
        beziPath.move(to: CGPoint(x: 5, y: 100))
        beziPath.addLine(to: CGPoint.init(x: 100, y: 80))
        beziPath.addLine(to: CGPoint.init(x: 70, y: 150))
        beziPath.addLine(to: CGPoint.init(x: 5, y: 100))
        
        imagV.image = UIImage.cr_image(with: img, size: CGSize(width: 100, height: 100))
//        imagV.clipImage(with: beziPath)
        
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
        // 添加手势，看手势与UIcontrol的touch事件响应情况
        let tap = UITapGestureRecognizer(target: self, action: #selector(customeRightItemTapAction))
        customeRightItem.addGestureRecognizer(tap)
        
        customeRightItem.addTarget(self, action: #selector(rightItemAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customeRightItem)
        // 5. 退出登录
       let loginOutBtn = PTTapLabel()
        loginOutBtn.text = "退出登录"
        addSubview(loginOutBtn)
        constrain(loginOutBtn) { btn in
            btn.centerX == btn.superview!.centerX
            btn.top == btn.superview!.centerY + 30
        }
        
        loginOutBtn.tapClosure = { [weak self] _,_ in
            if let `self` = self {
                //            self.loginOutAction()
                let vc = PTTestOffScreenRenderViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        // 6. 测试 离屏渲染
        
        // 7. 测试coreText
        let coreTextManager = PTCoreTextManager(with: view)
        
        // 8. 测试按钮扩大点击范围
        btn.tapEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
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
    
    private func testMap() {
        
    }
    
    @objc private  func leftItemAction() {
        
        
//        let vc = PTTestViewController() //PTBaseChatViewController()
//        navigationController?.pushViewController(vc, animated: true)
        
//        sptView.stopAnimate()
        
       // 2. 快速预览 展示 文档 pdf
//        let path = PTBaseBundle.loadFile(name: "ios.pdf")
//        let url = URL.init(fileURLWithPath: path)
//        documentInteractorVc = PTDocumentViewController(self, fileUrl: url)
        
        // 3.
        let ary = ["guideImage1", "guideImage1.png", "task@2x", "snapshot", "ios.pdf"]
        fileLookVc.filePaths = ary //["guideImage1@2x.png"] // ["ios.pdf"]
        
//       let nav = UINavigationController.init(rootViewController: fileLookVc)
//        present(nav, animated: false, completion: nil)
//        navigationController?.pushViewController(fileLookVc, animated: true)
        
        
        // 9. 测试 屏幕旋转屏幕
//        let vc = PTTestScreenRotationViewController()
//        navigationController?.pushViewController(vc, animated: true)
        
        // 10,.弹幕
        let vc = PTPopMessageViewController()
         navigationController?.pushViewController(vc, animated: true)
        
        // 语音朗读
//        let vc = PTSpeechViewController()
//        navigationController?.pushViewController(vc, animated: true)
        // 语音识别
//        let vc = PTVoiceRecognizeViewController()
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func rightItemAction() {
       let vc = PTTestPushOrPresentViewController() // PTBaseChatViewController()
        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
        
        // 测试模糊效果
//        if bm == nil {
//            bm = PTBlurredViewManager(with: view)
//        } else {
//            bm.removeBlurred()
//        }
      
    }
    
    /// 事实证明，在UIcontrol上加手势后，它对手势的响应优先级高于addTarget里的事件的优先级，如tap手势与按钮的addTarget里的方法会优先触发tap手势上的事件，即手势识别器对事件的响应级别高于hitTestView
    @objc private func customeRightItemTapAction(tap: UITapGestureRecognizer) {
        PTPrint("customeRightItemTapAction-------")
    }
    
    @objc private func loginOutAction() {
        kUserDefaults.setValue(nil, forKey: ksaveUserNamekey)
        kUserDefaults.synchronize()
//        kAppDelegate.makeSureTheMainRouter()
       
        
       let testVc = PTTestViewController()
//        let nav = PTNavigationController(rootViewController: testVc)
        
//        let mainVc = PTTabBarController()
//        PTRouter.setRootViewController(viewController: mainVc)
        
        navigationController?.present(testVc, animated: true, completion: nil)
    }

    // MARK: 测试 加载本地pdf
    @objc private func clickAction() {
        let webVc = PTBaseWebViewController()
        let file = PTBaseBundle.loadImage(name: "ios.pdf")
        navigationController?.pushViewController(webVc, animated: true)
//        // 加载本地文件 、网络文件
         webVc.urlString = file //"https://blog.csdn.net/u010105969/article/details/53942862"
        
        // 2.
//        let remotoHtml = "https://www.baidu.com"
//        // wkwebview 加载本地html  http 和https的本地文件
//        let localHtml = Bundle.main.path(forResource: "360Http.html", ofType: nil)!  // 360 baiduHttps.html
//        //        let url = URL.init(fileURLWithPath: localHtml)
//        let webVc = PTBaseWebViewController()
//        webVc.urlString = localHtml // remotoHtml
        
//        PTPrint("点击了按钮---")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            self?.navigationController?.navigationBar.transform = CGAffineTransform.init(translationX: 0, y: -44)
//        }
        
//        let vc = PTBaseListController()
        
        
//        let sptView = PTExposureView()
//        sptView.backgroundColor = .white
//        addSubview(sptView)
//        sptView.frame = view.bounds
//
//        delay(2) {
//            sptView.removeFromSuperview()
//        }
//        sptView.startAnimate()
//        sptView.setupOther()
        
    }
    
    deinit {
        debugPrint("PTHomeViewController deinit")
    }
    
}




