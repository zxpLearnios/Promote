//
//  HomeViewModel.swift
//  Promote
//
//  Created by Bavaria on 2018/3/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel: NSObject {

//    let name = Variable<String?>("")
    let name = BehaviorRelay<String>.init(value: "")
    var nameObserver: Observable<String>!
//    var nameObserver = BehaviorSubject<String>.init(value: "")
    
    let pwd = BehaviorRelay<String?>(value: "")
    let rePwd = BehaviorRelay<String?>(value: "")
    
    var pwdObserver: Observable<String>!
    var rePwdObserver: Observable<String>!
    
    
    
    override init() {
        super.init()
        setup()
    
    }
    
    func setup() {
//        nameObserver = name.asObservable().map{  str in
//            return "name："+str
//        }
        
        nameObserver = name.asObservable().map({ name in
            return "name："+name
        })
        
        pwdObserver = pwd.asObservable().map({ pwd in
            return "pwd:"+pwd!
        })
        
        rePwdObserver = rePwd.asObservable().map({ repwd in
            return "pwd:"+repwd!
        })
        
        rePwdObserver = Observable.combineLatesultSelector: )
//        Observable.combineLatest(name.asObservable(), name.asObservable()) {_,_ in
//
//        }
    }
    
    @objc private func verifyPassword(_ pwd: String, rePwd: String) -> Bool {
        return ""
    }
}
