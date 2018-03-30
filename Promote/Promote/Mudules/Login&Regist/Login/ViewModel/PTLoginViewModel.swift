//
//  PTLoginViewModel.swift
//  Promote
//
//  Created by Bavaria on 27/03/2018.
//

import UIKit
import RxCocoa
import RxSwift

class PTLoginViewModel: NSObject {
    
    var username: Driver<String>!
    var password: Driver<String>!
//    var loginBtnDriver: Driver<Void>!
    var loginTap: Observable<Void>!
    var isLoginBtnEnable = Observable.just(false)
    var isAutoLogin: Driver<Bool>!
    
    /** 是否正在自动登录中 */
//    var isAutoLogining: Driver<Bool>!
    /** 代替了Variable，且自身可以不停地赋新值，从而实现信号的发送 */
    var isAutoLogining: BehaviorRelay<Bool>!
    /** 是否自动登录完成  */
    var isAutoLoginCompleted: Variable<Bool>!
    
    var emptyObservable = BehaviorRelay<(String, String)>.just(("", ""))
    
    /**
     * loginTap： 点击事件
     * isAutoLogin: 是否开启自动登录
     */
    init(_ username: Driver<String>, password pwd: Driver<String>, loginTap: Observable<Void>? = nil, isAutoLogin autoLogin: Bool = false) {
        super.init()
        
        self.username = username
        self.password = pwd
        self.loginTap = loginTap
        // 初始化
        self.isAutoLogin = Driver<Bool>.just(autoLogin)
//        self.isAutoLogining = Driver.just(false)
        self.isAutoLogining = BehaviorRelay.init(value: false)
        self.isAutoLoginCompleted = Variable.init(false)
        
        
        // 合并用户名 密码, 使用Driver
        let usernameAndPwd = Driver.combineLatest(username, pwd) { (name: $0, passwrod: $1)
        }
        
        if autoLogin {
            // driver 不需要添加share(1)
    
            let usernameAndPwdDriver = Driver.combineLatest(username, pwd) { ($0, $1)
            }
            
            usernameAndPwd.asObservable().subscribe({
                let (name, pwd) = ($0.element?.name, $0.element?.passwrod)
                
                if name == "123" && pwd == "123" {
                    debugPrint("=-=-=-=-=")
                    // 发送信息
                     self.isAutoLogining.accept(true)
                    delay(3, callback: {
                        self.isAutoLoginCompleted.value = true
                    })
                } else {  
                    self.isAutoLogining.accept(false)
                }
                
            }).disposed(by: kdisposeBag)
            
        } else { // 使用Observable
            self.isLoginBtnEnable = Observable.combineLatest(username.asObservable(), pwd.asObservable(), resultSelector: { (name, pwd) in
                if name.count >= 3 && pwd.count >= 3 {
                    return true
                }
                return false
            })
            
            // driver 不需要添加share(1)
            _ = self.loginTap.withLatestFrom(usernameAndPwd).flatMapLatest { [weak self]  (name, pwd) in // arg
                
                //            let (name, pwd) = arg
                return (self?.loginAction(name, password: pwd).observeOn(MainScheduler.instance).catchErrorJustReturn(false).asDriver(onErrorJustReturn: false))!
                }.subscribe { (event) in
                    if let result = event.element {
                        if result {
                            kUserDefaults.set("username", forKey: ksaveUserNamekey)
                        }
                        Config.showAlert(withMessage: result ? kloginSuccess : kloginFailed)
                    } else {
                        Config.showAlert(withMessage: kloginFailed)
                    }
            }
        }
        
        
        
    }
    
    private func loginAction(_ name: String, password: String) -> Observable<Bool> {
//        debugPrint("用户名：\(name)，密码：\(password)")
        var result = Observable.just(false)
        if name == "123" && password == "123" {
            result = Observable.just(true) // Observable<Bool>.just(true)
        }
        return result
    }
}
