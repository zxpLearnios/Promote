//
//  PTNavigationController.swift
//  Promote
//
//  Created by Bavaria on 2018/4/19.
//  ios10后的tabbar问题，通过自定义导航控制器即可解决，否则用那种tabbar.ishidden = true 根本没用的

import UIKit


@objc protocol PTNavigationControllerPopDelegate {
   @objc optional func didClickBackButton()
}

class PTNavigationController: UINavigationController {

    var navPopDelegate: PTNavigationControllerPopDelegate!
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        doInit()
//        view.layoutIfNeeded()
    }
    
    // MARK: 初始化
    func doInit() {
        // 大标题样式
        if #available(iOS 11.0, *) {
//            navigationBar.prefersLargeTitles = true
        } else {
        }
        
        // 所有push出的控制器的title的属性设置
        let textAttibute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: knavTitleColor]
        navigationBar.titleTextAttributes = textAttibute
//
//        
        // 所有的push出的控制器左右item的 属性设置, 但item最好不要拖入，因为长按会变暗
        var  navBaritem = UIBarButtonItem()
        if #available(iOS 9.0, *) {
            navBaritem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [PTNavigationController.self])
        } else {
            navBaritem = UIBarButtonItem.appearance()
        }
        
        let itemAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: knavTitleColor]
        navBaritem.setTitleTextAttributes(itemAttribute, for: .normal)
        navBaritem.setTitleTextAttributes(itemAttribute, for: .highlighted) //  Selected Focused Reserved Highlighted
        
        //        navBaritem.setBackgroundImage(UIImage(named: "2"), forState: .Normal, barMetrics: .Default)
        //        navBaritem.setBackgroundImage(UIImage(named: "2"), forState: .Highlighted, barMetrics: .CompactPrompt)
        
        //  与tabbar有关的， 第一批控制器的标题
//        for subVC in self.viewControllers {
//            if subVC.tabBarItem != nil {
//                subVC.title = subVC.tabBarItem.title
//                
//            }
//        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 若滑动返回失效，则清空代理, 即可
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 重写此法以拦截所有push的控制器. ios 10 后，隐藏tabbar用此法不会出现任何问题.经测试，ios10后在别处设置hidesBottomBarWhenPushed都会有问题。
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 { // 非第一批控制器时 的情况
            
            // 左边的按钮
            let leftBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            leftBtn.setImage(UIImage(named: "navigationbar_back"), for: UIControl.State())
            leftBtn.setImage(UIImage(named: "navigationbar_back"), for: .highlighted)
            leftBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
            
            // 右边的按钮
          viewController.hidesBottomBarWhenPushed = true // statusBra有阴影
            
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    // pop 无须再在 相应控制器里设置navPopDelegate并在控制器消失时令navPopDelegate==nil了, 手势滑动返回只有一滑动即使还没返回也会调用， 故会导致在意见反馈也有内容时，只滑动不返回再点击返回按钮时 不提示 “是否放弃”
    @discardableResult internal override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: true)
//        if !isOpinionFeedbackHaveContent { // 已经反馈有内容时，滑动也不清空代理
//            navPopDelegate = nil
//        }
        return nil
    }
    
    // MARK: 返回
    @objc private func back() {
        if navPopDelegate != nil {
            navPopDelegate.didClickBackButton!()
            return
        }
        self.popViewController(animated: true)
    }
    
    // MARK: 右边按钮的方法
    @objc private func rightItemAction() {
        
    }
    
   
    
}
