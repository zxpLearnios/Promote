//
//  PTTapLabel.swift
//  Promote
//
//  Created by Bavaria on 2018/4/20.
//

import UIKit

class PTTapLabel: PTBaseLabel {

    private var tap: UITapGestureRecognizer!
    
    typealias TapClosureType = ((String, PTBaseLabel) -> Void)?
    var tapClosure: TapClosureType
    
    convenience init() {
        self.init()
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
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
