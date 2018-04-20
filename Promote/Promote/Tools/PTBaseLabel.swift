//
//  PTBaseLabel.swift
//  Promote
//
//  Created by Bavaria on 2018/4/20.
//

import UIKit

class PTBaseLabel: UILabel {

    convenience init(with bgColor: UIColor) {
        self.init()
        backgroundColor = bgColor
    }
    
    
    convenience init(with textColor: UIColor, fontSize: Int) {
        self.init()
        self.textColor = textColor
        font = UIFont.systemFont(ofSize: CGFloat(fontSize))
    }
    
}
