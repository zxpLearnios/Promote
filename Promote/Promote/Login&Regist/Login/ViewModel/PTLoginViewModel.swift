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
    var loginBtnDriver: Driver<Void>!
    var loginTap: Signal<Void>!
    var isLoginBtnEnable: Observable<Bool>!
    
    init(_ username: Driver<String>, password pwd: Driver<String>, loginTap: Signal<Void>) {
        super.init()
        
        self.username = username
        self.password = pwd
        
        let usernameAndPwd = Driver.combineLatest(username, pwd) { (name: $0, passwrod: $1)
        }
        
        _ = loginTap.withLatestFrom(usernameAndPwd).flatMapLatest { [weak self] _ in
            return (self?.loginAction().observeOn(MainScheduler.instance).asDriver(onErrorJustReturn: false))!
        }
    }
    
    func loginAction() -> Observable<Bool> {
        debugPrint("用户名：%@，密码：%@", "", "")
        let result = Observable<Bool>.just(true)
        return result
    }
}
