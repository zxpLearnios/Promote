//
//  PTOtherViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//

import UIKit

class PTOtherViewController: PTBaseViewController {

    
    private var count = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.magenta
        setupSubviews()
    }
    
    private func setupSubviews() {
        let btn = PTBaseButton()
        btn.backgroundColor = .red
        btn.setTitle("\(count)", for: .normal)
        btn.frame = CGRect(x: 100, y: 300, width: 100, height: 30)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
    }
    
    @objc func btnAction(btn: UIButton) {
        count += 1
        btn.setTitle("\(count)", for: .normal)
    }
    
    
}
