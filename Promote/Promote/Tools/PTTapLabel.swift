//
//  PTTapLabel.swift
//  Promote
//
//  Created by Bavaria on 2018/4/20.
//  支持点击的label

import UIKit

class PTTapLabel: PTBaseLabel {

    private var tap: UITapGestureRecognizer!
    
    typealias TapClosureType = ((String, PTBaseLabel) -> Void)?
    var tapClosure: TapClosureType = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    func set(_ textColor: UIColor, fontSize: CGFloat) {
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        if let tapClosure = tapClosure {
            tapClosure(text ?? "", self)
        }
    }

}
