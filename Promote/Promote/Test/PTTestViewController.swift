//
//  PTTestViewController.swift
//  Promote
//
//  Created by bavaria on 2018/4/6.
//  animView.pt.base == animView, 但animView.pt 没获取一次都是不同的PTPromote<UIView>对象，


import UIKit
import Cartography
import RxCocoa
import RxSwift


class PTTestViewController: PTBaseViewController {
    // 枚举类型限定
    enum Enum {
        case name(String)
        case age(Int)
    }
    
    var testAry = [""]
    var testAry1 = [""]
    let btn1 = UIButton()
    let btn2 = UIButton()
    let tablelView = UITableView()
    private let btn = UIButton()
    private let animView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 此时此方法会强引用当前对象，使直到遍历结束才会相应其他操作。即此法有严重问题
        //        asyncExecuteInMainThread(0) { [weak self] in
        //            if let `self` = self {
        //                for i in 0 ..< 10000000 {
        //                    self.testAry.append("\(i)")
        //                }
        //            }
        //
        //        }
        
        
        // 2. 和第一张情况一模一样
        //        asyncExecuteInMainThread(0) {
        //            for i in 0 ..< 10000000 {
        //                self.testAry.append("\(i)")
        //            }
        //        }
        
        // 3. 完美解决上述问题
        //        asyncExecuteInSubThread(0) { (currentThread) in
        //            for i in 0 ..< 10000000 {
        //                self.testAry.append("\(i)")
        //                if i == 9999999 {
        //                    debugPrint("遍历结束了\(self)") // self 有值的
        //                }
        //            }
        
        // 4.
        
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
    
    
    
    private func addSubviews() {
        // 1.
        view.addSubview(btn)
        constrain(btn) { (btn) in
            btn.center == btn.superview!.center
            btn.width == 100
        }

        animView.frame = CGRect.init(x: 100, y: 100, width: 150, height: 150)
        animView.backgroundColor = UIColor.red
        view.addSubview(animView)
        let _ = Enum.name("") // 只能这样初始化
        
        // 2.
        btn1.backgroundColor = .red
        btn2.backgroundColor = .gray

        btn1.setTitle("1111", for: .selected)
        btn2.setTitle("222", for: .selected)
        
        view.addSubview(btn1)
        view.addSubview(btn2)
        
        constrain(btn1, btn2, block: { b1, b2 in
            let sv = b1.superview!
            b1.centerX == sv.centerX
            b1.top == sv.top + 300
            
            b1.width == 100
            b1.height == 50
            
            b2.width == b1.width
            b2.height == b1.height
            
            distribute(by: 40, vertically: b1, b2)
            align(centerX: b1, b2)
            
        })
        
//        let buttons = [btn1, btn2] //.map {$0}
//        let selectedButton = Observable.from(
//             buttons.map { button in
//                button.rx.tap.map { button }
//            }).merge()
//
//        selectedButton.subscribe({
//            debugPrint("122323 \($0)")
//        })
//
//        for button in buttons {
//            selectedButton.map { $0 == button }
//                .bind(to: button.rx.isSelected)
//                .disposed(by: disposeBag)
//        }
        
       
        // 2.1  监听按钮点击，其实完全没必要如此做
//        btn1.rx.tap.bind(to: { _ in // .startWith()
//            clickAction("一开始就会触发")
//        })
        // 2.1.1
        btn1.rx.tap.bind {
            self.clickAction("不会立马触发，只有点击按钮才会触发")
        }.disposed(by: disposeBag)
        
        // 2.1.2 使用bind\bind（To）时，必须已经完成初始化了，即不会为空了。比如拖得控件则都不能使用\也无法使用bind，敲不出来的

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 0
//        doAnimate(Enum.name("for_shake"))
        
        // 1
        noUseFunc().testCanUseClosureFunctionThenExcute { (res) in
            debugPrint("这是常见的使用 带闭包参数的函数 时的情况 \(res)")
        }
        // 1.1  此法只是把闭包写在函数外实现而已。如果闭包是最后一个参数, 可以直接将闭包写到参数列表后面, 这样可以提高阅读性. 称之为尾随闭包
        noUseFunc().testCanUseClosureFunctionThenExcute(){ res in
            debugPrint("这是使用 带闭包参数的函数 时的不常用的方式  \(res)")
        }
        
        
    }
    
    private func noUseFunc() -> Self {
        return self
    }
    
    private func testCanUseClosureFunctionThenExcute(_ str: String = "函数的返回值为闭包时，外面可以先调用此法，然后再在 ）后面就实现此闭包即可", closure: @escaping (String) -> Void) {
        closure("-haha")
    }
    
    
    func clickAction(_ a: String) -> Void {
        doAnimate(Enum.name("for_scale"))
        let vc =  PTTestViewController()  // PTTestViewController PTLoginViewController()
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
