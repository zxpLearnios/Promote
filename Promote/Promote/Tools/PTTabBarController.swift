//
//  QLTabBarController.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.

import UIKit

class PTTabBarController: UITabBarController {

    
    // MARK: 做一些事
    class  func doInit() {
        
        // 所有的字控制器的tabbarItem的 字体属性
        let tabbarItem = UITabBarItem.appearance() // 不能用UIBarButtonItem
        let itemAttributeNormal = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.red]
        let itemAttributeHighlight = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.green]
        
        tabbarItem.setTitleTextAttributes(itemAttributeNormal, for: UIControlState())
        tabbarItem.setTitleTextAttributes(itemAttributeHighlight, for: .selected) // 用highlight无效
        
        //   此处设置tabbarItem的图片无效(估计纯代码情况下也是无效)
        //        tabBarItem.image = UIImage(named: "Customer_select")
        //        tabBarItem.selectedImage = UIImage(named: "Customer_unselect")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 选中时的title和图片颜色  252,116,6
        self.tabBar.tintColor = UIColor.RGBA(252, g: 116, b: 6, a: 1)
        // -1
//        self.delegate = self
        self.view.backgroundColor = UIColor.white
        
        // 1， 加子控制器
//        let homeVC = QLHomePageViewController()
//        self.addChildViewControllers(homeVC, title: "首页", itemImage: UIImage(named: "arrow_down"), itemSelectedImage: UIImage(named: "arrow_down"))
//
//        let accountVC = QLAccountViewController()
//        self.addChildViewControllers(accountVC, title: "账户", itemImage: UIImage(named: "arrow_down"), itemSelectedImage: UIImage(named: "arrow_down"))
//
//        let helpVC = QLHelpViewController()
//        self.addChildViewControllers(helpVC, title: "帮助", itemImage: UIImage(named: "arrow_down"), itemSelectedImage: UIImage(named: "arrow_down"))
        
      
//        self.tabBar.alpha = 0.8
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        for item in self.tabBar.subviews {
        //            if item.isKindOfClass(UIControl) {
        //                item.removeFromSuperview() // 此时不要
        //            }
        
        //        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 添加子控制器
    fileprivate func addChildViewControllers(_ viewController:UIViewController, title:String, itemImage:UIImage?, itemSelectedImage:UIImage?){
        
//        let newItemSelectdImg = itemSelectedImage?.imageWithRenderingMode(.AlwaysOriginal)
        
//        let iconImgNormal = UIImage.if_image(withUniCode: title, fontSize: 21)
//        let iconSelectImg = UIImage.if_image(withUniCode: title, familyName: "iconfont", fontSize: 21, fontColor: UIColor.orangeColor())
        
        var unicode = ""
        if title == "首页" {
            unicode = "\u{e617}"
        }else if title == "账户" {
            unicode = "\u{e61a}"
        }else if title == "帮助"{
            unicode = "\u{e618}"
        }
        
        
        let nav = UINavigationController.init(rootViewController: viewController)
        self.addChildViewController(nav)
    }
    


}
