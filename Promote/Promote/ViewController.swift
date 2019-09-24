//
//  ViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/3/21.
//

import UIKit




class ViewController: UIViewController {
a
    // 类型限定
    enum Enum {
        case name(String)
        case age(Int)
    }
    
    private let animView = UIView()
    private var ary: Array<String>?
    
    private var testAry = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let a = [1, 2, 3]
//        let b = a[safe: 4]
        addSubviews()
        
    }

    func doOther() {
        
        //        let selfType = self.self
//        var a = 10
//        if let num = ary?.count, num <= a {
//
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func addSubviews() {
        animView.frame = CGRect.init(x: 100, y: 100, width: 150, height: 150)
        animView.backgroundColor = UIColor.red
        view.addSubview(animView)
        let _ = Enum.name("") // 只能这样初始化
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doAnimate(Enum.name("for_shake"))
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        doAnimate(Enum.name("for_scale"))
        let vc = PTTestViewController()  // PTTestViewController PTLoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // switch的判断分支，若无任何操作，则须加break
    private func doAnimate(_ enumElement: Enum) {
        switch enumElement {
        case .name(let name):
            if name == "for_shake" {
                // 1.
//                animView.shake()
                // 2. UIView的实例的pt属性即为Promote<UIView>类型
                animView.pt.shake()
//                animView.pt.base.shake()
            } else if name == "for_scale" {
//                animView.scale()
            }
        default :
            let _ = ""
        }
    }
}



