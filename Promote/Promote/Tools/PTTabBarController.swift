//
//  QLTabBarController.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.

import UIKit

class PTTabBarController: UITabBarController {

    
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
        
        self.view.backgroundColor = UIColor.white
        self.tabBar.alpha = 0.8
        self.tabBar.tintColor = UIColor.RGBA(252, g: 116, b: 6, a: 1)
    
        let homeVc = PTHomeViewController()
        self.addChildViewControllers(homeVc, title: "Home", itemImageUnicode: "\u{e617}")
        let OtherVc = PTOtherViewController()
        self.addChildViewControllers(OtherVc, title: "Other", itemImageUnicode: "\u{e618}")
        let myVc = PTMyViewController()
        self.addChildViewControllers(myVc, title: "Mine", itemImageUnicode: "\u{e61a}")
        
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
    private func addChildViewControllers(_ viewController: UIViewController, title: String, itemImageUnicode code: String){
        
        let normalImg = UIImage.if_image(withUniCode: code, fontSize: 21)
        let selectImg = UIImage.if_image(withUniCode: code, familyName: "iconfont", fontSize: 21, fontColor: UIColor.orange)
        
        let newItemNormalImg = normalImg.withRenderingMode(.alwaysOriginal)
        let newItemSelectdImg = selectImg.withRenderingMode(.automatic) // 这也是默认样式
        
        viewController.title = title
        viewController.tabBarItem.image = newItemNormalImg
        viewController.tabBarItem.selectedImage = newItemSelectdImg
        
        let nav = UINavigationController.init(rootViewController: viewController)
        self.addChildViewController(nav)
    }
    


}
