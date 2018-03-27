//
//  PTLoginViewController.swift
//  Promote
//
//  Created by Bavaria on 27/03/2018.
//

import UIKit
import Cartography

class PTLoginViewController: UIViewController {

    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginBtn = UIButton()
    
    private var viewModel: PTLoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PTLoginViewModel.init(usernameField.rx.text.orEmpty.asDriver(), password: passwordField.rx.text.orEmpty.asDriver(), loginTap: loginBtn.rx.tap.asSignal())
        
//        viewModel.loginTap = loginBtn.rx.tap.asSignal()

////        viewModel.username = usern
//        viewModel.isLoginBtnEnable.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        
    }


    private func addSubviews() {
        constrain(usernameField, passwordField) { (nameF, pwdF) in
            
        }
    }
  
}
