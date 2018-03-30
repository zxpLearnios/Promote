//
//  PTLoginViewController.swift
//  Promote
//
//  Created by Bavaria on 27/03/2018.
//

import UIKit
import Cartography

class PTLoginViewController: PTBaseViewController {

    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginBtn = UIButton()
    
    // 非懒加载
//    var autoLoginLab: UILabel {
//        let lab = UILabel()
//        lab.text = "正在使用自动登录方式"
//        lab.font = UIFont.systemFont(ofSize: 20)
//        lab.textColor = .red
//        return lab
//    }
    // 只有闭包方式才是懒加载的
    var autoLoginLab: UILabel = {
        let lab = UILabel()
        lab.text = "正在使用自动登录方式"
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.textColor = .red
        return lab
    }()
    private var viewModel: PTLoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        
        // 1. 非自动登录 使用observable
        //            viewModel = PTLoginViewModel.init(usernameField.rx.text.orEmpty.asDriver(), password: passwordField.rx.text.orEmpty.asDriver(), loginTap: loginBtn.rx.tap.asObservable())
        //            // 监听viewModel.isLoginBtnEnable来设置按钮
        //            viewModel.isLoginBtnEnable.subscribe({ [unowned self] in
        //                if let result = $0.element {
        //                    self.loginBtn.backgroundColor = result ? kButtonUnableBgColor : kButtonUnableBgColor
        //                    self.loginBtn.isEnabled = result
        //                }
        //            }).disposed(by: disposeBag)
        // 2. 自动登录 使用driver
        viewModel = PTLoginViewModel.init(usernameField.rx.text.orEmpty.asDriver(), password: passwordField.rx.text.orEmpty.asDriver(), isAutoLogin: true)
        
        // （1）我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用。  （2）同时它和 subscribe 一样，可以通过不同的block 回调处理不同类型的 event。比如：      do(onNext:)方法就是在subscribe(onNext:) 前调用     而 do(onCompleted:) 方法则会在 subscribe(onCompleted:) 前面调用。
        
        viewModel.isAutoLogining.subscribe({ [unowned self] res in
            
            debugPrint("123234", res)
            self.autoLoginLab.text = res.element! ? "正在自动登录中..." : ""
        }).disposed(by: kdisposeBag)
//        viewModel.isAutoLogining.drive(onNext: { [unowned self] res in
//
//            debugPrint("123234", res)
//            self.autoLoginLab.text = res ? "正在自动登录中..." : ""
//        }).disposed(by: kdisposeBag)
        
        viewModel.isAutoLoginCompleted.asObservable().subscribe({ [unowned self] res in
            self.autoLoginLab.text = res.element! ? "自动登录完成" : ""
        }).disposed(by: kdisposeBag)
        
        // 监听viewModel.isLoginBtnEnable来设置按钮
        viewModel.isLoginBtnEnable.subscribe({ [unowned self] in
            if let result = $0.element {
                self.loginBtn.backgroundColor = result ? kButtonUnableBgColor : kButtonUnableBgColor
                self.loginBtn.isEnabled = result
            }
        }).disposed(by: kdisposeBag)
        delay(10) { [unowned self] in
            self.viewModel.isAutoLogin.drive(onNext: {  (result) in
                self.loginBtn.isHidden = result
//                self.autoLoginLab.isHidden = !result
            }).disposed(by: kdisposeBag)
        }
        
    }


    private func addSubviews() {
        addSubview(usernameField)
        addSubview(passwordField)
        addSubview(loginBtn)
        addSubview(autoLoginLab)
        
//        usernameField.text = "123"
        usernameField.placeholder = kuserNamePrompt
        passwordField.placeholder = kpwdPrompt
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        
        constrain(usernameField, passwordField, loginBtn, autoLoginLab) { (nameF, pwdF, btn, lab) in
            let supV = nameF.superview!
            nameF.centerX == supV.centerX
            nameF.width == 300
            
            pwdF.width == nameF.width
            pwdF.centerY == supV.centerY - 100
            
            btn.width == 200
            btn.height == 40
            
            lab.top == pwdF.bottom + 100
            
            align(centerX: nameF, pwdF, btn, lab)
            distribute(by: 40, vertically: nameF, pwdF, btn)
            UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
        }
    }
  
}
