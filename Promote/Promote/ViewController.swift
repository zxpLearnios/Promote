//
//  ViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/3/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    @IBOutlet weak var rePwdField: UITextField!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    // 类型限定
    enum Enum {
        case name(String)
        case age(Int)
    }
    
    private let animView = UIView()
    private var ary: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addSubviews()
        
        nameField.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: disposeBag)
//        pwdField.rx.text.orEmpty.bind(to: viewModel.pwd).disposed(by: disposeBag)
        
        viewModel.nameObserver.subscribe(onNext: { [weak self] (str) in
            self?.lab.text = str
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
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
    }
    
    // switch的判断分支，若无任何操作，则须加break
    private func doAnimate(_ enumElement: Enum) {
        switch enumElement {
        case .name(let name):
            if name == "for_shake" {
                // 1.
//                animView.shake()
                // 2.
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


