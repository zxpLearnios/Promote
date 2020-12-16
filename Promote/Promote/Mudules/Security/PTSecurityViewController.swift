//
//  PTSecurityViewController.swift
//  Promote
//
//  Created by bava on 2020/11/16.
//

import UIKit

class PTSecurityViewController: PTBaseViewController {

    var isSelect = false
    
    private var titleLab1: UILabel {
       return  UILabel()
    }
    
    private lazy var titleLab: PTTSecurityView = {
       return  PTTSecurityView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let btn = PTBaseButton()
        btn.title = "点击777"
        btn.titleColor = .gray
        
        titleLab.newText = "111"
        
        view.addSubview(titleLab)
        view.addSubview(btn)
        titleLab.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(100)
        }
        btn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(titleLab.snp.bottom).offset(50)
        }
        
//        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btn.tapCallback = {[weak self] btn in
            guard let `self` = self else {
                return
            }
            self.btnAction()
        }
    }

    
    @objc private func btnAction() {
        isSelect = !isSelect
        if isSelect {
            titleLab.newText = "222222"
        } else {
            titleLab.newText = "111"
        }
    }

}



private class PTTSecurityView: UIView {
    
    let label = PTTapLabel()
    
    var newText: String? {
        set {
            self.label.text = newValue
        }
        get {
            return "*"
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(label)
        label.textColor = .red
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    
    
}
